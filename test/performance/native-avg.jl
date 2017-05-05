input_file = "big_FakeNameGenerator.com_da80fd95.csv"
agecolnum = 23

# TODO: It would be nice to replace it with regexp
function cleaner(line)
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

function extract_age(line)
    line[agecolnum]
end

sum = cnt = first = 0

f = open(input_file, "r")
lit = eachline(f)
for line in lit
    if first == 0
        first = 1
        continue
    end
    purified_line = cleaner(line)
    splitted_line = split(purified_line, ',')
    age = extract_age(splitted_line)
    sum += parse(Int, age)
    cnt += 1
end
close(f)

avg = sum / cnt
println("SUM: $sum CNT: $cnt AVG: $avg")
