"""Application settings."""

from pathlib import Path
from typing import final

from pydantic import BaseModel, DirectoryPath, FilePath
from pydantic_settings import BaseSettings

DATA_DIR: DirectoryPath = Path(__file__).parent.parent / "data"


@final
class DataSettings(BaseModel):
    """Data file settings."""

    enwik_8: FilePath = DATA_DIR / "enwik8"


@final
class Settings(BaseSettings):
    """Main application settings."""

    data: DataSettings = DataSettings()
