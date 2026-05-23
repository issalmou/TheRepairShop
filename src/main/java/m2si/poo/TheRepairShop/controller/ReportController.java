package m2si.poo.TheRepairShop.controller;

import m2si.poo.TheRepairShop.model.Repair;
import m2si.poo.TheRepairShop.service.facade.ReportService;
import m2si.poo.TheRepairShop.service.implementation.ShopAccessService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Controller
@RequestMapping("/reports")
public class ReportController {

    private final ReportService reportService;
    private final ShopAccessService shopAccessService;
    private static final int THRESHOLD_DAYS = 7;

    public ReportController(ReportService reportService, ShopAccessService shopAccessService) {
        this.reportService = reportService;
        this.shopAccessService = shopAccessService;
    }

    @GetMapping("/overdue")
    public String overdue(@RequestParam(value = "threshold", required = false) Integer threshold, Model model) {
        int thresholdDays = (threshold != null && threshold > 0) ? threshold : THRESHOLD_DAYS;
        Set<Long> shopIds = shopAccessService.getShopIdsForCurrentView();
        List<Repair> overdue = shopIds.isEmpty()
                ? Collections.emptyList()
                : reportService.getOverdueRepairs(shopIds, thresholdDays);
        model.addAttribute("overdueRepairs", overdue);
        model.addAttribute("thresholdDays", thresholdDays);
        return "reports/overdue";
    }

    @GetMapping("/workload")
    public String workload(Model model) {
        Set<Long> shopIds = shopAccessService.getShopIdsForCurrentView();
        List<Map<String, Object>> workload = shopIds.isEmpty()
                ? Collections.emptyList()
                : reportService.getWorkloadByTechnician(shopIds);
        model.addAttribute("workloadByTechnician", workload);
        return "reports/workload";
    }
}
