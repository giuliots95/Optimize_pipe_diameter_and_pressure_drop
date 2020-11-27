%%% Pipe optimal design: smaller diameter / smaller pressure drop 
% CONTENT
% This script solves the problem of finding the optimal diameter for a
% straight pipe coneying an incompressible fluid, for different mass flow 
% rates. 
% The best design solution is considered the one that minimizes both 
% the pressure drop per unitary pipe length and the pipe diameter.
% 
% DESIGN VARIABLE 
% There is 1 design variable (the pipe diameter) and 2
% competitive objectives, so the problem is solved with the Pareto-optimum
% approach, that will output a compromise solution.
%
% The user can express both lower and upper boundaries for the search of
% the optimal pipe diameter and can provide lower and upper boundary for
% the flow velocity [m/s], thus constraining the optimization problem.
%
% PROBLEM CONSTANTS
% To perform the optimization, some fluid properties such as fluid dynamic 
% viscosity and density shall be imposed. The rated mass flow rate to be
% conveyed by the pipe and the pipe absolute roughness (that depends from
% the pipe material and conditions) shall be given as constant inputs.
%
% SOLVER CHOICE
% Non dominated configurations are found with the multi-objective genetic 
% algorithm solver "gamultiobj", but other algorithms such as 
% "paretosearch" can be used, editing the solver section.
%
% Note that both multi-objective solvers do not support inter variables as
% default, while "ga" solver enables also mixed-integer problems, but was
% conceived for mono-objective optimization only. One could also define a
% scalar overall cost function, like [1], but the purpose of this study is
% to consider the 2 objectives strictly separated.
%
% HOW IT WORKS
% For each mass flow rate, the program calculates non-dominated designs in 
% terms of pipe diameter [m] and pressure drop per meter [mm H20/m]. 
% The best solution is chosen with the TOPSIS method. 
% For a closer look on this outranking method, a good explanation is
% provided by [2]. Since there are only 2 objectives, I chose to assignan
% equal weight to each one, thinking that they have the same importance.
% The user is free to change the weights when calling the topsis.m
% function. For example, one could assign w=[0.25, 0.75] to make the
% diameter objective more relevant.
% 
% Finally, the best design for each flow rate is represented in the "pipe
% chart", that the log-log chart commonly used by technicians to speed up
% pipelines sizing. 
%   
% References:
%
% [1] S. B. Genic, B. M. Jacimovic, V. B. Genic, Economic optimiztion of
% pipe diameter for complete turbulence, Energy and Buildings 
% 45 (2012) p. 335–338. doi:10.1016/j.enbuild.2011.10.054
%
% [2] X. Li et al. Application of the Entropy Weight and TOPSIS Method in
% Safety Evaluation of Coal Mines, Procedia Engineerin. 
% doi:10.1016/j.proeng.2011.11.2410
%
clearvars;
clc;
%% input data
%m_dot=1; % the mass flow rate through the pipe [kg/s]
rho=1000;       % fluid density constant [kg/m3] e.g. for water @ 20 °C
mu=9*10^-4;     % fluid dynamic viscosity [Pa*s]
                % this can also be expressed as mu=nu*rho, if the dynamic 
                % viscosity is given. pay attention that these values 
                % depend from the fluid temperature.

roughness=0.5*1e-3;  % pipe rated absolute roughness [m]
                     % 0.001*1e-3 for floor heating pipe [m]
                     % 0.05*1e9-3 steel pipe with fine surface [m]
                     % 0.5*1e-3 common steel pipe [m]
%% define variable boundaries 
D_min=5*1e-3;    % lower bound for the pipe diameter in [m]
D_max=1000*1e-3; % upper bound for the pipe diameter in [m]
%% define constraints on the fluid velocity
% max & min fluid velocity allowed [m/s]. 
% These are common values that can be retrieved from technical manuals.
% The user can adjust as required.
velocity_boundaries=[0.1, 3]; % velocity [m/s]

%% input mass flow rates array
% Estimate best design for all these flow rates.
% m_dot_plot=[0.2, 0.3, 0.4, 0.5, 0.5, 0.7, 0.8, 0.9, 1, 2, 3, 4, 5, ...
%     6, 7, 8, 9, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 200, 300, 400];
m_dot_plot=[0.1, 0.2, 0.3, 0.5];
%% common diameters array
% This array is needed to plot the pipes chart. No influence on the
% optimization problem.
D_plot= [15, 20, 30, 40, 50, 65, 80, 100, ...
    125, 150, 200, 250, 300, 350, 400]./1000;
%% solve the problem
all_results=table();
for k=1:numel(m_dot_plot)
    m_dot=m_dot_plot(k);
    [results{k}, exitflag(k)]=optimize_pressure_drop_with_pipe_diameter(m_dot, ...
        rho, mu, roughness, D_min, D_max, velocity_boundaries);
    % these lines to give a feedback on how the calculation is proceeding.
    if exitflag(k) > 0
        disp((strcat('run ', num2str(k), ' / ', num2str(numel(m_dot_plot)),' successful ')));
        % sum up all non-dominated designs in a cell arra, one for each
        % mass flow rate
        all_results(k,:)=results{k}(1,:);
    else
        disp((strcat('run ', num2str(k), ' / ', num2str(numel(m_dot_plot)),' failed ')));
    end
end
%% save the best designs for each flow rate
writetable(all_results, 'optimal_pipe_design.csv');
%% plot the all optimal design in the "pipes chart"
figure(1)
dp_name='dp [mm H2O/m]';
d_name='d [mm]';
% plot the "pipes chart"
if numel(m_dot_plot) > 1
plot_pipes_chart(m_dot_plot, rho, mu, D_plot, roughness, ...
    [0.01, 1000], [0.1, max(m_dot_plot)]);
else
plot_pipes_chart(m_dot_plot, rho, mu, D_plot, roughness);
end
%
% plot the best designs 
for k=1:numel(m_dot_plot)
    loglog(all_results.(dp_name)(k), all_results.m_dot(k),'xk');
    hold on;
    text(all_results.(dp_name)(k),  all_results.m_dot(k), ...
        num2str(all_results.(d_name)(k)),'VerticalAlignment','bottom', ...
        'HorizontalAlignment','left');
end
savefig('pipes_chart_with_optimal_designs.fig');