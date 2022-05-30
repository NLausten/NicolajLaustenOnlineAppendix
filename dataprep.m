%% DATA PREP

% This is the Matlab code for loading in and preparing the data
% It takes the rawdata from datafiles raw, and outputs the prepared data
% into a file for each Model.
% Furthermore, it contains code for creating the time series plots.

clear
clc

addpath('datafilesraw')
addpath('functions-CCDK')


%% Dates

% Current setting is from 7.1960 - 6.2021
dates1 = (1960+7/12:1/12:2021+6/12)';
t1 = datetime(1960,7:738,1);
dates = datenum(t1)';
% can be converted to dates using 
%datetime(dates, 'ConvertFrom', 'datenum', 'Format', 'dd-MM-yyyy')

%% US DATA

    %% Uncertainty Data

    % Financial Uncertainty
    XX = xlsread('FinancialUncertainty.xlsx','Total Financial Uncertainty','B1:D733');
    
    XX = XX(1:end,:);
    Uf = XX(:,1); % using h=1
    Uf1 = (Uf - mean(Uf))/std(Uf);

    % Financial Uncertainty VIX
    XX = xlsread('VIX.xlsx','FRED','F12:F9332');
    
    XX1 = unique(XX,'stable');
    % series from 1986.01-2021.09
    datesTest1 = (1986+1/12:1/12:2021+09/12)';

    
    % Bloom Series
    XXB = xlsread('VIX.xlsx','Bloom','J284:J836');
   
    % 1962.7-2008.7
    datesTest2 = (1962+7/12:1/12:2008+07/12)';
    
    % Combining
    XXBS = XXB(1:282,:);
    
    VIX = [XXBS; XX1];
    % size 1962.7 - 2021.9
    
    % fit to 1962.7-2021.6
    VIX = VIX(1:end-3,:);
    
    VIX1 = (VIX - mean(VIX))/std(VIX);
    
    VIX = [nan(24,1); VIX]; 
    VIX1 = [nan(24,1); VIX1];
        
    datesTest3 = (1962+7/12:1/12:2021+09/12)';
    
    %comparison
    % plot(datesTest1,XX1,'r',datesTest2,XXB,'b')
    % plot(datesTest3,VIX,'r',datesTest1,XX1,'b',datesTest2,XXB,'g')
    
    % Macro Uncertainty

    XX = xlsread('MacroUncertainty.xlsx','Total Macro Uncertainty','B1:D733');
    XX = XX(1:end,:);
    
    Um = XX(:,1); % using h=1
    Um1 = (Um - mean(Um))/std(Um);
    

    %% Industrial Production
    % We define 4 measures log, log first diff, log 12 diff (year-on-year), and
    % the HP filtered detrended.

    XX = xlsread('INDPRO.xlsx','data','B1:B1237');

    XX = XX(1:end-6,:); % fitting endlenght

    XX = log(XX);

    Y1 = XX(end-length(Uf)+1:end,:); % Measure 1

    XXX = XX(2:end,:) - XX(1:end-1,:);

    Y2 = XXX(end-length(Uf)+1:end,:); % Measure 2

    XXX = XX(13:end,:) - XX(1:end-12,:);

    Y3 = XXX(end-length(Uf)+1:end,:)*100; % Measure 3
    %Y3 = (Y3 - mean(Y3))/std(Y3);

    [XXXT,XXXC] = hpfilter(XX,129600);

    Y4 = XXXC(end-length(Uf)+1:end,:); % Measure 4
    %Y4 = (Y4 - mean(Y4))/std(Y4);

    %% Other Variables

    % CPI
    XX = xlsread('CPIAUCSL.xlsx','data','A1:A902');
    % data from 1947.01.01 - 2022.01.01
    XX = XX(1:end-7,:); % remove to -2021.06.01 to fit

    XX = log(XX); % log

    XXX = XX(2:end,:) - XX(1:end-1,:); % first diff

    CPI = XXX(end - length(Uf) + 1:end,:);

    % Policy Rate
    XX = xlsread('PRATE.xlsx','data','A1:A902');
    % data from 1954.07.01 - 2022.01.01
    XX = XX(1:end-7,:); % remove to -2021.06.01 to fit

    XXX = log(XX); % log

    XXXX = XXX(2:end,:) - XXX(1:end-1,:); % first diff

    PRATE = XX(end - length(Uf) + 1:end,:);

    % Uemployment
    XX = xlsread('UNRATE.xlsx','data','A1:A902');
    % data from 1948.01.01 - 2022.01.01
    XX = XX(1:end-7,:); % remove to -2021.06.01 to fit

    XX = log(XX); % log

    XXX = XX(2:end,:) - XX(1:end-1,:); % first diff

    UNRATE = XXX(end - length(Uf) + 1:end,:);

    %%
    % Corona rammer cirka efter feb 2020, derfor kan det være sidste periode jf
    % Primiceri feb 2020 er periode 716 (eller end - 16).
    % Um(716) = 2.7483

    % indicator for high financial uncertainty
    Indf1 = zeros(size(Uf));
    Indf2 = zeros(size(Uf));
    for i = 1:length(Uf)-1
        if Uf(i+1,:) > 1.65 == 1
            Indf1(i+1,:) = 1;
        end

        if Uf(i+1,:) > 2 == 1
            Indf2(i+1,:) = 1;
        end
    end

    Indf3 = [Indf1 Indf2];

    Indf = zeros(size(Uf));
    LARGE = [118,161,170,327,458,476,495,505,578,716,725];
    Indf(LARGE) = 1;


    
    %% Collecting

    vNames = ["Uf", "Uf1","Um","Um1","VIX","VIX1","Y1","Y2","Y3","Y4","CPI","PRATE","UNRATE"];
    Data = [Uf Uf1 Um Um1 VIX VIX1 Y1 Y2 Y3 Y4 CPI PRATE UNRATE];

    save('data/Data_init','vNames','Data','dates');
    
