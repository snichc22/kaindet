package htl.kaindorf.backend.vk;

import htl.kaindorf.backend.SecurityConfiguration;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import tools.jackson.databind.json.JsonMapper;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;

@WebMvcTest(PrototypeController.class)
@Import({PrototypeService.class, PrototypeInit.class, SecurityConfiguration.class})
class PrototypeControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private JsonMapper jsonMapper;

    @BeforeAll
    static void endpointExists() {
        RequestMapping path = PrototypeController.class.getAnnotation(RequestMapping.class);

        assertNotNull(path, "PrototypeController has no path.");
        assertTrue(Arrays.asList(path.value()).contains("/vk/api"),
                "The path /vk/api does not exist.");

        boolean getFunctionExists = Arrays.stream(PrototypeController.class.getDeclaredMethods())
                .anyMatch(method -> method.isAnnotationPresent(GetMapping.class));

        assertTrue(getFunctionExists,
                "The GET function for /vk/api does not exist.");
    }

    @Test
    void returnsAllPeopleWithoutLogin() throws Exception {
        MvcResult result = mockMvc.perform(get("/vk/api")).andReturn();
        assertSuccessfulResponse(result);

        List<PrototypePeopleEntity> people = readPeople(result);
        assertEquals(8, people.size(),
                "GET /vk/api should return all 8 people.");
        assertEquals(Integer.valueOf(24), people.getFirst().getAge(),
                "The API returned a wrong or missing age for Anna.");
    }

    @Test
    void returnsMatchingPeople() throws Exception {
        MvcResult result = mockMvc.perform(get("/vk/api")
                .param("search", "miller")).andReturn();
        assertSuccessfulResponse(result);

        List<PrototypePeopleEntity> people = readPeople(result);
        assertEquals(1, people.size(),
                "The search function should return exactly one person for 'miller'.");
        assertEquals("Anna", people.getFirst().getFirstName(),
                "The search function returned the wrong person.");
        assertEquals("Miller", people.getFirst().getLastName(),
                "The search function returned the wrong person.");
    }

    private void assertSuccessfulResponse(MvcResult result) {
        int status = result.getResponse().getStatus();

        String errorMessage = switch (status) {
            case 404 -> "The path /vk/api does not exist.";
            case 405 -> "The path /vk/api exists, but the GET function does not exist.";
            case 401, 403 -> "Security is blocking GET /vk/api.";
            case 500 -> "GET /vk/api exists, but the backend function crashed.";
            default -> "GET /vk/api returned an unexpected HTTP status.";
        };

        assertEquals(200, status, errorMessage);
    }

    private List<PrototypePeopleEntity> readPeople(MvcResult result) {
        try {
            return jsonMapper.readerForListOf(PrototypePeopleEntity.class)
                    .readValue(result.getResponse().getContentAsString());
        } catch (Exception exception) {
            throw new AssertionError(
                    "GET /vk/api did not return a valid JSON list of people.", exception);
        }
    }
}
