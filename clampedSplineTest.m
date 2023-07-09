% Obtained via ChatGPT using these instructions:
% What is shape-preserving spline?
% Would a monotone spline work for non-monotonic data points?
% What is a convex spline? Explain it to me with graph examples.
% What is a bounded spline?
% What is a locally bounded spline?
% Give me the doi of a recent paper using locally bounded splines.
% What do you call a spline that has no points outside local data range?
% What is a mother-sucking globally elliptic spline?
% Is there a spline which has zero derivative at data points?
% Is there a spline monotone between nonmonotone data points?
% Is there a spline which has zero first-order-derivative at data points?
% Provide me with an algorithm for a clamped spline
% Provide me with an algorithm for a clamped spline in C++
% write compute_clamped_spline_coefficients in MATLAB

clc;
clear;
points = [[1,2]; [64,16]; [128,-5]; [192,-16]; [256,4]];
%points = [[1,0]; [256,0]];
x = (1:256)';
y = nan(length(x), 1);
plot(x, evaluateClampedSpline(points, x))

function yvec = evaluateClampedSpline(points, xvec)
    vecSize = size(xvec, 1);
    yvec = nan(vecSize, 1);
    for pointIndex = 1:size(points, 1)-1
        x1 = points(pointIndex, 1);
        x2 = points(pointIndex+1, 1);
        y1 = points(pointIndex, 2);
        y2 = points(pointIndex+1, 2);
        xvecprev = xvec(xvec < x1);
        xveccur = xvec(x1 <= xvec & xvec < x2);
        xvecnext = xvec(x2 <= xvec);
        startIndex = length(xvecprev)+1;
        endIndex = startIndex+length(xveccur);

%         a = yi;
%         b = (yip-yi)/(xip-xi);
        for i = startIndex:endIndex
            x = xvec(i,1);
%             yvec(i,1) = a + b * (x-xi);
            dx = x2-x1;
            a = -2*(y2-y1)/(dx^3);
            b = (y2-y1-a*dx^3)/(dx^2);
            yvec(i,1) = ...
                a * ((x - x1)^3) ...
                + b * ((x - x1)^2) ...
                + 0 * (x - x1) ...
                + y1;
        end
    end
end
