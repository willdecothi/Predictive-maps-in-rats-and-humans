load('humans.mat')
load('MB.mat')
load('Q.mat')
load('SR.mat')

cmap = brewermap(5,'Set1');

labels = [repelem("Human",18), repelem("SR",1800), repelem("Q",1800), repelem("MB",1800)];
ind_labels = [repelem("Human",1), repelem("SR",100), repelem("Q",100), repelem("MB",100)];
label_id = ["Q", "MB", "SR"]; 
n_labels = length(label_id);

dat_SR =  cat(4, SR_sin_ang, SR_cos_ang, SR_diff);
dat_MB =  cat(4, MB_sin_ang, MB_cos_ang, MB_diff);
dat_Q =  cat(4, Q_sin_ang, Q_cos_ang, Q_diff);
dat_human =  cat(4, human_sin_ang, human_cos_ang, human_diff);

dat = cat(1, dat_human, dat_SR, dat_Q, dat_MB);

%% Get ppt ids for indivual analyses
ppt_ids = zeros(18,length(labels));

for i = 1:size(ppt_ids,1)
    tmp_ppt_id = zeros(1,size(ppt_ids,1));
    tmp_ppt_id(i) = 1;
    tmp_agt_id = reshape(repmat(tmp_ppt_id,100,1),1,[]);
    ppt_ids(i,:) = cat(2,tmp_ppt_id, repmat(tmp_agt_id,1,3));
end
    
%% mahalanobis

mal_dists = zeros(25,length(label_id),18);

for ppt = 1:18
    for i = 1:25
            %sprintf('config %i, trial %i', i, j)
            dists = pdist2(reshape(dat(ppt_ids(ppt,:)==1,i,:,:),[],size(dat,4)),reshape(dat(ppt_ids(ppt,:)==1,i,:,:),[],size(dat,4)), 'mahalanobis');
            for k = 1:n_labels
                mal_dists(i,k,ppt) = nanmean(dists(repmat(ind_labels,1,10)=="Human",repmat(ind_labels,1,10) == label_id(k)),'all');
            end
    end
end

y_md = [nanmean(mal_dists(:,label_id == "Q",:),'all');
    nanmean(mal_dists(:,label_id == "MB",:),'all');
    nanmean(mal_dists(:,label_id == "SR",:),'all')];

figure
hold on
for i=1:3
    bar(i,y_md(i),'EdgeColor','k','FaceColor','w','LineWidth',2)
end
xticks(1:3)
xticklabels({'MF','MB','SR'})
title('Distance to human cluster')
ylabel('Mahalanobis Distance')
for i = 1:18
    plot((1:3)+ (-0.05+rand(1,3)/10), squeeze(nanmean(mal_dists(:,:,i),1)),'k.-','MarkerSize',12,'linewidth',0.5)
end
set(gca,'FontSize',18)
set(gcf,'color','w');
set(gca,'LineWidth',2)
ylim([2,3.05])