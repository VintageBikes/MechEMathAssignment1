function [x0,y0,theta] = egg_trajectory(t)
x0 = 7*t + 8;
y0 = -6*t.^2 + 20*t + 6;
theta = 5*t;
end