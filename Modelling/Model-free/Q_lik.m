function [ll] = Q_lik(x,dat)
%Q_LIK Summary of this function goes here
%   Detailed explanation goes here
alpha = x(1); gamma = x(2);
n_samples = size(dat,1);
llik = cell(n_samples,25,10);

load('mazes');
mazes = mazes;
load('PreQ.mat')
opt_Q = gamma.^PreQ;
opt_Q(isnan(opt_Q)) = 0;

%% Run Testing
parfor r = 1:n_samples
    Q = opt_Q;
    for config = 1:25
        A_allowed = map2allowed(mazes{config});
        
        for start = 1:10
            
            lik = 1;
            traj = dat{r,config,start};
            if(~isempty(traj))
                
                state_id = traj(1);
                for k = 1:(length(traj)-1)
                    [a_id, p] = SoftmaxLikeQ(Q, state_id, traj(1+k), A_allowed);
                    lik = [lik, p];
                    % observe the next state and next reward ** there is no reward matrix
                    [next_state_id, reward] = action2state(state_id, a_id, A_allowed);
                    
                    % update the Q matrix using the Q-learning rule
                    Q = Q_update(Q, state_id, a_id, reward, next_state_id, gamma, alpha);
                    state_id = next_state_id;
                    if(state_id == 34)
                        break
                    end
                end
            end
            llik{r,config,start} = log(lik);
        end
    end
end

ll = sum(cellfun(@sum,llik),'all');
end

