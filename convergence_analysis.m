function x = convergence_analysis(solver_flag, fun, x_guess0, guess_list1, guess_list2, filter_list)
    dxtol = 1e-14;
    ytol = 1e-14;
    max_iter = 200;
    dfdxmin = 1e-8;

    %% Step 2
    x_root = newton_solver(fun, x_guess0, dxtol, ytol, max_iter, dfdxmin)

    %% Step 3
    my_recorder = input_recorder();
    f_record = my_recorder.generate_recorder_fun(fun);
    x_current_list = [];
    x_next_list = [];
    index_list = [];
    %loop through each trial
    for n = 1:length(guess_list1)
        my_recorder.clear_input_list();
        if solver_flag == 1         % Bisection method
            x_left = guess_list1(n);
            x_right = guess_list2(n);
            if sign(fun(x_left)) == sign(fun(x_right))
                % Cancel this run if bisection will error out
                continue
            end
            x_root = bisection_solver(f_record, x_left, x_right, dxtol, ytol, max_iter);
        elseif solver_flag == 2     % Newton's method
            x_guess = guess_list1(n);
            x_root = newton_solver(f_record, x_guess, dxtol, ytol, max_iter, dfdxmin);
        elseif solver_flag == 3     % Secant method
            x_guess00 = guess_list1(n);
            x_guess01 = guess_list2(n);
            x_root = secant_solver(f_record, x_guess00, x_guess01, dxtol, ytol, max_iter, dfdxmin);
        elseif solver_flag == 4     % Fzero
            x_guess = guess_list1(n);
            x_root = fzero(f_record, x_guess);
        else
            error("solver_flag must be an integer between 1-4");
        end
        %at this point, input_list will be populated with the values that
        %the solver called at each iteration.
        %In other words, it is now [x_1,x_2,...x_n-1,x_n]
        %append the collected data to the compilation
        input_list = my_recorder.get_input_list();
        x_current_list = [x_current_list,input_list(1:end-1)];
        x_next_list = [x_next_list,input_list(2:end)];
        index_list = [index_list,1:length(input_list)-1];
    end
    
    %% Step 4
    e_list0 = abs(x_current_list-x_root);
    e_list1 = abs(x_next_list-x_root);

    loglog(e_list0,e_list1,'ro','MarkerFaceColor','r','MarkerSize',1);
    xlim([1e-20, 1e5]); ylim([1e-20, 1e5]);
    axis square;
    xlabel("e_{n}"); ylabel("e_{n+1}");
    hold on;

    %% Step 5
    x_regression = [];
    y_regression = [];
    
    for n=1:length(index_list)
        %if the error is not too big or too small
        %and it was enough iterations into the trial...
        if e_list0(n)>1e-15 && e_list0(n)<1e-2 && e_list1(n)>1e-14 && e_list1(n)<1e-2 && index_list(n)>2
            %then add it to the set of points for regression
            x_regression(end+1) = e_list0(n);
            y_regression(end+1) = e_list1(n);
        end
    end
    loglog(x_regression,y_regression,'bo','MarkerFaceColor','b','MarkerSize',1)
    
    %% Step 6
    [p, k] = generate_error_fit(x_regression, y_regression);
    
    %generate x data on a logarithmic range
    fit_line_x = 10.^[-16:.01:1]; %#ok<NBRAK1>
    %compute the corresponding y values
    fit_line_y = k*fit_line_x.^p;
    %plot on a loglog plot.
    loglog(fit_line_x,fit_line_y,'k-','linewidth',1.5)
    %legend("Raw Error Data", "Filtered Error Data", "Error Data with Fit", "location", "northwest");
    hold off;
    
    function [p,k] = generate_error_fit(x_regression,y_regression)
        %generate Y, X1, and X2
        %note that I use the transpose operator (')
        %to convert the result from a row vector to a column
        %If you are copy-pasting, the ' character may not work correctly
        Y = log(y_regression)';
        X1 = log(x_regression)';
        X2 = ones(length(X1),1);
        %run the regression
        coeff_vec = regress(Y,[X1,X2]);
        %pull out the coefficients from the fit
        p = coeff_vec(1);
        k = exp(coeff_vec(2));
    end

    %% Step 7
    if solver_flag == 1         % Bisection method
        title("Bisection Method");
        expected_p = 1;
        expected_k = 1/2;
        % Display the results in a table format
        bisection_error = ["p", "expected p", "k", "expected k"; p, expected_p, k, expected_k]
    elseif solver_flag == 2     % Newton's method
        title("Newton's Method");
        expected_p = 2;
        [approximate_dfdx, approximate_d2fdx2] = approximate_derivative(fun, x_root);
        expected_k = abs(approximate_d2fdx2/(2*approximate_dfdx));
        newtons_error = ["p", "expected p", "k", "expected k"; p, expected_p, k, expected_k]
    elseif solver_flag == 3     % Secant method
        title("Secant Method");
        expected_p = (1+sqrt(5))/2;
        secant_error = ["p", "expected p", "k"; p, expected_p, k]
    elseif solver_flag == 4     % Fzero
        title("Fzero");
        fzero_error = ["p", "k"; p, k]

    end

    %example of how to implement finite difference approximation
    %for the first and second derivative of a function
    %INPUTS:
    %fun: the mathetmatical function we want to differentiate
    %x: the input value of fun that we want to compute the derivative at
    %OUTPUTS:
    %dfdx: approximation of fun'(x)
    %d2fdx2: approximation of fun''(x)
    function [dfdx,d2fdx2] = approximate_derivative(fun,x)
        %set the step size to be tiny
        delta_x = 1e-6;
        %compute the function at different points near x
        f_left = fun(x-delta_x);
        f_0 = fun(x);
        f_right = fun(x+delta_x);
        %approximate the first derivative
        dfdx = (f_right-f_left)/(2*delta_x);
        %approximate the second derivative
        d2fdx2 = (f_right-2*f_0+f_left)/(delta_x^2);
    end
end