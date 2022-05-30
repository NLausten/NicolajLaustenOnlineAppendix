hmaxtoplot = 60; % IRFs horizon
bands  = [16,50,84]; % Percentiles

fA4 = figure;
clf
figSize = [12 6];
set(fA4, 'PaperUnits', 'inches');
set(fA4, 'Units','inches');
set(fA4, 'PaperSize', figSize);
set(fA4, 'PaperPositionMode', 'auto');
set(fA4, 'Position', [0 0 figSize(1) figSize(2)])

shockNames = {'FU', 'EBP', 'MU', 'Demand', 'Supply', 'Monetary', 'Financial'};
varNames = {'Uf', 'EBP', 'Um', 'EMP', 'Prices', 'FFR', 'S&P500'};

count  = 1;

for jj = 1:2 % Shocks: 1 = FU, 2 = EBP
    
    for ii = 1:n % Variables: n = 7
        
        percentiles_EMP = prctile(squeeze(Draws_IRFs_narrative(ii,jj,1:hmaxtoplot+1,:)),bands,2);

        subplot(2,n,count)        
        plotConfidenceBandsBlue(0:hmaxtoplot,percentiles_EMP,'r'); 
        hold on
        plot(0:hmaxtoplot,percentiles_EMP(:,2),'r','LineWidth',2.5);
        hold on
        plot(0:hmaxtoplot,zeros(hmaxtoplot+1,1),'-.k','LineWidth',0.75)      
        xmin=0;
        xmax=hmaxtoplot;
        xlim([xmin,xmax])
        set(gca, 'FontName', 'Times New Roman');
        set(gca, 'FontSize', 10);
        % set(gca, 'FontWeight', 'Bold');
        set(gca,'XTick',[0:round(hmaxtoplot/5):hmaxtoplot]')
        set(gca,'XTickLabel',num2str([0:round(hmaxtoplot/5):hmaxtoplot]'))
        box on
        title(strcat(varNames(ii),{' '},'to',{' '},shockNames(jj),' Shock'))
        set(gca,'Layer','top')
        
        if count > 7
            xlabel('Months')
        end
        
        count  = count+1;
        
    end
    
end
tightfig;
