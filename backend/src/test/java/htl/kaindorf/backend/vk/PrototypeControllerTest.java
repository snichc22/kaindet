package htl.kaindorf.backend.vk;

import htl.kaindorf.backend.SecurityConfiguration;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(PrototypeController.class)
@Import({PrototypeService.class, PrototypeInit.class, SecurityConfiguration.class})
class PrototypeControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void returnsAllPeopleWithoutLogin() throws Exception {
        mockMvc.perform(get("/vk/api"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(8))
                .andExpect(jsonPath("$[0].age").value(24));
    }

    @Test
    void returnsMatchingPeople() throws Exception {
        mockMvc.perform(get("/vk/api")
                        .param("search", "miller"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(1))
                .andExpect(jsonPath("$[0].firstName").value("Anna"))
                .andExpect(jsonPath("$[0].lastName").value("Miller"));
    }
}
