%% Secant Method Solver Function
function x_root = secant_solver(fun, x_guess0, x_guess1, dxtol, ytol, max_iter, dfdxmin)

    delta_x = 2 * dxtol;
    fval0 = fun(x_guess0);
    fval1 = fun(x_guess1);
    dfdx = (fval1 - fval0) / (x_guess1 - x_guess0);

    count = 0;
    while count < max_iter && abs(delta_x) > dxtol && abs(fval1) > ytol && abs(dfdx) > dfdxmin
        count = count + 1;
        delta_x = -fval1 / dfdx;
        x_guess2 = x_guess1 + delta_x;
        fval2 = fun(x_guess2);

        x_guess0 = x_guess1;
        fval0 = fval1;
        x_guess1 = x_guess2;
        fval1 = fval2;
        dfdx = (fval1 - fval0) / (x_guess1 - x_guess0);
    end
    x_root = x_guess1;
end