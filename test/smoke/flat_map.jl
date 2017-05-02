# test of basic funtionality
print("\n\n\nStarting test: "*(@__FILE__)*"\n")

nums = parallelize(sc, [1, 2, 3, 0, 4, 0])
rdd = flat_map(nums, it -> fill(it, it))

@test reduce(rdd, +) == 30



print("Test passed: "*(@__FILE__)*"\n\n\n")