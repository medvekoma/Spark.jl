# test of basic functionality

print("\n\n\nStarting test: "*(@__FILE__)*"\n")


txt = parallelize(sc, ["hello", "world"])
rdd = map_partitions(txt, it -> map(s -> length(s), it))

@test count(rdd) == 2
@test reduce(rdd, +) == 10



print("Test passed: "*(@__FILE__)*"\n\n\n")