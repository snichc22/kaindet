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
    const response = await axios.get("http://localhost:3000/vk/api");
    setPeople(response.data);
  }

  function sortPeople(){

  }

  function filterPeople(){

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
      </div>
  );
}