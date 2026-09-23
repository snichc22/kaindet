package htl.kaindorf.backend.vk;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/vk/api")
@RequiredArgsConstructor
public class PrototypeController {
    private final PrototypeService prototypeService;

    @GetMapping
    public List<PrototypePeopleEntity> getPeople(
            @RequestParam(defaultValue = "") String search) {
        return prototypeService.getPeople(search);
    }
}
