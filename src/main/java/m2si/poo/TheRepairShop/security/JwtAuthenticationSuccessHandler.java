package m2si.poo.TheRepairShop.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class JwtAuthenticationSuccessHandler implements AuthenticationSuccessHandler {
    private final JwtService jwtService;
    private final JwtCookieHelper jwtCookieHelper;

    public JwtAuthenticationSuccessHandler(JwtService jwtService, JwtCookieHelper jwtCookieHelper) {
        this.jwtService = jwtService;
        this.jwtCookieHelper = jwtCookieHelper;
    }

    @Override
    public void onAuthenticationSuccess(
            HttpServletRequest request,
            HttpServletResponse response,
            Authentication authentication
    ) throws IOException {
        if (authentication.getPrincipal() instanceof UserDetails userDetails) {
            String token = jwtService.generateToken(userDetails);
            jwtCookieHelper.addTokenCookie(response, token);
        }

        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
        if (isAdmin) {
            response.sendRedirect(request.getContextPath() + "/users/owners");
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }
}
