import itertools

from base import (Operation, Metric, FAILED, FailedExperiment, MetricNotFound)


class Parser():
    @staticmethod
    def is_type(operation, metric):
        return lambda string: f"{operation}, {metric}" in string

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
