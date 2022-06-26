using Pkg
cd(@__DIR__)
pkgtest= "Pkgtest3"
moda = "ModuleA1"
modb = "ModuleB1"
Pkg.generate(pkgtest)
cd(pkgtest)
Pkg.generate(moda)
Pkg.generate(modb)
cd(joinpath(@__DIR__, pkgtest, modb, "src"))
open("$modb.jl", "w") do f
    write(f, "module $modb\n")
    write(f, "bvar = 55\n")
    write(f, "bprint(txt) = println(\"$modb: \$txt\")\n")
    write(f, "end\n")
end
cd(joinpath(@__DIR__, pkgtest, moda, "src"))
open("$moda.jl", "w") do f
    write(f, "module $moda\n")
    write(f, "using $modb\n")
    write(f, "v = $modb.bvar + 2\n")
    write(f, "aprint(txt) = $modb.bprint(\"$moda: \$txt + \$v\")\n")
    write(f, "end\n")
end
mkdir(joinpath(@__DIR__, pkgtest, moda, "test"))
cd(joinpath(@__DIR__, pkgtest, moda, "test"))
open("$(moda)_test.jl", "w") do f
    write(f, "using $moda, $modb\n")
    write(f, "$moda.aprint(\"hello\")\n")
    write(f, "$modb.bprint(\"bye\")\n")
end
# Pkg.develop(path=joinpath(@__DIR__, pkgtest, moda))
# push!(LOAD_PATH, joinpath(@__DIR__, pkgtest, moda))  # required, if $moda not the active environment
# push!(LOAD_PATH, joinpath(@__DIR__, pkgtest, modb))
# push!(DEPOT_PATH, joinpath(@__DIR__, pkgtest, moda))
# push!(DEPOT_PATH, joinpath(@__DIR__, pkgtest, modb))
# using Revise
Pkg.activate(joinpath(@__DIR__, pkgtest, moda))
Pkg.develop(path=joinpath(@__DIR__, pkgtest, modb))
# Pkg.develop(path=joinpath(@__DIR__, pkgtest, moda))  # ERROR: package `$moda [cf7b7116]` has the same name or UUID as the active project
# Pkg.resolve()

# the following 3 lines are to be inserted to run the test from the pkgtest project environemnt
Pkg.activate(joinpath(@__DIR__, pkgtest))
Pkg.develop(path=joinpath(@__DIR__, pkgtest, modb))
Pkg.develop(path=joinpath(@__DIR__, pkgtest, moda))  # develop sequence: $modb before $modb resolves ERROR: LoadError: importing $moda into Main conflicts with an existing identifier

# Pkg.precompile()  # resolves ERROR: LoadError: importing $moda into Main conflicts with an existing identifier
# cd("..")
println("pwd: $(pwd())")
println("load path: $LOAD_PATH")
println("depot path: $DEPOT_PATH")
juliapath = "/Applications/Julia-1.8.app/Contents/Resources/julia/bin/"
Pkg.activate(joinpath(@__DIR__, pkgtest, moda))
include(joinpath(@__DIR__, pkgtest, moda, "test", "$(moda)_test.jl"))
# jlpath = `$(juliapath)julia --project=$(@__DIR__)/$pkgtest $(@__DIR__)/$pkgtest/$moda/test/$(moda)_test.jl`
# run(jlpath)
