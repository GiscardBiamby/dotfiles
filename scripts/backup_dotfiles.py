import shutil
from datetime import datetime
from pathlib import Path
import pathlib as pl


def backup_file(target_path: Path, backup_dir: Path, path: Path) -> None:
    if target_path.exists() and not target_path.is_symlink():
        backup_dir.mkdir(exist_ok=True, parents=True)
        backup_path = backup_dir / path.name
        print(f"File not managed by stow. Backing up: {target_path} --> {backup_path}")
        # shutil.move(str(target_path), backup_path)
        # backup_path.write_bytes(target_path.read_bytes())
        target_path.rename(backup_path)


def main():
    stow_dir = Path("../stow_packages").resolve().absolute()
    print("Path: ", stow_dir)
    assert stow_dir.exists(), str(stow_dir)
    assert stow_dir.is_dir(), str(stow_dir)
    backup_dir = Path(
        f"../../dotfiles_backups/{datetime.now().strftime('%Y-%m-%d--%H-%M-%S')}"
    ).resolve()
    home_dir = Path("../..").resolve().absolute()
    print("home_dir: ", home_dir)

    # Backup files in stow_packages that get stowed:
    print("\nBackup files in stow_packages that get stowed...")
    configs = sorted([c for c in stow_dir.glob("**/*") if c.is_file()])
    for c in configs:
        # print(c)
        target_path = home_dir / c.name
        backup_file(target_path, backup_dir, c)

    # Backup files in .config that get stowed:
    print("\nBackup files in .config that get stowed...")
    dotfiles_dir = str((home_dir / "dotfiles").absolute()) + "/"
    for config_dir in ["Code"]:
        config_dir = (Path("../.config") / config_dir).resolve()
        configs = sorted([c for c in config_dir.glob("**/*") if c.is_file()])
        for c in configs:
            target_path = home_dir / str(c).replace(dotfiles_dir, "")
            backup_file(target_path, get_backup_dir(c, backup_dir), c)
            # print(target_path, target_path.exists(), target_path.is_symlink())


def get_backup_dir(path: Path, backup_dir: Path) -> Path:
    dotfiles_dir = Path().resolve().parent
    backup_dir_new = Path(str(path).replace(str(dotfiles_dir), ""))
    if str(backup_dir_new).startswith(pl.os.sep):
        backup_dir_new = Path(str(backup_dir_new)[1:])
    backup_dir_new = (backup_dir / backup_dir_new).resolve()
    return backup_dir_new


if __name__ == "__main__":
    main()
