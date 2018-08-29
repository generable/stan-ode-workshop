# stan-ode-workshop
Stan ODE workshop for StanCon 2018 Helsinki


## Example

We are using the simple harmonic oscillator as our example. There are two states, y1 and y2.

The derivatives of the states with respect to time are:

- dy1/dt = y2
- dy2/dt = -y1 - theta * y2

where theta is some parameter. In the manual, the example is set up so at time 0, the initial condition is (1, 0) and the value of theta is 0.15.

## Contents

1.  `sho_sim.stan`
    - Simple program to simulate from a simple harmonic oscillator without noise.
    - exercise: adjust so it reads in data
    - exercise: simulate with noise
2. `sho.data.R`
    - Simulated data set for a single observation with noise.
3. `sho_fit.stan`
    - Fits a single observation.
    - Exercise: fit the initial conditions
4. `sho_multiple.data.R`
    - Simulated data set for multiple observations with noise.
5. `sho_fit_multiple.stan`
    - Fits multiple observations.
6. `sho_fit_multiple_parallel_start.stan`
    - Fits multiple observations, but set up to work with map_rect
7. `sho_fit_multiple_parallel.stan`
    - Fits multiple observations with map_rect
