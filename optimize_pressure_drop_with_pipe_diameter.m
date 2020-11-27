function [T, exitflag] = optimize_pressure_drop_with_pipe_diameter(m_dot, rho, mu, roughness, D_min, D_max, velocity_boundaries)
% This function solves the optimization problem of the pipe optimal
% diameter with minimal pressure drop.
%
% Inputs: - mass flow rate [kg/s] (scalar)
%         - fluid dwnsity [kg/m^3] (scalar)
%         - pipe absolute roughness [m] (scalar)
%         - lower boundary for the search of the pipe D [m] (scalar)
%         - upper boundary for the search of the pipe D [m] (scalar)
%         - velocity boundary [v_min, v_max] (1 x 2 array)
%
% Outputs: - T table containing all non-dominated solutions 
%          - exit flag (>0 if successful, <=0 if algorithm did not
%          converge)
%
% build up the objective function [f_array(1), f_array(2)]
f_array = @(D) obj_function(D, m_dot, rho, mu, roughness);
%
% call the constraints function [c(x1, x2), ~]
% note that the boundary constarint on the fluid velocity variable is
% in practice a non-linear constraint on the pipe diameter variable.
C = @(D) nlinconstraint(D, m_dot, rho, velocity_boundaries);
%
% set up the solver options
options = optimoptions('gamultiobj','InitialPopulationRange', ...
    [D_min; D_max],'Display','off','UseVectorized',true, ...
    'PopulationSize', 200,'MaxGenerations',500,'MaxTime', 60*5);
% time out after 5 minutes
% max # of populations is 500
%
[~, f_values, exitflag]=gamultiobj(f_array, 1, [], [], [], [], ...
    D_min, D_max, C, options);
%
if exitflag < 0
    % refuse solution
    error('optimization failed');
elseif exitflag==0
    % max number of generations reached
    warning('max number of generations reached. Try to relax variable boundaries or constraints');
else
    % accept solution
    disp('optimization successful');
    %
    w=[0.5, 0.5]; % assign equal weight to both objectives
    %
    % rank the objectives according to the TOPSIS method
    obj=topsis(f_values, w, [-1, -1]);
    
    % build the output table containing the designs in the pareto front
    d=obj(:,2); 
    delta_p_1m=obj(:,1);
    v=4*m_dot./(pi*d.^2.*rho);
    Re=rho.*v.*d./mu;
    delta_p_mmWC=delta_p_1m./9.81;
    T=table(m_dot.*ones(size(delta_p_1m)), round(delta_p_1m), ...
        round(delta_p_mmWC), round(d*1000,2), round(v, 2), round(Re));
    T.Properties.VariableNames={'m_dot','dp [Pa/m]', 'dp [mm H2O/m]',...
        'd [mm]', 'v [m/s]','Re'};
end
end

