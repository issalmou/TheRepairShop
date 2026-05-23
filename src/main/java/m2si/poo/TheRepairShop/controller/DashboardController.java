package m2si.poo.TheRepairShop.controller;

import m2si.poo.TheRepairShop.service.facade.ReportService;
import m2si.poo.TheRepairShop.service.implementation.ShopAccessService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.Collections;
import java.util.Set;

@Controller
public class DashboardController {

    private final ReportService reportService;
    private final ShopAccessService shopAccessService;

    public DashboardController(ReportService reportService, ShopAccessService shopAccessService) {
        this.reportService = reportService;
        this.shopAccessService = shopAccessService;
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        Set<Long> shopIds = shopAccessService.getShopIdsForCurrentView();
        if (shopIds.isEmpty()) {
            model.addAttribute("stats", Collections.emptyMap());
            model.addAttribute("recentRepairs", Collections.emptyList());
            model.addAttribute("workloadByTechnician", Collections.emptyList());
        } else {
            model.addAttribute("stats", reportService.getDashboardStats(shopIds));
            model.addAttribute("recentRepairs", reportService.getRecentRepairs(shopIds, 6));
            model.addAttribute("workloadByTechnician", reportService.getWorkloadByTechnician(shopIds));
            String shopName = shopAccessService.getDashboardShopLabel(shopIds);
            model.addAttribute("shopName", shopName);
        }
        return "dashboard";
    }
}
