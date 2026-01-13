"""Main application entry point."""

import logging

from . import markov
from .config import Settings


def main() -> None:
    """Run the module from the command line."""
    logging.basicConfig(level=logging.DEBUG)
    settings = Settings()

    markov.print_stats(settings)


if __name__ == "__main__":
    main()
