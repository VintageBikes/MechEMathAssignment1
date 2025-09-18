function [xmin, xmax, ymin, ymax] = find_bounding_box(x0, y0, theta, egg_params)
    
    egg_wrapper_func2_x = @(s_in) egg_wrapper_func1_x(s_in,x0,y0,theta,egg_params);
    egg_wrapper_func2_y = @(s_in) egg_wrapper_func1_y(s_in,x0,y0,theta,egg_params);

    s_guess_list = 0:.2:1;

    dxtol = 1e-14; ytol = 1e-14; max_iter = 200; dfdxmin = 1e-8;

    x_list = [];
    y_list = [];
    for s_guess = s_guess_list
        s_rootx = secant_solver(egg_wrapper_func2_x,s_guess,s_guess+1e-4,dxtol,ytol,max_iter,dfdxmin);
        [V,~] = egg_func(s_rootx,x0,y0,theta,egg_params);
        x_list(end+1) = V(1);

        s_rooty = secant_solver(egg_wrapper_func2_y,s_guess,s_guess+1e-4,dxtol,ytol,max_iter,dfdxmin);
        [V,~] = egg_func(s_rooty,x0,y0,theta,egg_params);
        y_list(end+1) = V(2);

    end

    xmin = min(x_list);
    xmax = max(x_list);
    ymin = min(y_list);
    ymax = max(y_list);
end

function Gx = egg_wrapper_func1_x(s,x0,y0,theta,egg_params)
    [~,G] = egg_func(s,x0,y0,theta,egg_params);
    Gx = G(1);
end

function Gy = egg_wrapper_func1_y(s,x0,y0,theta,egg_params)
    [~,G] = egg_func(s,x0,y0,theta,egg_params);
    Gy = G(2); 
end