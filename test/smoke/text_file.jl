# test of text_file
print("\n\n\nStarting test: "*(@__FILE__)*"\n")


#txt = text_file(sc, "file:///etc/passwd")
#txt = text_file(sc, @__FILE__)
txt = text_file(sc, "file:///"*@__FILE__)


nums  = map(txt, it -> length(it))

@test reduce(nums, +) == 285



print("Test passed: "*(@__FILE__)*"\n\n\n")