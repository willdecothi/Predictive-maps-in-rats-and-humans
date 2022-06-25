function [ best_action ] = MB_planning(state_id, blief_map, gamma, A_allowed)
%MB_planning Summary of this function goes here
%   Detailed explanation goes here
goal = zeros(10); goal(4,4) = 1;

poss_a = find(A_allowed(state_id,:) == 1);
poss_next = [];
V = [];
for i = 1:length(poss_a)
    [next, ~] = action2state(state_id,poss_a(i), A_allowed);
    poss_next = [poss_next, next];
    if (next == 34)
        V = [V, 1];
    else
        [x,y] = state2coords(next);
        blief_map(y,x) = 0;
        d = ASTARPATH(x,y,blief_map,goal);
        if (d > 0)
            V = [V, gamma^(d-1)];
        else
            V = [V, 0];
        end
    end
end

[mx,umax] = nanmax(V);
if (sum(V == mx) > 1)
    umax = datasample(find(V == mx),1);
end

best_action = poss_a(umax);

end

