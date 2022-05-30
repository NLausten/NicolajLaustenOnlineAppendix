% IRF Model I

hmaxtoplot = 48; % IRFs horizon
bands  = [16,50,84]; % Percentiles for credible sets

f2 = figure;
% f2 = figure('WindowState','maximized');
clf
figSize = [9 4.5];
set(f2, 'PaperUnits', 'inches');
set(f2, 'Units','inches');
set(f2, 'PaperSize', figSize);
set(f2, 'PaperPositionMode', 'auto');
set(f2, 'Position', [0 0 figSize(1) figSize(2)])

shockNames = {'Financial Uncertainty','Macro Uncertainty','Industrial Production'}; % Only FU and EBP
% shocks are identified
varNames = {'U_{F}','U_{M}' 'ip'};

count  = 1;

for jj = 1:1 % Shocks: 1 = FU, 2 = EBP
    
    for ii = 1:n % Variables: n = 7
        
        percentiles = prctile(squeeze(Draws_IRFs_narrative(ii,jj,1:hmaxtoplot+1,:)),bands,2);

        subplot(3,n,count)        
        plotConfidenceBandsBlue(0:hmaxtoplot,percentiles,[57 106 177]./255); 
        hold on
        plot(0:hmaxtoplot,percentiles(:,2),'Color',[57 106 177]./255,'LineWidth',2.5);
        hold on
        plot(0:hmaxtoplot,zeros(hmaxtoplot+1,1),'-.k','LineWidth',0.75)       
        xmin=0;
        xmax=hmaxtoplot;
        xlim([xmin,xmax])
        if count == 1
            ylim([-0.2,0.3]);
        elseif count == 2
            ylim([-0.2,0.3]);
        elseif count == 3
            ylim([-1,1.5])
        end
        set(gca, 'FontName', 'Times New Roman');
        set(gca, 'FontSize', 10);
        set(gca,'XTick',[0:round(hmaxtoplot/4):hmaxtoplot]')
        set(gca,'XTickLabel',num2str([0:round(hmaxtoplot/4):hmaxtoplot]'))
        box off
        ylabel(strcat(varNames(ii)),'FontWeight', 'bold')
        title(strcat(shockNames(jj),' Shock'))
        set(gca,'Layer','top','Ygrid','on')
        
        if count > 6
            xlabel('Months')
        end
        
        count  = count+1;
        
    end
    
end


for jj = 2:2 % Shocks: 1 = FU, 2 = EBP
    
    for ii = 1:n % Variables: n = 7
        
        percentiles = prctile(squeeze(Draws_IRFs_narrative(ii,jj,1:hmaxtoplot+1,:)),bands,2);

        subplot(3,n,count)        
        plotConfidenceBandsBlue(0:hmaxtoplot,percentiles,[57 106 177]./255); 
        hold on
        plot(0:hmaxtoplot,percentiles(:,2),'Color',[57 106 177]./255,'LineWidth',2.5);
        hold on
        plot(0:hmaxtoplot,zeros(hmaxtoplot+1,1),'-.k','LineWidth',0.75)       
        xmin=0;
        xmax=hmaxtoplot;
        xlim([xmin,xmax])
                if count == 4
            ylim([-0.2,0.3]);
                elseif count == 5
            ylim([-0.2,0.3]);
                elseif count == 6
            ylim([-1,1.5])
        end
        set(gca, 'FontName', 'Times New Roman');
        set(gca, 'FontSize', 10);
        set(gca,'XTick',[0:round(hmaxtoplot/4):hmaxtoplot]')
        set(gca,'XTickLabel',num2str([0:round(hmaxtoplot/4):hmaxtoplot]'))
        box off
        ylabel(strcat(varNames(ii)),'FontWeight', 'bold')
        title(strcat(shockNames(jj),' Shock'))
        set(gca,'Layer','top','Ygrid','on')
        
        if count == 9
            set(gca,'YTick',-1:0.5:1)
        end
        
        if count > 6
            xlabel('Months')
        end
        
        count  = count+1;
        
    end
    
end

for jj = 3:3 % Shocks: 1 = FU, 2 = EBP
    
    for ii = 1:n % Variables: n = 7
        
        percentiles = prctile(squeeze(Draws_IRFs_narrative(ii,jj,1:hmaxtoplot+1,:)),bands,2);

        subplot(3,n,count)        
        plotConfidenceBandsBlue(0:hmaxtoplot,percentiles,'r'); 
        hold on
        plot(0:hmaxtoplot,percentiles(:,2),'Color',[204 37 41]./255,'LineWidth',2.5);
        hold on
        plot(0:hmaxtoplot,zeros(hmaxtoplot+1,1),'-.k','LineWidth',0.75)       
        xmin=0;
        xmax=hmaxtoplot;
        xlim([xmin,xmax])
                if count == 7
            ylim([-0.2,0.3]);
                elseif count == 8
            ylim([-0.2,0.3]);
                elseif count == 9
            ylim([-1,1.5])
        end
        set(gca, 'FontName', 'Times New Roman');
        set(gca, 'FontSize', 10);
        set(gca,'XTick',[0:round(hmaxtoplot/4):hmaxtoplot]')
        set(gca,'XTickLabel',num2str([0:round(hmaxtoplot/4):hmaxtoplot]'))
        box off
        ylabel(strcat(varNames(ii)),'FontWeight', 'bold')
        title(strcat(shockNames(jj),' Shock'))
        set(gca,'Layer','top','Ygrid','on')
        
        if count > 6
            xlabel('Months')
        end
        
        count  = count+1;
        
    end
    
end

tightfig;

fname = strcat('results/IRFsUS2.eps');
print('-depsc', f2, fname); 
