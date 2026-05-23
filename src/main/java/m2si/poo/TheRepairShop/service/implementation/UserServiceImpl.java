package m2si.poo.TheRepairShop.service.implementation;

import m2si.poo.TheRepairShop.model.Role;
import m2si.poo.TheRepairShop.model.Shop;
import m2si.poo.TheRepairShop.model.User;
import m2si.poo.TheRepairShop.model.Owner;
import m2si.poo.TheRepairShop.model.Repairer;
import m2si.poo.TheRepairShop.repository.RepairRepository;
import m2si.poo.TheRepairShop.repository.ShopRepository;
import m2si.poo.TheRepairShop.repository.UserRepository;
import m2si.poo.TheRepairShop.repository.RoleRepository;
import m2si.poo.TheRepairShop.service.CreatedUserPasswordDto;
import m2si.poo.TheRepairShop.service.facade.UserService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

@Service
public class UserServiceImpl implements UserService {
    private static final String PASSWORD_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    private static final int PASSWORD_LENGTH = 12;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ShopRepository shopRepository;

    @Autowired
    private RepairRepository repairRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private ShopAccessService shopAccessService;

    @Autowired
    private RoleRepository roleRepository;

    private final SecureRandom secureRandom = new SecureRandom();

    private boolean isCurrentUserAdmin() {
        User current = shopAccessService.getCurrentUser();
        return current != null && current.isAdmin();
    }

    @Override
    public CreatedUserPasswordDto createReparateur(
            String username,
            String email,
            String firstName,
            String lastName,
            String phone,
            Long shopId
    ) {
        if (userRepository.existsByUsername(username)) {
            throw new IllegalStateException("Username is already in use");
        }
        if (userRepository.findByEmail(email).isPresent()) {
            throw new IllegalStateException("Email is already in use");
        }

        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new EntityNotFoundException("Shop not found with id: " + shopId));

        String plainPassword = generateRandomPassword();

        User user = new Repairer();
        user.setUsername(username);
        user.setEmail(email);
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setPhone(phone);
        user.setPassword(passwordEncoder.encode(plainPassword));
        user.setMustChangePassword(true);
        user.setActive(true);
        Role reparateurRole = roleRepository.findByName("REPARATEUR")
                .orElseThrow(() -> new EntityNotFoundException("Role REPARATEUR not found"));
        user.setRoles(new HashSet<>(Set.of(reparateurRole)));

        user.setShop(shop);
        User savedUser = userRepository.save(user);

        shop.getUsers().add(savedUser);

