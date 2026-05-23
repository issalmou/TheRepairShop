package m2si.poo.TheRepairShop.service;

public class CreatedUserPasswordDto {
    private Long userId;
    private String username;
    private String email;
    private String plainPassword;

    public CreatedUserPasswordDto() {
    }

    public CreatedUserPasswordDto(Long userId, String username, String email, String plainPassword) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.plainPassword = plainPassword;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPlainPassword() {
        return plainPassword;
    }

    public void setPlainPassword(String plainPassword) {
        this.plainPassword = plainPassword;
    }
}
