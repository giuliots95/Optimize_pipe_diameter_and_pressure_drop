function []=fliplegend(legend_labels, b)
% This function flips the order of the legend of a 2D plot, to make it
% appear in the same order as the plotted lines themselves.
%
% Inputs: - legend_labels (cell array of strings)
%           containing the text used to create the legend entries.
%         - b -> th legend data+
% 
% Use this function after that a legend has been created in the actual
% figure. To access the legend data, use 
% [~, b]=legend(My_legend_text_cell_array,...);
%
% Create a new cell array with the flipped legend elements
flipped_string=flipud(get(b(1:numel(legend_labels) ),'string'));
%
% Get the color handles of the lines in the legend
b1=b(numel(legend_labels)+1:2:end);
%
for i=1:numel(legend_labels)
    % Reverse the string in the legend
    set(b(i),'string', flipped_string{i}); 
    LegendColor(i,:)=b1(i).Color;
end
%
% Create a new color matrix with the reversed colors
flipped_LegendColor=flip(LegendColor);
%
for i=1:numel(legend_labels)
   % Reverse the colors in the legend
   set(b1(i),'color', flipped_LegendColor(i,:));
end
end
