"""Explore the effectiveness of unigram Markov-chains at next-byte detection."""

import logging
from collections import Counter
from itertools import pairwise
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from pydantic import FilePath

    from .config import Settings

_log = logging.getLogger()
_log.setLevel(logging.DEBUG)


def print_stats(settings: Settings) -> None:
    """Print Markov unigram efficiency stats."""
    raw = _read_file(settings.data.enwik_8)  # [:100_000] # chop it off
    mv = memoryview(raw)
    total_count = len(raw)

    unigrams = Counter[int]()
    _log.debug("counting unigrams...")
    unigrams = Counter(raw)
    _log.debug("done")

    # The most common character is of course the whitespace.
    top_c, _ = unigrams.most_common(1)[0]
    _log.debug("most common char: %s", repr(chr(top_c)))

    # How often would we guess the next token from all possible tokens, based on only the token distribution?
    # For simple raw bytes as tokens, about 13.51% of the time, which constitutes a lift of ~27.72. Not bad at all.
    good = 0
    for c in mv:
        if c == top_c:
            good += 1
        # What if we adjust the counter based on the remaining characters?
    ratio = float(good) / total_count
    _log.debug("good: %d, bad: %d, ratio: %f, lift: %f", good, total_count - good, ratio, ratio * len(unigrams))

    # How often would we guess the next token, given the next two tokens as choices?
    # About 54.02% of the time, which gives a lift of ~1.08. That is pretty bad, but expected.
    # The last choice is always correct since we have only one option, so we start with good = 1.
    good = 1
    for first, second in pairwise(mv):
        first_f, second_f = unigrams[first], unigrams[second]
        choice = second if second_f > first_f else first
        if choice == first:
            good += 1
    ratio = float(good) / total_count
    _log.debug("good: %d, bad: %d, ratio: %f, lift: %f", good, total_count - good, ratio, ratio * 2)


def _read_file(file_path: FilePath) -> bytes:
    _log.debug("reading %s", file_path)
    with file_path.open("rb") as data_file:
        return data_file.read()
