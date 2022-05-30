%%%%%%%%% CCDK FIGURES AND TABLES %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all
clc

addpath('functions')

load RESULTS_Baseline 

%%% Figure 2: Baseline: All IRFs to FU and EBP shocks %%%
Plot_All_IRFs_to_FU_and_EBP_Shocks

%%% Figure 4: IRFs of GDP to FU shock: Factual versus Counterfactuals %%%
Plot_fctl_and_ctf_IRFs_of_GDP_to_FU_shock

%%% Table 3 (Real GDP, Row 1): Estimates of the Baseline FUM (sum and peak) over a 2-year horizon %%%
FUM_Estimates_Sum_and_Peak

%%% Table 2: Baseline FEVDs of all 7 variables to Uf and EBP shocks at selected (including 
% the 2-year horizon results reported in table 2) %%%
FEVDs_of_All_Variables_to_FU_and_EBP_Shocks

clear


[data, labels] = xlsread('ebp_vxo_jan2021','ccdk');
ebp = data(:,2); % ebpstd = (ebp-mean(ebp))/std(ebp);
vxo = data(157:end,4); vxostd = [nan(156,1); (vxo-mean(vxo))/std(vxo)]*std(ebp)+mean(ebp);
lmn = data(1:end-6,5); lmnstd = [(lmn-mean(lmn))/std(lmn); nan(6,1)]*std(vxo)+mean(vxo);
vxo = [nan(156,1); vxo];

%%%% Figures 1 %%%%
f1 = figure;
clf
figSize = [12 6];
set(f1, 'PaperUnits', 'inches');
set(f1, 'Units','inches');
set(f1, 'PaperSize', figSize);
set(f1, 'PaperPositionMode', 'auto');
set(f1, 'Position', [0 0 figSize(1) figSize(2)])
T = size(data,1);
xxx = [1:T];
matT=[85:120:T];
matTx={'1980';'1990';'2000';'2010';'2020'};
subplot(2,1,1), plot(xxx,ebp,'g-.',xxx,vxostd,'b-','Linewidth',3); 
legend('EBP','VXO'); set(gca,'XTick',matT); set(gca,'XTickLabel',matTx); set(gca,'FontSize',14); 
axis([1 T+12 -1 4]); vline([178 429 567],'k-'); hline(0,'k-');
text(180,3.6,'Black Monday','FontSize',14);
text(380,3.6,'Great Recession','FontSize',14);
text(515,3.6,'COVID-19','FontSize',14);
hold on; 
xxxalt = [-6:6];
subplot(2,3,4); plot(xxxalt,ebp(172:184),'g-.',xxxalt,vxostd(172:184),'b-','Linewidth',3); 
legend('EBP','VXO'); title('Black Monday'); set(gca,'FontSize',14); axis([-6 6 -1 4]); vline(0,'k-'); hline(0,'k-');
subplot(2,3,5); plot(xxxalt,ebp(423:435),'g-.',xxxalt,vxostd(423:435),'b-','Linewidth',3); 
legend('EBP','VXO'); title('Great Recession'); set(gca,'FontSize',14); axis([-6 6 -1 4]); vline(0,'k-'); hline(0,'k-');
subplot(2,3,6); plot(xxxalt,ebp(561:573),'g-.',xxxalt,vxostd(561:573),'b-','Linewidth',3); 
legend('EBP','VXO'); title('COVID-19'); set(gca,'FontSize',14); axis([-6 6 -1 4]); vline(0,'k-'); hline(0,'k-');

%%%% Figures A1 %%%%
fA1 = figure;
clf
figSize = [12 6];
set(fA1, 'PaperUnits', 'inches');
set(fA1, 'Units','inches');
set(fA1, 'PaperSize', figSize);
set(fA1, 'PaperPositionMode', 'auto');
set(fA1, 'Position', [0 0 figSize(1) figSize(2)])
plot(xxx,lmnstd,'b-',xxx,vxo,'g--','Linewidth',3); 
legend('LMN','VXO'); set(gca,'XTick',matT); set(gca,'XTickLabel',matTx); set(gca,'FontSize',14); 
axis([1 T+12 0 70]); hline(0,'k-');

%%%% Figures 3 %%%%
[data2, labels] = xlsread('HD_realGDP','HD');
GRperiod = [416-1:434-1]; % 2007M12-2009M6 as per NBER, -1 to account for excel file's row # 1 = labels
TT = size(GRperiod,2);
zzz = [1:TT];
matT=[1:6:TT];
matTx={'Dec. 2007';'June 2008';'Dec. 2008';'June 2009'};
f3 = figure;
clf
figSize = [12 6];
set(f3, 'PaperUnits', 'inches');
set(f3, 'Units','inches');
set(f3, 'PaperSize', figSize);
set(f3, 'PaperPositionMode', 'auto');
set(f3, 'Position', [0 0 figSize(1) figSize(2)])
plot(zzz,data2(GRperiod,1),'b-.',zzz,data2(GRperiod,2),'g--',zzz,data2(GRperiod,1)+data2(GRperiod,2),'rd-',zzz,data2(GRperiod,3),'k-','Linewidth',3); 
legend('FU shock','EBP shock','FU + EBP shocks','Real GDP'); set(gca,'XTick',matT); set(gca,'XTickLabel',matTx); set(gca,'FontSize',14); 
axis([1 size(GRperiod,2) -5 5]); hline(0,'k-');

clear


%%%!!! B. Robustness Checks !!!%%%

%%% Industrial Production (IP) as a proxy for GDP %%%

load RESULTS_IP_Robustness

%%% Table 3 (Industrial Production, Row 2) : Estimates of the FUM (sum and peak) over a 2-year horizon %%%
FUM_Estimates_Sum_and_Peak_IP_Robustness

%%%% Figures A2 %%%%
Plot_All_IRFs_to_FU_and_EBP_Shocks_IP_Robustness

%%%% Figures A3 %%%%
Plot_fctl_and_ctf_IRFs_of_IP_to_FU_shock

clear


%%% Employment (EMP) as a proxy for GDP %%%

load RESULTS_EMP_Robustness

%%% Table 3 (Employment, Row 3) : Estimates of the FUM (sum and peak) over a 2-year horizon %%%
FUM_Estimates_Sum_and_Peak_EMP_Robustness

%%%% Figures A4 %%%%
Plot_All_IRFs_to_FU_and_EBP_Shocks_EMP_Robustness

%%%% Figures A5 %%%%
Plot_fctl_and_ctf_IRFs_of_EMP_to_FU_shock

