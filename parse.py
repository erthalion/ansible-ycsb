#!/usr/bin/env python3.6
# -*- coding: utf-8 -*-

import os
import sys
import glob
import json
import logging
import itertools
import toolz
import statistics

from matplotlib import rc
rc('font',**{'family':'sans-serif','sans-serif':['Helvetica']})
rc('text', usetex=True)

import matplotlib.pyplot as plt
import numpy as np
from scipy.interpolate import spline

from parser import Parser
from base import (FailedExperiment, MetricNotFound, RESULT_PATTERN,
                  MetricData, PlotNames)


logger = logging.getLogger(__name__)


def compare_result_file(file_name):
    match = RESULT_PATTERN.search(file_name)
    if match:
        return int(match.group(1))
    else:
        logger.error(f"Cannot find threads in file {file_name}")


def thread_info(threads, db, stage, metric):
    PATH = "workload?_threads_{}_*/*/{}_{}"

    def _get_metric(data):
        return getattr(Parser, metric)(data)

    def get_metric(file_name, data):
        try:
            return _get_metric(data)
        except FailedExperiment:
            logger.error(f"Experiment for {db} with {threads} threads " +
                         f"from {file_name} is failed")

            return 0

        except MetricNotFound:
            logger.error(
                f"Experiment for {db} with {threads} " +
                f"threads from {file_name} does not have metric {metric}"
            )

            return 0
        except Exception as ex:
            print(f"Got an Exception {ex} parsing {file_name}")

    def get_median_metric(thread, file_names):
        data_list = [
            (file_name, json.loads(open(file_name).read()))
            for file_name in file_names
        ]

        metrics = [get_metric(*row) for row in data_list]
        metrics = list(filter(toolz.identity, metrics))
        val = statistics.mean(metrics)
        logger.debug("Metrics for thread {thread} : {metrics}")
        logger.debug("Median for thread {thread} : {val}")
        return val

    data_files = sorted(glob.glob(PATH.format(threads, stage, db)), key=compare_result_file)
    data_files_by_threads = toolz.groupby(compare_result_file, data_files)
    return [
        get_median_metric(thread, file_names)
        for thread, file_names in data_files_by_threads.items()
    ]


def main(db, stage, metric, threads=None):
    if threads is None:
        threads = "*"

    if db:
        metric_values = thread_info(threads, db, stage, metric)
        return [MetricData(metric, metric_values, db)]
    else:
        pg_metric_values = thread_info(threads, Databases.PG.value, stage, metric)
        mysql_metric_values = thread_info(threads, Databases.MYSQL.value, stage, metric)
        mongodb_metric_values = thread_info(threads, Databases.MONGO.value, stage, metric)
        return [
            MetricData(metric, pg_metric_values, Databases.PG.value),
            MetricData(metric, mysql_metric_values, Databases.MYSQL.value),
            MetricData(metric, mongodb_metric_values, Databases.MONGODB.value),
        ]


def print_metrics(metrics):
    for metric in metrics:
        print(f"{metric.name} {metric.db} {metric.values}")


def get_metric_option(metric):
    return "_".join(metric.name.split("_")[2:])


def plot_metrics(metrics):
    plt, ax = prepare_plot(PlotNames.get(get_metric_option(metrics[0]), ""))

    for metric in metrics:
        ox, values = interpolate_metric(metric)
        plot_values(ax, ox, values, metric.db)

    ax.legend(shadow=True)
    plt.savefig(f"{metric.db}_{metric.name}.png")


def interpolate_metric(metric):
    interpolated_x = np.linspace(1, 100, 100)
    original_x = [1] + list(range(10, 110, 10))
    return (interpolated_x, spline(original_x, metric.values, interpolated_x))


def prepare_plot(plot_name):
    ax = plt.subplot()
    ax.set_facecolor("#eaeaf2")
    ax.grid(color='#ffffff', linestyle='-')
    plt.title(plot_name)
    return plt, ax


def plot_values(ax, ox, oy, db):
    ax.plot(ox, oy, '#8172b2', label=db, linewidth=2)


if __name__ == "__main__":

    args = iter(sys.argv[1:])
    db = next(args, None)
    stage = next(args, None)
    metric = next(args, None)
    threads = next(args, None)
    plot = bool(os.environ.get("PLOT", 0))

    if os.environ.get("DEBUG"):
        logger.setLevel(os.environ.get("LOG_LEVEL", logging.INFO))

    if plot:
        plot_metrics(main(db, stage, metric, threads))
    else:
        print_metrics(main(db, stage, metric, threads))
