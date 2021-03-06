#!/usr/bin/env bash

JOB_NAME="word_count"
INPUT_DIR="${JOB_NAME}/input"
OUTPUT_DIR="${JOB_NAME}/output"

HADOOP_STREAMING_JAR=${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-streaming-2.8.4.jar

hdfs dfs -mkdir -p ${INPUT_DIR}
hdfs dfs -put -f ../data/98-0.txt ${INPUT_DIR}
hdfs dfs -rm -r -skipTrash ${OUTPUT_DIR}

yarn jar ${HADOOP_STREAMING_JAR} \
    -D mapred.job.name=${JOB_NAME} \
    -D mapreduce.job.reduces=1 \
    -files mapper.py,reducer.py \
    -mapper "python mapper.py" \
    -combiner "python reducer.py" \
    -reducer "python reducer.py" \
    -input ${INPUT_DIR} \
    -output ${OUTPUT_DIR}

hdfs dfs -cat ${OUTPUT_DIR}/part-00000 | head
