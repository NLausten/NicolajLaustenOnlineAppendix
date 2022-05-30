% Plot FEVD

XX = cat(4,FEVD_Uf,FEVD_Um,FEVD_GDP);
hmaxtoplot=36;

f2 = figure;
% f2 = figure('WindowState','maximized');
clf
figSize = [12 6];
set(f2, 'PaperUnits', 'inches');
set(f2, 'Units','inches');
set(f2, 'PaperSize', figSize);
set(f2, 'PaperPositionMode', 'auto');
set(f2, 'Position', [0 0 figSize(1) figSize(2)])

shockNames = {'Financial Uncertainty Shock','Macro Uncertainty Shock','Industrial Production Shock'}; % Only FU and EBP
% shocks are identified
varNames = {'Financial Uncertainty','Macro Uncertainty' 'Industrial Production'};

count  = 1;

for jj = 1:3 % Shocks: 1 = FU, 2 = MU, 3=Y
    
    for ii = 1:n % Variables: n = 3
        
        
        percentiles = XX(jj,:,:,ii);
        percentiles = squeeze(percentiles);

        subplot(3,n,count)        
        plotConfidenceBandsBlue(0:hmaxtoplot,percentiles,'r'); 
        hold on
        plot(0:hmaxtoplot,percentiles(:,2),'r','LineWidth',2.5);
        hold on
        xmin=0;
        xmax=hmaxtoplot;
        xlim([xmin,xmax])
        ylim([0 1])
        set(gca, 'FontName', 'Times New Roman');
        set(gca, 'FontSize', 10);
        set(gca,'XTick',[0:round(hmaxtoplot/5):hmaxtoplot]')
        set(gca,'XTickLabel',num2str([0:round(hmaxtoplot/5):hmaxtoplot]'))
        box on
        ylabel(strcat(varNames(ii)))
        title('Contribution of',strcat(varNames(jj)))
        set(gca,'Layer','top')
        
        if count > 6
            xlabel('Months')
        end
        
        count  = count+1;
        
    end
    
end
tightfig;

fname = strcat('results/FEVD_1.eps');
print('-depsc', f2, fname); 

