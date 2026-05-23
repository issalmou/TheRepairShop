package m2si.poo.TheRepairShop.service.implementation;

import m2si.poo.TheRepairShop.model.Shop;
import m2si.poo.TheRepairShop.model.User;
import m2si.poo.TheRepairShop.model.Owner;
import m2si.poo.TheRepairShop.repository.ShopRepository;
import m2si.poo.TheRepairShop.repository.UserRepository;
import m2si.poo.TheRepairShop.service.facade.ShopService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ShopServiceImpl implements ShopService {

    @Autowired
    private ShopRepository shopRepository;

    @Autowired
    private UserRepository userRepository;

    @Override
    public Shop createShop(Shop shop, Long ownerId) {
        User user = userRepository.findById(ownerId)
                .orElseThrow(() -> new EntityNotFoundException("User not found with id: " + ownerId));
        if (!(user instanceof Owner)) {
            throw new IllegalArgumentException("User with id " + ownerId + " is not an Owner");
        }
        Owner owner = (Owner) user;
        shop.setOwner(owner);
        Shop saved = shopRepository.save(shop);
        saved.getUsers().add(owner);
        return shopRepository.save(saved);
    }

    @Override
    public List<Shop> getShopsByOwner(Long ownerId) {
        return shopRepository.findByOwnerId(ownerId);
    }

    @Override
    public List<Shop> getAllShops() {
        return shopRepository.findAll();
    }

    @Override
    public Shop getShopById(Long id) {
        return shopRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Shop not found with id: " + id));
    }

    @Override
    public Shop updateShop(Shop shop) {
        return shopRepository.save(shop)
    }

    @Override
    public void deleteShop(Long id) {
        Shop shop = getShopById(id);
        shop.setActive(false);
        shopRepository.save(shop);
    }
}
