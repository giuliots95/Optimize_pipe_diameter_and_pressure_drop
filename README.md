# Optimize_pipe_diameter_and_pressure_drop

 CONTENT
 This script solves the problem of finding the optimal diameter for a
 straight pipe coneying an incompressible fluid, for different mass flow 
 rates. 
 The best design solution is considered the one that minimizes both 
 the pressure drop per unitary pipe length and the pipe diameter.
 
 DESIGN VARIABLE 
 There is 1 design variable (the pipe diameter) and 2
 competitive objectives, so the problem is solved with the Pareto-optimum
 approach, that will output a "practical" compromise solution.

 The user can express both lower and upper boundaries for the search of
 the optimal pipe diameter and can provide lower and upper boundary for
 the flow velocity [m/s], thus constraining the optimization problem.

 PROBLEM CONSTANTS
 To perform the optimization, some fluid properties such as fluid dynamic 
 viscosity and density shall be imposed. The rated mass flow rate to be
 conveyed by the pipe and the pipe absolute roughness (that depends from
 the pipe material and conditions) shall be given as constant inputs.

 SOLVER CHOICE
 Non dominated configurations are found with the multi-objective genetic 
 algorithm solver "gamultiobj", but other algorithms such as 
 "paretosearch" can be used, editing the solver section.

 Note that both multi-objective solvers do not support integer variables as
 default, while "ga" solver enables also mixed-integer problems, but was
 conceived for mono-objective optimization only. One could also define a
 scalar overall cost function, as it was done in [1], but the purpose of this study is
 to consider the 2 objectives in a strictly separated manner.

 HOW IT WORKS
 For each mass flow rate, the program calculates non-dominated designs in 
 terms of pipe diameter [m] and pressure drop per meter [mm H20/m]. 
 The best solution is chosen with the TOPSIS method. 
 For a closer look on this outranking method, a good explanation is
 provided by [2]. Since there are only 2 objectives, I chose to assign an
 equal weight (for instance, the array {0.5, 0.5}) to each one, thinking that they have the same importance.
 The user is free to change the weights when calling the topsis.m
 function. For example, one could assign w=[0.25, 0.75] to make the
 diameter objective more relevant.
 
 Finally, the best design for each flow rate is represented in the "pipe
 chart", that the log-log chart commonly used by technicians to speed up
 pipelines sizing. 
 
 Note that commonly available pipe charts are provided for specific pipe applications, e.g. for pipes conveying domestic water etc. So, they are valid only for a specific fluid, meaning that fluid properties are implicitly assumed as constants amd also the fluid flow is assumed to be fully turbulent.
 In this program instead, user can change the fluid properties as desuired (e.g. how does the pipe design change if viscosity is higher than standard?). Moreover, no simplifying assumptions on the fluid flow are made to calculate friction coefficient and pressure losses. So this program was conceived to provide a more general and less "application dependant" approach to pipe diameter optimization.
   
 References:

 [1] S. B. Genic, B. M. Jacimovic, V. B. Genic, Economic optimiztion of
 pipe diameter for complete turbulence, Energy and Buildings 
 45 (2012) p. 335–338. doi:10.1016/j.enbuild.2011.10.054

 [2] X. Li et al. Application of the Entropy Weight and TOPSIS Method in
 Safety Evaluation of Coal Mines, Procedia Engineering. 
 doi:10.1016/j.proeng.2011.11.2410

