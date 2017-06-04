#! /usr/bin/python

import sys
import json
from itertools import takewhile, islice


def parse_sar_file(file_name, metric_type=None, single_column=False, all=False):
    with open(file_name) as sar_file:
        sar_data = sar_file.read().split("\n")
        data = islice(iter(sar_data), 4, None)
        block = True

        while block:
            block = list(takewhile(lambda v: v!= "", data))
            if not block:
                continue

            if metric_type is None:
                print(" ".join(block[0].split()[2:]))
                continue

            if all is True or (metric_type in block[0] and not single_column):
                print("\n".join(block))
                continue

            if metric_type in block[0] and single_column:
                column_index = block[0].split().index(metric_type)
                print("[{}]".format(", ".join(row.split()[column_index] for row in block[1:])))

            if metric_type not in block[0]:
                continue


if __name__ == "__main__":
    if sys.argv[2] == "filter" and sys.argv[3] == "column":
        parse_sar_file(sys.argv[1], metric_type=sys.argv[4], single_column=True)

    if sys.argv[2] == "filter":
        parse_sar_file(sys.argv[1], metric_type=sys.argv[3])

    if sys.argv[2] == "all":
        parse_sar_file(sys.argv[1], all=True)

    if sys.argv[2] == "list":
        parse_sar_file(sys.argv[1])
