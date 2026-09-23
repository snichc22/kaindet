import axios from "axios";
import { useEffect, useState } from "react";

type Person = {
  firstname: string;
  lastname: string;
  age: number;
};

export default function HomeScreen() {
  const [people, setPeople] = useState<Person[]>([]);

  async function getPeople() {
    const response = await axios.get("http://localhost:8080/vk/api");
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
            <div key={i}>
              {x.firstname} {x.lastname} ({x.age})
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