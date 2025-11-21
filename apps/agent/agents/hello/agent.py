from google.adk import Agent
from google.adk.tools import google_search

# Minimal starter agent that stays terse and can call Google Search when helpful.
root_agent = Agent(
    name="hello_agent",
    model="gemini-2.0-flash",
    instruction="You are a concise assistant for Diarlies. Prefer short answers.",
    description="Starter Google ADK agent with Google Search available.",
    tools=[google_search],
)
