// @vitest-environment jsdom
import * as React from "react";
import axios from "axios";
import { cleanup, fireEvent, render, screen } from "@testing-library/react";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import HomeScreen from "../app/index";

vi.mock("axios");

const people = [
  { firstname: "Max", lastname: "Muster", email: "max@test.at", age: 25 },
  { firstname: "Tom", lastname: "Maier", email: "tom@test.at", age: 17 },
  { firstname: "Anna", lastname: "Huber", email: "anna@test.at", age: 18 },
];

beforeEach(async () => {
  vi.mocked(axios.get).mockResolvedValue({ data: [...people] });
  render(<HomeScreen />);
  await screen.findByText("Max Muster (25)");
});

afterEach(() => {
  cleanup();
  vi.clearAllMocks();
});

describe("HomeScreen", () => {
  it("lädt und zeigt die Personen", () => {
    expect(axios.get).toHaveBeenCalledWith("http://localhost:8080/vk/api");
    expect(screen.getAllByText(/\(\d+\)$/).map((x) => x.textContent)).toEqual([
      "Max Muster (25)",
      "Tom Maier (17)",
      "Anna Huber (18)",
    ]);
  });

  it("sortiert nach Alter", () => {
    fireEvent.click(screen.getByRole("button", { name: "Sort People" }));

    expect(screen.getAllByText(/\(\d+\)$/).map((x) => x.textContent)).toEqual([
      "Tom Maier (17)",
      "Anna Huber (18)",
      "Max Muster (25)",
    ]);
  });

  it("filtert Personen unter 18 heraus", () => {
    fireEvent.click(screen.getByRole("button", { name: "Filter ü. 18" }));

    expect(screen.queryByText("Tom Maier (17)")).toBeNull();
    expect(screen.getAllByText(/\(\d+\)$/).map((x) => x.textContent)).toEqual([
      "Max Muster (25)",
      "Anna Huber (18)",
    ]);
  });
});
