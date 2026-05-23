package m2si.poo.TheRepairShop.repository;

import m2si.poo.TheRepairShop.dao.entity.Role;
import m2si.poo.TheRepairShop.dao.entity.User;
import m2si.poo.TheRepairShop.dao.entity.Owner;
import m2si.poo.TheRepairShop.dao.repository.RoleRepository;
import m2si.poo.TheRepairShop.dao.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.data.jpa.test.autoconfigure.DataJpaTest;

import java.util.Optional;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

@org.springframework.boot.test.context.SpringBootTest
@org.springframework.transaction.annotation.Transactional
public class UserRepositoryTest {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Test
    public void testSaveAndFindByUsernameWithRoles() {
        // Create and save test roles
        Role ownerRole = Role.builder().name("OWNER").build();
        roleRepository.save(ownerRole);

        // Create and save user
        Owner user = new Owner();
        user.setUsername("test.owner");
        user.setEmail("owner@test.com");
        user.setPassword("hashedpassword");
        user.setRoles(Set.of(ownerRole));

        userRepository.save(user);

        // Fetch
        Optional<User> fetched = userRepository.findByUsernameWithRoles("test.owner");

        assertThat(fetched).isPresent();
        assertThat(fetched.get().getUsername()).isEqualTo("test.owner");
        assertThat(fetched.get().getRoles()).contains(ownerRole);
    }

    @Test
    public void testExistsByEmailAndUsername() {
        Owner user = new Owner();
        user.setUsername("unique.user");
        user.setEmail("unique@test.com");
        user.setPassword("pwd");

        userRepository.save(user);

        assertThat(userRepository.existsByUsername("unique.user")).isTrue();
        assertThat(userRepository.existsByUsername("nonexistent")).isFalse();
        assertThat(userRepository.existsByEmailAndIdNot("unique@test.com", 999L)).isTrue();
        assertThat(userRepository.existsByEmailAndIdNot("unique@test.com", user.getId())).isFalse();
    }
}
