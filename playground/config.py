"""Application settings."""

from pathlib import Path
from typing import final

from pydantic import BaseModel, DirectoryPath, FilePath
from pydantic_settings import BaseSettings, SettingsConfigDict

DATA_DIR: DirectoryPath = Path(__file__).parent.parent / "data"


@final
class _Data(BaseModel):
    cutoff: int | None = None

    enwik_8: FilePath = DATA_DIR / "enwik8"


@final
class Settings(BaseSettings):
    """Main application settings."""

    model_config = SettingsConfigDict(cli_parse_args=True)

    data: _Data = _Data()
