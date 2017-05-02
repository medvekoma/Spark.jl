# test of text_file

lines = text_file(sc, "s3://fms.develop/BelaBoros/input/LoremIpsum.txt")

nums  = map(txt, it -> length(it))
@test reduce(nums, +) == 111


print("Test passed\n\n\n")