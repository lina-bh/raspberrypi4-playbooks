import collections
import itertools
import os
import subprocess
import sys
import typing
from collections.abc import Sequence, Iterable


def line_indent(s):
    return (s.count(" ")) // 3


def parse_object(lines: Iterable[str]):
    (it,) = itertools.tee(lines, 1)
    fields = {}
    for line in it:
        if line_indent(line) != 1:
            continue

        # try:
        field, typ = line[3:].split("\t")
        # except ValueError:
        # break

        fields[field] = typ

    return fields


def from_kubectl(lines: Iterable[str]):
    it = iter(lines)
    while not next(it).startswith("FIELDS:"):
        continue
    return parse_object(s[:-1] for s in it)


def kubectl_explain(typ):
    rd, wr = os.pipe()
    try:
        subprocess.run(
            [
                "kubectl",
                "explain",
                "--recursive=true",
                "--output=plaintext-openapiv2",
                typ,
            ],
            stdout=wr,
            stderr=subprocess.PIPE,
            check=True,
            text=True,
        )
    except subprocess.CalledProcessError as e:
        raise ValueError(f"kubectl {e.stderr}") from e
    finally:
        os.close(wr)
    return os.fdopen(rd, "r")


def main():
    pass


if __name__ == "__main__":
    main()
