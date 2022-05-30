% HDs_EU 3

startDate = [datenum(1999,1+p,01)];
endDate = [datenum(2020,2,01)];
numticks = 48;

idxStart=find(ismember(dates,startDate));
idxEnd=find(ismember(dates,endDate));

Ytemp = y(idxStart-p:idxEnd,:);
Ta = length(Ytemp);
exoga = ones(Ta,1);

Draws_HDs_narrative = nan(Ta-p+1,n,numSavedNarrative); % time, shock, draw

parfor draw = 1:numSavedNarrative
 
% disp(draw)
A0 = A0_narrative(:,:,draw);
phi = Beta_narrative(constant+1:end,:,draw)';
delta = Beta_narrative(1,:,draw)';    

[~,~,dc,~,stochasticComponents] = Get_SVAR_results(Ytemp,exoga,A0,delta(1:n),phi,p,h);
Draws_HDs_narrative(:,:,draw) = squeeze(stochasticComponents(4,1:end,:)); % stochasticComponents: variable (1 = U), time, shock
end

total = mean(squeeze(sum(Draws_HDs_narrative,2)),2); % Unexpected total change in GDP (i.e., GDP total variation)

HDs_percentiles_narrative = zeros(Ta-p+1,n,3); % Initialisation: time,shock,bands
for jj = 1:n
    HDs_percentiles_narrative(:,jj,:) = prctile(squeeze(Draws_HDs_narrative(1:end,jj,:)),bands,2);
end


f = figure;
clf
figSize = [10 10];
set(f, 'PaperUnits', 'inches');
set(f, 'Units','inches');
set(f, 'PaperSize', figSize);
set(f, 'PaperPositionMode', 'auto');
set(f, 'Position', [0 0 figSize(1) figSize(2)])
ti = get(gca,'TightInset');
set(gca,'Position',[1.1*ti(1) 1.1*ti(2) 0.99*(1-ti(3)-ti(1)) 0.99*(1-ti(4)-ti(2))]);

varNames1 = {'Fin Uncertainty','Mac Uncertainty','Credit Spread','Industrial Production','CPI','Policy Rate','Unemployment','Equity Prices'};
shockNames1 = {'Financial Uncertainty','Macro Uncertainty','Credit Spread'};

count = 1;

for jj=1:3
    subplot(3,1,count);

    percentiles3 = prctile(squeeze(Draws_HDs_narrative(1:end,jj,:)),bands,2);
    if jj ~= 3 
        plotConfidenceBandsBlue(dates(idxStart-1:idxEnd),percentiles3,[57 106 177]./255);
    end
    
    if jj == 3
       plotConfidenceBandsBlue(dates(idxStart-1:idxEnd),percentiles3,'r');
    end
    
    hold on
        
    if jj ~= 3 
    P2 = plot(dates(idxStart-1:idxEnd),percentiles3(:,2),'Color',[57 106 177]./255,'linewidth',2);
    else
    P2 = plot(dates(idxStart-1:idxEnd),percentiles3(:,2),'Color',[204 37 41]./255,'linewidth',2);
    end
    
    
    hold on
    P3 = plot(dates(idxStart-1:idxEnd),total(1:end),'-k','linewidth',1.5);
    plot(dates(idxStart-1:idxEnd),zeros(Ta-p+1,1),'--k','linewidth',0.75)    
    hold off   
    title(strcat(shockNames1(jj),{' '},'Shock'))  
    ax = gca;
    set(ax,'XTick',dates(idxStart-1:numticks:idxEnd))
    ax.XTickLabel = {datestr(dates(idxStart-1:numticks:idxEnd),'yyyy')};   
    xlim([dates(idxStart-1), dates(idxEnd)])
    box off
    set(gca, 'FontName', 'Times New Roman');
    %legend([P2,P4,P3],'Contribution of Uncertainty shock','Contribution of Credit Spread Shock','Total variation');
    set(gca, 'FontSize', 12);
    set(gca,'Layer','top')
    set(gca,'YGrid','on','YTick',-30:5:10)
    
    count = count + 1;
    
end     

%fname = strcat('results/HD_EU3.eps');
%print('-depsc', f, fname);