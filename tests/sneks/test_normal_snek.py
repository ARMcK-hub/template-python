from snek_case.sneks import NormalSnek


def test_can_create() -> None:
    # Assemble / Act / Assert
    NormalSnek()


def test_type_is_normal() -> None:
    # Assemble / Act / Assert
    assert NormalSnek.snek_type == "normal"
