using Logging

"""
abc:
- this
- is
- the
- docstring
of mytest

"""
mytest(x) = println("test: $x @mydoc: $(@doc mytest)")

println("stand alone:")
println(@doc mytest)
mytest("hugo")
for i in 1:10
@info "$(@doc mytest)"  maxlog=1
end


