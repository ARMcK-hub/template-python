from snek_case import __version__


def test_version() -> None:
    # Assemble / Act / Assert
    assert __version__ == "0.1.0"
