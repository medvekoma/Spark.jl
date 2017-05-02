# test of map function
print("\n\n\nStarting test: "*(@__FILE__)*"\n")

rdd = parallelize(sc, 1:5)
mappedRdd = map(rdd, nr -> nr * 10)
values = collect(mappedRdd)

@test values == [10, 20, 30, 40, 50]




print("Test passed: "*(@__FILE__)*"\n\n\n")