import os

from functools import partial

import lazy_object_proxy


def start_spark(app_name="Jupyter"):

    def sc_lazy(spark):
        return spark.sparkContext

    def hc_lazy(spark):
        return HiveContext(spark.sparkContext)

    global sc
    global hc
    global sqlContext
    global spark

    import findspark
    findspark.init()

    from pyspark.sql import SparkSession
    from pyspark.sql import HiveContext

    spark = lazy_object_proxy.Proxy(SparkSession.builder
                                                .appName(app_name)
                                                .enableHiveSupport()
                                                .config("spark.dynamicAllocation.enabled", "true")
                                                .config("spark.dynamicAllocation.minExecutors", "0")
                                                .config("spark.dynamicAllocation.maxExecutors", "11")
                                                .config("spark.dynamicAllocation.cachedExecutorIdleTimeout", "90s")
                                                .config("spark.executor.cores", "1")
                                                .config("spark.executor.memory", "10512m")
                                                .config("spark.memory.storageFraction", "0.2")
                                                .config("spark.serializer",
                                                        "org.apache.spark.serializer.KryoSerializer")
                                                .config("spark.kryoserializer.buffer.max", "512m")
                                                .config("spark.driver.memory", "10g")
                                                .config("spark.executor.memoryOverhead", 1024)
                                                .config("spark.driver.memoryOverhead", 512)
                                                .config("spark.driver.maxResultSize", "10000m")
                                                .config("spark.port.maxRetries", 96)
                                                .getOrCreate)

    sc = lazy_object_proxy.Proxy(partial(sc_lazy, spark))
    sqlContext = lazy_object_proxy.Proxy(partial(hc_lazy, spark))
    hc = lazy_object_proxy.Proxy(partial(hc_lazy, spark))


start_spark()
