package htl.kaindorf.backend.vk;

import lombok.Getter;
import org.springframework.stereotype.Component;
import tools.jackson.databind.json.JsonMapper;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

@Component
@Getter
public class PrototypeInit {
    private final List<PrototypePeopleEntity> people;

    public PrototypeInit(JsonMapper jsonMapper) throws IOException {
        try (InputStream jsonStream = PrototypeInit.class.getResourceAsStream("/people.json")) {
            if (jsonStream == null) {
                throw new IOException("people.json was not found");
            }
            people = jsonMapper.readerForListOf(PrototypePeopleEntity.class)
                    .readValue(jsonStream);
        }
    }
}
