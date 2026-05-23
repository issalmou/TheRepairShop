package m2si.poo.TheRepairShop.model;

import jakarta.persistence.Column;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@DiscriminatorValue("REPARATEUR")
@Getter
@Setter
@NoArgsConstructor
public class Repairer extends User {

    @Column(name = "specialization", length = 100)
    private String specialization;

    @Column(name = "experience_years")
    private Integer experienceYears;

    @Column(name = "hourly_rate", length = 50)
    private String hourlyRate;
}
