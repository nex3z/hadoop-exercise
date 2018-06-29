#!/usr/bin/env bash

WORD_COUNT_OUTPUT_DIR="word_count_result"
WORD_RATE_OUTPUT_DIR="word_rate_result"

hdfs dfs -rm -r -skipTrash ${WORD_COUNT_OUTPUT_DIR}
hdfs dfs -rm -r -skipTrash ${WORD_RATE_OUTPUT_DIR}

yarn jar ${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-streaming-2.8.4.jar \
    -D mapred.jab.name="word-count" \
    -D mapreduce.job.reduces=2 \
    -files word_count_mapper.py,word_count_reducer.py \
    -mapper "python word_count_mapper.py" \
    -reducer "python word_count_reducer.py" \
    -input /data/word_count \
    -output ${WORD_COUNT_OUTPUT_DIR}

hdfs dfs -cat ${WORD_COUNT_OUTPUT_DIR}/part-00000 | head

yarn jar ${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-streaming-2.8.4.jar \
    -D mapred.jab.name="word-rate" \
    -D mapreduce.job.reduces=1 \
    -files word_rate_reducer.py \
    -mapper "cat" \
    -reducer "python word_rate_reducer.py" \
    -input ${WORD_COUNT_OUTPUT_DIR} \
    -output ${WORD_RATE_OUTPUT_DIR}

hdfs dfs -cat ${WORD_RATE_OUTPUT_DIR}/part-00000 | head
