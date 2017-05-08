using Spark

@attach path = "s3://fms.develop/Otil/input/big_FakeNameGenerator.com_da80fd95.csv"
@attach agecolnum = 23

# TODO: It would be nice to replace it with regexp
@attach function cleaner(line)
    ret = ""
    dq = 0
    for i in line
        if i == '\"'
            dq = dq + 1
        end
        ret *= (i == ',' && dq % 2 > 0) ? " " : string(i)
    end
    ret
end

@attach function isheader(line)
    !ismatch(r"^Number", line)
end

@attach function extractage(line)
    parse(Int, split(cleaner(line), ",")[agecolnum])
end

sc = SparkContext(master="yarn", deploymode="client", appname="AvgExample")
txt = text_file(sc, path)
pureRDD = filter(txt, x -> isheader(x))
ageRDD = map(pureRDD, x -> extractage(x))
cnt = count(ageRDD)
println(cnt)
sum = reduce(ageRDD, +)
result = sum / cnt

println("\n Avarage of ages: $result \n")

close(sc)
