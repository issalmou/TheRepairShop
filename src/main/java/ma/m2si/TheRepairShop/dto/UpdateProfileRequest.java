package ma.m2si.TheRepairShop.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import lombok.Data;


import lombok.Data;
import java.math.BigDecimal;

@Data
public class UpdateProfileRequest {

    // Champs communs à tous les utilisateurs
    private String firstName;
    private String lastName;
    private String phoneNumber;
    private String address;

    // Champs spécifiques pour OWNER
    private String companyName;
    private String taxNumber;
    private String businessLicense;
    private String website;
    private String companyDescription;

    // Champs spécifiques pour REPARATOR
    private String specialization;
    private Integer experienceYears;
    private BigDecimal hourlyRate;
    private Boolean available;
    private String skills;
    private String certification;
}