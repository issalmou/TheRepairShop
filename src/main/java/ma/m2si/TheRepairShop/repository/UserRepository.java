package ma.m2si.TheRepairShop.repository;

import ma.m2si.TheRepairShop.entity.User;
import ma.m2si.TheRepairShop.entity.UserRole;
import ma.m2si.TheRepairShop.entity.UserStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);

    List<User> findByRole(UserRole role);

    List<User> findByStatus(UserStatus status);

    Optional<User> findByResetPasswordToken(String token);

    @Modifying
    @Query("UPDATE User u SET u.lastLogin = :lastLogin WHERE u.id = :userId")
    void updateLastLogin(@Param("userId") Long userId, @Param("lastLogin") LocalDateTime lastLogin);

    @Modifying
    @Query("UPDATE User u SET u.status = :status WHERE u.id = :userId")
    void updateUserStatus(@Param("userId") Long userId, @Param("status") UserStatus status);

    long countByRole(UserRole role);

    long countByStatus(UserStatus status);
}