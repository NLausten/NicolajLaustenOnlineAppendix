%%% HDs of GDP to U and CS shock EU %%% 

startDate = [datenum(1999,1+p,01)];
endDate = [datenum(2020,2,01)];
numticks = 36;
bands  = [16,50,84];

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
Draws_HDs_narrative(:,:,draw) = squeeze(stochasticComponents(7,1:end,:)); % stochasticComponents:
end
% 1.U, 2.CS, 3.Y, 4.CPI, 5.PRATE, 6.UNRATE, 7.STOXX

total = mean(squeeze(sum(Draws_HDs_narrative,2)),2); % Unexpected total change in GDP (i.e., GDP total variation)

HDs_percentiles_narrative = zeros(Ta-p+1,n,3); % Initialisation: time,shock,bands
for jj = 1:n
    HDs_percentiles_narrative(:,jj,:) = prctile(squeeze(Draws_HDs_narrative(1:end,jj,:)),bands,2);
end


f = figure; %('Position', [100, 100, 1024, 1200]);
clf
%figure1=figure('Position', [100, 100, 1024, 1200]);
figSize = [10 6];
set(f, 'PaperUnits', 'inches');
set(f, 'Units','inches');
set(f, 'PaperSize', figSize);
set(f, 'PaperPositionMode', 'auto');
set(f, 'Position', [0 0 figSize(1) figSize(2)])
ti = get(gca,'TightInset');
set(gca,'Position',[1.1*ti(1) 1.1*ti(2) 0.99*(1-ti(3)-ti(1)) 0.99*(1-ti(4)-ti(2))]);

varNames1 = {'Uncertainty','Credit Spread','Industrial Production'};
shockNames1 = {'Uncertainty','Credit Spread','Industrial Production'};

count = 1;

for jj=1:2
    subplot(3,1,count);

    percentiles3 = prctile(squeeze(Draws_HDs_narrative(1:end,jj,:)),bands,2);
    if (jj ~= 2)
        plotConfidenceBandsBlue(dates(idxStart-1:idxEnd),percentiles3,[57 106 177]./255);
    else 
        plotConfidenceBandsBlue(dates(idxStart-1:idxEnd),percentiles3,'r');
    end
    
    hold on
        
    if (jj ~= 2)
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
    set(ax,'XTick',dates([idxStart-1:numticks:idxEnd-32 254]))
    ax.XTickLabel = {datestr(dates([idxStart-1:numticks:idxEnd-32 254]),'yyyy')};   
    xlim([dates(idxStart-1), dates(idxEnd)])
    %ylim([-25 10])
    box off
    set(gca, 'FontName', 'Times New Roman');
    %legend([P2,P4,P3],'Contribution of Uncertainty shock','Contribution of Credit Spread Shock','Total variation');
    set(gca, 'FontSize', 12);
    set(gca,'Layer','top')
    set(gca,'YGrid','on')%,'YTick',-25:10:5)
    
    count = count + 1;
    
end     

subplot(3,1,count)
percentilesXX = nan(length(Ytemp(:,1))-p+1,3,2);
for ij = 1:2
percentilesXX(:,:,ij) = prctile(squeeze(Draws_HDs_narrative(1:end,ij,:)),bands,2);
end
percentilesYY = sum(percentilesXX,3);

 
 plotConfidenceBandsBlue(dates(idxStart-1:idxEnd),percentilesYY,[57 106 177]./255);
    
 
 hold on
 
    P2 = plot(dates(idxStart-1:idxEnd),percentilesYY(:,2),'Color',[57 106 177]./255,'linewidth',2);

   hold on
    P3 = plot(dates(idxStart-1:idxEnd),total(1:end),'-k','linewidth',1.5);
    plot(dates(idxStart-1:idxEnd),zeros(Ta-p+1,1),'--k','linewidth',0.75)    
    hold off   
    title(strcat('All Shocks'))  
    ax = gca;
    set(ax,'XTick',dates([idxStart-1:numticks:idxEnd-32 254]))
    ax.XTickLabel = {datestr(dates([idxStart-1:numticks:idxEnd-32 254]),'yyyy')};  
    xlim([dates(idxStart-1), dates(idxEnd)])
    %ylim([-25 10])
    box off
    set(gca, 'FontName', 'Times New Roman');
    %legend([P2,P4,P3],'Contribution of Uncertainty shock','Contribution of Credit Spread Shock','Total variation');
    set(gca, 'FontSize', 12);
    set(gca,'Layer','top')
    set(gca,'YGrid','on')%,'YTick',-25:10:5)
    
count = count + 1;

tightfig;

%fname = strcat('results/HD_EU1Astoxx.eps');
%print('-depsc', f, fname);