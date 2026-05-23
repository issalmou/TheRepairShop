package m2si.poo.TheRepairShop.repository;

import m2si.poo.TheRepairShop.model.Device;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;

@Repository
public interface DeviceRepository extends JpaRepository<Device, Long> {
    List<Device> findByClientId(Long clientId);

    @Query("""
            SELECT d FROM Device d
            JOIN d.client c
            WHERE c.shop.id IN :shopIds
            ORDER BY c.lastName, c.firstName, d.brand, d.model
            """)
    List<Device> findByClientShopIdIn(@Param("shopIds") Collection<Long> shopIds);
}
