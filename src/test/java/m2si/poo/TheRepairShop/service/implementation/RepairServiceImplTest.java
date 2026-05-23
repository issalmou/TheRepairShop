package m2si.poo.TheRepairShop.service.implementation;

import m2si.poo.TheRepairShop.enums.RepairStatus;
import m2si.poo.TheRepairShop.model.*;
import m2si.poo.TheRepairShop.repository.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.access.AccessDeniedException;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class RepairServiceImplTest {

    @Mock
    private RepairRepository repairRepository;

    @Mock
    private DeviceRepository deviceRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private RepairProgressRepository repairProgressRepository;

    @Mock
    private ShopAccessService shopAccessService;

    @InjectMocks
    private RepairServiceImpl repairService;

    private User testUser;
    private Device testDevice;
    private Repair testRepair;

    @BeforeEach
    public void setup() {
        testUser = new Repairer();
        testUser.setId(1L);
        testUser.setUsername("tech");

        testDevice = new Device();
        testDevice.setId(2L);
        testDevice.setBrand("Samsung");
        testDevice.setModel("Galaxy");

        testRepair = new Repair();
        testRepair.setId(3L);
        testRepair.setDevice(testDevice);
        testRepair.setStatus(RepairStatus.PENDING);
        testRepair.setCreatedBy(testUser);
    }

    @Test
    public void testCreateRepair_Success() {
        when(deviceRepository.findById(2L)).thenReturn(Optional.of(testDevice));
        when(shopAccessService.getCurrentUser()).thenReturn(testUser);
        when(repairRepository.existsByDeviceIdAndStatusIn(eq(2L), any())).thenReturn(false);
        when(repairRepository.save(any(Repair.class))).thenAnswer(invocation -> invocation.getArgument(0));

        Repair created = repairService.createRepair(2L, "Flashed screen");

        assertThat(created).isNotNull();
        assertThat(created.getDescription()).isEqualTo("Flashed screen");
        assertThat(created.getStatus()).isEqualTo(RepairStatus.PENDING);

        verify(repairProgressRepository, times(1)).save(any(RepairProgress.class));
    }

    @Test
    public void testCreateRepair_DeviceHasActiveRepair() {
        when(deviceRepository.findById(2L)).thenReturn(Optional.of(testDevice));
        when(repairRepository.existsByDeviceIdAndStatusIn(eq(2L), any())).thenReturn(true);

        assertThatThrownBy(() -> repairService.createRepair(2L, "Flashed screen"))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("already has an open repair ticket");
    }

    @Test
    public void testAssignRepair_Success() {
        User technician = new Repairer();
        technician.setId(4L);
        technician.setUsername("alex");

        when(repairRepository.findById(3L)).thenReturn(Optional.of(testRepair));
        when(userRepository.findById(4L)).thenReturn(Optional.of(technician));
        when(shopAccessService.getRepairersForRepair(testRepair)).thenReturn(List.of(technician));
        when(shopAccessService.getCurrentUser()).thenReturn(testUser);
        when(repairRepository.save(any(Repair.class))).thenAnswer(invocation -> invocation.getArgument(0));

        Repair assigned = repairService.assignRepair(3L, 4L);

        assertThat(assigned.getStatus()).isEqualTo(RepairStatus.IN_PROGRESS);
        assertThat(assigned.getAssignedTechnician()).isEqualTo(technician);
        verify(repairProgressRepository, times(1)).save(any(RepairProgress.class));
    }

    @Test
    public void testAssignRepair_TechnicianNotInShop() {
        User technician = new Repairer();
        technician.setId(4L);
        technician.setUsername("alex");

        when(repairRepository.findById(3L)).thenReturn(Optional.of(testRepair));
        when(userRepository.findById(4L)).thenReturn(Optional.of(technician));
        when(shopAccessService.getRepairersForRepair(testRepair)).thenReturn(Collections.emptyList());

        assertThatThrownBy(() -> repairService.assignRepair(3L, 4L))
                .isInstanceOf(AccessDeniedException.class)
                .hasMessageContaining("Technician does not belong to this shop");
    }

    @Test
    public void testUpdateDiagnosis_Success() {
        testRepair.setStatus(RepairStatus.IN_PROGRESS);
        when(repairRepository.findById(3L)).thenReturn(Optional.of(testRepair));
        when(shopAccessService.getCurrentUser()).thenReturn(testUser);
        when(repairRepository.save(any(Repair.class))).thenAnswer(invocation -> invocation.getArgument(0));

        Repair completed = repairService.updateDiagnosis(3L, "Dead battery replaced", new BigDecimal("350.00"));

        assertThat(completed.getStatus()).isEqualTo(RepairStatus.COMPLETED);
        assertThat(completed.getDiagnosis()).isEqualTo("Dead battery replaced");
        assertThat(completed.getFinalCost()).isEqualTo(new BigDecimal("350.00"));
        verify(repairProgressRepository, times(1)).save(any(RepairProgress.class));
    }
}
