# tests the attach macro
print("\n\n\nStarting test: "*(@__FILE__)*"\n")

a = 2

# test of basic funtionality

@share(sc, a)

txt = parallelize(sc, ["hello", "world"])
rdd = map(txt, it -> length(it) + a)

@test reduce(rdd, +) == 14



print("Test passed: "*(@__FILE__)*"\n\n\n")