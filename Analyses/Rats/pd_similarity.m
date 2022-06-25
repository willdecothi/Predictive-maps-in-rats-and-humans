function pd_sim = pd_similarity(reference_traj,target_traj,map)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
pd_sim = zeros(size(reference_traj));
for i = 1:length(pd_sim)
    state = reference_traj(i);
    [state_x,state_y] = state2coords(state);
    target_dists = zeros(size(target_traj));
    for j = 1:length(target_traj)
        target_state = target_traj(j);
        [target_x,target_y] = state2coords(target_state);
        goal = zeros(10);
        goal(target_y, target_x) = 1;
        if goal(state_y, state_x) == 1
            target_dists(j) = 0;
        else
            target_dists(j) = ASTARPATH(state_x,state_y,map,goal);
        end
    end
    pd_sim(i) = min(target_dists);
end
end