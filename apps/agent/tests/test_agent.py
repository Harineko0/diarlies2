from agents.hello.agent import root_agent


def test_root_agent_metadata():
    assert root_agent.name == "hello_agent"
    assert root_agent.model
