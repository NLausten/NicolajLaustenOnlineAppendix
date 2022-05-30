% FEVD EU

hmaxtoplot2 = 36; % 3 yrs ahead
bands  = [16,50,84];

Draws_FEVDs_narrative = nan(n,n,hmaxtoplot2+1,numSavedNarrative); % Initialisation: variable,shock,horizon,draw

parfor draw = 1:numSavedNarrative
    
    IRFs = getIRFs(Beta_narrative(:,:,draw),A0_narrative(:,:,draw),exog,n,p,hmax);
    Draws_FEVDs_narrative(:,:,:,draw) = varianceDecompositionOfVAR(IRFs,hmaxtoplot2);
    
end

% Compute FEVDs of all 7 endogenous variables to FU and EBP shocks over a 2-year horizon:
FEVD_percentiles_narrative = zeros(n,2,hmaxtoplot2+1,3); % Initialisation: variable,shock,horizon,bands
for jj = 1:4  % Shock   
    for ii = 1:n  % Variable     
        FEVD_percentiles_narrative(ii,jj,:,:) = prctile(squeeze(Draws_FEVDs_narrative(ii,jj,1:end,:)),bands,2);         
    end   
end


%%% Table Construction for all 7 endogenous variables to FU and EBP shocks over a 2-year horizon %%%

%% 1. Data Arrangements before constructing table:

% FEVDs for each of the 7 variables to FU and EBP shocks over selected horizons:
FEVD_UF = squeeze(FEVD_percentiles_narrative(1,:,[2 13 37],:));
FEVD_CS = squeeze(FEVD_percentiles_narrative(2,:,[2 13 37],:));
FEVD_GDP = squeeze(FEVD_percentiles_narrative(3,:,[2 13 37],:));
FEVD_Prices = squeeze(FEVD_percentiles_narrative(4,:,[2 13 37],:));
FEVD_FFR = squeeze(FEVD_percentiles_narrative(5,:,[2 13 37],:));
FEVD_UNRATE = squeeze(FEVD_percentiles_narrative(6,:,[2 13 37],:));
FEVD_STOCK = squeeze(FEVD_percentiles_narrative(7,:,[2 13 37],:));


% FEVDs for each of the 7 variables to Financial Uncertainty shock only over same selected horizons:
FEVD_UF1 = squeeze(FEVD_UF(1,:,:));
FEVD_CS1 = squeeze(FEVD_CS(1,:,:));
FEVD_GDP1 = squeeze(FEVD_GDP(1,:,:));
FEVD_Prices1 = squeeze(FEVD_Prices(1,:,:));
FEVD_FFR1 = squeeze(FEVD_FFR(1,:,:));
FEVD_UNRATE1 = squeeze(FEVD_UNRATE(1,:,:));
FEVD_STOCK1 = squeeze(FEVD_STOCK(1,:,:));

% FEVDs for each of the 7 variables to Macro Uncertainty shock only over same selected horizons:
FEVD_UF2 = squeeze(FEVD_UF(2,:,:)); 
FEVD_CS2 = squeeze(FEVD_CS(2,:,:));
FEVD_GDP2 = squeeze(FEVD_GDP(2,:,:));
FEVD_Prices2 = squeeze(FEVD_Prices(2,:,:));
FEVD_FFR2 = squeeze(FEVD_FFR(2,:,:));
FEVD_UNRATE2 = squeeze(FEVD_UNRATE(2,:,:));
FEVD_STOCK2 = squeeze(FEVD_STOCK(2,:,:));


% Selected horizons labels:
Horizon = [0; 12; 36];
Horizon1 = [0:hmaxtoplot2]';

%% 2. Table construction:

%Tab1 = table(Horizon,FEVD_U1,FEVD_U2,'VariableNames', {'Horizons','16th-50th-84th Prctles FEVDs of U to U Shock','16th-50th-84th Prctles FEVDs of U to CS Shock'});
%Tab2 = table(Horizon,FEVD_CS1,FEVD_CS2,'VariableNames', {'Horizons','16th-50th-84th Prctles FEVDs of CS to U Shock','16th-50th-84th Prctles FEVDs of CS to CS Shock'});
%Tab3 = table(Horizon,FEVD_GDP1,FEVD_GDP2,'VariableNames', {'Horizons','16th-50th-84th Prctles FEVDs of Y to U Shock','16th-50th-84th Prctles FEVDs of Y to CS Shock'});
%Tab4 = table(Horizon,FEVD_Prices1,FEVD_Prices2,'VariableNames', {'Horizons','16th-50th-84th Prctles FEVDs of Prices to U Shock','16th-50th-84th Prctles FEVDs of Prices to CS Shock'});
%Tab5 = table(Horizon,FEVD_FFR1,FEVD_FFR2,'VariableNames', {'Horizons','16th-50th-84th Prctles FEVDs of PRATE to U Shock','16th-50th-84th Prctles FEVDs of PRATE to CS Shock'});
%Tab6 = table(Horizon,FEVD_UNRATE1,FEVD_UNRATE2,'VariableNames', {'Horizons','16th-50th-84th Prctles FEVDs of UNRATE to U Shock','16th-50th-84th Prctles FEVDs of UNRATE to CS Shock'});
%Tab7 = table(Horizon,FEVD_STOCK1,FEVD_STOCK2,'VariableNames', {'Horizons','16th-50th-84th Prctles FEVDs of STOCK to U Shock','16th-50th-84th Prctles FEVDs of STOCK to CS Shock'});

%% 3. Tables for export 

% Table 1: Role of fin uncertainty shock over horizons (median)
EX_Tab1 = [FEVD_UF1(:,2) FEVD_CS1(:,2) FEVD_GDP1(:,2) FEVD_Prices1(:,2) FEVD_FFR1(:,2) FEVD_UNRATE1(:,2) FEVD_STOCK1(:,2)];
EX_Tab1 = round(EX_Tab1,2);
% Table 2: Bounds (fin Uncertainty shock)
EX_Tab2 = [FEVD_UF1(:,[1,3]) FEVD_CS1(:,[1,3]) FEVD_GDP1(:,[1,3]) FEVD_Prices1(:,[1,3]) FEVD_FFR1(:,[1,3]) FEVD_UNRATE1(:,[1,3]) FEVD_STOCK1(:,[1,3])];
EX_Tab2 = round(EX_Tab2,2);
% Table 3: Median CS shock
EX_Tab3 = [FEVD_UF2(:,2) FEVD_CS2(:,2) FEVD_GDP2(:,2) FEVD_Prices2(:,2) FEVD_FFR2(:,2) FEVD_UNRATE2(:,2) FEVD_STOCK2(:,2)];
EX_Tab3 = round(EX_Tab3,2);
% Table 4: Bounds (CS shock)
EX_Tab4 = [FEVD_UF2(:,[1,3]) FEVD_CS2(:,[1,3]) FEVD_GDP2(:,[1,3]) FEVD_Prices2(:,[1,3]) FEVD_FFR2(:,[1,3]) FEVD_UNRATE2(:,[1,3]) FEVD_STOCK2(:,[1,3])];
EX_Tab4 = round(EX_Tab4,2);