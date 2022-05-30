%%% MODEL 2 CODE %%%
% This Code Can Create the Results from Model 2. 

% Manual Adjustments must be made in the choosing of variables, and the
% restrictions imposed to create the specific models.

clear
close all
clc

tic

rng(1234567)     % RNG seed 

addpath('subfunctions')
addpath('data')
addpath('plotstabels')

%% Reduced form Settings 

% Data Location and Adjustments

datafile = 'data/Data_initEU.mat'; % Monthly (1962M1 - 2021M6) 
panelselect = [2,4,6,7,8,9,10]; % Choose subset and/or re-order variables (optional) 

% Variables: 
% 1: EU_Uf = financial uncertainty;
% 2: EU_Uf1 =  standardized Uf;
% 3: EU_EPU = EPU
% 4: EU_CREDIT = Credit Spread non financial
% 5: EU_Y2
% 6: EU_Y3 = industrial production growth (percentages)
% 7: EU_CPI = 
% 8: EU_PRATE = Policy Rate
% 9: EU_UNRATE = Unemployment Rate
% 10: EU_STOXX = Stock Market Prices
% 11: EU_CONS = Consumer Confidence



startYear = 1999;                       % Choose start year (earliest full year)
endYear = 2019;                         % last full year
% Sample: 1999.01 - 2020.02

AppendMonths  = 2;                       % number of months to append
PrependMonths = 0;                       % number of months in year before to add


% Model Specification

constant = 1;                           % Add constant in VAR
exog = [];                              % Specify position of exogenous variables (optional);
p = 6;                                  % Maximum lag order of VAR
h = 0;                                  % Desired forecast horizon



%% Reduced Form Priors

prior_settings.prior_family = 'conjugate';
prior_settings.prior = 'flat';                % Select 'flat' or 'Minnesota'



%% Structural Identification Settings

StructuralIdentification = 'None';           % Chose 'None' or 'Signs/Zeros' or 'Choleski';
agnostic = 'irfs';  % select: 'structural' or 'irfs';
     
     % (1) Set up standard sign restrictions:
      % SR{#} reads as: SR{r} = {Shockname,{Variable Names}, Horizon, Sign (1 or -1),}; 
        SR{1} = {'Unc',{'EU_Uf1'}, 0,   1}; 
        %SR{2} = {'MacUnc',{'EU_EPU'},0,1};
        SR{2} = {'Cred',{'EU_CREDIT'}, 0, 1};
        %SR{4} = {'Cons',{'EU_CONS'},0,1};
       
     % (3) Set up Narrative Sign Restrictions:
      % NSR{#} reads as: NSR{r} = {'shockname',type of restriction ('sign of shock' or
      % 'contribution'), date, end date (for contributions only), variable 
      % (for contributions only), sign, 'strong' or 'weak' for contributions}
      % N.B. 'strong' means 'overwhelming' and 'weak' means 'most important'
         NSR{1} = {'Unc','contribution',datenum(2008,09,01),datenum(2008,10,01),'EU_Uf1',1,'weak'};
         %NSR{2} = {'MacUnc','sign of shock',datenum(2008,09,01),1};
         NSR{2} = {'Cred','contribution',datenum(2008,09,01),datenum(2008,10,01),'EU_CREDIT',1,'weak'};
         %NSR{4} = {'Cons','sign of shock',datenum(2008,09,01),-1};
          
          
%% Gibbs Sampler Settings

numDesiredDraws = 10000; % Number of desired draws 

BetaSigmaTries = 100; % Maximum number of posterior draws trials used 
% by the Gibbs Sampler when evaluating the posterior draws

Qs_per_BetaSigma = 100; % Number of orthogonal matrices to be simulated for each posterior draw

nRepsWeights = 1000; % maximum number of re-weighting of the draws when 
% narrative restrictions are taken into account 


CodeMainBody

toc

return;

%% My plot functions

Plot_IRFS_EU % Impulse Response plot (depends on the model specification)

FEVD_EU2 % For spec 1 and spec 2

%FEVD_EU3 % For spec 3

%FEVD_EU4 % For spec 4

HDs_EU % spec 1
%HDs_EU2 % spec 2
%HDs_EU3 % spec 3
%HDs_EU4 % spec 4


%% This last part creates the estimate structural shocks during COVID-19

MedShocks = median(Draws_Shocks_narrative,3);
Shocks68 = prctile(Draws_Shocks_narrative,100,3);
FinShocks = squeeze(Draws_Shocks_narrative(:,1,:));


startDate = [datenum(1999,1,01)];
endDate = [datenum(2021,6,01)];
numticks = 36;
bands  = [16,50,84];

idxStart=find(ismember(dates,startDate));
idxEnd=find(ismember(dates,endDate));

percentiles = prctile(squeeze(Draws_Shocks_narrative(:,1,:)),bands,2);

% Plot estimated structural shocks
f2 = figure;
clf
figSize = [9 4.5];
set(f2, 'PaperUnits', 'inches');
set(f2, 'Units','inches');
set(f2, 'PaperSize', figSize);
set(f2, 'PaperPositionMode', 'auto');
set(f2, 'Position', [0 0 figSize(1) figSize(2)])

plotConfidenceBandsBlue(dates(idxStart+6:idxEnd),percentiles,'r'); 
hold on
plot(dates(idxStart+6:idxEnd),percentiles(:,2),'Color',[204 37 41]./255,'LineWidth',2.5);
hold on
plot(dates(idxStart+6:idxEnd),zeros(264,1),'-.k','LineWidth',0.75)       
xlim([dates(idxStart+6), dates(idxEnd)])
ylim([-3.5 7])
    ax = gca;
    set(ax,'XTick',dates([idxStart+6:numticks:idxEnd]))
    ax.XTickLabel = {datestr(dates([idxStart+6:numticks:idxEnd]),'yyyy')};   
    box off
    set(gca, 'FontName', 'Times New Roman');
    %legend([P2,P4,P3],'Contribution of Uncertainty shock','Contribution of Credit Spread Shock','Total variation');
    set(gca, 'FontSize', 12);
    set(gca,'Layer','top')
    set(gca,'YGrid','on')%,'YTick',-25:10:5)
    fname = strcat('results/SSfin_spec4.eps');
    print('-depsc', f2, fname); 

COVIDSHOCKFIN = MedShocks(end-15,1);
COVIDSHOCKEPU = MedShocks(end-15,2);
COVIDSHOCKCRED = MedShocks(end-15,3);
COVIDSHOCKCONS = MedShocks(end-15,4);

COVIDLARGEFIN = Shocks68(end-15,1);
