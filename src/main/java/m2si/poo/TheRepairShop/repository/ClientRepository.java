package m2si.poo.TheRepairShop.repository;

import m2si.poo.TheRepairShop.model.Client;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

@Repository
public interface ClientRepository extends JpaRepository<Client, Long> {
    List<Client> findByLastNameContainingIgnoreCase(String name);
    List<Client> findByShopIdIn(Collection<Long> shopIds);
    List<Client> findByShopIdInAndLastNameContainingIgnoreCase(Collection<Long> shopIds, String name);
    Page<Client> findByShopIdIn(Collection<Long> shopIds, Pageable pageable);
    Page<Client> findByShopIdInAndLastNameContainingIgnoreCase(Collection<Long> shopIds, String name, Pageable pageable);
    Optional<Client> findByEmail(String email);
    Optional<Client> findByTrackingKey(String trackingKey);
    List<Client> findByShopId(Long shopId);
}
