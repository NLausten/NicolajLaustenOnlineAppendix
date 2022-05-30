%%% PLOT TS EU
    f1 = figure;
    clf
    fontSize = 12;
    figSize = [12 6];
    set(f1, 'PaperUnits', 'inches');
    set(f1, 'Units','inches');
    set(f1, 'PaperSize', figSize);
    set(f1, 'PaperPositionMode', 'auto');
    set(f1, 'Position', [0 0 figSize(1) figSize(2)])

    plot(t1,y(1,:),'k')
    title('Uncertainty','fontSize',fontSize)
    ylim([-2 4.5])
    yline(0,'--')

    tightfig;
    
    fname = strcat('results/Figure1TimeSeries.eps');
    print('-depsc', f1, fname); 