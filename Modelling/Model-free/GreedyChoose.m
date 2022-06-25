function [ action ] = GreedyChoose(V, state, A_allowed)
%GREEDYCHOOSE Summary of this function goes here
%   Detailed explanation goes here
poss_a = find(A_allowed(state,:) == 1);
poss_next = [];

for i = 1:length(poss_a)
    [next, ~] = action2state(state,poss_a(i), A_allowed);
    poss_next = [poss_next, next];
end

[mx,umax] = nanmax(V(poss_next));
if (sum(V(poss_next) == mx) > 1)    
    umax = datasample(find(V(poss_next) == mx),1);
end

action = poss_a(umax);

end

