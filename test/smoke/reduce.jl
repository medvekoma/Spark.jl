# test of reduce with no map stage
print("\n\n\nStarting test: "*(@__FILE__)*"\n")

txt = parallelize(sc, ["hello", "world"])

@test reduce(txt, *) == "helloworld"


print("Test passed: "*(@__FILE__)*"\n\n\n")