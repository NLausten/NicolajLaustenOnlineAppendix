
%% HD with Bands PointWise

% Fit with p (first month + 6)
startDate = [datenum(1961,01,01)];
endDate = [datenum(2020,01,01)];
numticks = 60;
bands  = [16,50,84]; % Percentiles for credible sets

tXX = datetime(1960,12:721,1);
dates1 = datenum(tXX)';
datetime(dates1, 'ConvertFrom', 'datenum', 'Format', 'dd-MM-yyyy');

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

t1XX = find(ismember(dates1,t1X));
t2XX = find(ismember(dates1,t2X));
GR1 = [t1XX:t2XX];
GR2 = [t1XX-1:t2XX];

% 2000s Recession

t1X = [datenum(2001,3,01)];
t2X = [datenum(2001,11,01)]; 

t1XX = find(ismember(dates1,t1X));
t2XX = find(ismember(dates1,t2X));

BM1 = [t1XX:t2XX];

% 70s Recession

t1X = [datenum(1973,11,01)];
t2X = [datenum(1975,03,01)]; 

t1XX = find(ismember(dates1,t1X));
t2XX = find(ismember(dates1,t2X));

BW1 = [t1XX:t2XX];


EVENT = cell(2,1);
EVENT{1} = BW1;
%EVENT{2} = BM1;
EVENT{2} = GR1;
Event_names = {'1970s Recession','The Great Recession'};


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

for jj = 1:size(EVENT,1)
    
    subplot(2,1,jj)
    
    hold on
    plot(dates1(EVENT{jj}),HD_FU(EVENT{jj}),'-','color',[0.9020 0.1176 0.1176]) %FU
    plot(dates1(EVENT{jj}),HD_MU(EVENT{jj}),'-','color',[0.0353 0.4627 0.8392]) %MU
    plot(dates1(EVENT{jj}),HD_Y(EVENT{jj}),'-','color',[0.0392 0.6784 0.1686]) %Y
        plot(dates1(EVENT{jj}),HD_MU(EVENT{jj})+HD_FU(EVENT{jj}),'-','color',[0.7137 0.0549 0.7608]) % Both Unc

    plot(dates1(EVENT{jj}),total(EVENT{jj}),'-k','linewidth',2); % Total
    hold off
    title(strcat(Event_names(jj))) 
    ax = gca;
    set(ax,'XTick',dates1(EVENT{jj}(1):1:EVENT{jj}(end)))
    ax.XTickLabel = {datestr(dates1(EVENT{jj}:1:EVENT{jj}(end)),'mmm-yy')};   
    xlim([dates1(EVENT{jj}(1)), dates1(EVENT{jj}(end))])
    ylim([-22 7])
    box on
    grid on
    set(gca, 'FontName', 'Times New Roman');
    set(gca, 'FontSize', 12);
    set(gca,'Layer','top')
    hline(0,'-k');
    
end
tightfig;
lgd = legend({'FU shock','MU shock','Productivity shock','FU + MU shocks','Real Activity'}, 'Location','southwest');
lgd.NumColumns = 2;
lgd.FontSize = 6;

fname = strcat('results/HDsUS.eps');
print('-depsc', f1, fname); 
