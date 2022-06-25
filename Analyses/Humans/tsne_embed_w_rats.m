load('rat.mat')
load('humans.mat')
load('MB.mat')
load('Q.mat')
load('SR.mat')

cmap = brewermap(5,'Set1');

labels = [repelem("Rat",9), repelem("Human",18), repelem("SR",1800), repelem("Q",1800), repelem("MB",1800)];
label_id = ["Q", "MB", "SR", "Human"]; 
n_labels = length(label_id);

dat_SR =  cat(4, SR_sin_ang, SR_cos_ang, SR_diff);
dat_MB =  cat(4, MB_sin_ang, MB_cos_ang, MB_diff);
dat_Q =  cat(4, Q_sin_ang, Q_cos_ang, Q_diff);
dat_human =  cat(4, human_sin_ang, human_cos_ang, human_diff);
dat_rat =  cat(4, rat_sin_ang, rat_cos_ang, rat_diff);

dat = cat(1, dat_rat, dat_human, dat_SR, dat_Q, dat_MB);
mean_dat = squeeze(nanmean(dat,[2,3]));

%% tsne
figure
[Y,loss] = tsne(mean_dat,'Algorithm','Exact','Distance','mahalanobis', 'Perplexity',30);
gscatter(flipud(Y(:,1)),flipud(Y(:,2)),flipud(labels'),flipud(cmap([1,3,4,5,2],:)),'.',12)
set(gca,'FontSize',18)
title('t-sne averaged over trials and configs')
set(gcf,'color','w');
set(gca,'FontSize',18)
set(gca,'LineWidth',2)
pbaspect([1 1 1])
