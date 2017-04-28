# test of reduce with no map stage

txt = parallelize(sc, ["hello", "world"])

@test reduce(txt, *) == "helloworld"


print("Test passed\n\n\n")