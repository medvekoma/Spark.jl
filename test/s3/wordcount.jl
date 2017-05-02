# lines = text_file(sc, "s3://fms.develop/aszu/wiki.html")
lines = text_file(sc, "s3://fms.develop/data/wiki/")

words = flat_map(lines, x -> split(x, r"[\s/\.\\,<>\"{}\(\)=:!\[\]\|;]"))
words2 = filter(words, w -> !isempty(w))

pairs = map_pair(words2, w -> (w,1))
counts = reduce_by_key(pairs, +)

collect(counts)
