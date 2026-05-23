package m2si.poo.TheRepairShop;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@SpringBootApplication
public class TheRepairShopApplication {

	public static void main(String[] args) {
		loadEnv();
		SpringApplication.run(TheRepairShopApplication.class, args);
	}

	private static void loadEnv() {
		try {
			Path envPath = Paths.get(".env");
			if (Files.exists(envPath)) {
				List<String> lines = Files.readAllLines(envPath);
				for (String line : lines) {
					line = line.trim();
					if (line.isEmpty() || line.startsWith("#")) {
						continue;
					}
					int separatorIndex = line.indexOf('=');
					if (separatorIndex > 0) {
						String key = line.substring(0, separatorIndex).trim();
						String value = line.substring(separatorIndex + 1).trim();
						
						// Remove enclosing quotes if present
						if (value.startsWith("\"") && value.endsWith("\"") && value.length() >= 2) {
							value = value.substring(1, value.length() - 1);
						} else if (value.startsWith("'") && value.endsWith("'") && value.length() >= 2) {
							value = value.substring(1, value.length() - 1);
						}
						
						System.setProperty(key, value);
					}
				}
			}
		} catch (IOException e) {
			System.err.println("Warning: Could not read .env file: " + e.getMessage());
		}
	}

}
