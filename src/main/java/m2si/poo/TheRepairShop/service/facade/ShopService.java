package m2si.poo.TheRepairShop.service.facade;

import m2si.poo.TheRepairShop.model.Shop;

import java.util.List;

public interface ShopService {
    Shop createShop(Shop shop, Long ownerId);
    List<Shop> getShopsByOwner(Long ownerId);
    List<Shop> getAllShops();
    Shop getShopById(Long id);
    Shop updateShop(Shop shop);
    void deleteShop(Long id);
}
