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
    raw_data = _read_file(settings.data.enwik_8)
    if cutoff := settings.data.cutoff:
        raw_data = raw_data[:cutoff]
    mv = memoryview(raw_data)

    _ngram_1_stats(mv)
    _ngram_2_stats(mv)


def _ngram_1_stats(mv: memoryview) -> None:
    total_count = len(mv)

    _log.debug("counting unigrams...")
    ngrams_1 = Counter(mv)
    _log.debug("done")

    # The most common character is of course the whitespace.
    top_c, _ = ngrams_1.most_common(1)[0]
    _log.debug("most common char: %r", chr(top_c))

    # How often would we guess the next token from all possible tokens, based on only the token distribution?
    # For simple raw bytes as tokens, about 13.51% of the time, which constitutes a lift of ~27.72. Not bad at all.
    good = 0
    for c in mv:
        if c == top_c:
            good += 1
        # What if we adjust the counter based on the remaining characters?
    ratio = float(good) / total_count
    _log.debug("good: %d, bad: %d, ratio: %f, lift: %f", good, total_count - good, ratio, ratio * len(ngrams_1))

    # How often would we guess the next token, given the next two tokens as choices?
    # About 54.02% of the time, which gives a lift of ~1.08. That is pretty bad, but expected.
    # The last choice is always correct since we have only one option, so we start with good = 1.
    good = 1
    for first, second in pairwise(mv):
        first_f, second_f = ngrams_1[first], ngrams_1[second]
        choice = second if second_f > first_f else first
        if choice == first:
            good += 1
    ratio = float(good) / total_count
    _log.debug("good: %d, bad: %d, ratio: %f, lift: %f", good, total_count - good, ratio, ratio * 2)


def _ngram_2_stats(mv: memoryview) -> None:
    total_count = len(mv)

    _log.debug("counting unigrams...")
    ngrams_1 = Counter(mv)
    _log.debug("counting n-grams (2)...")
    ngrams_2 = Counter(pairwise(mv))
    _log.debug("counting n-grams (2) matrix...")
    ngrams_2_map = [Counter[int]() for _ in range(256)]
    for a, b in pairwise(mv):
        ngrams_2_map[a][b] += 1
    _log.debug("done")

    # Tho most common 2-gram seems to be 'e '.
    top_2, n = ngrams_2.most_common(1)[0]
    _log.debug("most common n-gram (2): %r (%d)", "".join(tuple(map(chr, top_2))), n)

    # How often would we guess the next token from all possible tokens, based on the digram, falling back to unigrams?
    good = 0
    for a, b in pairwise(mv):
        top = ngrams_2_map[a].most_common(1)
        choice = top[0][0] if top else ngrams_1.most_common(1)[0]
        if choice == b:
            good += 1
    ratio = float(good) / total_count
    _log.debug("good: %d, bad: %d, ratio: %f, lift: %f", good, total_count - good, ratio, ratio * 256)


def _read_file(file_path: FilePath) -> bytes:
    _log.debug("reading %s", file_path)
    with file_path.open("rb") as data_file:
        return data_file.read()
