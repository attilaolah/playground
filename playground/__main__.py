"""Main application entry point."""

import logging

from . import markov_unigram
from .config import Settings


def main() -> None:
    """Main module entry point."""
    logging.basicConfig(level=logging.DEBUG)
    settings = Settings()

    markov_unigram.print_stats(settings)


if __name__ == "__main__":
    main()
