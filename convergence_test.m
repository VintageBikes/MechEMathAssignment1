function convergence_test()
    x_in = linspace(0,50,200);
    [fvals, dfdx_vals] = test_function(x_in);

    dxtol = 1e-14;
    ytol = 1e-14;
    dfdxmin = 1e-10;
    max_iter = 100;
    

    x_root = newton_solver(@test_function,27,dxtol,ytol,max_iter,dfdxmin);

    success_list = [];
    fail_list = [];

    for n = 1:length(x_in)
        x_guess = x_in(n);
        root_attempt = newton_solver(@test_function,x_guess,dxtol,ytol,max_iter,dfdxmin);
        if abs(x_root - root_attempt) < .1
            success_list(end+1) = x_guess;
        else
            fail_list(end+1) = x_guess;
        end
    end

    success_list
    fail_list

    hold on
    [f_success, ~] = test_function(success_list);
    [f_fail, ~] = test_function(fail_list);

    plot(x_in, fvals, 'k','LineWidth',2);
    plot([x_in(1),x_in(end)],[0,0],'b--','LineWidth',1);
    plot(success_list,f_success,'go','MarkerFaceColor','g','MarkerSize',3);
    plot(fail_list,f_fail,'ro','MarkerFaceColor','r','MarkerSize',3);

end


%Example sigmoid function
function [f_val,dfdx] = test_function(x)
    a = 27.3; 
    b = 2; 
    c = 8.3; 
    d = -3;
    H = exp((x-a)/b);
    dH = H/b;
    L = 1+H;
    dL = dH;
    f_val = c*H./L+d;
    dfdx = c*(L.*dH-H.*dL)./(L.^2);
end