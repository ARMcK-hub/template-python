from abc import ABC, abstractmethod


class Snek(ABC):
    """
    An abstract interface for Snek(s).
    """

    @property
    @abstractmethod
    def snek_type(self) -> str:
        raise NotImplementedError

    @property
    @abstractmethod
    def snek(self) -> str:
        raise NotImplementedError

    def show_snek(self) -> None:
        print(self.snek)

    def __repr__(self) -> str:
        return self.snek

    def __str__(self) -> str:
        return self.snek
