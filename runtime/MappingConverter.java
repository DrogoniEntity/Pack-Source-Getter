import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

public class MappingConverter {

	public static void main(String args[]) throws Throwable {
		if (args.length < 2)
		{
			System.err.println("Missing input file and output file parameters");
			System.exit(-1);
			return;
		}
		File in = new File(args[0]);
		File out = new File(args[1]);
		
		boolean reverse = false;
		if (args.length > 2)
			reverse = args[2].equals("reverse");
		
		System.out.println("Loading all obfuscated classes...");
		HashMap<String, String> obfuscatedClasses = getObfuscatedClassesName(in);

		BufferedReader reader = new BufferedReader(new FileReader(in));
		PrintWriter writer = new PrintWriter(new FileWriter(out));
		String line;
		System.out.println("Retrieve fields and methods...");
		while ((line = reader.readLine()) != null) {
			// Skip comments
			if (line.startsWith("#"))
				continue;

			String[] s = line.split(" -> ");
			String deobfName = s[0];
			String obfName = s[1];

			// Class's details
			if (line.startsWith("    ")) {
				deobfName = deobfName.trim();
				obfName = obfName.trim();

				s = deobfName.split(" ");
				String type = s[0];
				String name = s[1];

				String methodParam = "";
				// Is method
				if (name.contains("(") && name.contains(")")) {
					methodParam = " (";
					String paramString = name.substring(name.indexOf("("), name.indexOf(")"))
							.replace("(", "").replace(")", "");
					if (type.lastIndexOf(":") > -1)
						type = type.substring(type.lastIndexOf(":") + 1);
					name = name.substring(0, name.indexOf("("));
					if (obfuscatedClasses.containsKey(type) && !reverse)
						type = "L" + obfuscatedClasses.get(type) + ";";
					else
						type = toSrgType(type);
					
					String[] param = paramString.split(",");
					String newParamString = "";
					for (int i = 0; i < param.length; i++)
					{
						if (param[i].isEmpty())
							continue;
						if (obfuscatedClasses.containsKey(param[i]) && !reverse)
							newParamString += "L" + obfuscatedClasses.get(param[i]).replace('.', '/') + ";";
						else
							newParamString += toSrgType(param[i]);
					}
					methodParam += newParamString + ")" + type.replace('.', '/');
				}
				
				if (reverse)
					writer.println("\t" + name + methodParam + " " + obfName);
				else
					writer.println("\t" + obfName + methodParam + " " + name);
			}
			else
			{
				obfName = obfName.substring(0, obfName.length() - 1);
				if (reverse)
					writer.println(deobfName.replace('.', '/') + " " + obfName.replace(".", "/"));
				else
					writer.println(obfName.replace('.', '/') + " " + deobfName.replace(".", "/"));
			}
		}
		
		reader.close();
		writer.close();
		System.out.println("File created");
	}

	private static HashMap<String, String> getObfuscatedClassesName(File mapFile) throws IOException {
		HashMap<String, String> out = new HashMap<String, String>();
		BufferedReader reader = new BufferedReader(new FileReader(mapFile));
		String line;
		while ((line = reader.readLine()) != null) {
			// Skip comments
			if (line.startsWith("#"))
				continue;

			String[] s = line.split(" -> ");
			String deobfName = s[0];
			String obfName = s[1].substring(0, s[1].length() - 1);

			if (!line.startsWith("    ")) {
				out.put(deobfName, obfName);
			}
		}

		reader.close();

		return out;
	}

	private static String toSrgType(String methodType) {
		switch (methodType) {
		case "int":
			return "I";
		case "double":
			return "D";
		case "boolean":
			return "Z";
		case "float":
			return "F";
		case "long":
			return "J";
		case "byte":
			return "B";
		case "short":
			return "S";
		case "char":
			return "C";
		case "void":
			return "V";
		default:
			return "L" + methodType.replaceAll("\\.", "/") + ";";
		}
	}
}
