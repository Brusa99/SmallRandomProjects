# Lotka Volterra with 3 Species

This is the final project for the _Modelli Matematici_ course held for the Bachelor Degree in Mathematics at the University of Trieste.  
It was made in September 2022. The code is in `matlab` language as required by the professors.  

The model describes how three different species (prey, predator, super predator) interact.

### Contents

- `Modello_Simone_Brusatin.pdf` is the final report.  
- `RK4.m` implements the Runge-Kutta method with 4 levels for ODEs.  
- `LV3.m` implements the ODE.  
- `geq.m` returns the non-trivial equilibrium point of the model.  
- `auteq.m` returns the eigenvalues of the jacobian of the system.  
- `driverLV3.m` evolves and plots.