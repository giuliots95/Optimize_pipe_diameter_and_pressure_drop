function [c, ceq] = nlinconstraint(D, m_dot, rho, velocity_boundaries)
% this function handles the non-linear constraints to be passed to the
% solver.
%   In general, 2 arrays are given in output: 
%   Cineq contains the inequualities array such as g(x) <= 0
%   Ceq contains the equality constraints, like h(x) = 0
%
% in this case, there is only 1 constraint on the pressure drop objective,
% that shall be less/more than the max/min available value. 
%
v=4*m_dot./(pi*D.^2.*rho);
% constraint functions
c=[];
if ismatrix(velocity_boundaries) && ~isempty(velocity_boundaries)
    if isscalar(velocity_boundaries(1)) && ~isnan(velocity_boundaries(1))
        c(:,1) = velocity_boundaries(1) - v;    
    end
    if isscalar(velocity_boundaries(2)) && ~isnan(velocity_boundaries(2))
        c(:,2) =  v - velocity_boundaries(2); 
    end
end
ceq=[];
% no equalities as constraints for this problem
end

