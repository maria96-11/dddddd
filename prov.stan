//
// This Stan program defines a simple model, with a

data {
  int n;
  matrix[1, n] y;
  
}
transformed data {
  matrix[1, 1] F;
  matrix[1, 1] G;
  F = rep_matrix(1, 1, 1);
  G = rep_matrix(1, 1, 1);

}
parameters {
  real<lower = 0> sigma_y;
  real<lower = 0> sigma_theta;
  vector[1] m0;
  real<lower = 0> sigmac;

  
}
transformed parameters{
  matrix[1, 1] V;
  matrix[1, 1] W;
  matrix[1, 1] C0;
  C0[1,1] = pow(sigmac,2);
  V[1, 1] =  pow(sigma_y, 2);
  W[1, 1] = pow(sigma_theta, 2);
}
model {
  m0[1] ~ normal(0,100);
  sigmac ~ cauchy(0,1); #deve per forn
  sigma_y ~ cauchy(0,1);
  sigma_theta ~ cauchy(0,1);
  

  y ~ gaussian_dlm_obs(F, G, V, W, m0, C0);
}

generated quantities {
  vector[n] theta;

  theta[1] = normal_rng(m0[1], sigmac);
    for(t in 2:n){
        theta[t] = G[1,1]*theta[t-1] + normal_rng(0, sigma_theta);
    }

}   
