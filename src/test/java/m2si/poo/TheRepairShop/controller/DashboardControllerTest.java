package m2si.poo.TheRepairShop.controller;

import org.junit.jupiter.api.Test;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

public class DashboardControllerTest extends BaseControllerTest {

    @Test
    public void testDashboardAccessUnauthenticatedRedirectsToLogin() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/dashboard"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/login"));
    }

    @Test
    public void testDashboardAccessAuthenticatedAsOwner() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/dashboard")
                        .with(user("salma.owner").roles("OWNER")))
                .andExpect(status().isOk())
                .andExpect(view().name("dashboard"))
                .andExpect(model().attributeExists("stats"))
                .andExpect(model().attributeExists("recentRepairs"))
                .andExpect(model().attributeExists("workloadByTechnician"))
                .andExpect(model().attribute("shopName", "Atelier Hassan II"));
    }

    @Test
    public void testDashboardAccessAuthenticatedAsRepairer() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/dashboard")
                        .with(user("amina.tech").roles("REPARATEUR")))
                .andExpect(status().isOk())
                .andExpect(view().name("dashboard"))
                .andExpect(model().attributeExists("stats"))
                .andExpect(model().attributeExists("recentRepairs"))
                .andExpect(model().attributeExists("workloadByTechnician"))
                .andExpect(model().attribute("shopName", "Atelier Hassan II"));
    }
}
