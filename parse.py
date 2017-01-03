#!/usr/bin/env python3.4
# -*- coding: utf-8 -*-

import sys
import enum
import glob
import json
import logging
import itertools


logger = logging.getLogger(__name__)


FAILED = "FAILED"


class FailedExperiment(Exception):
    pass


class MetricNotFound(Exception):
    pass


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
        return lambda string: "{operation}, {metric}".format(
                operation=operation,
                metric=metric,
            ) in string

    @classmethod
    def get_metric(cls, operation, metric):
        def process(data):
            if FAILED in data["stdout"]:
                raise FailedExperiment()

            line = next(filter(
                cls.is_type(operation, metric),
                (row for row in data["stdout_lines"])
            ), "")

            if not line:
                raise MetricNotFound()

            return float(line.split(",")[-1].strip())

        return process


for operation, metric in itertools.product(Operation, Metric):
    method = Parser.get_metric(operation.value, metric.value)
    method_name = "get_{}_{}".format(operation.name, metric.name)
    setattr(Parser, method_name.lower(), method)


def thread_info(threads, db, metric):
    def get_metric(data):
        try:
            return getattr(Parser, metric)(data)
        except FailedExperiment:
            logger.error(
                "Experiment for {} with {} threads is failed".format(
                db, threads))

            return 0

        except MetricNotFound:
            logger.error(
                "Experiment for {} with {} threads does not have metric {}".format(
                db, threads, metric))

            return 0


    data_files = glob.glob(PATH.format(threads, db))
    data_list = [
        json.loads(open(data_file).read())
        for data_file in data_files
    ]

    return [get_metric(data) for data in data_list]


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
