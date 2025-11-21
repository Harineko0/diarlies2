import { render, screen } from "@testing-library/react";
import Home from "./page";

describe("Home page", () => {
  it("renders headline and CTA", () => {
    render(<Home />);
    expect(screen.getByText(/AI that listens/i)).toBeInTheDocument();
    expect(screen.getByRole("button", { name: /start a diary/i })).toBeInTheDocument();
  });
});
