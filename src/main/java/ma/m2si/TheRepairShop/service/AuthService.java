package ma.m2si.TheRepairShop.service;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import ma.m2si.TheRepairShop.presentation.dto.ChangePasswordRequest;
import ma.m2si.TheRepairShop.presentation.dto.LoginRequest;
import ma.m2si.TheRepairShop.presentation.dto.RegisterRequest;
import ma.m2si.TheRepairShop.presentation.dto.UpdateProfileRequest;
import ma.m2si.TheRepairShop.dao.entity.*;
import ma.m2si.TheRepairShop.dao.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class AuthService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public User getUserByUsername(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));
    }
    public User authenticateUserSession(LoginRequest loginRequest) {
        String usernameOrEmail = loginRequest.getUsernameOrEmail();

        User user = userRepository.findByUsername(usernameOrEmail)
                .orElseGet(() -> userRepository.findByEmail(usernameOrEmail)
                        .orElseThrow(() -> new RuntimeException("User not found")));

        if (!passwordEncoder.matches(loginRequest.getPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid password");
        }

        if (!user.isEnabled()) {
            throw new RuntimeException("Account is disabled");
        }

        userRepository.updateLastLogin(user.getId(), LocalDateTime.now());
        return user;
    }

    @Transactional
    public User registerUser(RegisterRequest registerRequest) {
        if (userRepository.existsByUsername(registerRequest.getUsername())) {
            throw new RuntimeException("Username is already taken!");
        }

        if (userRepository.existsByEmail(registerRequest.getEmail())) {
            throw new RuntimeException("Email is already in use!");
        }

        User user = new User();
        user.setUsername(registerRequest.getUsername());
        user.setEmail(registerRequest.getEmail());
        user.setPassword(passwordEncoder.encode(registerRequest.getPassword()));
        user.setFirstName(registerRequest.getFirstName());
        user.setLastName(registerRequest.getLastName());
        user.setPhoneNumber(registerRequest.getPhoneNumber());
        user.setAddress(registerRequest.getAddress());
        user.setStatus(UserStatus.ACTIVE);

        return userRepository.save(user);
    }


    @Transactional
    public User registerOwner(RegisterRequest registerRequest) {
        // Vérifier si le nom d'utilisateur existe déjà
        if (userRepository.existsByUsername(registerRequest.getUsername())) {
            throw new RuntimeException("Ce nom d'utilisateur est déjà pris!");
        }

        // Vérifier si l'email existe déjà
        if (userRepository.existsByEmail(registerRequest.getEmail())) {
            throw new RuntimeException("Cet email est déjà utilisé!");
        }

        // Créer un nouvel OWNER
        Owner owner = new Owner();
        owner.setUsername(registerRequest.getUsername());
        owner.setEmail(registerRequest.getEmail());
        if (!registerRequest.getPassword().equals(registerRequest.getConfirmPassword())) {
            throw new RuntimeException("Le mot de passe et la confirmation ne correspondent pas !");
        }

        owner.setPassword(passwordEncoder.encode(registerRequest.getPassword()));
        owner.setFirstName(registerRequest.getFirstName());
        owner.setLastName(registerRequest.getLastName());
        owner.setPhoneNumber(registerRequest.getPhoneNumber());
        owner.setAddress(registerRequest.getAddress());
        owner.setRole(UserRole.OWNER);
        owner.setStatus(UserStatus.ACTIVE);
        owner.setEnabled(true);

        // Renseigner les champs spécifiques du propriétaire
        owner.setCompanyName(registerRequest.getCompanyName());
        owner.setTaxNumber(registerRequest.getTaxNumber());
        owner.setBusinessLicense(registerRequest.getBusinessLicense());
        owner.setWebsite(registerRequest.getWebsite());
        owner.setCompanyDescription(registerRequest.getCompanyDescription());

        return userRepository.save(owner);
    }
    public User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            throw new RuntimeException("No authenticated user found");
        }

        String username = authentication.getName();
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    // Overloaded method for session-based approach
    @Transactional
    public User updateProfileUnified(UpdateProfileRequest request) {
        User currentUser = getCurrentUser();

        // Mettre à jour les champs communs
        if (request.getFirstName() != null && !request.getFirstName().isEmpty()) {
            currentUser.setFirstName(request.getFirstName());
        }

        if (request.getLastName() != null && !request.getLastName().isEmpty()) {
            currentUser.setLastName(request.getLastName());
        }

        if (request.getPhoneNumber() != null) {
            currentUser.setPhoneNumber(request.getPhoneNumber());
        }

        if (request.getAddress() != null) {
            currentUser.setAddress(request.getAddress());
        }

        // Mettre à jour les champs spécifiques selon le type d'utilisateur
        if (currentUser instanceof Owner) {
            Owner owner = (Owner) currentUser;

            if (request.getCompanyName() != null) {
                owner.setCompanyName(request.getCompanyName());
            }
            if (request.getTaxNumber() != null) {
                owner.setTaxNumber(request.getTaxNumber());
            }
            if (request.getBusinessLicense() != null) {
                owner.setBusinessLicense(request.getBusinessLicense());
            }
            if (request.getWebsite() != null) {
                owner.setWebsite(request.getWebsite());
            }
            if (request.getCompanyDescription() != null) {
                owner.setCompanyDescription(request.getCompanyDescription());
            }

            return userRepository.save(owner);
        }

        else if (currentUser instanceof Repairer) {
            Repairer repairer = (Repairer) currentUser;

            if (request.getSpecialization() != null) {
                repairer.setSpecialization(request.getSpecialization());
            }
            if (request.getExperienceYears() != null) {
                repairer.setExperienceYears(request.getExperienceYears());
            }
            if (request.getHourlyRate() != null) {
                repairer.setHourlyRate(request.getHourlyRate());
            }
            if (request.getAvailable() != null) {
                repairer.setAvailable(request.getAvailable());
            }
            if (request.getSkills() != null) {
                repairer.setSkills(request.getSkills());
            }
            if (request.getCertification() != null) {
                repairer.setCertification(request.getCertification());
            }

            return userRepository.save(repairer);
        }

        return userRepository.save(currentUser);
    }

    // Overloaded method for session-based approach
    @Transactional
    public void changePassword(ChangePasswordRequest passwordRequest, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (!passwordEncoder.matches(passwordRequest.getCurrentPassword(), user.getPassword())) {
            throw new RuntimeException("Current password is incorrect!");
        }

        if (!passwordRequest.getNewPassword().equals(passwordRequest.getConfirmPassword())) {
            throw new RuntimeException("New password and confirm password do not match!");
        }

        user.setPassword(passwordEncoder.encode(passwordRequest.getNewPassword()));
        userRepository.save(user);
    }

    public void logout(HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null) {
            new SecurityContextLogoutHandler().logout(request, response, auth);
        }
    }

}