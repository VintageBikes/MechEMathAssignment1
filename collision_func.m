function [t_ground,t_wall] = collision_func(traj_fun, egg_params, y_ground, x_wall)
%your code here

    wall_dist_func = @(t) egg_wrapper_max_x(t,traj_fun,egg_params)-x_wall;
    ground_dist_func = @(t) egg_wrapper_max_y(t,traj_fun,egg_params)-y_ground;


    dxtol = 1e-14;
    ytol = 1e-14;
    max_iter = 200;
    dfdxmin = 1e-8;

    x_guess0 = wall_dist_func(0);
    x_guess1 = wall_dist_func(2);
    y_guess0 = ground_dist_func(0);
    y_guess1 = ground_dist_func(2);


    t_wall = secant_solver(wall_dist_func, x_guess0, x_guess1, dxtol, ytol, max_iter, dfdxmin);
    t_ground = secant_solver(ground_dist_func, y_guess0, y_guess1, dxtol, ytol, max_iter, dfdxmin);

end

function xmax = egg_wrapper_max_x(t,traj_fun,egg_params)
    [x0,y0,theta] = traj_fun(t);
    [~, xmax,~, ~] = find_bounding_box(x0,y0,theta,egg_params);
end

function ymin = egg_wrapper_max_y(t,traj_fun,egg_params)
    [x0,y0,theta] = traj_fun(t);
    [~, ~, ymin, ~] = find_bounding_box(x0,y0,theta,egg_params);
end