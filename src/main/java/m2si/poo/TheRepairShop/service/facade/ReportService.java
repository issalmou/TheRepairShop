package m2si.poo.TheRepairShop.service.facade;

import m2si.poo.TheRepairShop.model.Repair;

import java.util.Collection;
import java.util.List;
import java.util.Map;

public interface ReportService {
    Map<String, Object> getDashboardStats(Collection<Long> shopIds);

    List<Repair> getOverdueRepairs(Collection<Long> shopIds, int thresholdDays);

    List<Map<String, Object>> getWorkloadByTechnician(Collection<Long> shopIds);

    List<Repair> getRecentRepairs(Collection<Long> shopIds, int limit);
}
