using Spark
using Base.Test

sc = SparkContext(master = "yarn")

# include("basic.jl")
include("wordcount.jl")

close(sc)

