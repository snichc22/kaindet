package htl.kaindorf.backend.vk;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PrototypePeopleEntity {
    private Long id;
    private String firstName;
    private String lastName;
    private String email;
    private Integer age;
}
