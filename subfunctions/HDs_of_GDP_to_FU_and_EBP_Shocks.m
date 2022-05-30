%%% HDs of GDP to FU and EBP Shocks %%% 

startDate = [datenum(2007,10,01)];
endDate = [datenum(2009,10,01)];
numticks = 3;

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
Draws_HDs_narrative(:,:,draw) = squeeze(stochasticComponents(4,1:end,:)); % stochasticComponents: variable (4 = GDP), time, shock
end

total = mean(squeeze(sum(Draws_HDs_narrative,2)),2); % Unexpected total change in GDP (i.e., GDP total variation)

HDs_percentiles_narrative = zeros(Ta-p+1,n,3); % Initialisation: time,shock,bands
for jj = 1:n
    HDs_percentiles_narrative(:,jj,:) = prctile(squeeze(Draws_HDs_narrative(1:end,jj,:)),bands,2);
end

% Median HDs of GDP to FU and EBP Shocks
HD_FU = squeeze(HDs_percentiles_narrative(:,1,2)); % FU shock
HD_EBP = squeeze(HDs_percentiles_narrative(:,2,2)); % EBP shocks

f = figure;
clf
figSize = [5 7];
set(f, 'PaperUnits', 'inches');
set(f, 'Units','inches');
set(f, 'PaperSize', figSize);
set(f, 'PaperPositionMode', 'auto');
set(f, 'Position', [0 0 figSize(1) figSize(2)])
ti = get(gca,'TightInset');
set(gca,'Position',[1.1*ti(1) 1.1*ti(2) 0.99*(1-ti(3)-ti(1)) 0.99*(1-ti(4)-ti(2))]);


for jj = 1:2 % Shocks: 1 = FU, 2 = EBP.
  
    subplot(2,1,jj)
    
    percentiles3 = prctile(squeeze(Draws_HDs_narrative(1:end,jj,:)),bands,2);
    plotConfidenceBandsBlue(dates(idxStart-1:idxEnd),percentiles3,'r');
    hold on
    P2 = plot(dates(idxStart-1:idxEnd),percentiles3(:,2),'r','linewidth',2.5);
    hold on
    P3 = plot(dates(idxStart-1:idxEnd),total(1:end),'-.k','linewidth',2.5);
    plot(dates(idxStart-1:idxEnd),zeros(Ta-p+1,1),'--k','linewidth',0.75)    
    hold off   
    title(strcat(shockNames(jj),{' '},'Shock'))  
    ax = gca;
    set(ax,'XTick',dates(idxStart-1:numticks:end))
    ax.XTickLabel = {datestr(dates(idxStart-1:numticks:end),'mmm-yy')};   
    xlim([dates(idxStart-1), dates(idxEnd)])
    box on    
    set(gca, 'FontName', 'Times New Roman');
    set(gca, 'FontSize', 12);
    set(gca,'Layer','top')
end
tightfig;
legend([P2,P3],'HD of GDP','Total Variation')





