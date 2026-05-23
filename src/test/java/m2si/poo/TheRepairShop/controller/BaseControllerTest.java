package m2si.poo.TheRepairShop.controller;

import m2si.poo.TheRepairShop.model.*;
import m2si.poo.TheRepairShop.repository.RoleRepository;
import m2si.poo.TheRepairShop.repository.ShopRepository;
import m2si.poo.TheRepairShop.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.util.Set;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
public abstract class BaseControllerTest {

    @Autowired
    protected MockMvc mockMvc;

    @Autowired
    protected RoleRepository roleRepository;

    @Autowired
    protected UserRepository userRepository;

    @Autowired
    protected ShopRepository shopRepository;

    @Autowired
    protected PasswordEncoder passwordEncoder;

    protected Role adminRole;
    protected Role ownerRole;
    protected Role reparateurRole;

    protected Owner testOwner;
    protected Repairer testRepairer;
    protected Admin testAdmin;

    protected Shop testShop;

    @BeforeEach
    public void baseSetup() {
        // Clear repositories before each test to ensure test isolation
        userRepository.deleteAll();
        shopRepository.deleteAll();
        roleRepository.deleteAll();

        // 1. Seed Roles
        adminRole = roleRepository.save(Role.builder().name("ADMIN").build());
        ownerRole = roleRepository.save(Role.builder().name("OWNER").build());
        reparateurRole = roleRepository.save(Role.builder().name("REPARATEUR").build());

        // 2. Create Owner
        testOwner = new Owner();
        testOwner.setUsername("salma.owner");
        testOwner.setEmail("salma@test.com");
        testOwner.setPassword(passwordEncoder.encode("password123"));
        testOwner.setCompanyName("Alaoui Electro");
        testOwner.setTaxId("TAX-MA-99");
        testOwner.setRoles(Set.of(ownerRole));
        testOwner.setActive(true);
        testOwner = userRepository.save(testOwner);

        // 3. Create Shop
        testShop = new Shop();
        testShop.setName("Atelier Hassan II");
        testShop.setAddress("77 Bd Hassan II");
        testShop.setOwner(testOwner);
        testShop.setActive(true);
        testShop = shopRepository.save(testShop);

        // Update owner shop
        testOwner.setShop(testShop);
        testOwner = userRepository.save(testOwner);

        // 4. Create Repairer
        testRepairer = new Repairer();
        testRepairer.setUsername("amina.tech");
        testRepairer.setEmail("amina@test.com");
        testRepairer.setPassword(passwordEncoder.encode("password123"));
        testRepairer.setSpecialization("Smartphones");
        testRepairer.setExperienceYears(3);
        testRepairer.setRoles(Set.of(reparateurRole));
        testRepairer.setShop(testShop);
        testRepairer.setActive(true);
        testRepairer = userRepository.save(testRepairer);

        // 5. Create Admin
        testAdmin = new Admin();
        testAdmin.setUsername("admin.user");
        testAdmin.setEmail("admin@test.com");
        testAdmin.setPassword(passwordEncoder.encode("password123"));
        testAdmin.setDepartment("Operations");
        testAdmin.setRoles(Set.of(adminRole));
        testAdmin.setActive(true);
        testAdmin = userRepository.save(testAdmin);
    }
}
