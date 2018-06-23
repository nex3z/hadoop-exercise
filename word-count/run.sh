#!/usr/bin/env bash

OUTPUT_DIR="word_count_result"

hdfs dfs -rm -r -skipTrash ${OUTPUT_DIR}

yarn jar ${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-streaming-2.8.4.jar \
    -D mapred.jab.name="word-count" \
    -D mapreduce.job.reduces=1 \
    -files mapper.py,reducer.py \
    -mapper "python mapper.py" \
    -combiner "python reducer.py" \
    -reducer "python reducer.py" \
    -input /data/word_count \
    -output ${OUTPUT_DIR}

hdfs dfs -cat ${OUTPUT_DIR}/part-00000 | head
