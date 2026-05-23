package m2si.poo.TheRepairShop.service.implementation;

import java.security.SecureRandom;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.persistence.EntityNotFoundException;
import m2si.poo.TheRepairShop.dao.entity.Owner;
import m2si.poo.TheRepairShop.dao.entity.Repairer;
import m2si.poo.TheRepairShop.dao.entity.User;
import m2si.poo.TheRepairShop.dao.repository.RoleRepository;
import m2si.poo.TheRepairShop.dao.repository.UserRepository;
import m2si.poo.TheRepairShop.service.facade.UserService;

@Service
public class UserServiceImpl implements UserService {
    private static final String PASSWORD_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    private static final int PASSWORD_LENGTH = 12;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    private final SecureRandom secureRandom = new SecureRandom();

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
    }
