function [f, message] = colebrook(Re, k)
% Compute the friction factor given the Reynolds number, the roughness
% epsilon and the reference inner pipe diameter D. The calculation is
% iterative.
%
% inputs: - Reynolds number [-] (scalar)
%         - relative roughness [-] (scalar)
%
% Outputs: - f Darcy-Weissbach friction factor (dimensionless)
%          - message (1 if calculation is successful, -1 if fails)
%
% Pay attention: if you provide k as k = epsilon / D
%                epsilon and D shall have the same dimension!
%
% To use this function with array inputs, simply use arrayfun.
%
if Re <=0 || k <=0 
    error('inputs must be all positive values');
    return;
else
    if Re < 2300
        % laminar flow
        f = 64/Re;
        message=1;
    else
        % note that transition flow i.e. for 2300 < Re < 3400
        % the turbulent correlation is assumed for a matter of simplicity.
        % In this way, the discontinuity in the f function is placed at
        % lower Re. 
        %
        % rewrite fun(f) == 0
        fun=@(f) (1/sqrt(f)+2*log10(k/3.71+2.51/(Re*sqrt(f))));
        [f, ~, flag]=fsolve(fun, 0.1,  optimset('Display','off'));
        % discuss solutions
        if flag <= 0
            % refuse solution
            f=NaN;
            message=-1;
            % algorithm did not converge to a solution.
        else 
            % accept solution
            message=1;
        end
    end
end

