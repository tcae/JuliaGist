using Flux, BenchmarkTools

# 24 covariates each per 200 observations
x = rand(24, 200); # 24 inputs per 200 observations
# println("x=$(typeof(x)) $(size(x)) $(x[:,1:2])")
# 2 responses each per 200 observations
y = Matrix{Float64}(undef, 2, 200) .= randn.() .* 10;
# println("y=$(typeof(y)) $(size(y)) $(y[:,1:3])")


chain = Chain(
  Dense(24, 8, tanh; bias = true),
  Flux.Dropout(0.2),
  Dense(8, 2, identity; bias = false)
);
chain.layers[2].active = true # activate dropout

ya = Array(y);

@benchmark gradient(Flux.params($chain)) do
  Flux.mse($chain($x), $ya)
end