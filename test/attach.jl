# tests the attach macro
@attach a = 2
@attach include("attach_include.jl")

# test of basic funtionality
txt = parallelize(sc, ["hello", "world"])
rdd = map_partitions(txt, it -> map(func, it))

@test reduce(rdd, +) == 14
