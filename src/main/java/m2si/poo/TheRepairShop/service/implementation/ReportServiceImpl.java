package m2si.poo.TheRepairShop.service.implementation;

import m2si.poo.TheRepairShop.enums.RepairStatus;
import m2si.poo.TheRepairShop.model.Repair;
import m2si.poo.TheRepairShop.model.User;
import m2si.poo.TheRepairShop.repository.RepairRepository;
import m2si.poo.TheRepairShop.repository.ShopRepository;
import m2si.poo.TheRepairShop.service.facade.ReportService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ReportServiceImpl implements ReportService {

    private final RepairRepository repairRepository;
    private final ShopRepository shopRepository;

    public ReportServiceImpl(RepairRepository repairRepository, ShopRepository shopRepository) {
        this.repairRepository = repairRepository;
        this.shopRepository = shopRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getDashboardStats(Collection<Long> shopIds) {
        Map<String, Object> stats = new HashMap<>();
        if (shopIds == null || shopIds.isEmpty()) {
            return stats;
        }

        List<Repair> shopRepairs = repairRepository.findByShopIds(shopIds);

        long totalRepairs = shopRepairs.size();
        long pendingCount = shopRepairs.stream().filter(r -> r.getStatus() == RepairStatus.PENDING).count();
        long inProgressCount = shopRepairs.stream().filter(r -> r.getStatus() == RepairStatus.IN_PROGRESS).count();
        long completedCount = shopRepairs.stream().filter(r -> r.getStatus() == RepairStatus.COMPLETED).count();
        long returnedCount = shopRepairs.stream().filter(r -> r.getStatus() == RepairStatus.RETURNED).count();

        BigDecimal totalRevenue = BigDecimal.ZERO;
        for (Repair r : shopRepairs) {
            if ((r.getStatus() == RepairStatus.COMPLETED || r.getStatus() == RepairStatus.RETURNED)
                    && r.getFinalCost() != null) {
                totalRevenue = totalRevenue.add(r.getFinalCost());
            }
        }

        stats.put("totalRepairs", totalRepairs);
        stats.put("pendingCount", pendingCount);
        stats.put("inProgressCount", inProgressCount);
        stats.put("completedCount", completedCount);
        stats.put("returnedCount", returnedCount);
        stats.put("totalRevenue", totalRevenue);

        return stats;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Repair> getOverdueRepairs(Collection<Long> shopIds, int thresholdDays) {
        if (shopIds == null || shopIds.isEmpty()) {
            return Collections.emptyList();
        }

        LocalDateTime cutoff = LocalDateTime.now().minusDays(thresholdDays);
        return repairRepository.findByShopIdsAndStatus(shopIds, RepairStatus.IN_PROGRESS).stream()
                .filter(r -> r.getCreatedAt() != null && r.getCreatedAt().isBefore(cutoff))
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getWorkloadByTechnician(Collection<Long> shopIds) {
        if (shopIds == null || shopIds.isEmpty()) {
            return Collections.emptyList();
        }

        List<Repair> shopRepairs = repairRepository.findByShopIds(shopIds);

        Map<User, List<Repair>> grouped = shopRepairs.stream()
                .filter(r -> r.getAssignedTechnician() != null)
                .collect(Collectors.groupingBy(Repair::getAssignedTechnician));

        List<Map<String, Object>> result = new ArrayList<>();

        for (Map.Entry<User, List<Repair>> e : grouped.entrySet()) {
            User tech = e.getKey();
            List<Repair> list = e.getValue();
            long assignedCount = list.size();
            long completedCount = list.stream().filter(r -> r.getStatus() == RepairStatus.COMPLETED).count();

            Map<String, Object> map = new HashMap<>();
            map.put("technician", tech);
            map.put("assignedCount", assignedCount);
            map.put("completedCount", completedCount);

            result.add(map);
        }

        result.sort((a, b) -> Long.compare((Long) b.get("assignedCount"), (Long) a.get("assignedCount")));

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Repair> getRecentRepairs(Collection<Long> shopIds, int limit) {
        if (shopIds == null || shopIds.isEmpty() || limit <= 0) {
            return Collections.emptyList();
        }
        return repairRepository.findByShopIdsWithDeviceAndClient(shopIds).stream()
                .limit(limit)
                .collect(Collectors.toList());
    }
}
