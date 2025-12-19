"""Main application entry point."""

from .config import Settings
from .errors import DataFileNotFoundError


def main() -> None:
    """Main module entry point.

    Raises:
        DataFileNotFoundError: If a data file was not found.
    """
    settings = Settings()

    if not settings.data.enwik_8.exists():
        raise DataFileNotFoundError(settings.data.enwik_8)


if __name__ == "__main__":
    main()
