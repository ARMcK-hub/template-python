import pytest
from snek_case.sneks import Snek


class TestSnek(Snek):
    snek_type = "test"
    snek = "---:>"


def test_cannot_create() -> None:
    # Assemble / Act / Assert
    with pytest.raises(TypeError):
        Snek()  # type: ignore


def test_can_subclass() -> None:
    # Assemble / Act / Assert
    TestSnek()


def test_object_is_snek() -> None:
    # Assemble / Act
    snek = TestSnek()

    # Assert
    assert str(snek) == TestSnek.snek
