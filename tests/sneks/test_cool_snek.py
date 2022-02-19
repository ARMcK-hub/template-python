from snek_case.sneks import CoolSnek


def test_can_create() -> None:
    # Assemble / Act / Assert
    CoolSnek()


def test_type_is_cool() -> None:
    # Assemble / Act / Assert
    assert CoolSnek.snek_type == "cool"