%% EU DATA (EURO 19)

    % Uncertainty data
    
    % must find
    
    % VSTOXX
    XX = xlsread('EU_VSTOXX.xlsx','Sheet1','G2:G5892');
    
    XXX = unique(XX,'stable');
    
    EU_Uf  = XXX(1:end-2,:); % fit ending to 2021.12
    EU_Uf1 = (EU_Uf - mean(EU_Uf))/std(EU_Uf);

    % size 1999.01 - 2022.2
    
    EU_dates1 = (1999+1/12:1/12:2021+12/12)';
    EUt1 = datetime(1999,1:276,1);
    EU_dates = datenum(EUt1)';
    
    XX = xlsread('EU_EPU.xlsx','download');
    % 1987.01 - 2022.03 
    
    XX = XX(1:end-3,:);
    XX = (XX - mean(XX))/std(XX);
    
    EU_EPU = XX(end-length(EU_Uf)+1:end,:);
   
    % Industrial Production
    % We define 4 measures log, log first diff, log 12 diff (year-on-year), and
    % the HP filtered detrended.

    XX = xlsread('EU_INDPRO.xlsx','data');
    % data range: 1991.01-2021.12
    
    XX = XX(1:end,:); % fitting endlenght

    EU_Y1 = XX(end-length(EU_Uf)+1:end,:);
    EU_Y1 = EU_Y1 - mean(EU_Y1);
    
    XX = log(XX);

    % Measure 1

    XXX = XX(2:end,:) - XX(1:end-1,:);

    EU_Y2 = XXX(end-length(EU_Uf)+1:end,:)*100; % Measure 2

    XXX = XX(13:end,:) - XX(1:end-12,:);

    EU_Y3 = XXX(end-length(EU_Uf)+1:end,:)*100; % Measure 3

    [XXXT,XXXC] = hpfilter(XX,129600);

    %EU_Y4 = XXXC(end-length(Uf)+1:end,:); % Measure 4
    
    % other
    
    % CPI

    % CPI 
    XX = xlsread('EU_CPI.xlsx','data');
    % data from 1996.01 - 2022.01
    XX = XX(1:end-1,:); % remove to -2021.06.01 to fit
    
    XX = log(XX); % log

    XXX = XX(13:end,:) - XX(1:end-12,:); % YoY

    EU_CPI = XXX(end - length(EU_Uf1) + 1:end,:)*100;

    % Policy Rate 
    XX = xlsread('EU_EONIA.xlsx','Ark1');
    % data from 1994.01-2021.12
    EU_PRATE = XX(end - length(EU_Uf1) + 1:end,:);

    
    % Policy rate (funny)
    %XX = xlsread('EU_PRATE.xlsx','Sheet1','B1:B209');
    % data from 2004.09 - 2022.01
    %XX = XX(1:end-7,:); % remove to -2021.06.01 to fit

    %XXX = log(XX); % log

    %XXX = XX(2:end,:) - XX(1:end-1,:); % first diff

    %EU_PRATE1 = XX(end - length(Uf) + 1:end,:);

    % Uemployment (percentage unemployment) % dont use for now
    XX = xlsread('EU_UNRATE.xlsx','data');
    % data from 1998.04 - 2021.12
    XX = XX(1:end,:); % remove to -2021.12.01 to fit

    %XX = log(XX); % log

    %XXX = XX(2:end,:) - XX(1:end-1,:); % first diff

    EU_UNRATE = XX(end - length(EU_Uf) + 1:end,:);

    % Unemployment in 1000s (eller noget)
    XX = xlsread('EU_UNRATE2.xlsx','download');
    % 1998.04 - 2022.02
    XX = XX(1:end-2);
    
    standardXX = XX(10);
    
    XX = XX/standardXX*100;
   
    XX = log(XX);
    
    %XXX = XX(7:end,:) - XX(1:end-6,:);
    XXX = XX(2:end,:) - XX(1:end-1,:);
    
    EU_UNRATE2 = XXX(end-length(EU_Uf)+1:end,:)*100;
    
    XXY = XX(25:end,:) - XX(13:end-12,:);
    
    
    % EU stoxx
    
    XX = xlsread('EU_STOXX.xlsx','download');
    % 1997.01 - 2022.3 (missing value december 2021).
    
    XX = XX(1:end-2,:);
    
    standardXX = XX(25);
    
    XX = XX/standardXX*100;
    
    XX = log(XX);
    
    XXX = XX(13:end,:) - XX(12:end-1,:);

    EU_STOXX = XXX(end-length(EU_Uf)+1:end,:)*100;
    
    % Credit Spread
    XX = xlsread('EU_CREDIT.xlsx','download1'); 
    % 1999.01 - 2022.2
    
    XX = XX(1:end-2,:);
    
    EU_CREDIT = XX(end-length(EU_Uf)+1:end);
    
    % Consumer Confidence
    XX = xlsread('consumerconfi.xlsx','Consumer');
    % 1973.01-2022.03
    XX = XX(1:end-3,:);
    
    EU_CONS = XX(end-length(EU_Uf)+1:end);
    
    % Collecting
    
    vNamesEU = ["EU_Uf", "EU_Uf1","EU_EPU","EU_CREDIT","EU_Y2","EU_Y3","EU_CPI","EU_PRATE","EU_UNRATE","EU_STOXX","EU_CONS"];
    DataEU = [EU_Uf EU_Uf1 EU_EPU EU_CREDIT EU_Y2 EU_Y3 EU_CPI EU_PRATE EU_UNRATE EU_STOXX EU_CONS];

    save('data/Data_initEU','vNamesEU','DataEU','EU_dates');
    
   
    return;
    
    %% PLOT EU
    f2 = figure;
    clf
    fontSize = 12;
    figSize = [12 11];
    set(f2, 'PaperUnits', 'inches');
    set(f2, 'Units','inches');
    set(f2, 'PaperSize', figSize);
    set(f2, 'PaperPositionMode', 'auto');
    set(f2, 'Position', [0 0 figSize(1) figSize(2)])

    subplot(5,1,1)
    plot(EUt1,EU_Y3,'Color',[57 106 177]./255,'LineWidth',1.5)
    title('Industrial Production','fontSize',fontSize)
    ylim([-40 40])
    set(gca,...
        'Box','off',...
    'YGrid','on',...
    'XGrid','on',...
    'XColor',[.3 .3 .3],...
    'YColor',[.3 .3 .3],...
        'XTick',[EUt1(1:24:end-11) EUt1(276)],...
    'XTickLabel',XDATANAMES);
    yline(0,'--')
    
    subplot(5,1,2)
    plot(EUt1,EU_CPI,'Color',[57 106 177]./255,'LineWidth',1.5)
    title('CPI','fontSize',fontSize)
    set(gca,...
        'Box','off',...
    'YGrid','on',...
    'XGrid','on',...
    'XColor',[.3 .3 .3],...
    'YColor',[.3 .3 .3],...
        'XTick',[EUt1(1:24:end-11) EUt1(276)],...
    'XTickLabel',XDATANAMES);
    yline(0,'--')
    
    subplot(5,1,3)
    plot(EUt1,EU_PRATE,'Color',[57 106 177]./255,'LineWidth',1.5)
    title('Policy Rate','fontSize',fontSize)
    ylim([-1 6])
    set(gca,...
        'Box','off',...
    'YGrid','on',...
    'XGrid','on',...
    'XColor',[.3 .3 .3],...
    'YColor',[.3 .3 .3],...
        'XTick',[EUt1(1:24:end-11) EUt1(276)],...
    'XTickLabel',XDATANAMES);
    yline(0,'--')
    
    subplot(5,1,4)
    plot(EUt1,EU_UNRATE,'Color',[57 106 177]./255,'LineWidth',1.5)
    title('Unemployment Rate','fontSize',fontSize)
    %ylim([-3.5 6.5])
    set(gca,...
        'Box','off',...
    'YGrid','on',...
    'XGrid','on',...
    'XColor',[.3 .3 .3],...
    'YColor',[.3 .3 .3],...
        'XTick',[EUt1(1:24:end-11) EUt1(276)],...
    'XTickLabel',XDATANAMES);
    yline(0,'--')
    
    subplot(5,1,5)
    plot(EUt1,EU_STOXX,'Color',[57 106 177]./255,'LineWidth',1.5)
    title('Equity Prices','fontSize',fontSize)
    yline(0,'--')
    set(gca,...
        'Box','off',...
    'YGrid','on',...
    'XGrid','on',...
    'XColor',[.3 .3 .3],...
    'YColor',[.3 .3 .3],...
        'XTick',[EUt1(1:24:end-11) EUt1(276)],...
    'XTickLabel',XDATANAMES);

    tightfig;
    
    fname = strcat('results/EU_TSMANY.eps');
    print('-depsc', f2, fname); 
    
    XDATANAMES = {'1999','2001','2003','2005','2007','2009','2011','2013','2015','2017','2019','2021',''};
    l1 = datenum(2008,09,01);

    
    % Plot Uncertainty and Credit
    
    f3 = figure;
    clf
    fontSize = 12;
    figSize = [10 4];
    set(f3, 'PaperUnits', 'inches');
    set(f3, 'Units','inches');
    set(f3, 'PaperSize', figSize);
    set(f3, 'PaperPositionMode', 'auto');
    set(f3, 'Position', [0 0 figSize(1) figSize(2)])
    
    plot(EUt1,EU_Uf1,'-','Color',[57 106 177]./255,'LineWidth',1.5)
    hold on
    plot(EUt1,(EU_CREDIT-mean(EU_CREDIT))/std(EU_CREDIT),'-','Color',[204 37 41]./255,'LineWidth',1.5)
    legend(["Uncertainty","Credit Spread"],'location','NorthWest','FontSize',12)
    xlabel('Year')
    xline(EUt1(117),'--')

    
    set(gca,...
        'Box','off',...
    'YGrid','on',...
    'XGrid','on',...
    'XColor',[.3 .3 .3],...
    'YColor',[.3 .3 .3],...
        'XTick',[EUt1(1:24:end-11) EUt1(276)],...
    'XTickLabel',XDATANAMES);
    
    fname = strcat('results/EU_TS1.eps');
    print('-depsc', f3, fname); 
    
    % Plot VSTOXX uncertainty and EPU
    
    f3 = figure;
    clf
    fontSize = 12;
    figSize = [10 4];
    set(f3, 'PaperUnits', 'inches');
    set(f3, 'Units','inches');
    set(f3, 'PaperSize', figSize);
    set(f3, 'PaperPositionMode', 'auto');
    set(f3, 'Position', [0 0 figSize(1) figSize(2)]);
    
    P1 = plot(EUt1,EU_Uf1,'Color',[57 106 177]./255,'LineWidth',1.5);
    hold on
    P2 = plot(EUt1,(EU_EPU-mean(EU_EPU))/std(EU_EPU),'-','Color',[204 37 41]./255,'LineWidth',1.5);
    
    set(gca,...
        'Box','off',...
    'YGrid','on',...
    'XColor',[.3 .3 .3],...
    'YColor',[.3 .3 .3],...
    'XGrid','on',...
     'XTick',[EUt1(1:24:end-11) EUt1(276)],...
    'XTickLabel',XDATANAMES);
    legend([P1,P2],{'VSTOXX','EPU'},'Location','NorthWest','Fontsize',12);
    
    fname = strcat('results/EU_TS2.eps');
    print('-depsc', f3, fname); 
    
    % Plot VSTOXX uncertainty and CC
    
    f3 = figure;
    clf
    fontSize = 12;
    figSize = [10 4];
    set(f3, 'PaperUnits', 'inches');
    set(f3, 'Units','inches');
    set(f3, 'PaperSize', figSize);
    set(f3, 'PaperPositionMode', 'auto');
    set(f3, 'Position', [0 0 figSize(1) figSize(2)]);
    
    P1 = plot(EUt1,EU_Uf1,'Color',[57 106 177]./255,'LineWidth',1.5);
    hold on
    P2 = plot(EUt1,(EU_CONS-mean(EU_CONS))/std(EU_CONS),'-','Color',[204 37 41]./255,'LineWidth',1.5);
        xline(EUt1(117),'--')

    set(gca,...
        'Box','off',...
    'YGrid','on',...
    'XColor',[.3 .3 .3],...
    'YColor',[.3 .3 .3],...
    'XGrid','on',...
    'XTick',[EUt1(1:24:end-11) EUt1(276)],...
    'XTickLabel',XDATANAMES);
    legend([P1,P2],{'VSTOXX','Consumer Confidence'},'Location','NorthWest','Fontsize',12);
    
    fname = strcat('results/EU_TS3.eps');
    print('-depsc', f3, fname); 
    
 %% Plot MODEL 1. (US DATA Must Be Loaded)

    % plot for macroeconomic uncertainty
    Labelsshow = {'1960','1964','1968','1972','1976','1980','1984','1988','1992','1996','2000','2004','2008','2012','2016','2020',''};
    %some dates for plot
    k1 = t1(100);
    k2 = t1(304);
    k3 = t1(555);
    k4 = t1(691);
    k5 = t1(208);   
    
    j1=datetime(2020,1,1); % corona
    j2=datetime(2008,9,1); % great recession
    j3=datetime(1987,10,1); % black monday
    j4=datetime(1970,12,1); % Bretton Woods
    
    l1 = datenum(2008,09,01);
    l2 = datenum(1987,10,01);
    l3 = datenum(1970,12,01);
    
    f1 = figure;
    clf
    fontSize = 12;
    figSize = [12 8];
    set(f1, 'PaperUnits', 'inches');
    set(f1, 'Units','inches');
    set(f1, 'PaperSize', figSize);
    set(f1, 'PaperPositionMode', 'auto');
    set(f1, 'Position', [0 0 figSize(1) figSize(2)])

    subplot(3,1,1)
    plot(dates,Uf1,'Color',[57 106 177]./255,'linewidth',1.5)
    title('Financial Uncertainty','fontSize',fontSize)
    xline([l1],'-',{'The Great Recession'},'LabelOrientation','horizontal',...
    'LabelHorizontalAlignment','left','Color',[204 37 41]./255,'linewidth',1.5)
    xline([l2],'-',{'Black Monday'},'LabelOrientation','horizontal',...
    'LabelHorizontalAlignment','left','Color',[204 37 41]./255,'linewidth',1.5)
    xline(l3,'-',{'Bretton Woods','Collapse'},'LabelOrientation','horizontal'...
    ,'Color',[204 37 41]./255,'linewidth',1.5)
    box off
    ax = gca;
    set(ax,'XTick',[dates(1:48:end-11)' dates(732)],'XTickLabel',Labelsshow)

    xlim([dates(1), dates(end)])
    set(gca,'YGrid','on','XGrid','on')
    %xline(j1)
    ylim([-2 6])
    yline(0,'--')

    subplot(3,1,2)
    plot(dates,Um1,'Color',[57 106 177]./255,'linewidth',1.5)
    title('Macro Uncertainty','fontSize',fontSize)
    xline([l1],'-',{'The Great Recession'},'LabelOrientation','horizontal',...
    'LabelHorizontalAlignment','left','Color',[204 37 41]./255,'linewidth',1.5)
    xline([l2],'-',{'Black Monday'},'LabelOrientation','horizontal',...
    'LabelHorizontalAlignment','left','Color',[204 37 41]./255,'linewidth',1.5)
    xline(l3,'-',{'Bretton Woods','Collapse'},'LabelOrientation','horizontal'...
    ,'Color',[204 37 41]./255,'linewidth',1.5)
    %xline(j1)
    box off
        ax = gca;
    set(ax,'XTick',[dates(1:48:end-11)' dates(732)],'XTickLabel',Labelsshow)
    xlim([dates(1), dates(end)])
    set(gca,'YGrid','on','XGrid','on')
    ylim([-2 6])
    yline(0,'--')

    subplot(3,1,3)
    plot(dates,Y3,'Color',[57 106 177]./255,'linewidth',1.5)
    title('Industrial Production growth (%)','fontSize',fontSize)
    yline(0,'--')
    xline([l1],'-',{'The Great Recession'},'LabelOrientation','horizontal',...
    'LabelHorizontalAlignment','left','Color',[204 37 41]./255,'linewidth',1.5)
    xline([l2],'-',{'Black Monday'},'LabelOrientation','horizontal',...
    'LabelHorizontalAlignment','left','Color',[204 37 41]./255,'linewidth',1.5)
    xline(l3,'-',{'Bretton Woods','Collapse'},'LabelOrientation','horizontal'...
    ,'Color',[204 37 41]./255,'linewidth',1.5)
    box off
        ax = gca;
    set(ax,'XTick',[dates(1:48:end-11)' dates(732)],'XTickLabel',Labelsshow)
    xlim([dates(1), dates(end)])
    set(gca,'YGrid','on','XGrid','on','YTick',-20:10:20)
    ylim([-20 20])
    %xline(j1)

    tightfig;
    
    fname = strcat('results/TimeSeriesUS.eps');
    print('-depsc', f1, fname); 
