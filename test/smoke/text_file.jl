# test of text_file

txt = text_file(sc, @__FILE__)
nums  = map(txt, it -> length(it))

@test reduce(nums, +) == 111
