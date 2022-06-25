load('likelihoods_individuals.mat')
load('likelihoods_RW.mat')

cmap = brewermap(5,'Set1');

lliks = zeros([3,size(MB_acts)]);
lliks(1,:,:,:) = cellfun(@sum,Q_llik);
lliks(2,:,:,:) = cellfun(@sum,MB_llik);
lliks(3,:,:,:) = cellfun(@sum,SR_llik);

ll_winners = lliks == max(lliks,[],1);


baseline = sum(cellfun(@sum,RW_llik),'all');

ll = sum(lliks,[2,3,4]);

hybrid = max(cellfun(@nansum,MB_llik),cellfun(@nansum,Q_llik));

lliks = zeros([3,size(MB_acts)]);
lliks_RW = exp(cellfun(@mean,RW_llik));
lliks(1,:,:,:) = exp(cellfun(@mean,Q_llik)) - lliks_RW;
lliks(2,:,:,:) = exp(cellfun(@mean,MB_llik)) - lliks_RW;
lliks(3,:,:,:) = exp(cellfun(@mean,SR_llik)) - lliks_RW;

figure
hold on
bar(1:3,ll,'FaceColor','k','LineWidth',2)
title('Humans')
xticks(1:3)
xticklabels({'MF','MB','SR'})

box on
ylabel('Log Likelihood')
yline(baseline, 'Color','red', 'LineWidth',2,'LineStyle','--')
ylim([-8.8e4,-8.25e4])
yticks([-8.75e4, -8.5e4, -8.25e4])
set(gca,'FontSize',18)
set(gcf,'color','w');
set(gca,'LineWidth',2)

trial_lliks1 = squeeze(nanmean(lliks(:,:,:,1:5),[3,4]));
trial_lliks2 = squeeze(nanmean(lliks(:,:,:,6:10),[3,4]));

figure
hold on
bar([1:3, 4.5:1:6.5], [mean(trial_lliks1, 2); mean(trial_lliks2,2)],'EdgeColor','k','FaceColor','w','LineWidth',2)
for i = 1:18
plot((1:3) + (-0.05+0.1*rand(1,3)),  trial_lliks1(:,i), 'k.-','MarkerSize',12, 'linewidth',1.5)
plot((4.5:1:6.5) + (-0.05+0.1*rand(1,3)),  trial_lliks2(:,i), 'k.-','MarkerSize',12, 'linewidth',1.5)
end
title('Humans')
xline(3.75,':k','LineWidth',2)
set(gca,'FontSize',18)
set(gcf,'color','w');
set(gca,'LineWidth',2)
xticks([1:3, 4.5:1:6.5])
xticklabels({'MF', 'MB','SR','MF', 'MB','SR'})
ylabel('Avg action likelihood')
box on


figure
imagesc(squeeze(nanmean(lliks,[2,4])))
title('Humans')
set(gca,'FontSize',18)
set(gcf,'color','w');
set(gca,'LineWidth',2)
yticks([1,2,3])
yticklabels({'MF','MB','SR'})
colormap jet
colorbar
pbaspect([25 3 1])


figure
pie(nanmean(ll_winners,[2,3,4]) / sum(nanmean(ll_winners,[2,3,4])))
colormap(ones(3))
set(gca,'FontSize',18)
set(gcf,'color','w');
set(gca,'LineWidth',2)