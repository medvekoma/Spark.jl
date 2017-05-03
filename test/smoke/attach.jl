# tests the attach macro
print("\n\n\nStarting test: "*(@__FILE__)*"\n")

@attach a = 2

# attach cannot be used with include on Spark.jl
#@attach include("attach_include.jl")


@attach function func(s)
    length(s) + a
end


# test of basic functionality
txt = parallelize(sc, ["hello", "world"])
rdd = map_partitions(txt, it -> map(func, it))

@test reduce(rdd, +) == 14


print("Test passed:"*(@__FILE__)*"\n\n\n")