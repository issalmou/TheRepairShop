package m2si.poo.TheRepairShop.controller;

import m2si.poo.TheRepairShop.dto.CreateOwnerRequest;
import m2si.poo.TheRepairShop.dto.UpdateOwnerRequest;
import m2si.poo.TheRepairShop.model.User;
import m2si.poo.TheRepairShop.service.CreatedUserPasswordDto;
import m2si.poo.TheRepairShop.service.facade.UserService;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/users/owners")
public class OwnerManagementController {

    private final UserService userService;

    public OwnerManagementController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public String listOwners(Model model) {
        model.addAttribute("owners", userService.getAllOwners());
        return "owners/list";
    }

    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("ownerForm", new CreateOwnerRequest());
        return "owners/form";
    }

    @PostMapping
    public String createOwner(
            @Valid @ModelAttribute("ownerForm") CreateOwnerRequest form,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes
    ) {
        if (bindingResult.hasErrors()) {
            return "owners/form";
        }

        try {
            CreatedUserPasswordDto created = userService.createOwner(
                    form.getUsername(),
                    form.getEmail(),
                    form.getFirstName(),
                    form.getLastName(),
                    form.getPhone(),
                    form.getPassword()
            );
            redirectAttributes.addFlashAttribute("generatedPassword", created.getPlainPassword());
            redirectAttributes.addFlashAttribute("generatedUsername", created.getUsername());
            redirectAttributes.addFlashAttribute("message", "Owner created successfully");
        } catch (IllegalStateException | IllegalArgumentException e) {
            bindingResult.reject("owner.create.failed", e.getMessage());
            return "owners/form";
        }
        return "redirect:/users/owners";
    }

    @GetMapping("/{id}/edit")
    public String showEditForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            User owner = userService.getOwnerById(id);
            model.addAttribute("owner", owner);
            model.addAttribute("ownerForm", toUpdateOwnerRequest(owner));
            model.addAttribute("editMode", true);
            return "owners/form";
        } catch (EntityNotFoundException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/users/owners";
        }
    }

    @PostMapping("/{id}/edit")
    public String updateOwner(
            @PathVariable Long id,
            @Valid @ModelAttribute("ownerForm") UpdateOwnerRequest form,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        try {
            User owner = userService.getOwnerById(id);
            if (bindingResult.hasErrors()) {
                prepareOwnerEditModel(model, owner);
                return "owners/form";
            }

            userService.updateOwner(
                    id,
                    form.getEmail(),
                    form.getFirstName(),
                    form.getLastName(),
                    form.getPhone(),
                    form.isActive(),
                    form.getNewPassword()
            );
            redirectAttributes.addFlashAttribute("message", "Owner updated successfully");
        } catch (EntityNotFoundException | IllegalStateException | IllegalArgumentException e) {
            if (e instanceof EntityNotFoundException) {
                redirectAttributes.addFlashAttribute("error", e.getMessage());
                return "redirect:/users/owners";
            }
            bindingResult.reject("owner.update.failed", e.getMessage());
            try {
                prepareOwnerEditModel(model, userService.getOwnerById(id));
                return "owners/form";
            } catch (EntityNotFoundException nested) {
                redirectAttributes.addFlashAttribute("error", nested.getMessage());
                return "redirect:/users/owners";
            }
        }
        return "redirect:/users/owners";
    }

    @PostMapping("/{id}/delete")
    public String deleteOwner(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            userService.deleteOwner(id);
            redirectAttributes.addFlashAttribute("message", "Owner deleted successfully");
        } catch (IllegalStateException | EntityNotFoundException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/users/owners";
    }

    @PostMapping("/{id}/reset-password")
    public String resetPassword(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            CreatedUserPasswordDto created = userService.resetOwnerPassword(id);
            redirectAttributes.addFlashAttribute("generatedPassword", created.getPlainPassword());
            redirectAttributes.addFlashAttribute("generatedUsername", created.getUsername());
            redirectAttributes.addFlashAttribute("message", "Owner password reinitialized successfully");
        } catch (EntityNotFoundException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/users/owners";
    }

    private UpdateOwnerRequest toUpdateOwnerRequest(User owner) {
        UpdateOwnerRequest form = new UpdateOwnerRequest();
        form.setEmail(owner.getEmail());
        form.setFirstName(owner.getFirstName());
        form.setLastName(owner.getLastName());
        form.setPhone(owner.getPhone());
        form.setActive(Boolean.TRUE.equals(owner.getActive()));
        return form;
    }

    private void prepareOwnerEditModel(Model model, User owner) {
        model.addAttribute("owner", owner);
        model.addAttribute("editMode", true);
    }
}
