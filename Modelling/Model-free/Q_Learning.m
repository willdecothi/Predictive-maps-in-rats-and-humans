load('human_params.mat')
load('humans.mat')
ppts_traj = humans;

% load('rat_params.mat')
% load('rat.mat')
% ppts_traj = rat;

K = 45;

n_samples = 100;
n_ppt = length(ppt_params);
success = nan(n_samples*n_ppt,25,10);
trajectories = cell(n_samples*n_ppt,25,10);
lambda = 0.5;

load('mazes.mat')
A_space = ["N",0,-1;"E",1,0;"S",0,1;"W",-1,0];

%% Training
load('PreQ.mat')

%% Run Testing
for ppt = 1:n_ppt
    alpha = ppt_params(ppt,1);
    gamma = ppt_params(ppt,2);
    opt_Q = gamma.^PreQ;
    opt_Q(isnan(opt_Q)) = 0;
    
    for s = 1:n_samples
        agent_idx = (ppt-1)*n_samples+s;
        display(agent_idx/(n_samples*n_ppt));
        old_Q = opt_Q;
        
        for config = 1:25
            A_allowed = map2allowed(mazes{config});
            Q = old_Q;
            epsilon = 0.11;
            % Simulate behaviour
            for start = 1:10
                old_E = zeros(100,4);
                E = zeros(100,4);
                epsilon = epsilon-0.01;
                [state_y, state_x] = find(mazes{config} == start);
                state_id = coords2state(state_x,state_y);
                traj = state_id;
                
                for k = 1:K   % number of timepoints left
                    rndm = rand; % get 1 uniform random number
                    x = sum(rndm >= cumsum([0, 1-epsilon, epsilon])); % check it to be in which probability area
                    % explore or exploit
                    if x == 1   % exploit
                        current_action = A_space(datasample(find(A_allowed(state_id,:).*Q(state_id,:) == max(A_allowed(state_id,:).*Q(state_id,:))),1),1);
                    else        % explore
                        current_action = A_space(datasample(find(A_allowed(state_id,:) == 1),1),1); % choose 1 action randomly (uniform random distribution)
                    end
                    % action chosen, now find reward
                    a_id = find(A_space(:,1) == current_action); % idx of the chosen action
                    % observe the next state and next reward ** there is no reward matrix
                    [next_state_id, reward] = action2state(state_id, a_id, A_allowed);
                    % update the SR matrix using TD rule
                    E(state_id,a_id) = E(state_id,a_id) + 1;
                    Q = Q_trace_update(Q, E, state_id, a_id, reward, next_state_id, gamma, alpha);
                    E = gamma*lambda*E;

                    % update the stored trajectories
                    traj = [traj, next_state_id];
                    % if reached terminal state
                    if (next_state_id == 34)
                        success(agent_idx,config,start) = 1;
                        trajectories{agent_idx,config,start} = traj;
                        break
                    elseif (k ==K)
                        trajectories{agent_idx,config,start} = traj;
                        success(agent_idx,config,start) = 0;
                        break
                    else
                        state_id = next_state_id;
                    end
                end
                
                ppt_traj = ppts_traj{ppt,config,start};
                if (~isempty(ppt_traj))
                    time_steps_left = length(ppt_traj)-1;
                    % Update M based on true trajectory
                    for t = 1:time_steps_left
                        state = ppt_traj(t);
                        next_state = ppt_traj(t+1);
                        action = state2action(state, next_state);
                        a_id = find(A_space(:,1) == action); % idx of the chosen action
                        [~, reward] = action2state(state, a_id, A_allowed);
                        old_E(state,a_id) = old_E(state,a_id) + 1;
                        old_Q = Q_trace_update(old_Q, old_E, state, a_id, reward, next_state, gamma, alpha);
                        old_E = gamma*lambda*old_E;

                    end
                end
            end
        end
    end
end

Q_succ = success;
Q = trajectories;