package m2si.poo.TheRepairShop.repository;

import m2si.poo.TheRepairShop.enums.RepairStatus;
import m2si.poo.TheRepairShop.model.Repair;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;
import java.util.Set;

@Repository
public interface RepairRepository extends JpaRepository<Repair, Long> {
    List<Repair> findByStatus(RepairStatus status);
    List<Repair> findByAssignedTechnicianId(Long technicianId);
    List<Repair> findByCreatedById(Long userId);
    long countByStatus(RepairStatus status);

    @Query("""
            SELECT r FROM Repair r
            JOIN r.device d
            JOIN d.client c
            WHERE c.shop.id IN :shopIds
            ORDER BY r.createdAt DESC
            """)
    List<Repair> findByShopIds(@Param("shopIds") Collection<Long> shopIds);

    @Query("""
            SELECT r FROM Repair r
            JOIN FETCH r.device d
            JOIN FETCH d.client c
            WHERE c.shop.id IN :shopIds
            ORDER BY r.createdAt DESC
            """)
    List<Repair> findByShopIdsWithDeviceAndClient(@Param("shopIds") Collection<Long> shopIds);

    @Query("""
            SELECT r FROM Repair r
            JOIN r.device d
            JOIN d.client c
            WHERE c.shop.id IN :shopIds AND r.status = :status
            ORDER BY r.createdAt DESC
            """)
    List<Repair> findByShopIdsAndStatus(
            @Param("shopIds") Collection<Long> shopIds,
            @Param("status") RepairStatus status
    );

    @Query("""
            SELECT r FROM Repair r
            JOIN r.device d
            JOIN d.client c
            WHERE c.trackingKey = :trackingKey
            ORDER BY r.createdAt DESC
            """)
    List<Repair> findByClientTrackingKey(@Param("trackingKey") String trackingKey);

    boolean existsByDeviceIdAndStatusIn(Long deviceId, Set<RepairStatus> statuses);
}
