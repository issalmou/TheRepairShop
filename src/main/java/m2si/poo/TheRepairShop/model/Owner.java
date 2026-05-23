package m2si.poo.TheRepairShop.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

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

    @OneToMany(mappedBy = "owner", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<Shop> shops = new HashSet<>();
}
