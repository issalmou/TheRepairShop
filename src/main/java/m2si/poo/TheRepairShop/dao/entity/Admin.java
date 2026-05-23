package m2si.poo.TheRepairShop.dao.entity;

import jakarta.persistence.Column;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@DiscriminatorValue("ADMIN")
@Getter
@Setter
@NoArgsConstructor
public class Admin extends User {

    @Column(name = "department", length = 100)
    private String department;

    @Column(name = "admin_level", length = 50)
    private String adminLevel;
}
