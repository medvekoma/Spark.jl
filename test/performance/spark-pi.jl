using Spark

sc = SparkContext(master="yarn", appname="JULIA - PI")

slices = if size(ARGS,1) > 0 parse(Int64, ARGS[1]) else 4 end
n = min(100000 * slices, typemax(Int64))
rdd = parallelize(sc, 1:n, n_split = slices)

count = map(rdd, item -> (
                      x = rand() * 2 - 1;
                      y = rand();
                      if x*x + y*y < 1
                        return 1;
                      else
                        return 0;
                      end
                        )
            )

result = reduce(count, +)

valuOfPi = 4 * result / (n-1)

println("\n Pi is roughly  : $valuOfPi \n")
close(sc)
