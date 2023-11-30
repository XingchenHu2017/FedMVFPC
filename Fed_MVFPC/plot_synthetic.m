function hh = plot_synthetic(numview,outV,X,c)
MS = 8;
for tt = 1:numview
    temp_outV = outV{end};
    tempV = temp_outV{tt}';
    tempX = X{tt}';
    subplot(1,3,tt)
    scatter(tempX(1:2500,1),tempX(1:2500,2),MS,'Marker','o','MarkerFaceColor',[246,83,20]/255,'MarkerEdgeColor',[0.4 0.4,0.4],'LineWidth',0.02)
    hold on
    scatter(tempX(2501:5000,1),tempX(2501:5000,2),MS,'Marker','o','MarkerFaceColor',[124,187,0]/255,'MarkerEdgeColor',[0.4 0.4,0.4],'LineWidth',0.02)
    hold on
    scatter(tempX(5001:7500,1),tempX(5001:7500,2),MS,'Marker','o','MarkerFaceColor',[0,161,241]/255,'MarkerEdgeColor',[0.4 0.4,0.4],'LineWidth',0.02)
    hold on
    scatter(tempX(7501:10000,1),tempX(7501:10000,2),MS,'Marker','o','MarkerFaceColor',[255,187,0]/255,'MarkerEdgeColor',[0.4 0.4,0.4],'LineWidth',0.02)
    
    hold on
    dim = 2;
    for ii = 1:c
        for iter = 1:length(outV)-1
            temp_outV = outV{iter};
            prot_c = temp_outV{tt}';
            c_x1 = prot_c(ii,1);
            c_x2 = prot_c(ii,2);
            temp_outV = outV{iter+1};
            prot_d = temp_outV{tt}';
            d_x1 = prot_d(ii,1);
            d_x2 = prot_d(ii, 2);
            hold on; plot([c_x1, d_x1], [c_x2, d_x2], 'k-o','MarkerFaceColor',[0.6,0.6,0.6] );
        end
    end
    hold on
    scatter(tempV(:,1),tempV(:,2),40,'xr','LineWidth',2)
    if tt == 1
        xlabel('x_{1}')
        ylabel('x_{2}')
        set(gca,'FontSize',16,'Fontname','Times New Roman')
    elseif tt == 2
        xlabel('x_{1}')
        ylabel('x_{3}')
        set(gca,'FontSize',16,'Fontname','Times New Roman')
    elseif tt == 3
        xlabel('x_{2}')
        ylabel('x_{3}')
        set(gca,'FontSize',16,'Fontname','Times New Roman')
    end
end
end

