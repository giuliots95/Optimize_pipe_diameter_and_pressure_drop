function output_DM = topsis(DM, weights, min_max)
% This function ranks the decision matrix [m x n] with n = attributes (columns)
% and m = alternatives, configurations (rows) using the TOPSIS method.
% 
% Inputs: - decision matrix [m x n]
%         - weights array for the attributes [1 x m]
%         - minimize/maximize array [1 x m] 
%             for the j-th attribute, with j = 1, 2, ... m
%             choose +1 if the j-th attribute shall be maximized
%                    -1 if the j-th attribute shall be minimized
%
% Output: - ranked decision matrix [m x n]
%           expressed with the "real" units.
%
% Pay attention, this function works if each element of the decision matrix
% is a scalar, not an array!
%
[m, n]=size(DM);
Z=NaN.*ones(m,n);
Zw=Z;
a_plus=NaN.*ones(1, n);
a_minus=NaN.*ones(1, n);
%
for j=1:n
   Z(:,j)=DM(:,j)./(sum(DM(:,j).^2, 1)).^0.5;
Zw(:,j)=Z(:,j).*weights(j);      % take the weights into account
    if min_max(j)==-1
        a_plus(j)=min(Zw(:,j));
        a_minus(j)=max(Zw(:,j));
    elseif min_max(j)==1
        a_plus(j)=max(Zw(:,j));
        a_minus(j)=min(Zw(:,j));
    end
end
Si_minus=sum((Zw-a_minus).^2, 2).^0.5; % distance from the ideal negative
Si_plus=sum((Zw-a_plus).^2, 2).^0.5; % distance from the ideal positive
c=Si_minus./(Si_plus+Si_minus); % relative the relative degree of approximation
new_DM=[DM, c];
ranked_DM=sortrows(new_DM, n+1, 'descend');
output_DM=ranked_DM(:, 1:n);
end

