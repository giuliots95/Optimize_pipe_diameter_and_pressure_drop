function plot_pipes_chart(m_dot, rho, mu, D_plot, roughness, Xlim, Ylim)
% This function plots the pipe diameter chart with respect to the fluid
% flow rate and the obtained pressure drop.
%   inputs: - mass flow rate array [kg/s]
%           - density constant [kg/m3]
%           - dynamic viscosity constant [Pa*s]
%           - pipe diameters array [m]
%           - pipe roughness constant [m]
%
%   optional arguments: - 1x2 array limit on pressure drop (X axis)
%                       - 1x2 array limit on flow rate (Y axis)
%
%   output: the figure plot for the riquired diameters & mass flow rates.
%
%% plot the iso-diameter lines
for j=1:numel(D_plot)
    D=D_plot(j).*ones(size(m_dot));
    v=4*m_dot./(pi*D.^2.*rho); % fluid velocity
    Re=(rho.*v.*D)./mu; % Reynolds number
    f=arrayfun(@colebrook, Re, roughness./D); % friction factor (Darcy-Weissbach)
    delta_p_m=(1./D).*f*0.5.*rho.*v.^2; % pressure drop per 1 [m] tube length
    d_p_mm_WC=delta_p_m./9.81; % pressure drop in mm water column/m
    loglog(d_p_mm_WC, m_dot);
    hold on;
    Legend_labels{j}=strcat('D = ', num2str(D(1).*1000),' mm');
end
%% plot the iso-velocity lines (optional)
u_plot=[0.2, 0.3, 0.4, 0.5, 0.6, 0.8, 1, 1.2, 1.6, 2, 2.5, 3, 3.2];
for i=1:numel(u_plot)
    u=u_plot(i);
    D_u=(4*m_dot./(rho*pi*u)).^0.5;
    Re_u=(rho.*u.*D_u)./mu;
    f_u=arrayfun(@colebrook, Re_u, roughness./D_u); 
    delta_p_m_u=(1./D_u).*f_u*0.5.*rho.*u.^2;
    % convert the pressure drop in mm water column/m
    delta_p_mm_WC_u=delta_p_m_u/9.81;
    loglog(delta_p_mm_WC_u, m_dot,'--k');
    hold on;
    text(delta_p_mm_WC_u(end), m_dot(end), num2str(u),'Rotation',90);
end
%% limit the plot
if exist('Xlim','var')
xlim(Xlim);
end
if exist('Ylim','var')
ylim(Ylim);
end
grid minor;
% add a legend to the iso-diameter lines
[~, b]=legend(Legend_labels,'Location','EastOutside','AutoUpdate','Off');
% flip upside down the legend items to match with the lines in the plot
fliplegend(Legend_labels, b);
%
xlabel('pressure drop per meter [mm water column/m]');
ylabel('mass flow rate [kg/s]');
end

