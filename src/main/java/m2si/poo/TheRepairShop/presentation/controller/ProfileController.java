package m2si.poo.TheRepairShop.presentation.controller;

import java.security.Principal;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import m2si.poo.TheRepairShop.dao.entity.User;
import m2si.poo.TheRepairShop.dao.repository.UserRepository;
import m2si.poo.TheRepairShop.service.facade.UserService;

@Controller
@RequestMapping("/profile")
public class ProfileController {

    private final UserRepository userRepository;
    private final UserService userService;

    public ProfileController(UserRepository userRepository, UserService userService) {
        this.userRepository = userRepository;
        this.userService = userService;
    }

    @GetMapping
    public String showProfile(Principal principal, Model model) {
        User user = getCurrentUser(principal);
        if (user == null) {
            return "redirect:/login";
        }
        if (user.isMustChangePassword()) {
            return "redirect:/profile/change-password";
        }
        model.addAttribute("user", user);
        return "profile/edit";
    }
    @GetMapping("/change-password")
    public String showChangePasswordForm(Principal principal, Model model) {
        User user = getCurrentUser(principal);
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("mustChangePassword", user.isMustChangePassword());
        return "profile/change-password";
    }
    private User getCurrentUser(Principal principal) {
        if (principal == null) {
            return null;
        }
        return userRepository.findByUsername(principal.getName()).orElse(null);
    }
}
