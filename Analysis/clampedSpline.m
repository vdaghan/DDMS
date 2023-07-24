function yvec = clampedSpline(points, xvec)
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