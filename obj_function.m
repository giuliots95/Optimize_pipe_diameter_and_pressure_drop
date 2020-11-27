function y = obj_function(D, m_dot, rho, mu, roughness)
% This function contains the objectives to be minimized. 
% The first objective is expressed as the pressure drop per meter of 
% pipe, i.e. [Pa/m]. The second one is the inner pipe diameter in [m]
%
% To run this function, the Colebrook implicit solver is required.
%
% pressure drop [Pa/m]
% 
% delta p     8 * m^2                        4 m         epsilon
% -------- = ----------------- * colebrook(---------- , --------- )
%    L        pi^2 * rho * D^5              pi * D * m       D
%
v=4*m_dot./(pi*D.^2.*rho); % fluid velocity
Re=(rho.*v.*D)./mu; % Reynolds number
f=arrayfun(@colebrook, Re, roughness./D); % friction factor (Darcy-Weissbach)
delta_p_m=(1./D).*f*0.5.*rho.*v.^2; % pressure drop per 1 [m] tube length
% objectives
y(:,1)=delta_p_m;
y(:,2)=D;
end

