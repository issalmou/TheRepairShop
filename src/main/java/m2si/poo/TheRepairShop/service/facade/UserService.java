package m2si.poo.TheRepairShop.service.facade;

import m2si.poo.TheRepairShop.dao.entity.User;

public interface UserService {
    User updateOwnProfile(Long userId, String email, String firstName, String lastName, String phone,
                        String companyName, String taxId,
                        String specialization, Integer experienceYears, String hourlyRate);
}
