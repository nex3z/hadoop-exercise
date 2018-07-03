#!/usr/bin/env bash

JOB_NAME_WORD_COUNT="word_count"
INPUT_DIR="${JOB_NAME_WORD_COUNT}/input"
OUTPUT_DIR_WORD_COUNT="${JOB_NAME_WORD_COUNT}/output"

HADOOP_STREAMING_JAR=${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-streaming-2.8.4.jar

hdfs dfs -mkdir -p ${INPUT_DIR}
hdfs dfs -put -f ../data/98-0.txt ${INPUT_DIR}
hdfs dfs -rm -r -skipTrash ${OUTPUT_DIR_WORD_COUNT}

yarn jar ${HADOOP_STREAMING_JAR} \
    -D mapred.jab.name=${JOB_NAME_WORD_COUNT} \
    -D mapreduce.job.reduces=2 \
    -files word_count_mapper.py,word_count_reducer.py \
    -mapper "python word_count_mapper.py" \
    -reducer "python word_count_reducer.py" \
    -input ${INPUT_DIR} \
    -output ${OUTPUT_DIR_WORD_COUNT}

hdfs dfs -cat ${OUTPUT_DIR_WORD_COUNT}/part-00000 | head


JOB_NAME_WORD_RATE="word_rate"
OUTPUT_DIR_WORD_RATE="${JOB_NAME_WORD_RATE}/output"

hdfs dfs -rm -r -skipTrash ${OUTPUT_DIR_WORD_RATE}

yarn jar ${HADOOP_STREAMING_JAR} \
    -D mapred.jab.name=${JOB_NAME_WORD_RATE} \
    -D mapreduce.job.reduces=1 \
    -files word_rate_reducer.py \
    -mapper "cat" \
    -reducer "python word_rate_reducer.py" \
    -input ${OUTPUT_DIR_WORD_COUNT} \
    -output ${OUTPUT_DIR_WORD_RATE}

hdfs dfs -cat ${OUTPUT_DIR_WORD_RATE}/part-00000 | head
