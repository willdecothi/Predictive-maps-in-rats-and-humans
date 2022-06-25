function [ll] = MB_lik(x,dat)
%MB_LIK Summary of this function goes here
%   Detailed explanation goes here
gamma = x(1);
n_samples = size(dat,1);
llik = cell(n_samples,25,10);

A_space = ["N",0,-1;"E",1,0;"S",0,1;"W",-1,0];
load('mazes.mat');
mazes = mazes;
parfor rat = 1:n_samples
    states = 1:100;
    % Organise permitted actions
    blief_map = zeros(10);
    
    % Set simulation parameters
    
    for config = 1:25
        A_allowed = map2allowed(mazes{config});
        
        for start = 1:10
            
            lik = 1;
            traj = dat{rat,config,start};
            if(~isempty(traj))
                
                state_id = traj(1);
                
                for k = 1:(length(traj)-1)   % number of timepoints
                    %disp(['iteration: ' num2str(k)]);
                    blief_map = update_bliefs(blief_map, state_id, mazes{config});
                    next_state_id = traj(1+k);
                    
                    p = SoftmaxMB(state_id,next_state_id, blief_map, gamma, A_allowed);
                    lik = [lik, p];
                    state_id = next_state_id;
                    if(state_id == 34)
                        break
                    end
                end
            end
            llik{rat,config,start} = log(lik);
        end
    end
end

ll = sum(cellfun(@sum,llik),'all');
end

