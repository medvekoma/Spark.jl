# test repartition and coalesce
print("\n\n\nStarting test: "*(@__FILE__)*"\n")

nums1 = parallelize(sc, 1:30)
# in local mode the number of partitions will be 1,but
# in YARN mode it can be different
#@test num_partitions(nums1) == 1


nums3 = repartition(nums1, 3)
@test num_partitions(nums3) == 3

nums2 = coalesce(nums3, 2)
@test num_partitions(nums2) == 2

nums2 = coalesce(nums3, 2; shuffle=true)
@test num_partitions(nums2) == 2


pnums1 = cartesian(nums1, nums1)
# in local mode the number of partitions will be 1,but
# in YARN mode it can be different
#@test num_partitions(pnums1) == 1

pnums3 = repartition(pnums1, 3)
@test num_partitions(pnums3) == 3


pnums2 = coalesce(pnums3, 2)
@test num_partitions(pnums2) == 2

pnums2 = coalesce(pnums3, 2; shuffle=true)
@test num_partitions(pnums2) == 2



print("Test passed: "*(@__FILE__)*"\n\n\n")