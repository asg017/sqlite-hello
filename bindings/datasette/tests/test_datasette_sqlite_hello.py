from datasette.app import Datasette
import pytest


@pytest.mark.asyncio
async def test_plugin_is_installed():
    datasette = Datasette(memory=True)
    response = await datasette.client.get("/-/plugins.json")
    assert response.status_code == 200
    installed_plugins = {p["name"] for p in response.json()}
    assert "datasette-sqlite-hello" in installed_plugins

@pytest.mark.asyncio
async def test_sqlite_hello_functions():
    datasette = Datasette(memory=True)
    response = await datasette.client.get("/_memory.json?sql=select+hello_version(),hello('alex')")
    assert response.status_code == 200
    hello_version, hello = response.json()["rows"][0]
    assert hello_version[0] == "v"
    assert len(hello) == 26
