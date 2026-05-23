package m2si.poo.TheRepairShop.security;

import m2si.poo.TheRepairShop.model.User;
import m2si.poo.TheRepairShop.repository.UserRepository;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class ForcePasswordChangeFilter extends OncePerRequestFilter {
    private final UserRepository userRepository;

    public ForcePasswordChangeFilter(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication != null
                && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {
            String username = authentication.getName();
            User user = userRepository.findByUsername(username).orElse(null);

            if (user != null && user.isMustChangePassword()) {
                String contextPath = request.getContextPath();
                String requestUri = request.getRequestURI();
                String path = contextPath != null && !contextPath.isEmpty()
                        ? requestUri.substring(contextPath.length())
                        : requestUri;

                if (!isAllowedPath(path)) {
                    response.sendRedirect(contextPath + "/profile/change-password");
                    return;
                }
            }
        }

        filterChain.doFilter(request, response);
    }

    private boolean isAllowedPath(String path) {
        if (path == null) {
            return true;
        }

        return path.equals("/profile/change-password")
                || path.equals("/login")
                || path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/images/");
    }
}
