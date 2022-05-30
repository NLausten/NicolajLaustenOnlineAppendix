
%% HD with Bands PointWise
startDate = [datenum(2007,6,01)];
endDate = [datenum(2009,6,01)];
numticks = 60;
bands  = [16,50,84]; % Percentiles for credible sets


idxStart=find(ismember(dates,startDate));
idxEnd=find(ismember(dates,endDate));

Ytemp = y(idxStart-p:idxEnd,:);
Ta = length(Ytemp);
exoga = ones(Ta,1);

draws_HDs_narrative = nan(Ta-p+1,n,numSavedNarrative); % draws_HDs_narrative is a 561 by 7 by 1548 matrix   

parfor draw = 1:numSavedNarrative

A0 = A0_narrative(:,:,draw);
phi = Beta_narrative(constant+1:end,:,draw)';
delta = Beta_narrative(1,:,draw)';    

[~,~,dc,~,stochasticComponents] = Get_SVAR_results(Ytemp,exoga,A0,delta(1:n),phi,p,h);
draws_HDs_narrative(:,:,draw) = squeeze(stochasticComponents(3,1:end,:));% stochasticComponents: variable (4 = GDP), time, shocks
end

total = mean(squeeze(sum(draws_HDs_narrative,2)),2); % Unexpected total change in GDP

HDs_percentiles_narrative = zeros(Ta-p+1,n,3); % Initialisation: time,shock,bands
for jj = 1:n
    HDs_percentiles_narrative(:,jj,:) = prctile(squeeze(draws_HDs_narrative(1:end,jj,:)),bands,2);
end

% Median HDs of GDP to FU and EBP Shocks
HD_FU = squeeze(HDs_percentiles_narrative(:,1,2)); % FU shock
HD_MU = squeeze(HDs_percentiles_narrative(:,2,2)); % EBP shocks
HD_Y = squeeze(HDs_percentiles_narrative(:,3,2)); % EBP shocks

% Periods
% Great Recession
t1X = [datenum(2007,12,01)];
t2X = [datenum(2009,06,01)]; 

t1X = find(ismember(dates,t1X));
t2X = find(ismember(dates,t2X));
GR1 = [t1X:t2X];
GR2 = [t1X-6:t2X-6];



%plot
f1 = figure;
clf
figSize = [5 7];
set(f1, 'PaperUnits', 'inches');
set(f1, 'Units','inches');
set(f1, 'PaperSize', figSize);
set(f1, 'PaperPositionMode', 'auto');
set(f1, 'Position', [0 0 figSize(1) figSize(2)])
ti = get(gca,'TightInset');
set(gca,'Position',[1.1*ti(1) 1.1*ti(2) 0.99*(1-ti(3)-ti(1)) 0.99*(1-ti(4)-ti(2))]);


    hold on
    plot(dates(idxStart-1:idxEnd),HD_FU(1:end),'--r') %FU
    plot(dates(idxStart-1:idxEnd),HD_MU(1:end),'--b') %MU
    plot(dates(idxStart-1:idxEnd),HD_MU(1:end)+HD_FU(1:end),'--g') % Both
    plot(dates(idxStart-1:idxEnd),total(1:end),'.-k','linewidth',3); % Total

    hold off   
    ax = gca;
    set(ax,'XTick',dates(idxStart-1:3:idxEnd))
    ax.XTickLabel = {datestr(dates(idxStart-1:3:idxEnd),'mmm-yy')};   
    xlim([dates(idxStart-1), dates(idxEnd)])
    box on
    legend('FU shock','MU shock','FU + MU shocks','Real Activity');
    set(gca, 'FontName', 'Times New Roman');
    set(gca, 'FontSize', 12);
    set(gca,'Layer','top')
    hline(0,'-k');
 