package htl.kaindorf.backend.vk;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Locale;

@Service
@RequiredArgsConstructor
public class PrototypeService {
    private final PrototypeInit prototypeInit;

    public List<PrototypePeopleEntity> getPeople(String search) {
        if (search == null || search.isBlank()) {
            return prototypeInit.getPeople();
        }

        String query = search.trim().toLowerCase();

        return prototypeInit.getPeople().stream()
                .filter(person -> (
                        person.getFirstName() + " "
                                + person.getLastName() + " "
                                + person.getEmail())
                        .toLowerCase()
                        .contains(query))
                .toList();
    }
}
