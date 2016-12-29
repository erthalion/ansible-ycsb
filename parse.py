#!/usr/bin/env python3.4
# -*- coding: utf-8 -*-

import sys
import enum
import glob
import json


class Databases(enum.Enum):
    PG = "postgresql"
    MYSQL = "mysql"
    MONGO = "mongodb"


class Metric(enum.Enum):
    THROUGHPUT = "Throughput"
    LATENCY_99 = "99thPercentileLatency"
    AVG_LATENCY = "AverageLatency"
    MIN_LATENCY = "MinLatency"
    MAX_LATENCY = "MaxLatency"

class Operation(enum.Enum):
    ANY = ""
    OVERALL = "[OVERALL]"
    READ = "[READ]"
    UPDATE = "[UPDATE]"
    INSERT = "[INSERT]"


PATH = "workload?_threads_{}_*/*/run_{}"


class Parser():
    @staticmethod
    def is_type(operation, metric):
        return lambda string: string.startswith(
            "{operation}, {metric}".format(
                operation=operation,
                metric=metric,
            )
        )

    @classmethod
    def get_metric(cls, operation, metric):
        def process(data):
            line = next(filter(
                cls.is_type(operation, metric),
                (row for row in data["stdout_lines"])
            ), "")
            return float(line.split(",")[-1].strip())

        return process

    @classmethod
    def get_throughput(cls, data):
        return cls.get_metric(Operation.OVERALL.value,
                               Metric.THROUGHPUT.value)(data)

    @classmethod
    def get_latency_99(cls, data):
        return cls.get_metric(Operation.ANY.value,
                               Metric.LATENCY_99.value)(data)

    @classmethod
    def get_latency_avg(cls, data):
        return cls.get_metric(Operation.ANY.value,
                               Metric.AVG_LATENCY.value)(data)

    @classmethod
    def get_latency_min(cls, data):
        return cls.get_metric(Operation.ANY.value,
                               Metric.MIN_LATENCY.value)(data)

    @classmethod
    def get_latency_max(cls, data):
        return cls.get_metric(Operation.ANY.value,
                               Metric.MAX_LATENCY.value)(data)


def thread_info(thread, db, metric):
    data_files = glob.glob(PATH.format(thread, db))
    data_list = [
        json.loads(open(data_file).read())
        for data_file in data_files
    ]

    return [getattr(Parser, metric)(data) for data in data_list]


def main(db, metric):
    if db:
        metric_list = thread_info(70, db, metric)
        print("{} {}".format(metric, metric_list))
    else:
        pg_metric_list = thread_info(70, Databases.PG.value, metric)
        mysql_metric_list = thread_info(70, Databases.MYSQL.value, metric)
        mongodb_metric_list = thread_info(70, Databases.MONGO.value, metric)
        print("{} postgresql".format(metric, pg_metric_list))
        print("{} mysql".format(metric, mysql_metric_list))
        print("{} mongodb".format(metric, mongodb_metric_list))


if __name__ == "__main__":

    db = sys.argv[1]
    metric = sys.argv[2]

    main(db, metric)
