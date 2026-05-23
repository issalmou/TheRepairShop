package m2si.poo.TheRepairShop.service.implementation;

import m2si.poo.TheRepairShop.model.Client;
import m2si.poo.TheRepairShop.model.Device;
import m2si.poo.TheRepairShop.model.Repair;
import m2si.poo.TheRepairShop.model.Shop;
import m2si.poo.TheRepairShop.model.User;
import m2si.poo.TheRepairShop.repository.ClientRepository;
import m2si.poo.TheRepairShop.repository.DeviceRepository;
import m2si.poo.TheRepairShop.repository.RepairRepository;
import m2si.poo.TheRepairShop.repository.ShopRepository;
import m2si.poo.TheRepairShop.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class ShopAccessService {

    /** When set in session, owner lists/dashboard are scoped to this shop only; absent = all owned shops. */
    public static final String SESSION_OWNER_SELECTED_SHOP_ID = "OWNER_SELECTED_SHOP_ID";

    private final UserRepository userRepository;
    private final ShopRepository shopRepository;
    private final ClientRepository clientRepository;
    private final DeviceRepository deviceRepository;
    private final RepairRepository repairRepository;

    public ShopAccessService(
            UserRepository userRepository,
            ShopRepository shopRepository,
            ClientRepository clientRepository,
            DeviceRepository deviceRepository,
            RepairRepository repairRepository
    ) {
        this.userRepository = userRepository;
        this.shopRepository = shopRepository;
        this.clientRepository = clientRepository;
        this.deviceRepository = deviceRepository;
        this.repairRepository = repairRepository;
    }

    public User getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return null;
        }
        return userRepository.findByUsername(auth.getName()).orElse(null);
    }

    public Set<Long> getAccessibleShopIds() {
        User user = getCurrentUser();
        if (user == null) {
            return Collections.emptySet();
        }

        Set<Long> shopIds = new HashSet<>();
        if (user.isAdmin()) {
            shopRepository.findAll().forEach(shop -> {
                if (shop.getId() != null) {
                    shopIds.add(shop.getId());
                }
            });
            return shopIds;
        }
        if (user.isOwner()) {
            shopRepository.findByOwnerId(user.getId()).forEach(shop -> shopIds.add(shop.getId()));
        }
        if (user.getShop() != null) {
            shopIds.add(user.getShop().getId());
        }
        return shopIds;
    }

    /**
     * Shop IDs used for listing dashboard, repairs, clients, and reports.
     * Owners may narrow to one shop via session; technicians always see their assigned shops.
     */
    public Set<Long> getShopIdsForCurrentView() {
        User user = getCurrentUser();
        if (user == null) {
            return Collections.emptySet();
        }
        Set<Long> accessible = getAccessibleShopIds();
        if (!user.isOwnerOrAdmin()) {
            return accessible;
        }
        HttpSession session = currentSession();
        if (session == null) {
            return accessible;
        }
        Object attr = session.getAttribute(SESSION_OWNER_SELECTED_SHOP_ID);
        if (!(attr instanceof Long selectedId)) {
            return accessible;
        }
        if (!accessible.contains(selectedId)) {
            session.removeAttribute(SESSION_OWNER_SELECTED_SHOP_ID);
            return accessible;
        }
        return Collections.singleton(selectedId);
    }

    public Long getOwnerSelectedShopId() {
        User user = getCurrentUser();
        if (user == null || !user.isOwnerOrAdmin()) {
            return null;
        }
        HttpSession session = currentSession();
        if (session == null) {
            return null;
        }
        Object attr = session.getAttribute(SESSION_OWNER_SELECTED_SHOP_ID);
        return attr instanceof Long ? (Long) attr : null;
    }

    public void setOwnerSelectedShopId(Long shopId, HttpSession session) {
        User user = getCurrentUser();
        if (user == null || !user.isOwnerOrAdmin()) {
            throw new AccessDeniedException("Only shop owners or admins can change the selected shop");
        }
        if (session == null) {
            return;
        }
        Set<Long> accessible = getAccessibleShopIds();
        if (shopId == null) {
            session.removeAttribute(SESSION_OWNER_SELECTED_SHOP_ID);
            return;
        }
        if (!accessible.contains(shopId)) {
            throw new AccessDeniedException("Access denied to shop");
        }
        session.setAttribute(SESSION_OWNER_SELECTED_SHOP_ID, shopId);
    }

    private HttpSession currentSession() {
        ServletRequestAttributes attrs = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attrs == null) {
            return null;
        }
        return attrs.getRequest().getSession(true);
    }

    public List<Shop> getAccessibleShops() {
        Set<Long> shopIds = getAccessibleShopIds();
        if (shopIds.isEmpty()) {
            return Collections.emptyList();
        }
        List<Shop> shops = new ArrayList<>(shopRepository.findAllById(shopIds));
        shops.sort(Comparator.comparing(Shop::getName, Comparator.nullsLast(String::compareToIgnoreCase)));
        return shops;
    }

    public Shop resolveShopForWrite(Long shopId) {
        Set<Long> accessible = getAccessibleShopIds();
        if (accessible.isEmpty()) {
            throw new AccessDeniedException("No shop access");
        }

        if (shopId != null) {
            if (!accessible.contains(shopId)) {
                throw new AccessDeniedException("Access denied to shop");
            }
            return shopRepository.findById(shopId)
                    .orElseThrow(() -> new EntityNotFoundException("Shop not found with id: " + shopId));
        }

        if (accessible.size() == 1) {
            Long onlyShopId = accessible.iterator().next();
            return shopRepository.findById(onlyShopId)
                    .orElseThrow(() -> new EntityNotFoundException("Shop not found with id: " + onlyShopId));
        }

        throw new IllegalStateException("shopId is required when you have access to multiple shops");
    }

    public void assertShopAccess(Long shopId) {
        if (shopId == null || !getAccessibleShopIds().contains(shopId)) {
            throw new AccessDeniedException("Access denied to shop");
        }
    }

    public void assertClientAccess(Long clientId) {
        Client client = clientRepository.findById(clientId)
                .orElseThrow(() -> new EntityNotFoundException("Client not found with id: " + clientId));
        assertClientAccess(client);
    }

    public void assertClientAccess(Client client) {
        if (client.getShop() == null || client.getShop().getId() == null) {
            throw new AccessDeniedException("Client is not assigned to a shop");
        }
        assertShopAccess(client.getShop().getId());
    }

    public void assertDeviceAccess(Long deviceId) {
        Device device = deviceRepository.findById(deviceId)
                .orElseThrow(() -> new EntityNotFoundException("Device not found with id: " + deviceId));
        assertDeviceAccess(device);
    }

    public void assertDeviceAccess(Device device) {
        if (device.getClient() == null) {
            throw new AccessDeniedException("Device is not linked to a client");
        }
        assertClientAccess(device.getClient());
    }

    public void assertRepairAccess(Long repairId) {
        Repair repair = repairRepository.findById(repairId)
                .orElseThrow(() -> new EntityNotFoundException("Repair not found with id: " + repairId));
        assertRepairAccess(repair);
    }

    public void assertRepairAccess(Repair repair) {
        if (repair.getDevice() == null || repair.getDevice().getClient() == null) {
            throw new AccessDeniedException("Repair is not linked to a shop client");
        }
        assertClientAccess(repair.getDevice().getClient());
    }

    public List<User> getRepairersForShop(Long shopId) {
        assertShopAccess(shopId);
        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new EntityNotFoundException("Shop not found with id: " + shopId));

        List<User> repairers = new ArrayList<>();
        if (shop.getUsers() == null) {
            return repairers;
        }
        for (User user : shop.getUsers()) {
            if (user.isReparateur() && Boolean.TRUE.equals(user.getActive())) {
                repairers.add(user);
            }
        }
        return repairers;
    }

    public List<User> getRepairersForRepair(Repair repair) {
        assertRepairAccess(repair);
        Long shopId = repair.getDevice().getClient().getShop().getId();
        return getRepairersForShop(shopId);
    }

    public void assertRepairerManagedByOwner(Long repairerId) {
        User repairer = userRepository.findById(repairerId)
                .orElseThrow(() -> new EntityNotFoundException("User not found with id: " + repairerId));
        if (!repairer.isReparateur()) {
            throw new AccessDeniedException("User is not a repairer");
        }
        User current = getCurrentUser();
        if (current != null && current.isAdmin()) {
            return;
        }
        Set<Long> accessibleShopIds = getAccessibleShopIds();
        if (repairer.getShop() == null || !accessibleShopIds.contains(repairer.getShop().getId())) {
            throw new AccessDeniedException("Repairer is not assigned to your shops");
        }
    }

    /**
     * Short label for dashboard subtitle (single shop name, "All shops", or comma-separated names).
     */
    public String getDashboardShopLabel(Set<Long> shopIds) {
        if (shopIds == null || shopIds.isEmpty()) {
            return "";
        }
        User user = getCurrentUser();
        if (user != null && user.isOwnerOrAdmin() && shopIds.size() > 1) {
            Long selected = getOwnerSelectedShopId();
            if (selected == null) {
                return "All shops";
            }
        }
        List<Shop> shops = new ArrayList<>(shopRepository.findAllById(shopIds));
        shops.sort(Comparator.comparing(Shop::getName, Comparator.nullsLast(String::compareToIgnoreCase)));
        return shops.stream()
                .map(Shop::getName)
                .filter(n -> n != null && !n.isBlank())
                .collect(Collectors.joining(", "));
    }
}
