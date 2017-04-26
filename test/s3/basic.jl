using Spark

sc = SparkContext(master = "local")

lines = text_file(sc, "s3://fms.download/app/scripts/bootstrap.sh")

# the following line fails with the following exception: 
# java.io.IOException: No FileSystem for scheme: s3
#   at org.apache.hadoop.fs.FileSystem.getFileSystemClass(FileSystem.java:2584)

collect(lines)

# Adding /usr/lib/hadoop/* to the classpath did not help

close(sc)

