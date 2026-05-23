package m2si.poo.TheRepairShop.controller;

import m2si.poo.TheRepairShop.model.Client;
import m2si.poo.TheRepairShop.repository.ClientRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

public class ClientControllerTest extends BaseControllerTest {

    @Autowired
    private ClientRepository clientRepository;

    @Test
    public void testListClientsRedirectsUnauthenticated() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/clients"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/login"));
    }

    @Test
    public void testListClientsAuthenticated() throws Exception {
        // Seed a client
        Client c = new Client();
        c.setFirstName("Karim");
        c.setLastName("Ouazzani");
        c.setEmail("karim@test.com");
        c.setPhone("0611223344");
        c.setShop(testShop);
        clientRepository.save(c);

        mockMvc.perform(MockMvcRequestBuilders.get("/clients")
                        .with(user("salma.owner").roles("OWNER")))
                .andExpect(status().isOk())
                .andExpect(view().name("clients/list"))
                .andExpect(model().attributeExists("clients"));
    }

    @Test
    public void testCreateClientForm() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/clients/new")
                        .with(user("salma.owner").roles("OWNER")))
                .andExpect(status().isOk())
                .andExpect(view().name("clients/form"))
                .andExpect(model().attributeExists("client"))
                .andExpect(model().attributeExists("shops"));
    }

    @Test
    public void testCreateClientSubmit() throws Exception {
        long initialCount = clientRepository.count();

        mockMvc.perform(MockMvcRequestBuilders.post("/clients/new")
                        .param("firstName", "John")
                        .param("lastName", "Doe")
                        .param("email", "john.doe@test.com")
                        .param("phone", "0699887766")
                        .param("address", "Rabat")
                        .param("shopId", testShop.getId().toString())
                        .with(user("salma.owner").roles("OWNER"))
                        .with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/clients"))
                .andExpect(flash().attributeExists("message"));

        assertThat(clientRepository.count()).isEqualTo(initialCount + 1);
    }
}
