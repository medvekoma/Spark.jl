
function init()
    envcp = get(ENV, "CLASSPATH", "")
    sparkjlassembly = joinpath(dirname(@__FILE__), "..", "jvm", "sparkjl", "target", "sparkjl-0.1-assembly.jar")
    classpath = @static is_windows() ? "$envcp;$sparkjlassembly" : "$envcp:$sparkjlassembly"
    try
        print("JVM starting from init.jl")
        # prevent exceptions in REPL on code reloading
        JavaCall.init(["-ea", "-Xmx1024M", "-Djava.class.path=$classpath", "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=4000"])
    end
end

init()
