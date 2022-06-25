load('trajectory_similarity_analysis.mat')

dat_pd = cat(4, rat_pd_sim_Q, rat_pd_sim_MB, rat_pd_sim_SR);
dat_pd = cellfun(@(X) mean(min(X,[],1)), dat_pd);

y_md = squeeze(nanmean(dat_pd,[1,2,3]));

figure
hold on
for i=1:3
    bar(i,y_md(i),'EdgeColor','k','FaceColor','w','LineWidth',2)
end
xticks(1:3)
xticklabels({'MF','MB','SR'})
title('Rat Trajectory Similarity')
ylabel('Distance to Agent Trajectory')
for i = 1:9
    plot((1:3)+ (-0.05+rand(1,3)/10), squeeze(nanmean(dat_pd(i,:,:,:),[2,3])),'k.-','MarkerSize',12,'linewidth',0.5)
end
ylim([0,4])
set(gca,'FontSize',18)
set(gcf,'color','w');
set(gca,'LineWidth',2)

figure
hold on
bar([1:3, 4.5:1:6.5], [squeeze(nanmean(dat_pd(:,:,1:5,:),[1,2,3])); squeeze(nanmean(dat_pd(:,:,6:10,:),[1,2,3]))],'EdgeColor','k','FaceColor','w','LineWidth',2)
for i = 1:9
    plot((1:3) + (-0.05+0.1*rand(1,3)),  squeeze(nanmean(dat_pd(i,:,1:5,:),[1,2,3])), 'k.-','MarkerSize',12, 'linewidth',.5)
    plot((4.5:1:6.5) + (-0.05+0.1*rand(1,3)),  squeeze(nanmean(dat_pd(i,:,6:10,:),[1,2,3])), 'k.-','MarkerSize',12, 'linewidth',.5)
end
title('Rat Trajectory Similarity: First 5 vs. Last 5 Trials')
xline(3.75,':k','LineWidth',2)
set(gca,'FontSize',18)
set(gcf,'color','w');
set(gca,'LineWidth',2)
ylim([0,5])
xticks([1:3, 4.5:1:6.5])
xticklabels({'MF', 'MB','SR','MF', 'MB','SR'})
ylabel('Distance to Agent Trajectory')

figure
imagesc(squeeze(nanmean(dat_pd,[1,3]))')
yticks(1:3)
yticklabels({'MF','MB','SR'})
colormap jet
colorbar
caxis([0,2])
set(gca,'FontSize',18)
set(gcf,'color','w');
set(gca,'LineWidth',2);
title('Predictions over configurations')
pbaspect([25 3 1])