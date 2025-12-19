"""Common exceptions."""

from typing import TYPE_CHECKING, final, override

if TYPE_CHECKING:
    from pathlib import PurePath


@final
class DataFileNotFoundError(FileNotFoundError):
    """A file from the data directory is missing."""

    @override
    def __init__(self, file_path: PurePath) -> None:
        super().__init__(f"data file {file_path} is missing")
