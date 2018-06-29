import sys

last_key = None
word_count = 0

for line in sys.stdin:
    try:
        key, count = line.strip().split('\t', 1)
        count = int(count)
    except ValueError as e:
        continue
    if last_key != key:
        if last_key:
            print("{}\t{}".format(last_key, word_count))
        word_count = 0
        last_key = key
    word_count += count

if last_key:
    print("{}\t{}".format(last_key, word_count))
