# test of basic functionality

txt = parallelize(sc, ["hello", "world"])
rdd = map_partitions(txt, it -> map(s -> length(s), it))

@test count(rdd) == 2
@test reduce(rdd, +) == 10



print("Test passed\n\n\n")