package m2si.poo.TheRepairShop.repository;

import m2si.poo.TheRepairShop.model.RepairProgress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RepairProgressRepository extends JpaRepository<RepairProgress, Long> {
    List<RepairProgress> findByRepairIdOrderByCreatedAtAsc(Long repairId);
}
