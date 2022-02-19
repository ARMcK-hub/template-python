import os
import shutil
from pathlib import Path
from typing import Iterable

import pytest
from snek_case.core import JsonConfigurationProvider

# test configuration
TEST_CONFIG_FILE = os.path.join(os.path.dirname(__file__), "config/config.tests.json")
test_config = JsonConfigurationProvider(TEST_CONFIG_FILE)

test_data_path = os.path.join(
    Path(os.path.dirname(__file__)).parent, test_config.get("data_path")
)


@pytest.fixture(autouse=True, scope="function")
def prep_and_cleanup(output_path: str) -> Iterable[None]:
    # run before test

    if os.path.exists(output_path):
        shutil.rmtree(output_path)

    shutil.copytree(test_data_path, output_path)

    yield
    # run after the test
    if os.path.exists(output_path):
        shutil.rmtree(output_path)


# ----- data paths -----
@pytest.fixture(scope="session")
def data_path() -> str:
    return test_data_path


@pytest.fixture(scope="session")
def output_path() -> str:
    return os.path.join(test_data_path, "output")
