package ma.m2si.TheRepairShop.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import ma.m2si.TheRepairShop.entity.UserRole;

@Data
@AllArgsConstructor
public class AuthResponse {
    private String token;
    private String type = "Bearer";
    private Long id;
    private String username;
    private String email;
    private String firstName;
    private String lastName;
    private UserRole role;

    public AuthResponse(String token, Long id, String username, String email,
                        String firstName, String lastName, UserRole role) {
        this.token = token;
        this.id = id;
        this.username = username;
        this.email = email;
        this.firstName = firstName;
        this.lastName = lastName;
        this.role = role;
    }
}