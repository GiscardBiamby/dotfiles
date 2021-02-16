from datetime import datetime
from pathlib import Path
import shutil


def main():
    stow_dir = Path("../stow_packages").resolve().absolute()
    print("Path: ", stow_dir)
    assert stow_dir.exists(), str(stow_dir)
    assert stow_dir.is_dir(), str(stow_dir)
    backup_dir = Path(f"../../dotfiles_backups_{datetime.now().strftime('%Y-%m-%d--%H-%M-%S')}")
    backup_dir.mkdir(exist_ok=True, parents=True)
    home_dir = Path("../..").resolve().absolute()
    print("home_dir: ", home_dir)
    configs = sorted([c for c in stow_dir.glob("**/*") if c.is_file()])
    for c in configs:
        print(c)
        target_path = home_dir / c.name
        print(target_path, target_path.exists(), target_path.is_symlink())
        if target_path.exists() and not target_path.is_symlink():
            backup_path = backup_dir / c.name
            print("target_path: ", target_path)
            print("backup path: ", backup_path)
            # shutil.move(target_path, backup_path)


if __name__ == "__main__":
    main()
