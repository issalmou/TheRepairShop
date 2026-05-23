package m2si.poo.TheRepairShop.controller;

import m2si.poo.TheRepairShop.model.Shop;
import m2si.poo.TheRepairShop.model.User;
import m2si.poo.TheRepairShop.service.implementation.ShopAccessService;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.List;

@ControllerAdvice
public class ShopSelectionModelAdvice {

    private final ShopAccessService shopAccessService;

    public ShopSelectionModelAdvice(ShopAccessService shopAccessService) {
        this.shopAccessService = shopAccessService;
    }

    @ModelAttribute
    public void addOwnerShopSwitcher(Model model) {
        User user = shopAccessService.getCurrentUser();
        if (user == null || !user.isOwnerOrAdmin()) {
            return;
        }
        List<Shop> shops = shopAccessService.getAccessibleShops();
        if (shops.size() <= 1) {
            return;
        }
        model.addAttribute("ownerShopSwitcher", Boolean.TRUE);
        model.addAttribute("ownerShopsForSwitcher", shops);
        model.addAttribute("ownerSelectedShopId", shopAccessService.getOwnerSelectedShopId());
    }
}
