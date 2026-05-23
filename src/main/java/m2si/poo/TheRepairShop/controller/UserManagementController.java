package m2si.poo.TheRepairShop.controller;

import m2si.poo.TheRepairShop.dto.CreateRepairerRequest;
import m2si.poo.TheRepairShop.dto.UpdateRepairerRequest;
import m2si.poo.TheRepairShop.model.Shop;
import m2si.poo.TheRepairShop.model.User;
import m2si.poo.TheRepairShop.service.CreatedUserPasswordDto;
import m2si.poo.TheRepairShop.service.implementation.ShopAccessService;
import m2si.poo.TheRepairShop.service.facade.UserService;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/users/manage")
public class UserManagementController {

    private final UserService userService;
    private final ShopAccessService shopAccessService;

    public UserManagementController(
            UserService userService,
            ShopAccessService shopAccessService
    ) {
        this.userService = userService;
        this.shopAccessService = shopAccessService;
    }

    @GetMapping
    public String listRepairers(Model model) {
        User owner = getCurrentUser();
        if (owner == null) {
            return "redirect:/login";
        }

        Set<Long> shopIds = shopAccessService.getShopIdsForCurrentView();
        List<Shop> shops = getShopsForCurrentView();
        Set<User> repairers = new LinkedHashSet<>();
        for (Long shopId : shopIds) {
            List<User> users = userService.getUsersByShop(shopId);
            for (User user : users) {
                if (user != null && user.isReparateur()) {
                    repairers.add(user);
                }
            }
        }

        model.addAttribute("users", new ArrayList<>(repairers));
        model.addAttribute("shops", shops);
        model.addAttribute("shopScopeLabel", shopAccessService.getDashboardShopLabel(shopIds));
        return "users/list";
    }

    @GetMapping("/new")
    public String showCreateForm(Model model) {
        User owner = getCurrentUser();
        if (owner == null) {
            return "redirect:/login";
        }

        prepareRepairerCreateModel(model);
        model.addAttribute("userForm", new CreateRepairerRequest());
        return "users/form";
    }

    @PostMapping
    public String createRepairer(
            @Valid @ModelAttribute("userForm") CreateRepairerRequest form,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        User owner = getCurrentUser();
        if (owner == null) {
            return "redirect:/login";
        }

        if (bindingResult.hasErrors()) {
            prepareRepairerCreateModel(model);
            return "users/form";
        }

        if (!isShopInCurrentView(form.getShopId())) {
            bindingResult.rejectValue("shopId", "shop.invalid", "Invalid shop selection");
            prepareRepairerCreateModel(model);
            return "users/form";
        }

        try {
            CreatedUserPasswordDto created = userService.createReparateur(
                    form.getUsername(),
                    form.getEmail(),
                    form.getFirstName(),
                    form.getLastName(),
                    form.getPhone(),
                    form.getShopId()
            );
            redirectAttributes.addFlashAttribute("generatedPassword", created.getPlainPassword());
            redirectAttributes.addFlashAttribute("generatedUsername", created.getUsername());
        } catch (IllegalStateException | IllegalArgumentException e) {
            bindingResult.reject("user.create.failed", e.getMessage());
            prepareRepairerCreateModel(model);
            return "users/form";
        }
        return "redirect:/users/manage";
    }

    @GetMapping("/{id}/edit")
    public String showEditForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        User owner = getCurrentUser();
        if (owner == null) {
            return "redirect:/login";
        }

