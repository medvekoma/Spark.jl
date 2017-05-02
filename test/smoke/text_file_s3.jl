# test of text_file in AWS S3


lines = text_file(sc, "s3://fms.develop/BelaBoros/input/LoremIpsum.txt")
#lines = parallelize(sc, ["Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."])
println(collect(lines))


numberOfLines=count(lines)
println(numberOfLines)
@test numberOfLines == 1


lineLengths  = map(lines, it -> length(it))
println(collect(lineLengths))


#numberOfCharacters = reduce(lineLengths, +)
#@test numberOfCharacters == 446


print("Test passed\n\n\n")
