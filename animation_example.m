function egg_animation()
%set up the axis
    hold on; axis equal; axis square
    axis([0,50,0,50])
    %initialize the plot of the square

%iterate through time
for t=0:.001:10
%set up the axis
    hold on; axis equal; axis square
    axis([0,50,0,50])
    
    s_perimeter = linspace(0,1,50);

    [V_vals, G_vals] = egg_func(s_perimeter,x0,y0,theta,egg_params);
    cla;   
    plot(V_vals(1,:),V_vals(2,:),'k','LineWidth',2);

    s_tangent = .3;
    [V_tangent, G_tangent] = egg_func(s_tangent,x0,y0,theta,egg_params);
    
    %plot(V_tangent(1,:),V_tangent(2,:),'ro','MarkerFaceColor','r','MarkerSize',4);
    %plot(V_tangent(1)+[0,G_tangent(1)],V_tangent(2)+[0,G_tangent(2)],'k','LineWidth',2);
    plot(V_vals(1,:),V_vals(2,:),'ro','MarkerFaceColor','r','MarkerSize',4);

    [xmin,xmax,ymin,ymax] = find_bounding_box(x0,y0,theta,egg_params);

    plot([xmin,xmax,xmax,xmin,xmin],[ymin,ymin,ymax,ymax,ymin],'k');
    
end
end