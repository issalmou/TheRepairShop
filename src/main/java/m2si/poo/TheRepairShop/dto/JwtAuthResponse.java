package m2si.poo.TheRepairShop.dto;

public class JwtAuthResponse {
    private String token;
    private String tokenType = "Bearer";
    private long expiresInSeconds;

    public JwtAuthResponse(String token, long expiresInSeconds) {
        this.token = token;
        this.expiresInSeconds = expiresInSeconds;
    }

    public String getToken() {
        return token;
    }

    public String getTokenType() {
        return tokenType;
    }

    public long getExpiresInSeconds() {
        return expiresInSeconds;
    }
}
