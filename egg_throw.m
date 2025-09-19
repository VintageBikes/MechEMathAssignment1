function egg_throw()
    
    egg_params = struct();
    egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;
    y_ground = 0;
    x_wall = 20;
    
    [t_ground,t_wall] = collision_func(@egg_trajectory, egg_params, y_ground, x_wall);
    
        if t_ground < t_wall
            hit = t_ground;
            collision = y_ground;
            touch = 2;
            word_hit = "ground";
        else
            hit = t_wall;
            collision = x_wall;
            touch = 1;
            word_hit = "wall";
        end

        
    egg_animation(x_wall,y_ground,t_ground,t_wall,egg_params);
    
   
    [x0,y0,theta] = egg_trajectory(hit);
    s_perimeter = linspace(0,1,100);
    [V, ~] = egg_func(s_perimeter,x0,y0,theta,egg_params);
    differences = abs(V(touch,:) - collision);
    [~,index] = min(differences);
    collision_point_x = V(1,index);
    collision_point_y = V(2,index);
    plot(collision_point_x,collision_point_y,'r.','marker','o');

    disp("The egg hit the " + word_hit + " at " + hit + " seconds!");

    
end

function egg_animation(x_wall,y_ground,t_ground,t_wall,egg_params)
    figure();
    hold on
    axis([0,20,0,20]);
    egg_plot = plot(0,0,'k','LineWidth',2);
    box_plot = plot(0,0,'k');

    %set up the axis
        hold on; axis equal; axis square
        axis([0,50,-10,50]);
        %initialize the plot of the square
        if t_ground < t_wall
            hit = t_ground;
        else
            hit = t_wall;
        end
    time_span = 0:0.01:hit;
    %iterate through time
    for n = 1:length(time_span)
        t = time_span(n);

        xline(x_wall)
        yline(y_ground)

        [x0,y0,theta] = egg_trajectory(t);
        
        s_perimeter = linspace(0,1,50);
        [V_vals, ~] = egg_func(s_perimeter,x0,y0,theta,egg_params);

        % plot(V_vals(1,:),V_vals(2,:),'k','LineWidth',2);
        set(egg_plot,'xdata',V_vals(1,:),'ydata',V_vals(2,:));
        

        %s_tangent = .3;
        %[V_tangent, G_tangent] = egg_func(s_tangent,x0,y0,theta,egg_params);

        %plot(V_tangent(1,:),V_tangent(2,:),'ro','MarkerFaceColor','r','MarkerSize',4);
        %plot(V_tangent(1)+[0,G_tangent(1)],V_tangent(2)+[0,G_tangent(2)],'k','LineWidth',2);
        %plot(V_vals(1,:),V_vals(2,:),'ro','MarkerFaceColor','r','MarkerSize',4);

        [xmin,xmax,ymin,ymax] = find_bounding_box(x0,y0,theta,egg_params);

        xbox = [xmin,xmax,xmax,xmin,xmin];
        ybox = [ymin,ymin,ymax,ymax,ymin];
        set(box_plot,'xdata',xbox,'ydata',ybox);
        % plot([xmin,xmax,xmax,xmin,xmin],[ymin,ymin,ymax,ymax,ymin],'k');
        drawnow;
    end
    
end
