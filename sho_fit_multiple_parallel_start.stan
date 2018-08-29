functions {
  real[] sho(real t, real[] y, real[] theta, real[] x_r, int[] x_i) {
    real dy1_dt = y[2];
    real dy2_dt = -y[1] - theta[1] * y[2];
    return { dy1_dt, dy2_dt };
  }

  vector individual_ode(vector phi, vector theta,
                        real[] x_r, int[] x_i) {
    int T = x_i[1];
    real y[T, 2] = integrate_ode_bdf(sho, x_r[1:2], 0.0, x_r[3:(T+2)], to_array_1d(theta), x_r, x_i);
    return append_row(to_vector(y[, 1]), to_vector(y[, 2]));
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
  int x_i[N] = rep_array(T, N);
  real x_r[N, T + 2];
  vector[0] phi;

  for (n in 1:N) {
    x_r[n, 1:2] = y0[n];
    x_r[n, 3:(T + 2)] = ts;
  }
}
parameters {
  real theta[N, 1];
  real<lower = 0> sigma;
}
transformed parameters {
  real y[N, T, 2];

  for (n in 1:N) {
    vector[T * 2] result = individual_ode(phi, to_vector(theta[n]), x_r[n], x_i);
    y[n, , 1] = to_array_1d(result[1:T]);
    y[n, , 2] = to_array_1d(result[(T + 1) : (2 * T)]);
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
