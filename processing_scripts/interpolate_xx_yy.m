function [xx,yy]=interpolate_xx_yy(pts,id)

part = pts(id,:);
xx = spline(1 : size(part, 1), part(:, 1), 1 : 0.01 : size(part, 1));
yy = spline(1 : size(part, 1), part(:, 2), 1 : 0.01 : size(part, 1));
end