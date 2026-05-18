package ma.m2si.TheRepairShop.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import ma.m2si.TheRepairShop.dto.LoginRequest;
import ma.m2si.TheRepairShop.dto.RegisterRequest;
import ma.m2si.TheRepairShop.entity.User;
import ma.m2si.TheRepairShop.service.AuthService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@NoArgsConstructor
@AllArgsConstructor
public class AuthController {

    private AuthService authService;

    @GetMapping("/login")
    public String showLoginForm(@RequestParam(value = "error", required = false) String error,
                                @RequestParam(value = "logout", required = false) String logout,
                                Model model) {
        if (!model.containsAttribute("loginRequest")) {
            model.addAttribute("loginRequest", new LoginRequest());
        }

        if (error != null) {
            model.addAttribute("error", "Email/Utilisateur ou mot de passe incorrect");
        }
        if (logout != null) {
            model.addAttribute("success", "Vous avez été déconnecté avec succès");
        }

        return "auth/login";
    }

    @PostMapping("/login")
    public String processLogin(@Valid @ModelAttribute("loginRequest") LoginRequest loginRequest,
                               BindingResult result,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            return "auth/login";
        }

        try {
            User user = authService.authenticateUserSession(loginRequest);
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userRole", user.getRole());
            redirectAttributes.addFlashAttribute("success", "Bienvenue " + user.getFirstName() + "!");
            return "redirect:/dashboard";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Email/Utilisateur ou mot de passe incorrect");
            return "redirect:/login";
        }
    }

    @GetMapping("/signout")
    public String logout(HttpServletRequest request,
                         HttpServletResponse response,
                         RedirectAttributes redirectAttributes) {
        authService.logout(request, response);
//        redirectAttributes.addFlashAttribute("success", "Vous avez été déconnecté avec succès");
        return "redirect:/login";
    }

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("registerRequest", new RegisterRequest());
        return "auth/register";
    }

    @PostMapping("/register")
    public String processRegister(@Valid @ModelAttribute("registerRequest") RegisterRequest registerRequest,
                                  BindingResult result,
                                  RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            return "auth/register";
        }

        try {
            // Enregistrer uniquement des propriétaires (OWNER)
            User user = authService.registerOwner(registerRequest);
            redirectAttributes.addFlashAttribute("success",
                    "Inscription réussie ! Vous pouvez maintenant vous connecter en tant que propriétaire.");
            return "redirect:/login";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/register";
        }
    }
}