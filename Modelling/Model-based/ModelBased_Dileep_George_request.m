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

load('mazes.mat')
A_space = ["N",0,-1;"E",1,0;"S",0,1;"W",-1,0];

%% Run Testing
for ppt = 1:n_ppt
    gamma = ppt_params(ppt,1);
    
    for s = 1:n_samples
        agent_idx = (ppt-1)*n_samples+s;
        display(agent_idx/(n_samples*n_ppt));
        old_blief_map = zeros(10);
%         blief_map = zeros(10);
        for config = 1:25
            A_allowed = map2allowed(zeros(10));
            epsilon = 0.11;
            blief_map = old_blief_map;
            
            % Simulate behaviour
            for start = 1:10

                epsilon = epsilon-0.01;
                [state_y, state_x] = find(mazes{config} == start);
                state_id = coords2state(state_x,state_y);
                traj = state_id;
                
                for k = 1:K   % number of timepoints left
                    blief_map = update_bliefs_Dileep_George_request(blief_map, state_id, mazes{config});
                    rndm = rand; % get 1 uniform random number
                    x = sum(rndm >= cumsum([0, 1-epsilon, epsilon])); % check it to be in which probability area
                    % explore or exploit
                    if x == 1   % exploit
                        current_action = A_space(MB_planning(state_id, blief_map, gamma, A_allowed), 1);
                    else        % explore
                        current_action = A_space(datasample(find(A_allowed(state_id,:) == 1),1),1); % choose 1 action randomly (uniform random distribution)
                    end
                    % action chosen, now find reward
                    a_id = find(A_space(:,1) == current_action); % idx of the chosen action
                    % observe the next state and next reward ** there is no reward matrix
                    [next_state_id, ~] = action2state(state_id, a_id, map2allowed(mazes{config}));
                    [blocked_state_id, ~] = action2state(state_id, a_id, A_allowed);
                    if blocked_state_id ~= next_state_id
                        blief_map = update_bliefs_Dileep_George_request(blief_map, blocked_state_id, mazes{config});
                    end
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
                        old_blief_map = update_bliefs_Dileep_George_request(old_blief_map, state_id, mazes{config});
                        next_state = ppt_traj(t+1);
                    end
                end
            end
        end
    end
end

MB_succ = success;
MB = trajectories;