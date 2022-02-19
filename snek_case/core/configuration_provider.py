from abc import ABC, abstractmethod
from typing import Any, Dict


class ConfigurationProvider(ABC):
    _config: Dict[str, Any]

    def __init__(self) -> None:
        self.get_config()

    @abstractmethod
    def get_config(self) -> None:
        raise NotImplementedError

    @abstractmethod
    def get(self, key: str) -> Any:
        raise NotImplementedError
