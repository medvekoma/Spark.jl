# test of map function
print("\n\n\nStarting test: "*(@__FILE__)*"\n")

rdd = parallelize(sc, 1:10, n_split=2)
partitions = map_partitions(rdd, partition -> mean(partition))
values = collect(partitions)

@test values == [3, 8]


print("Test passed: "*(@__FILE__)*"\n\n\n")