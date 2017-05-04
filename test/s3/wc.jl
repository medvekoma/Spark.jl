using Spark
using Base.Test

sc = SparkContext(master = "yarn")

lines = text_file(sc, "s3://fms.develop/data/wiki/englishText_10*")
words = flat_map(lines, l -> split(l, " "))
count(words)

close(sc)

