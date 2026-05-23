package m2si.poo.TheRepairShop.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class CreateOwnerRequest {
    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 100, message = "Username must be between 3 and 100 characters")
    @Pattern(regexp = "^[A-Za-z0-9._-]+$", message = "Username can only contain letters, numbers, dots, underscores, and hyphens")
    private String username;

    @NotBlank(message = "Email is required")
    @Email(message = "Enter a valid email address")
    @Size(max = 150, message = "Email must be 150 characters or fewer")
    private String email;

    @Size(max = 100, message = "First name must be 100 characters or fewer")
    private String firstName;

    @Size(max = 100, message = "Last name must be 100 characters or fewer")
    private String lastName;

    @Pattern(regexp = "^$|^[+0-9][0-9 .-]{5,19}$", message = "Enter a valid phone number")
    private String phone;

    @Pattern(regexp = "^$|.{8,255}", message = "Password must be at least 8 characters")
    private String password;

    public String getUsername() {
        return trim(username);
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return trim(email);
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFirstName() {
        return trim(firstName);
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return trim(lastName);
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPhone() {
        return trim(phone);
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return trim(password);
    }

    public void setPassword(String password) {
        this.password = password;
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
