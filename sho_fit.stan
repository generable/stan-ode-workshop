functions {
  real[] sho(real t, real[] y, real[] theta, real[] x_r, int[] x_i) {
    real dy1_dt = y[2];
    real dy2_dt = -y[1] - theta[1] * y[2];
    return { dy1_dt, dy2_dt };
  }
}
data {
  int<lower = 0> T;
  real t0;
  real<lower = t0> ts[T];
  real y_hat[T, 2];
  real y0[2];
}
transformed data {
  real x_r[0];
  int x_i[0];
}
parameters {
  real theta[1];
  real<lower = 0> sigma;
}
transformed parameters {
  real y[T, 2] = integrate_ode_bdf(sho, y0, 0.0, ts, theta, x_r, x_i);
}
model {
  sigma ~ normal(0.1, 0.1);
  theta ~ normal(0.15, 0.1);
  y0 ~ normal({1.0, 0.0}, 0.1);

  y_hat[, 1] ~ normal(y[, 1],  sigma);
  y_hat[, 2] ~ normal(y[, 2],  sigma);
}
generated quantities {
}
