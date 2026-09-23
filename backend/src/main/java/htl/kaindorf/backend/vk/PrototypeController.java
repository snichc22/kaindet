package htl.kaindorf.backend.vk;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/vk/api")
@RequiredArgsConstructor
@CrossOrigin(origins = "http://localhost:8081")
public class PrototypeController {
    private final PrototypeService prototypeService;

    @GetMapping
    public List<PrototypePeopleEntity> getPeople(
            @RequestParam(defaultValue = "") String search) {
        return prototypeService.getPeople(search);
    }
}
