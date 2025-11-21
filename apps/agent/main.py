from agents.hello.agent import root_agent


def main() -> None:
    """Simple entrypoint that points to the ADK agent."""
    print(
        "Starter agent is defined in agents/hello/agent.py as `root_agent`.\n"
        "Run it with: uv run adk run agents/hello\n"
        "To experiment with a web UI: uv run adk web agents/hello --port 8080"
    )
    print(f"Agent name: {root_agent.name}")


if __name__ == "__main__":
    main()
