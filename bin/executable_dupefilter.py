#!/usr/bin/env python3

import json
import os
import sys
from collections import defaultdict
from pathlib import Path
from typing import List, Iterable, Tuple, Dict, Set
from multiprocessing import Pool
import hashlib
import unicodedata


DIR_FILE = Path("dupes.json")


def with_stem(path, stem):
    return path.with_name(stem + path.suffix)


def filter_files_in_same_dir_parens(files: Set[Path]) -> Iterable[Path]:
    """
    Returns files to remove, if all the files are directly in the same
    directory, and have files names with numbers in parens:

    - dir/file.ext
    - dir/file (1).ext
    - dir/file (2).ext

    :param files: files with same hash
    :return: files to remove
    """
    dirnames = set(str(f.parent) for f in files)
    if not len(dirnames) == 1:
        return []

    orig = sorted(files, key=lambda x: len(str(x)))[0]
    others = set(with_stem(orig, f"{orig.stem} ({i})") for i in range(1, len(files)))
    others.add(orig)

    if others != files:
        return []

    others.remove(orig)
    return others


def filter_files_in_same_dir_unicode_normalized(files: Set[Path]) -> Iterable[Path]:
    dirnames = set(str(f.parent) for f in files)
    if not len(dirnames) == 1:
        return []

    normalized = set()
    for f in files:
        normalized.add(unicodedata.normalize('NFKD', str(f)))

    if len(files) == len(normalized):
        return []

    best = sorted(files, key=lambda x: len(str(x).encode('utf-8')))
    return best[1:]


def filter_files_in_same_dir(files: Set[Path]) -> Iterable[Path]:
    dirnames = set(str(f.parent) for f in files)
    if not len(dirnames) == 1:
        return []

    best = sorted(files, key=lambda x: len(str(x).encode('utf-8')))
    print('keeping: ', best[0])
    return best[1:]



def main():
    with open(DIR_FILE, "r") as f:
        files_by_hash = json.load(f)

    for _, files in files_by_hash.items():
        files_set: Set[Path] = set()
        for f in files:
            f = Path(f)
            if f.exists():
                files_set.add(f)

        to_delete = filter_files_in_same_dir(files_set)
        for f in to_delete:
            print("deleting:", f)
            # f.unlink(missing_ok=True)


if __name__ == "__main__":
    main()
