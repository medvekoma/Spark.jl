# test of group_by_key
print("\n\n\nStarting test: "*(@__FILE__)*"\n")

nums1 = parallelize(sc, 1:3)
nums2 = parallelize(sc, 1:2)
rdd = cartesian(nums1, nums2)
rdd2 = group_by_key(rdd)
rdd3 = map(rdd2, it -> it[1] + sum(it[2]))
@test reduce(rdd3, +) == 15



print("Test passed: "*(@__FILE__)*"\n\n\n")