%% Newton's Method Solver Function
function x_root = newton_solver(fun, x_guess, dxtol, ytol, max_iter, dfdxmin)
    global input_list;

    delta_x = 2 * dxtol;
    [fval, dfdx] = fun(x_guess);

    count = 0;
    while count < max_iter && abs(delta_x) > dxtol && abs(fval) > ytol && abs(dfdx) > dfdxmin
        count = count + 1;
        delta_x = -fval / dfdx;
        x_guess = x_guess + delta_x;
        [fval, dfdx] = fun(x_guess);
        input_list = [input_list, x_guess];
    end
    x_root = x_guess;
end