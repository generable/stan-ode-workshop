library(rstan)


## sim
## ./sho_sim sample
fit <- read_stan_csv("output.csv")
y <- extract(fit)$y

dim(y)

y[1, ,]
y[2, ,]

plot(y[1,, ], type = 'l')



## sim with noise
## ./sho_sim_with_noise sample random seed=8292018
fit <- read_stan_csv("output.csv")
y <- extract(fit)$y
y_hat <- extract(fit)$y_hat

dim(y)

y[1, ,]
y[2, ,]

plot(y[1,, ], type = 'l')

y_hat <- extract(fit)$y_hat
points(y_hat[1,,], type='l')


## create single data set
data <-list()
data$T <- 20
data$ts <- 1:20
data$t0 <- 0
data$y0 <- c(1, 0)
data$y_hat <- y_hat[1,,]
data$theta <- -0.15

stan_rdump(ls(data), "sho.data.R", envir = list2env(data))


## fit
## ./sho_fit sample data file=sho.data.R
fit <- read_stan_csv("output.csv")
y <- extract(fit)$y



## sim multiple dataset with noise
## ./sho_sim_with_noise_multiple sample random seed=8292018
set.seed(8292018)


fit <- read_stan_csv("output.csv")
y_hat <- extract(fit)$y_hat
theta <- extract(fit)$theta
N <- 10
idx <- sample(1:nrow(y_hat), N)

data <-list()
data$T <- 20
data$N <- N
data$ts <- 1:20
data$t0 <- 0
data$y0 <- t(array(c(1, 0), c(2, N)))
data$y_hat <- y_hat[idx,,]
data$theta <- theta[idx]

stan_rdump(ls(data), "sho_multiple.data.R", envir = list2env(data))



## multiple fit
## ./sho_fit_multiple sample data file=sho_multiple.data.R init=0

fit <- read_stan_csv("output.csv")
print(fit)


## multiple parallel fit
## echo CXXFLAGS += -DSTAN_THREADS
## export STAN_NUM_THREADS=-1
## ./sho_fit_multiple_parallel sample data file=sho_multiple.data.R init=0

fit <- read_stan_csv("output.csv")
print(fit)
