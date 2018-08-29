functions {
  real[] sho(real t, real[] y, real[] theta, real[] x_r, int[] x_i) {
    real dy1_dt = y[2];
    real dy2_dt = -y[1] - theta[1] * y[2];
    return { dy1_dt, dy2_dt };
  }
}
data {
  int<lower = 0> T;
  int<lower = 0> N;
  real t0;
  real<lower = t0> ts[T];
  real y_hat[N, T, 2];
  real y0[N, 2];
}
transformed data {
  real x_r[0];
  int x_i[0];
}
parameters {
  real theta[N, 1];
  real<lower = 0> sigma;
}
transformed parameters {
  real y[N, T, 2];
  for (n in 1:N) {
    y[n, , ] = integrate_ode_bdf(sho, y0[n], 0.0, ts, theta[n], x_r, x_i);
  }
}
model {
  sigma ~ normal(0.1, 0.1);
  for (n in 1:N) {
    theta[n, 1] ~ normal(0.15, 0.1);
    y0[n] ~ normal({1.0, 0.0}, 0.1);
  }

  for (n in 1:N) {
    y_hat[n, , 1] ~ normal(y[n, , 1],  sigma);
    y_hat[n, , 2] ~ normal(y[n, , 2],  sigma);
  }
}
generated quantities {
}
