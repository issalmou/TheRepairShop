package m2si.poo.TheRepairShop.service.facade;

import m2si.poo.TheRepairShop.model.User;
import m2si.poo.TheRepairShop.service.CreatedUserPasswordDto;

import java.util.List;

public interface UserService {
    CreatedUserPasswordDto createReparateur(String username, String email, String firstName, String lastName, String phone, Long shopId);
    List<User> getUsersByShop(Long shopId);
    User getReparateurById(Long userId);
    User updateReparateur(Long ownerId, Long repairerId, String email, Long shopId, String firstName, String lastName, String phone, boolean active);
    User updateProfile(Long userId, String firstName, String lastName, String phone);
    User updateOwnProfile(Long userId, String email, String firstName, String lastName, String phone,
                          String companyName, String taxId,
                          String specialization, Integer experienceYears, String hourlyRate);
    void changePassword(Long userId, String oldPassword, String newPassword);
    void deactivateUser(Long userId);
    void deleteReparateur(Long ownerId, Long repairerId);

    List<User> getAllOwners();
    User getOwnerById(Long ownerId);
    CreatedUserPasswordDto createOwner(String username, String email, String firstName, String lastName, String phone, String plainPassword);
    User updateOwner(Long ownerId, String email, String firstName, String lastName, String phone, boolean active, String newPassword);
    void deleteOwner(Long ownerId);
    void setOwnerPassword(Long ownerId, String newPassword);
    CreatedUserPasswordDto resetOwnerPassword(Long ownerId);
    CreatedUserPasswordDto resetRepairerPassword(Long ownerId, Long repairerId);
}
