# test of text_file

#txt = text_file(sc, "file:///etc/passwd")
#txt = text_file(sc, @__FILE__)
txt = text_file(sc, "file:///"*@__FILE__)


nums  = map(txt, it -> length(it))

@test reduce(nums, +) == 111


print("Test passed\n\n\n")