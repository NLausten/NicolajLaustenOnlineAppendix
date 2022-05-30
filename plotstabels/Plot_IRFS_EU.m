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

shockNames = {'Unc'}; % Only FU and EBP
% shocks are identified
varNames = {'Financial Uncertainty','Credit Spread','Industrial Production', 'Inflation','Policy Rate','Unemployment Rate','Equity Prices'};

count  = 1;

for jj = 1:1 % Shocks: 1 = FU, 2 = Y
    
    for ii = 1:n % Variables: n = 7
        
        percentiles = prctile(squeeze(Draws_IRFs_narrative(ii,jj,1:hmaxtoplot+1,:)),bands,2);

        subplot(4,3,count)        
        plotConfidenceBandsBlue(0:hmaxtoplot,percentiles,'r'); 
        hold on
        plot(0:hmaxtoplot,percentiles(:,2),'Color',[204 37 41]./255,'LineWidth',2.5);
        hold on
        plot(0:hmaxtoplot,zeros(hmaxtoplot+1,1),'-.k','LineWidth',0.75)       
        xmin=0;
        xmax=hmaxtoplot;
        xlim([xmin,xmax])
        set(gca, 'FontName', 'Times New Roman');
        set(gca, 'FontSize', 8);
        set(gca,'XTick',[0:round(hmaxtoplot/4):hmaxtoplot]')
        set(gca,'XTickLabel',num2str([0:round(hmaxtoplot/4):hmaxtoplot]'))
        box off
        %ylabel(strcat(varNames(ii)),'FontWeight', 'bold')
        title(strcat(varNames(ii)))
        set(gca,'Layer','top','YGrid', 'on')
        
        if count > 6
            xlabel('Months') 
        end
        
        count  = count+1;
        
    end
    
end
tightfig;

%fname = strcat('results/IRFsEUModel4_CONS.eps');
%print('-depsc', f2, fname); 

% Colors
% Blue: [57 106 177]./255
% Red: [204 37 41]./255
% Green: [62 150 81]./255
