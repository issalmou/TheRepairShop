package ma.m2si.TheRepairShop.dao.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "owners")
@PrimaryKeyJoinColumn(name = "user_id")
@Data
@EqualsAndHashCode(callSuper = true)
@AllArgsConstructor
public class Owner extends User {

    private String companyName;

    @Column(unique = true)
    private String taxNumber;

    private String businessLicense;

    private String website;

    private String companyLogo;

    @Column(columnDefinition = "TEXT")
    private String companyDescription;

    @OneToMany(mappedBy = "owner", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Repairer> repairers = new ArrayList<>();

    // Constructeur par défaut avec rôle OWNER
    public Owner() {
        super();
        this.setRole(UserRole.OWNER);
    }

    // Constructeur avec paramètres
    public Owner(String username, String email, String password, String firstName, String lastName) {
        super(username, email, password, firstName, lastName);
        this.setRole(UserRole.OWNER);
    }

    // Méthode utilitaire pour ajouter un réparateur
    public void addRepairer(Repairer repairer) {
        repairers.add(repairer);
        repairer.setOwner(this);
    }

    // Surcharger pour s'assurer que le rôle est toujours OWNER
    protected void ensureOwnerRole() {
        if (this.getRole() == null) {
            this.setRole(UserRole.OWNER);
        }
    }
}