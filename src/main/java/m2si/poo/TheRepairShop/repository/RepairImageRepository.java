package m2si.poo.TheRepairShop.repository;

import m2si.poo.TheRepairShop.model.RepairImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RepairImageRepository extends JpaRepository<RepairImage, Long> {
    List<RepairImage> findByRepairId(Long repairId);
}
