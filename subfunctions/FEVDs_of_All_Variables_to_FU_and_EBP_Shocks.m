hmaxtoplot2 = 36; % 3 yrs ahead
bands  = [16,50,84];

Draws_FEVDs_narrative = nan(n,n,hmaxtoplot2+1,numSavedNarrative); % Initialisation: variable,shock,horizon,draw

parfor draw = 1:numSavedNarrative
    
    IRFs = getIRFs(Beta_narrative(:,:,draw),A0_narrative(:,:,draw),exog,n,p,hmax);
    Draws_FEVDs_narrative(:,:,:,draw) = varianceDecompositionOfVAR(IRFs,hmaxtoplot2);
    
end

% Compute FEVDs of all 7 endogenous variables to FU and EBP shocks over a 2-year horizon:
FEVD_percentiles_narrative = zeros(n,2,hmaxtoplot2+1,3); % Initialisation: variable,shock,horizon,bands
for jj = 1:n  % Shock   
    for ii = 1:n  % Variable     
        FEVD_percentiles_narrative(ii,jj,:,:) = prctile(squeeze(Draws_FEVDs_narrative(ii,jj,1:end,:)),bands,2);         
    end   
end


%%% Table Construction for all 7 endogenous variables to FU and EBP shocks over a 2-year horizon %%%

%% 1. Data Arrangements before constructing table:

% FEVDs for each of the 7 variables to FU and EBP shocks over selected horizons:
FEVD_Uf = squeeze(FEVD_percentiles_narrative(1,:,1:end,:));
FEVD_Um = squeeze(FEVD_percentiles_narrative(2,:,1:end,:));
FEVD_GDP = squeeze(FEVD_percentiles_narrative(3,:,1:end,:));
%FEVD_EBP = squeeze(FEVD_percentiles_narrative(2,:,1:4:end,:));
%FEVD_Prices = squeeze(FEVD_percentiles_narrative(5,:,1:4:end,:));
%FEVD_FFR = squeeze(FEVD_percentiles_narrative(6,:,1:4:end,:));
%FEVD_SP500 = squeeze(FEVD_percentiles_narrative(7,:,1:4:end,:));

% FEVDs for each of the 7 variables to FU shock only over same selected horizons:
FEVD_Uf1 = squeeze(FEVD_Uf(1,:,:)); 
FEVD_Um1 = squeeze(FEVD_Um(1,:,:));
FEVD_GDP1 = squeeze(FEVD_GDP(1,:,:));
%FEVD_EBP1 = squeeze(FEVD_EBP(1,:,:));
%FEVD_Prices1 = squeeze(FEVD_Prices(1,:,:));
%FEVD_FFR1 = squeeze(FEVD_FFR(1,:,:));
%FEVD_SP5001 = squeeze(FEVD_SP500(1,:,:));

% FEVDs for each of the 7 variables to MU shock only over same selected horizons:
FEVD_Uf2 = squeeze(FEVD_Uf(2,:,:)); 
FEVD_Um2 = squeeze(FEVD_Um(2,:,:));
FEVD_GDP2 = squeeze(FEVD_GDP(2,:,:));
%FEVD_EBP2 = squeeze(FEVD_EBP(2,:,:));
%FEVD_Prices2 = squeeze(FEVD_Prices(2,:,:));
%FEVD_FFR2 = squeeze(FEVD_FFR(2,:,:));
%FEVD_SP5002 = squeeze(FEVD_SP500(2,:,:));

% FEVDs for each of the 7 variables to Y shock only over same selected horizons:
FEVD_Uf3 = squeeze(FEVD_Uf(3,:,:)); 
FEVD_Um3 = squeeze(FEVD_Um(3,:,:));
FEVD_GDP3 = squeeze(FEVD_GDP(3,:,:));

% Selected horizons labels:
%Horizon = [0; 4; 8; 12; 16; 20; 24];
Horizon1 = [0:hmaxtoplot2]';

%% 2. Table construction:

Tab1 = table(Horizon1,FEVD_Uf1,FEVD_Uf2,FEVD_Uf3,'VariableNames', {'Horizons','16th-50th-84th Prctles FEVDs of Uf to FU Shock','16th-50th-84th Prctles FEVDs of Uf to MU Shock','16th-50th-84th Prctles FEVDs of Uf to Y Shock'});
Tab2 = table(Horizon1,FEVD_Um1,FEVD_Um2,FEVD_Um3,'VariableNames', {'Horizons','16th-50th-84th Prctles FEVDs of Um to FU Shock','16th-50th-84th Prctles FEVDs of Um to MU Shock','16th-50th-84th Prctles FEVDs of Uf to Y Shock'});
Tab3 = table(Horizon1,FEVD_GDP1,FEVD_GDP2,FEVD_GDP3,'VariableNames', {'Horizons','16th-50th-84th Prctles FEVDs of Y to FU Shock','16th-50th-84th Prctles FEVDs of Y to MU Shock','16th-50th-84th Prctles FEVDs of Uf to Y Shock'});
%Tab4 = table(Horizon,FEVD_EBP1,FEVD_EBP2,'VariableNames', {'Horizons','16th-50th-84th Prctles FEVDs of EBP to FU Shock','16th-50th-84th Prctles FEVDs of EBP to EBP Shock'});
%Tab5 = table(Horizon,FEVD_Prices1,FEVD_Prices2,'VariableNames', {'Horizons','16th-50th-84th Prctles FEVDs of Prices to FU Shock','16th-50th-84th Prctles FEVDs of Prices to EBP Shock'});
%Tab6 = table(Horizon,FEVD_FFR1,FEVD_FFR2,'VariableNames', {'Horizons','16th-50th-84th Prctles FEVDs of FFR to FU Shock','16th-50th-84th Prctles FEVDs of FFR to EBP Shock'});
%Tab7 = table(Horizon,FEVD_SP5001,FEVD_SP5002,'VariableNames', {'Horizons','16th-50th-84th Prctles FEVDs of S&P500 to FU Shock','16th-50th-84th Prctles FEVDs of S&P500 to EBP Shock'});