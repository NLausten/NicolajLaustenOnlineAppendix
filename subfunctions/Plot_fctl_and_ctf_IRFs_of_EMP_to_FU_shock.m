% Variable 4 (GDP), Shock 1 (FU)
percentiles1_41 = prctile(squeeze(Draws_IRFs_narrative(4,1,1:hmaxtoplot+1,:)),bands,2); % Factual
percentiles2_41 = prctile(squeeze(Draws_IRFs_narrative_CTF(4,1,1:hmaxtoplot+1,:)),bands,2); % Counterfactual

fA5 = figure;      
plot(0:hmaxtoplot,percentiles1_41(:,2),'-b','LineWidth',4); % Median IRF (factual)
hold on
plot(0:hmaxtoplot,percentiles2_41(:,2),'-.g','LineWidth',4); % Median IRF (counterfactual)
hold on
plot(0:hmaxtoplot,zeros(hmaxtoplot+1,1),'-.k','LineWidth',1)
xmin=0;
xmax=hmaxtoplot;
xlim([xmin,xmax])
set(gca, 'FontName', 'Times New Roman');
set(gca, 'FontSize', 14);
% set(gca, 'FontWeight', 'Bold');
box on
title(strcat('Median IRFs of',{' '},varNames(4),{' '},'to',{' '},shockNames(1),' Shock'))
set(gca,'Layer','top')        
xlabel('Months')        
tightfig;
legend('Factual','Counterfactual')
