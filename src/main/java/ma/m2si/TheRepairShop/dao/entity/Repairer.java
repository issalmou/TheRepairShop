package ma.m2si.TheRepairShop.dao.entity;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

@Entity
@Table(name = "repairers")
@PrimaryKeyJoinColumn(name = "user_id")
@Data
@EqualsAndHashCode(callSuper = true)
@AllArgsConstructor
public class Repairer extends User {

    private String specialization;

    private Integer experienceYears;

    @Column(precision = 10, scale = 2)
    private BigDecimal hourlyRate;

    private boolean available = true;

    @Column(columnDefinition = "TEXT")
    private String skills;

    private String certification;

    @ManyToOne
    @JoinColumn(name = "owner_id")
    private Owner owner;

    // Constructeur par défaut avec rôle REPARATOR
    public Repairer() {
        super();
        this.setRole(UserRole.REPARATOR);
    }

    // Constructeur avec paramètres
    public Repairer(String username, String email, String password, String firstName, String lastName) {
        super(username, email, password, firstName, lastName);
        this.setRole(UserRole.REPARATOR);
    }
}