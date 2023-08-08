using SimpleChains, BenchmarkTools, Static

# 24 covariates each per 200 observations
x = rand(24, 200); # 24 inputs per 200 observations

# 2 responses each per 200 observations
y = Matrix{Float64}(undef, 2, 200) .= randn.() .* 10;

schain = SimpleChain(
  static(24), # input dimension (optional)
  TurboDense{true}(tanh, 8), # dense layer with bias that maps to 8 outputs and applies `tanh` activation
  SimpleChains.Dropout(0.2), # dropout layer
  TurboDense{false}(identity, 2), # dense layer without bias that maps to 2 outputs and `identity` activation
  SquaredLoss(y)
);

p = randn(Static.known(SimpleChains.numparam(schain)));
g = similar(p);

# Entirely in place evaluation
@benchmark valgrad!($g, $schain, $x, $p) # dropout active