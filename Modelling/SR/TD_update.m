function [new_M] = TD_update(M, state, next_state, gamma, alpha )
%TD_UPDATE Summary of this function goes here
%   Detailed explanation goes here
new_M = M;

new_M(state,:) = M(state,:) + alpha*(1*(1:100 == state) + gamma * M(next_state,:) - M(state,:));

end

