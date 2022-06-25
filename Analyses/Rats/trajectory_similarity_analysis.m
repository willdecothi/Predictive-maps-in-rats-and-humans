%% load data
load('rat.mat')
load('MB.mat')
load('Q.mat')
load('SR.mat')
load('mazes.mat')

%% Get ppt ids for indivual analyses
ppt_ids = zeros(9,900);
for i = 1:size(ppt_ids,1)
    tmp_ppt_id = zeros(1,size(ppt_ids,1));
    tmp_ppt_id(i) = 1;
    ppt_ids(i,:) = reshape(repmat(tmp_ppt_id,100,1),1,[]);
end

[rat_pd_sim_Q, rat_pd_sim_MB, rat_pd_sim_SR] = deal(cell(size(rat)));

for ppt = 1:9
    agent_ids = find(ppt_ids(ppt,:));
    for config = 1:25
        display([ppt, config/25])
        map = 1*(mazes{config} == -1);
        for trial = 1:10
            reference_traj = rat{ppt,config,trial};
            [Q_pd_sim, MB_pd_sim, SR_pd_sim] = deal(nan(100,length(reference_traj)));
            if ~isempty(reference_traj)
                parfor i = 1:length(agent_ids)
                    ag_id = agent_ids(i);
                    Q_pd_sim(i,:) = pd_similarity(reference_traj, Q{ag_id,config,trial}, map);
                    MB_pd_sim(i,:) = pd_similarity(reference_traj, MB{ag_id,config,trial}, map);
                    SR_pd_sim(i,:) = pd_similarity(reference_traj, SR{ag_id,config,trial}, map);
                end
            end
            rat_pd_sim_Q{ppt,config,trial} = Q_pd_sim;
            rat_pd_sim_MB{ppt,config,trial} = MB_pd_sim;
            rat_pd_sim_SR{ppt,config,trial} = SR_pd_sim;
        end
    end
end