        try {
            shopAccessService.assertRepairerManagedByOwner(id);
            User repairer = userService.getReparateurById(id);
            List<Shop> shops = getShopsForCurrentView();
            Long selectedShopId = resolveSelectedShopId(repairer, shops);

            model.addAttribute("user", repairer);
            model.addAttribute("userForm", toUpdateRepairerRequest(repairer, selectedShopId));
            model.addAttribute("shops", shops);
            model.addAttribute("selectedShopId", selectedShopId);
            model.addAttribute("editMode", true);
            return "users/form";
        } catch (EntityNotFoundException | AccessDeniedException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/users/manage";
        }
    }

    @PostMapping("/{id}/edit")
    public String updateRepairer(
            @PathVariable Long id,
            @Valid @ModelAttribute("userForm") UpdateRepairerRequest form,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        User owner = getCurrentUser();
        if (owner == null) {
            return "redirect:/login";
        }

        try {
            shopAccessService.assertRepairerManagedByOwner(id);
            User repairer = userService.getReparateurById(id);
            List<Shop> shops = getShopsForCurrentView();

            if (bindingResult.hasErrors()) {
                prepareRepairerEditModel(model, repairer, shops, form.getShopId());
                return "users/form";
            }

            if (!isShopInCurrentView(form.getShopId())) {
                bindingResult.rejectValue("shopId", "shop.invalid", "Invalid shop selection");
                prepareRepairerEditModel(model, repairer, shops, form.getShopId());
                return "users/form";
            }

            userService.updateReparateur(
                    owner.getId(),
                    id,
                    form.getEmail(),
                    form.getShopId(),
                    form.getFirstName(),
                    form.getLastName(),
                    form.getPhone(),
                    form.isActive()
            );
            redirectAttributes.addFlashAttribute("message", "Repairer updated successfully");
        } catch (IllegalStateException | IllegalArgumentException e) {
            try {
                User repairer = userService.getReparateurById(id);
                List<Shop> shops = getShopsForCurrentView();
                bindingResult.reject("user.update.failed", e.getMessage());
                prepareRepairerEditModel(model, repairer, shops, form.getShopId());
                return "users/form";
            } catch (EntityNotFoundException nested) {
                redirectAttributes.addFlashAttribute("error", nested.getMessage());
            }
        } catch (EntityNotFoundException | AccessDeniedException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/users/manage";
    }

    @PostMapping("/{id}/delete")
    public String deleteRepairer(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        User owner = getCurrentUser();
        if (owner == null) {
            return "redirect:/login";
        }

        try {
            shopAccessService.assertRepairerManagedByOwner(id);
            userService.deleteReparateur(owner.getId(), id);
            redirectAttributes.addFlashAttribute("message", "Repairer deleted successfully");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (EntityNotFoundException | AccessDeniedException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/users/manage";
    }

    @PostMapping("/{id}/deactivate")
    public String deactivateUser(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        if (getCurrentUser() == null) {
            return "redirect:/login";
        }

        try {
            shopAccessService.assertRepairerManagedByOwner(id);
            userService.deactivateUser(id);
            redirectAttributes.addFlashAttribute("message", "User deactivated successfully");
        } catch (EntityNotFoundException | AccessDeniedException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/users/manage";
    }

    @PostMapping("/{id}/reset-password")
    public String resetPassword(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        User owner = getCurrentUser();
        if (owner == null) {
            return "redirect:/login";
        }

        try {
            shopAccessService.assertRepairerManagedByOwner(id);
            CreatedUserPasswordDto created = userService.resetRepairerPassword(owner.getId(), id);
            redirectAttributes.addFlashAttribute("generatedPassword", created.getPlainPassword());
            redirectAttributes.addFlashAttribute("generatedUsername", created.getUsername());
            redirectAttributes.addFlashAttribute("message", "Repairer password reinitialized successfully");
        } catch (EntityNotFoundException | AccessDeniedException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/users/manage";
    }

    private Long resolveSelectedShopId(User repairer, List<Shop> ownerShops) {
        if (repairer.getShop() == null) {
            return ownerShops != null && !ownerShops.isEmpty() ? ownerShops.get(0).getId() : null;
        }
        return repairer.getShop().getId();
    }

    private UpdateRepairerRequest toUpdateRepairerRequest(User repairer, Long selectedShopId) {
        UpdateRepairerRequest form = new UpdateRepairerRequest();
        form.setEmail(repairer.getEmail());
        form.setShopId(selectedShopId);
        form.setFirstName(repairer.getFirstName());
        form.setLastName(repairer.getLastName());
        form.setPhone(repairer.getPhone());
        form.setActive(Boolean.TRUE.equals(repairer.getActive()));
        return form;
    }

    private void prepareRepairerCreateModel(Model model) {
        model.addAttribute("shops", getShopsForCurrentView());
    }

    private void prepareRepairerEditModel(Model model, User repairer, List<Shop> shops, Long selectedShopId) {
        model.addAttribute("user", repairer);
        model.addAttribute("shops", shops);
        model.addAttribute("selectedShopId", selectedShopId);
        model.addAttribute("editMode", true);
    }

    private User getCurrentUser() {
        return shopAccessService.getCurrentUser();
    }

    private List<Shop> getShopsForCurrentView() {
        Set<Long> shopIds = shopAccessService.getShopIdsForCurrentView();
        return shopAccessService.getAccessibleShops().stream()
                .filter(shop -> shop.getId() != null && shopIds.contains(shop.getId()))
                .collect(Collectors.toList());
    }

    private boolean isShopInCurrentView(Long shopId) {
        if (shopId == null) {
            return false;
        }
        User current = shopAccessService.getCurrentUser();
        if (current != null && current.isAdmin()) {
            return shopAccessService.getShopIdsForCurrentView().contains(shopId);
        }
        return shopAccessService.getAccessibleShopIds().contains(shopId)
                && shopAccessService.getShopIdsForCurrentView().contains(shopId);
    }
}
