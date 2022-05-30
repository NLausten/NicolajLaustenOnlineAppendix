%%% MODEL 1 CODE %%%
% This Code Can Create the Results from Model 1. 


clear
close all
clc

tic

rng(1234567)     % RNG Seed

addpath('subfunctions')
addpath('data')
addpath('plotstabels')

%% Reduced form Settings 

% Data Location and Adjustments

datafile = 'Data_init.mat'; % Monthly (1962M1 - 2021M6) 
panelselect = [2,4,9]; % Choose subset and/or re-order variables (optional) 

% Variables: 
% 1: Uf = financial uncertainty;
% 2: Uf1 =  standardized Uf;
% 3: Um = macroeconomic uncertainty;
% 4: Um1 = standardized Um
% 5: VIX = VIX
% 6: VIX1 = standardized VIX
% 7: Y1 = measure 1 (logged)
% 8: Y2 = measure 2 (logged, first diff)
% 9: Y3 = measure 3 (logged, YoY)
% 10: Y4 = measure 4 (HP-filtered)


% Shocks of interest:
% FU = financial uncertainty shock;
% MU = macroeconomic uncertainty shock.
% Y = real activity shock


startYear = 1960;                       % Choose start year
endYear = 2019;                                        

AppendMonths  = 1;                       % number of months to append
PrependMonths = 0;                       % number of months in year before to add

% This choses a dataseries from 1962.7 (earliest observation) - 2020.2

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
        SR{1} = {'FU',{'Uf1'}  ,0,   1}; 
        SR{2} = {'MU',{'Um1'}  ,0,   1};
        SR{3} = {'Y',{'Y3'}   ,0,   1}; 
       
     % (3) Set up Narrative Sign Restrictions:
      % NSR{#} reads as: NSR{r} = {'shockname',type of restriction ('sign of shock' or
      % 'contribution'), date, end date (for contributions only), variable 
      % (for contributions only), sign, 'strong' or 'weak' for contributions}
      % N.B. 'strong' means 'overwhelming' and 'weak' means 'most important'
          NSR{1} = {'FU','contribution',datenum(1987,10,01),datenum(1987,10,01),'Uf1',1,'strong'};
          NSR{2} = {'FU','contribution',datenum(2008,09,01),datenum(2008,10,01),'Uf1',1,'weak'};
          NSR{3} = {'MU','sign of shock',datenum(1970,12,01),1};

          
          
%% Gibbs Sampler Settings

numDesiredDraws = 10000; % Number of desired draws 

BetaSigmaTries = 100; % Maximum number of posterior draws trials used 
% by the Gibbs Sampler when evaluating the posterior draws

Qs_per_BetaSigma = 100; % Number of orthogonal matrices to be simulated for each posterior draw

nRepsWeights = 1000; % maximum number of re-weighting of the draws when 
% narrative restrictions are taken into account 

% Run Algorithm 1
CodeMainBody


toc

return;

%% Results

Plot_IRFS_US % IRFs of all variables to all shocks 

FEVD_US % Foerecast error variance decompositions

HDs_US % Historical decomposition

