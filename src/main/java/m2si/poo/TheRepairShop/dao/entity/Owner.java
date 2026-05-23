package m2si.poo.TheRepairShop.dao.entity;

import jakarta.persistence.Column;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@DiscriminatorValue("OWNER")
@Getter
@Setter
@NoArgsConstructor
public class Owner extends User {

    @Column(name = "company_name", length = 255)
    private String companyName;

    @Column(name = "tax_id", length = 100)
    private String taxId;

}
