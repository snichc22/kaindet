package htl.kaindorf.backend.vk;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.test.web.servlet.MockMvc;
import tools.jackson.databind.json.JsonMapper;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

class PrototypeControllerTest {
    private MockMvc mockMvc;

    @BeforeEach
    void setUp() throws Exception {
        JsonMapper jsonMapper = JsonMapper.builder().build();
        PrototypeInit prototypeInit = new PrototypeInit(jsonMapper);
        PrototypeService prototypeService = new PrototypeService(prototypeInit);
        PrototypeController prototypeController = new PrototypeController(prototypeService);

        mockMvc = standaloneSetup(prototypeController).build();
    }

    @Test
    void returnsAllPeople() throws Exception {
        mockMvc.perform(get("/vk/api"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(8));
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
