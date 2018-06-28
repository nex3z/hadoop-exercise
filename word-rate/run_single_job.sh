#!/usr/bin/env bash

OUTPUT_DIR="word_rate_result"

hdfs dfs -rm -r -skipTrash ${OUTPUT_DIR}

yarn jar ${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-streaming-2.8.4.jar \
    -D mapred.jab.name="word-rate" \
    -D mapreduce.job.reduces=1 \
    -files word_count_mapper.py,word_rate_reducer.py \
    -mapper "python word_count_mapper.py" \
    -reducer "python word_rate_reducer.py" \
    -input /data/word_count \
    -output ${OUTPUT_DIR}

hdfs dfs -cat ${OUTPUT_DIR}/part-00000 | head
