import sys
import operator


word_dict = {}

for line in sys.stdin:
    try:
        key, count = line.strip().split('\t', 1)
        count = int(count)
    except ValueError as e:
        continue
    if key in word_dict:
        word_dict[key] += count
    else:
        word_dict[key] = count

sorted_dict = sorted(word_dict.items(), key=operator.itemgetter(1), reverse=True)
for (key, value) in sorted_dict:
    print("{}\t{}".format(key, value))
