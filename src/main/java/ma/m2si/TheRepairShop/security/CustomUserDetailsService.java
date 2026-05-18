package ma.m2si.TheRepairShop.security;

import ma.m2si.TheRepairShop.dao.entity.User;
import ma.m2si.TheRepairShop.dao.entity.UserRole;
import ma.m2si.TheRepairShop.dao.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private UserRepository userRepository;
    @Autowired
    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String usernameOrEmail) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(usernameOrEmail)
                .orElseGet(() -> userRepository.findByEmail(usernameOrEmail)
                        .orElseThrow(() -> new UsernameNotFoundException("Utilisateur non trouvé: " + usernameOrEmail)));

        // CORRECTION: Vérifier et corriger le rôle s'il est null
        if (user.getRole() == null) {
            System.err.println("⚠️ ERREUR: L'utilisateur " + user.getUsername() + " a un rôle NULL!");
            System.err.println("⚠️ Attribution du rôle CLIENT par défaut...");
            user.setRole(UserRole.CLIENT);
            user = userRepository.save(user);
            System.err.println("✅ Rôle corrigé pour l'utilisateur " + user.getUsername());
        }

        System.out.println("✅ Authentification user: " + user.getUsername() +
                " | Role: " + user.getRole() +
                " | Enabled: " + user.isEnabled());

        return org.springframework.security.core.userdetails.User
                .withUsername(user.getUsername())
                .password(user.getPassword())
                .authorities("ROLE_" + user.getRole().name())
                .accountExpired(!user.isAccountNonExpired())
                .accountLocked(!user.isAccountNonLocked())
                .credentialsExpired(!user.isCredentialsNonExpired())
                .disabled(!user.isEnabled())
                .build();
    }
}