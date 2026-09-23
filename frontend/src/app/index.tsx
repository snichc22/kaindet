import axios from "axios";
import { useEffect, useState } from "react";

type Person = {
  id: number;
  firstName: string;
  lastName: string;
  email: string;
  age: number;
};

export default function HomeScreen() {
  const [people, setPeople] = useState<Person[]>([]);

  async function getPeople() {
    const response = await axios.get("http://localhost:8080/vk/api");
    console.log(response.data);
    setPeople(response.data);
  }

  function sortPeople(list: Person[]): Person[] {
    return [...list].sort((a, b) => a.age - b.age);
  }

  function filterPeople(list: Person[]): Person[] {
    return list.filter((person) => person.age >= 18);
  }

  useEffect(() => {
    getPeople();
  }, []);

  return (
      <div>
        {people.map((x, i) => (
            <div key={x.id}>
              {x.firstName} {x.lastName} - Age {x.age}
            </div>
        ))}

        <button onClick={() => setPeople(sortPeople(people))}>
          Sort People
        </button>

        <button onClick={() => setPeople(filterPeople(people))}>
          Filter ü. 18
        </button>
      </div>
  );
}