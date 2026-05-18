package ma.m2si.TheRepairShop.config;

import ma.m2si.TheRepairShop.entity.*;
import ma.m2si.TheRepairShop.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        System.out.println("=== Initialisation des utilisateurs ===");

        // Supprimer les anciens utilisateurs pour repartir sur une base propre
        // Attention: Cela supprime tous les utilisateurs existants
        if (userRepository.count() > 0) {
            System.out.println("Suppression des utilisateurs existants...");
            userRepository.deleteAll();
            System.out.println("✅ Tous les utilisateurs ont été supprimés");
        }

        // 1. Créer ADMIN
        User admin = new User();
        admin.setUsername("admin");
        admin.setEmail("admin@repair.com");
        admin.setPassword(passwordEncoder.encode("admin123"));
        admin.setFirstName("Admin");
        admin.setLastName("System");
        admin.setRole(UserRole.ADMIN);
        admin.setStatus(UserStatus.ACTIVE);
        admin.setEnabled(true);
        admin.setAccountNonExpired(true);
        admin.setAccountNonLocked(true);
        admin.setCredentialsNonExpired(true);
        userRepository.save(admin);
        System.out.println("✅ Admin créé - Username: admin, Password: admin123");

        // 2. Créer OWNER
        Owner owner = new Owner();
        owner.setUsername("owner");
        owner.setEmail("owner@repair.com");
        owner.setPassword(passwordEncoder.encode("owner123"));
        owner.setFirstName("Jean");
        owner.setLastName("Dupont");
        owner.setRole(UserRole.OWNER);
        owner.setStatus(UserStatus.ACTIVE);
        owner.setEnabled(true);
        owner.setAccountNonExpired(true);
        owner.setAccountNonLocked(true);
        owner.setCredentialsNonExpired(true);
        owner.setCompanyName("Dupont Réparations SARL");
        owner.setTaxNumber("FR123456789");
        owner.setBusinessLicense("LIC-2024-001");
        owner.setWebsite("https://dupont-reparations.fr");
        owner.setCompanyDescription("Leader dans la réparation électronique");
        userRepository.save(owner);
        System.out.println("✅ Owner créé - Username: owner, Password: owner123");

        // 3. Créer REPARATOR
        Repairer repairer = new Repairer();
        repairer.setUsername("reparator");
        repairer.setEmail("reparator@repair.com");
        repairer.setPassword(passwordEncoder.encode("reparator123"));
        repairer.setFirstName("Marie");
        repairer.setLastName("Martin");
        repairer.setRole(UserRole.REPARATOR);
        repairer.setStatus(UserStatus.ACTIVE);
        repairer.setEnabled(true);
        repairer.setAccountNonExpired(true);
        repairer.setAccountNonLocked(true);
        repairer.setCredentialsNonExpired(true);
        repairer.setSpecialization("Électronique");
        repairer.setExperienceYears(5);
        repairer.setHourlyRate(new BigDecimal("25.00"));
        repairer.setSkills("Soudure, Diagnostic, Réparation PCB");
        repairer.setCertification("Certifié Apple");
        repairer.setAvailable(true);
        repairer.setOwner(owner); // Lier au propriétaire
        userRepository.save(repairer);
        System.out.println("✅ Réparateur créé - Username: reparator, Password: reparator123");

        // 4. Créer CLIENT
        User client = new User();
        client.setUsername("client");
        client.setEmail("client@repair.com");
        client.setPassword(passwordEncoder.encode("client123"));
        client.setFirstName("Pierre");
        client.setLastName("Durand");
        client.setRole(UserRole.CLIENT);
        client.setStatus(UserStatus.ACTIVE);
        client.setEnabled(true);
        client.setAccountNonExpired(true);
        client.setAccountNonLocked(true);
        client.setCredentialsNonExpired(true);
        client.setPhoneNumber("0612345678");
        client.setAddress("123 Rue de Paris, 75001 Paris");
        userRepository.save(client);
        System.out.println("✅ Client créé - Username: client, Password: client123");

        // Afficher tous les utilisateurs créés
        System.out.println("\n=== Liste des utilisateurs ===");
        userRepository.findAll().forEach(user -> {
            String type = "";
            if (user instanceof Owner) type = " [PROPRIÉTAIRE]";
            else if (user instanceof Repairer) type = " [RÉPARATEUR]";
            else type = " [UTILISATEUR]";

            System.out.println("Username: " + user.getUsername() +
                    ", Password: [ENCODÉ]" +
                    ", Rôle: " + user.getRole() +
                    type);
        });
        System.out.println("=== Initialisation terminée ===\n");
    }
}