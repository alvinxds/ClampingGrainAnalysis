function [angle] = getAngleToXAxis(p1, p2)
    dx = p2(1) - p1(1);
    dy = p2(2) - p1(2);
    angle = atan(dy./dx);
end