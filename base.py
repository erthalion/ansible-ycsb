import enum
import re
from collections import namedtuple


RESULT_PATTERN = re.compile("workload._threads_(\d+)_*")
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


PlotNames = dict([
    (Metric.THROUGHPUT.value, "Throughput (ops/sec)"),
    (Metric.LATENCY_99.value, "Latency 99%"),
])

MetricData = namedtuple("MetricData", ["name", "values", "db"])
