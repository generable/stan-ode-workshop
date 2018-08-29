functions {
  real[] sho(real t, real[] y, real[] theta, real[] x_r, int[] x_i) {
    real dy1_dt = y[2];
    real dy2_dt = -y[1] - theta[1] * y[2];
    return { dy1_dt, dy2_dt };
  }
}
transformed data {
  real ts[20] = { 1.0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 };
  real y0[2] = { 1.0, 0.0 };
  real theta[1] = { 0.15 };
  real x_r[0];
  int x_i[0];
}
parameters {
  real<lower = 0, upper = 1> p;
}
model {
}
generated quantities {
  real y[20, 2] = integrate_ode_bdf(sho, y0, 0.0, ts, theta, x_r, x_i);
  real y_hat[20, 2];

  for (t in 1:20) {
    y_hat[t, 1] = y[t, 1] + normal_rng(0, 0.1);
    y_hat[t, 2] = y[t, 2] + normal_rng(0, 0.1);
  }
}
