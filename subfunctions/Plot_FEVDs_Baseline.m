%% Forecast Error Variance Decompositions With Bands
hmaxtoplot = 60; % 5 yrs ahead for graph
% hmaxtoplot = 24; % 2 yrs ahead for table

Draws_FEVDs_narrative = nan(n,n,hmaxtoplot+1,numSavedNarrative); % variable,shock,horizon,draw

parfor draw = 1:numSavedNarrative
    
    IRFs = getIRFs(Beta_narrative(:,:,draw),A0_narrative(:,:,draw),exog,n,p,hmax);
    Draws_FEVDs_narrative(:,:,:,draw) = varianceDecompositionOfVAR(IRFs,hmaxtoplot);
    
end


bands  = [16,50,84];

f = figure;
clf
figSize = [10 6];
set(f, 'PaperUnits', 'inches');
set(f, 'Units','inches');
set(f, 'PaperSize', figSize);
set(f, 'PaperPositionMode', 'auto');
set(f, 'Position', [0 0 figSize(1) figSize(2)])
ti = get(gca,'TightInset');
set(gca,'Position',[1.1*ti(1) 1.1*ti(2) 0.99*(1-ti(3)-ti(1)) 0.99*(1-ti(4)-ti(2))]);

C={[0.98 0.2 0.2],[0.8 0.8 0.8],[0.8 0.8 0.8] [0.8 0.8 0.8] [0.8 0.8 0.8] [0.8 0.8 0.8]}; % make a colors list 

count = 1;

 for jj = 1:n  % Shock 
    
    for ii = 1:n  % Variable
        % ii = 4; % GDP
        
     subplot(n,n,count)
       
    FEVD_percentiles_narrative = prctile(squeeze(Draws_FEVDs_narrative(ii,jj,1:end,:)),bands,2);
    
    % plotConfidenceBandsBlue([0:10],FEVD_percentiles_baseline,'b');
    hold on
    plotConfidenceBandsBlue([0:hmaxtoplot],FEVD_percentiles_narrative,'r');
%     hold on    

    %xlim([0, 4])
    ylim([0, 1])   
    
    if count > 6
        xlabel('Years')
    end
    
    if count == 1 || 4 || 7
    ylabel(strcat(shockNames(jj)))
    end
    
    %if count == 8
    %ylabel(strcat(shockNames(jj),{' '},'Shock'))
    %end
    
    set(gca,'Layer','top')
    set(gca, 'FontName', 'Times New Roman');
    set(gca, 'FontSize', 7);
    set(gca, 'FontWeight', 'Bold');
    set(gca,'XTick',[0:12:hmaxtoplot]')
%     set(gca,'YTick',[0:0.1:0.6]')    
    set(gca,'XTickLabel',num2str((1/12).*[0:12:hmaxtoplot]'))    
    box on
    title(strcat(varNames(ii)))  
   count = count+1;
    
    end
    
end
tightfig;

%fname = strcat('results/FEVD_US.eps');
%print('-dpdf', f, fname); 