package m2si.poo.TheRepairShop.controller;

import m2si.poo.TheRepairShop.model.Shop;
import m2si.poo.TheRepairShop.model.User;
import m2si.poo.TheRepairShop.repository.UserRepository;
import m2si.poo.TheRepairShop.service.implementation.ShopAccessService;
import m2si.poo.TheRepairShop.service.facade.ShopService;
import m2si.poo.TheRepairShop.service.facade.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/shops")
public class ShopController {

    private final ShopService shopService;
    private final UserRepository userRepository;
    private final ShopAccessService shopAccessService;
    private final UserService userService;

    public ShopController(
            ShopService shopService,
            UserRepository userRepository,
            ShopAccessService shopAccessService,
            UserService userService
    ) {
        this.shopService = shopService;
        this.userRepository = userRepository;
        this.shopAccessService = shopAccessService;
        this.userService = userService;
    }

    @PostMapping("/select")
    public String selectShopForView(
            @RequestParam(required = false) String shopId,
            @RequestParam(required = false) String redirect,
            HttpSession session,
            HttpServletRequest request
    ) {
        Long id = null;
        if (shopId != null && !shopId.isBlank()) {
            try {
                id = Long.parseLong(shopId);
            } catch (NumberFormatException ex) {
                return "redirect:/dashboard";
            }
        }
        shopAccessService.setOwnerSelectedShopId(id, session);
        if (redirect != null && isSafeRelativeRedirect(request, redirect)) {
            return "redirect:" + redirect;
        }
        return "redirect:/dashboard";
    }

    private static boolean isSafeRelativeRedirect(HttpServletRequest request, String target) {
        if (target == null || target.isBlank()) {
            return false;
        }
        if (target.contains("\r") || target.contains("\n")) {
            return false;
        }
        if (!target.startsWith("/")) {
            return false;
        }
        if (target.startsWith("//")) {
            return false;
        }
        if (target.contains("://")) {
            return false;
        }
        if (target.contains("/WEB-INF/") || target.contains("/META-INF/")) {
            return false;
        }
        String ctx = request.getContextPath();
        if (ctx != null && !ctx.isEmpty() && !target.startsWith(ctx)) {
            return false;
        }
        return true;
    }

    @GetMapping
    public String listShops(Model model, Principal principal) {
        User current = getCurrentUser(principal);
        if (current == null) {
            return "redirect:/login";
        }

        List<Shop> shops = current.isAdmin()
                ? shopService.getAllShops()
                : shopService.getShopsByOwner(current.getId());
        model.addAttribute("shops", shops);
        model.addAttribute("adminView", current.isAdmin());
        return "shops/list";
    }

    @GetMapping("/new")
    public String showCreateForm(Model model, Principal principal) {
        User current = getCurrentUser(principal);
        if (current == null) {
            return "redirect:/login";
        }

        model.addAttribute("shop", new Shop());
        if (current.isAdmin()) {
            model.addAttribute("owners", userService.getAllOwners());
            model.addAttribute("adminCreate", true);
        }
        return "shops/form";
    }

    @PostMapping
    public String createShop(
            @ModelAttribute Shop shop,
            @RequestParam(required = false) Long ownerId,
            Principal principal,
            RedirectAttributes redirectAttributes
    ) {
        User current = getCurrentUser(principal);
        if (current == null) {
            return "redirect:/login";
        }

        Long targetOwnerId = current.isAdmin() ? ownerId : current.getId();
        if (targetOwnerId == null) {
            redirectAttributes.addFlashAttribute("error", "Please select an owner for this shop.");
            return "redirect:/shops/new";
        }

        shopService.createShop(shop, targetOwnerId);
        redirectAttributes.addFlashAttribute("message", "Shop created successfully");
        return "redirect:/shops";
    }

    @GetMapping("/{id}/edit")
    public String showEditForm(@PathVariable Long id, Model model, Principal principal) {
        if (getCurrentUser(principal) == null) {
            return "redirect:/login";
        }

        Shop shop = shopService.getShopById(id);
        model.addAttribute("shop", shop);
        return "shops/form";
    }

    @PostMapping("/{id}")
    public String updateShop(
            @PathVariable Long id,
            @ModelAttribute Shop updated,
            Principal principal,
            RedirectAttributes redirectAttributes
    ) {
        if (getCurrentUser(principal) == null) {
            return "redirect:/login";
        }

        Shop shop = shopService.getShopById(id);
        shop.setName(updated.getName());
        shop.setAddress(updated.getAddress());
        shop.setPhone(updated.getPhone());

        shopService.updateShop(shop);
        redirectAttributes.addFlashAttribute("message", "Shop updated successfully");
        return "redirect:/shops";
    }

    @PostMapping("/{id}/delete")
    public String deleteShop(@PathVariable Long id, Principal principal, RedirectAttributes redirectAttributes) {
        if (getCurrentUser(principal) == null) {
            return "redirect:/login";
        }

        shopService.deleteShop(id);
        redirectAttributes.addFlashAttribute("message", "Shop deleted successfully");
        return "redirect:/shops";
    }

    private User getCurrentUser(Principal principal) {
        if (principal == null) {
            return null;
        }
        return userRepository.findByUsername(principal.getName()).orElse(null);
    }
}
