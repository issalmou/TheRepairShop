package m2si.poo.TheRepairShop.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "users")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "user_type", discriminatorType = DiscriminatorType.STRING)
@Getter
@Setter
@NoArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 100)
    private String username;

    @Column(nullable = false, unique = true, length = 150)
    private String email;

    @Column(nullable = false, length = 255)
    private String password;

    @Column(name = "first_name", length = 100)
    private String firstName;

    @Column(name = "last_name", length = 100)
    private String lastName;

    @Column(length = 20)
    private String phone;

    @Column(name = "must_change_password")
    private Boolean mustChangePassword = false;

    @Column(name = "last_password_change")
    private LocalDateTime lastPasswordChange;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "user_roles",
        joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "role_id")
    )
    private Set<Role> roles = new HashSet<>();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "shop_id")
    private Shop shop;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private Boolean active = true;

    public Boolean isMustChangePassword() {
        return mustChangePassword != null && mustChangePassword;
    }

    public boolean hasRole(String roleName) {
        return roles != null && roles.stream().anyMatch(r -> r.getName().equalsIgnoreCase(roleName));
    }

    public boolean hasRole(Role role) {
        return role != null && roles != null && roles.contains(role);
    }

    public boolean isOwner() {
        return this instanceof Owner || hasRole("OWNER");
    }

    public boolean isReparateur() {
        return this instanceof Repairer || hasRole("REPARATEUR");
    }

    public boolean isAdmin() {
        return this instanceof Admin || hasRole("ADMIN");
    }

    public boolean isOwnerOrAdmin() {
        return isOwner() || isAdmin();
    }

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
