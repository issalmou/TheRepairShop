package ma.m2si.TheRepairShop.presentation.controller;

import jakarta.validation.Valid;
import ma.m2si.TheRepairShop.presentation.dto.ChangePasswordRequest;
import ma.m2si.TheRepairShop.presentation.dto.UpdateProfileRequest;
import ma.m2si.TheRepairShop.dao.entity.Owner;
import ma.m2si.TheRepairShop.dao.entity.Repairer;
import ma.m2si.TheRepairShop.dao.entity.User;
import ma.m2si.TheRepairShop.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/profile")
public class ProfileController {

    @Autowired
    private AuthService authService;

    @GetMapping
    public String showProfile(Model model) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String username = auth.getName();

            User currentUser = authService.getUserByUsername(username);
            model.addAttribute("user", currentUser);
            model.addAttribute("updateProfileRequest", new UpdateProfileRequest());
            model.addAttribute("changePasswordRequest", new ChangePasswordRequest());

            // Passer les objets spécifiques selon le type
            if (currentUser instanceof Owner) {
                model.addAttribute("owner", (Owner) currentUser);
            } else if (currentUser instanceof Repairer) {
                model.addAttribute("repairer", (Repairer) currentUser);
            }

            return "auth/profile";
        } catch (Exception e) {
            return "redirect:/login";
        }
    }

    @PostMapping("/update")
    public String updateProfile(@Valid @ModelAttribute("updateProfileRequest") UpdateProfileRequest updateRequest,
                                BindingResult result,
                                RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            redirectAttributes.addFlashAttribute("error", "Erreur de validation");
            return "redirect:/profile";
        }

        try {
            authService.updateProfileUnified(updateRequest);
            redirectAttributes.addFlashAttribute("success", "Profil mis à jour avec succès!");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/profile";
    }
    @PostMapping("/change-password")
    public String changePassword(@Valid @ModelAttribute("changePasswordRequest") ChangePasswordRequest passwordRequest,
                                 BindingResult result,
                                 RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            redirectAttributes.addFlashAttribute("passwordError", "Erreur de validation");
            return "redirect:/profile";
        }

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String username = auth.getName();
            authService.changePassword(passwordRequest, Long.valueOf(username));
            redirectAttributes.addFlashAttribute("success", "Mot de passe changé avec succès!");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("passwordError", e.getMessage());
        }

        return "redirect:/profile";
    }
}