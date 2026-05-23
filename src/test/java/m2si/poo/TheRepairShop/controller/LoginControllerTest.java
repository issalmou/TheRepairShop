package m2si.poo.TheRepairShop.controller;

import org.junit.jupiter.api.Test;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

public class LoginControllerTest extends BaseControllerTest {

    @Test
    public void testGetLoginPage() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/login"))
                .andExpect(status().isOk())
                .andExpect(view().name("login"));
    }

    @Test
    public void testLoginWithValidUser() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.post("/login")
                        .param("username", "salma.owner")
                        .param("password", "password123")
                        .with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/dashboard"));
    }

    @Test
    public void testLoginWithInvalidUser() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.post("/login")
                        .param("username", "baduser")
                        .param("password", "badpassword")
                        .with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/login?error=bad_credentials"));
    }
}
