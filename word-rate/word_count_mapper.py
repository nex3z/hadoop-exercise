import sys

for line in sys.stdin:
    try:
        line = line.strip()
    except ValueError as e:
        continue
    words = line.split()
    for word in words:
        print("{}\t{}".format(word.lower(), 1))
