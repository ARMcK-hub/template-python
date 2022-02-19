import json
from typing import Any

from .configuration_provider import ConfigurationProvider


class JsonConfigurationProvider(ConfigurationProvider):
    def __init__(self, config_file: str) -> None:
        self._config_file = config_file
        super().__init__()

    def get_config(self) -> None:
        with open(self._config_file, "r") as file:
            self._config = json.load(file)

    def get(self, key: str) -> Any:
        return self._config.get(key)
