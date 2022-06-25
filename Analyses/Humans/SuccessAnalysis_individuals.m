load('humans.mat')
load('MB.mat')
load('Q.mat')
load('SR.mat')

cmap = brewermap(5,'Set1');
n_ppt = 18;
%% succ by trial
figure
hold on
x = (1:10)';

y = squeeze(nanmean(human_succ,[1,2]));
CI = [y'-squeeze(nanstd(human_succ,[],[1,2]))'/sqrt(n_ppt); y'+squeeze(nanstd(human_succ,[],[1,2]))'/sqrt(n_ppt)];
fill([x;flipud(x)],[CI(1,:),fliplr(CI(2,:))],[.9 .9 .9],'linestyle','none');
plot(x,y,'color',cmap(3,:),'linewidth',2)

y = squeeze(nanmean(Q_succ,[1,2]));
CI = [y'-squeeze(nanstd(Q_succ,[],[1,2]))'/sqrt(n_ppt*100); y'+squeeze(nanstd(Q_succ,[],[1,2]))'/sqrt(n_ppt*100)];
fill([x;flipud(x)],[CI(1,:),fliplr(CI(2,:))],[.9 .9 .9],'linestyle','none');
plot(x,y,'color',cmap(5,:),'linewidth',2)


y = squeeze(nanmean(MB_succ,[1,2]));
CI = [y'-squeeze(nanstd(MB_succ,[],[1,2]))'/sqrt(n_ppt*100); y'+squeeze(nanstd(MB_succ,[],[1,2]))'/sqrt(n_ppt*100)];
fill([x;flipud(x)],[CI(1,:),fliplr(CI(2,:))],[.9 .9 .9],'linestyle','none');
plot(x,y,'color',cmap(2,:),'linewidth',2)


y = squeeze(nanmean(SR_succ,[1,2]));
CI = [y'-squeeze(nanstd(SR_succ,[],[1,2]))'/sqrt(n_ppt*100); y'+squeeze(nanstd(SR_succ,[],[1,2]))'/sqrt(n_ppt*100)];
fill([x;flipud(x)],[CI(1,:),fliplr(CI(2,:))],[.9 .9 .9],'linestyle','none');
plot(x,y,'color',cmap(4,:),'linewidth',2)

ylabel('Proportion goal reached')
xlabel('Trial #')
legend({'','Human','','MF','','MB','','SR'})
ylim([0,1])
xlim([0.98,10])
yticks([0,0.25,0.5,0.75,1])
set(gca,'LineWidth',2)
set(gcf,'color','w');
set(gca,'FontSize',16)

%% succ by config 
figure
imagesc([squeeze(nanmean(human_succ,[1,3])); squeeze(nanmean(Q_succ,[1,3])); squeeze(nanmean(MB_succ,[1,3])); squeeze(nanmean(SR_succ,[1,3]))])
colormap jet
pbaspect([25,4,1])
yticks(1:4)
yticklabels({'Human','MF','MB','SR'})
xticks([])
set(gca,'LineWidth',2)
set(gcf,'color','w');
set(gca,'FontSize',18)

%% config correlations
ppt_ids = zeros(n_ppt,n_ppt*100);

for i = 1:n_ppt
    tmp_ppt_id = zeros(1,n_ppt);
    tmp_ppt_id(i) = 1;
    ppt_ids(i,:) = reshape(repmat(tmp_ppt_id,100,1),1,[]);
end

ppt_rhos = zeros(n_ppt,3);
for i = 1:n_ppt
    ppt_rhos(i,1) = corr(squeeze(nanmean(Q_succ(ppt_ids(i,:)==1,:,:),[1,3]))', squeeze(nanmean(human_succ(i,:,:),[1,3]))','Type','Spearman');
    ppt_rhos(i,2) = corr(squeeze(nanmean(MB_succ(ppt_ids(i,:)==1,:,:),[1,3]))', squeeze(nanmean(human_succ(i,:,:),[1,3]))','Type','Spearman');
    ppt_rhos(i,3) = corr(squeeze(nanmean(SR_succ(ppt_ids(i,:)==1,:,:),[1,3]))', squeeze(nanmean(human_succ(i,:,:),[1,3]))','Type','Spearman');
end

rhos = nanmean(ppt_rhos,1);
rhos_err = nanstd(ppt_rhos,[],1)/sqrt(n_ppt);

figure
hold on
bar(rhos,'LineWidth',2,'EdgeColor','k','FaceColor','w')
xticks([1,2,3])
xticklabels({'MF','MB','SR'})
errorbar(rhos, rhos_err, '.k', 'LineWidth', 2)
set(gca,'LineWidth',2)
set(gcf,'color','w');
set(gca,'FontSize',18)