        return new CreatedUserPasswordDto(
                savedUser.getId(),
                savedUser.getUsername(),
                savedUser.getEmail(),
                plainPassword
        );
    }

    @Override
    public List<User> getUsersByShop(Long shopId) {
        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new EntityNotFoundException("Shop not found with id: " + shopId));
        return new ArrayList<>(shop.getUsers());
    }

    @Override
    public User getReparateurById(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found with id: " + userId));
        if (!user.isReparateur()) {
            throw new EntityNotFoundException("User is not a repairer with id: " + userId);
        }
        return user;
    }

    @Override
    @Transactional
    public User updateReparateur(
            Long ownerId,
            Long repairerId,
            String email,
            Long shopId,
            String firstName,
            String lastName,
            String phone,
            boolean active
    ) {
        User repairer = getReparateurById(repairerId);
        if (email != null && userRepository.existsByEmailAndIdNot(email, repairerId)) {
            throw new IllegalStateException("Email is already in use");
        }

        Shop targetShop = shopRepository.findById(shopId)
                .orElseThrow(() -> new EntityNotFoundException("Shop not found with id: " + shopId));
        if (!isCurrentUserAdmin()
                && (targetShop.getOwner() == null || !ownerId.equals(targetShop.getOwner().getId()))) {
            throw new EntityNotFoundException("Shop not found with id: " + shopId);
        }

        repairer.setEmail(email);
        repairer.setFirstName(firstName);
        repairer.setLastName(lastName);
        repairer.setPhone(phone);
        repairer.setActive(active);

        if (repairer.getShop() != null) {
            repairer.getShop().getUsers().remove(repairer);
        }
        repairer.setShop(targetShop);
        targetShop.getUsers().add(repairer);

        return userRepository.save(repairer);
    }

    @Override
    @Transactional
    public void deleteReparateur(Long ownerId, Long repairerId) {
        User repairer = getReparateurById(repairerId);
        if (!repairRepository.findByAssignedTechnicianId(repairerId).isEmpty()) {
            throw new IllegalStateException("Cannot delete repairer with existing repairs");
        }

        if (repairer.getShop() != null) {
            repairer.getShop().getUsers().remove(repairer);
        }
        userRepository.delete(repairer);
    }

    @Override
    public List<User> getAllOwners() {
        Role ownerRole = roleRepository.findByName("OWNER")
                .orElseThrow(() -> new EntityNotFoundException("Role OWNER not found"));
        return userRepository.findByRolesContaining(ownerRole);
    }

    @Override
    public User getOwnerById(Long ownerId) {
        User user = userRepository.findById(ownerId)
                .orElseThrow(() -> new EntityNotFoundException("User not found with id: " + ownerId));
        if (!user.isOwner()) {
            throw new EntityNotFoundException("User is not an owner with id: " + ownerId);
        }
        return user;
    }

    @Override
    public CreatedUserPasswordDto createOwner(
            String username,
            String email,
            String firstName,
            String lastName,
            String phone,
            String plainPassword
    ) {
        if (userRepository.existsByUsername(username)) {
            throw new IllegalStateException("Username is already in use");
        }
        if (userRepository.findByEmail(email).isPresent()) {
            throw new IllegalStateException("Email is already in use");
        }

        String password = plainPassword != null && !plainPassword.isBlank()
                ? plainPassword
                : generateRandomPassword();
        if (password.length() < 8) {
            throw new IllegalArgumentException("Password must be at least 8 characters");
        }

        User user = new Owner();
        user.setUsername(username);
        user.setEmail(email);
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setPhone(phone);
        user.setPassword(passwordEncoder.encode(password));
        user.setMustChangePassword(plainPassword == null || plainPassword.isBlank());
        user.setActive(true);
        Role ownerRole = roleRepository.findByName("OWNER")
                .orElseThrow(() -> new EntityNotFoundException("Role OWNER not found"));
        user.setRoles(new HashSet<>(Set.of(ownerRole)));

        User saved = userRepository.save(user);
        return new CreatedUserPasswordDto(
                saved.getId(),
                saved.getUsername(),
                saved.getEmail(),
                password
        );
    }

    @Override
    public User updateOwner(
            Long ownerId,
            String email,
            String firstName,
            String lastName,
            String phone,
            boolean active,
            String newPassword
    ) {
        User owner = getOwnerById(ownerId);
        if (email != null && userRepository.existsByEmailAndIdNot(email, ownerId)) {
            throw new IllegalStateException("Email is already in use");
        }
        owner.setEmail(email);
        owner.setFirstName(firstName);
        owner.setLastName(lastName);
        owner.setPhone(phone);
        owner.setActive(active);
        if (newPassword != null && !newPassword.isBlank()) {
            if (newPassword.length() < 8) {
                throw new IllegalArgumentException("Password must be at least 8 characters");
            }
            owner.setPassword(passwordEncoder.encode(newPassword));
            owner.setMustChangePassword(false);
            owner.setLastPasswordChange(LocalDateTime.now());
        }
        return userRepository.save(owner);
    }

    @Override
    public void setOwnerPassword(Long ownerId, String newPassword) {
        if (newPassword == null || newPassword.length() < 8) {
            throw new IllegalArgumentException("Password must be at least 8 characters");
        }
        User owner = getOwnerById(ownerId);
        owner.setPassword(passwordEncoder.encode(newPassword));
        owner.setMustChangePassword(false);
        owner.setLastPasswordChange(LocalDateTime.now());
        userRepository.save(owner);
    }

    @Override
    @Transactional
    public void deleteOwner(Long ownerId) {
        User owner = getOwnerById(ownerId);
        if (!shopRepository.findByOwnerId(ownerId).isEmpty()) {
            throw new IllegalStateException("Cannot delete owner with existing shops. Delete or reassign shops first.");
        }
        userRepository.delete(owner);
    }

    @Override
    public User updateProfile(Long userId, String firstName, String lastName, String phone) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found with id: " + userId));
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setPhone(phone);
        return userRepository.save(user);
    }

    @Override
    public User updateOwnProfile(Long userId, String email, String firstName, String lastName, String phone,
                                 String companyName, String taxId,
                                 String specialization, Integer experienceYears, String hourlyRate) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found with id: " + userId));
        if (email != null && userRepository.existsByEmailAndIdNot(email, userId)) {
            throw new IllegalStateException("Email is already in use");
        }
        user.setEmail(email);
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setPhone(phone);

        if (user instanceof Owner) {
            Owner owner = (Owner) user;
            owner.setCompanyName(companyName);
            owner.setTaxId(taxId);
        } else if (user instanceof Repairer) {
            Repairer repairer = (Repairer) user;
            repairer.setSpecialization(specialization);
            repairer.setExperienceYears(experienceYears);
            repairer.setHourlyRate(hourlyRate);
        }

        return userRepository.save(user);
    }

    @Override
    public void changePassword(Long userId, String oldPassword, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found with id: " + userId));
        if (oldPassword == null || !passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new IllegalArgumentException("Current password is incorrect");
        }
        if (newPassword == null || newPassword.length() < 8) {
            throw new IllegalArgumentException("New password must be at least 8 characters");
        }
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setMustChangePassword(false);
        user.setLastPasswordChange(LocalDateTime.now());
        userRepository.save(user);
    }

    @Override
    public void deactivateUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found with id: " + userId));
        user.setActive(false);
        userRepository.save(user);
    }

    private String generateRandomPassword() {
        StringBuilder builder = new StringBuilder(PASSWORD_LENGTH);
        for (int i = 0; i < PASSWORD_LENGTH; i++) {
            int index = secureRandom.nextInt(PASSWORD_CHARS.length());
            builder.append(PASSWORD_CHARS.charAt(index));
        }
        return builder.toString();
    }

    @Override
    @Transactional
    public CreatedUserPasswordDto resetOwnerPassword(Long ownerId) {
        User owner = getOwnerById(ownerId);
        String plainPassword = generateRandomPassword();
        owner.setPassword(passwordEncoder.encode(plainPassword));
        owner.setMustChangePassword(true);
        owner.setLastPasswordChange(null);
        userRepository.save(owner);
        return new CreatedUserPasswordDto(owner.getId(), owner.getUsername(), owner.getEmail(), plainPassword);
    }

    @Override
    @Transactional
    public CreatedUserPasswordDto resetRepairerPassword(Long ownerId, Long repairerId) {
        User repairer = getReparateurById(repairerId);
        String plainPassword = generateRandomPassword();
        repairer.setPassword(passwordEncoder.encode(plainPassword));
        repairer.setMustChangePassword(true);
        repairer.setLastPasswordChange(null);
        userRepository.save(repairer);
        return new CreatedUserPasswordDto(repairer.getId(), repairer.getUsername(), repairer.getEmail(), plainPassword);
    }
}
