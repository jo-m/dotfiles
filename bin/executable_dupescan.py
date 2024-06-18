#!/usr/bin/env python3

import json
import os
import sys
from collections import defaultdict
from pathlib import Path
from typing import List, Iterable, Tuple, Dict
from multiprocessing import Pool
import hashlib

NPROC = 4
DIR_FILE = Path("dupes.json")


def get_all_files(path: Path) -> Iterable[Path]:
    for root, dirs, files in os.walk(path):
        for f in files:
            yield Path(root) / Path(f)


def hash_file(file: Path) -> Tuple[Path, str]:
    with open(file, "rb") as f:
        return file, hashlib.md5(f.read()).hexdigest()


def walk_files(path: Path) -> Dict[str, List[str]]:
    ret: defaultdict[str, List[str]] = defaultdict(lambda: [])

    with Pool(NPROC) as p:
        for file, fhash in p.imap(hash_file, get_all_files(path), chunksize=100):
            ret[fhash].append(str(file))

    return {k: v for k, v in ret.items() if len(v) > 1}


def main():
    assert len(sys.argv) == 2
    target = Path(sys.argv[1]).resolve()
    assert target.is_dir()
    assert not DIR_FILE.exists()

    files_by_hash = walk_files(target)
    with open(DIR_FILE, "w") as f:
        json.dump(files_by_hash, f, indent="  ")


if __name__ == "__main__":
    main()
