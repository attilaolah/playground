"""Main application entry point."""

import logging

from . import markov
from .config import Settings


def main() -> None:
    """Main module entry point."""
    logging.basicConfig(level=logging.DEBUG)
    settings = Settings()

    markov.print_stats(settings)


if __name__ == "__main__":
    main()
