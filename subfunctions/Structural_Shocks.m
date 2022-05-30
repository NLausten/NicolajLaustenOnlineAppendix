Uf_2008M10 = Draws_Shocks(424,1,:);
figure
plot(squeeze(Uf_2008M10))
axis tight

histogram(Uf_2008M10,15)

bands  = [16,50,84];
% count  = 1;

% for jj = 1:7
 for jj = 3
    
 % for ii = 1:n


    % subplot(3,7,count)
    
    % percentiles1 = prctile(squeeze(Draws_IRFs(ii,jj,1:hmaxtoplot+1,:)),bands,2);
    percentiles_median_shocks = prctile(squeeze(Draws_Shocks(1:560,jj,:)),bands,2);
        
% %     plotConfidenceBandsBlue(0:hmaxtoplot,percentiles1,'b');
% %     hold on
%     plotConfidenceBandsBlue(0:hmaxtoplot,percentiles3,'r');
%     hold on    
%     plot(0:hmaxtoplot,zeros(hmaxtoplot+1,1),'--k')

%     plot(0:hmaxtoplot,),'color',[0.8 0.8 0.8 1]);  
    
%     plot(0:hmaxtoplot,squeeze(Draws_IRFs(ii,jj,1:hmaxtoplot+1,index2(1:z21))),'color',[0.8 0.8 0.8 1]);  
%     hold on
%     
%     plot(0:hmaxtoplot,squeeze(Draws_IRFs(ii,jj,1:hmaxtoplot+1,index3(1:z31))),'color',[1 0 0 1]);
%     
%     plot(0:hmaxtoplot,squeeze(Draws_IRFs(ii,jj,1:hmaxtoplot+1,modal_IRF_narrative_noElasticity)),'k','LineWidth',1.5)
% %     plot(0:hmaxtoplot,squeeze(Draws_IRFs(ii,jj,1:hmaxtoplot+1,index3(1:z31))),'color',[0 0 0 1]);

%     hold off
    
%     xmin=0;
%     xmax=hmaxtoplot;
%     xlim([xmin,xmax])
%     if ii == 1
%     ylim([-2.5,1.5]) 
%     ylabel('Percent')
%     else
%     ylim([-5,10])
%     end

%     set(gca, 'FontName', 'Times New Roman');
%     set(gca, 'FontSize', 8); 
%     set(gca,'XTick',[0:round(hmaxtoplot/4.33):hmaxtoplot]')
%     set(gca,'XTickLabel',num2str([0:round(hmaxtoplot/4.33):hmaxtoplot]'))    
%     box on
%     title(strcat(varNames(ii),{' '},'to',{' '},shockNames(jj),' Shock'))
%     set(gca,'Layer','top')

%     if count > 14
%             xlabel('Months')
%     end
%     count  = count+1;
    
 end
    
% end