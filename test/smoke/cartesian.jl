# test of cartesian

nums1 = parallelize(sc, 1:3)
nums2 = parallelize(sc, 1:2)
nums3 = map(nums2, it -> it + 10)
rdd = cartesian(nums1, nums3)
rdd2 = map(rdd, it-> it[1] + it[2])
@test reduce(rdd2, +) == 81



print("Test passed\n\n\n")