jj = 1; % FU shock
ii = 4; % GDP variable 

%%% FUM (min or peak) over a 2-year horizon
FUM_Min_fctl = min(squeeze(Draws_IRFs_narrative(ii,jj,1:24,:)));
FUM_Min_ctl = min(squeeze(Draws_IRFs_narrative_CTF(ii,jj,1:24,:)));
FUM_Min = FUM_Min_fctl./FUM_Min_ctl;

% Print FUM_Min
disp(strcat('16Prctle(FUM_Min_IP) Median(FUM_Min_IP) 84Prctle(FUM_Min_IP)'))
disp([prctile(FUM_Min,16), median(FUM_Min), prctile(FUM_Min,84)])

%%% FUM (sum) over a 2-year horizon
FUM_Sum_fctl = sum(squeeze(Draws_IRFs_narrative(ii,jj,1:24,:)));
FUM_Sum_ctl = sum(squeeze(Draws_IRFs_narrative_CTF(ii,jj,1:24,:)));
FUM_Sum = FUM_Sum_fctl./FUM_Sum_ctl;

% Print FUM_Sum
disp(strcat('16Prctle(FUM_Sum_IP) Median(FUM_Sum_IP) 84Prctle(FUM_Sum_IP)'))
disp([prctile(FUM_Sum,16), median(FUM_Sum), prctile(FUM_Sum,84)])
