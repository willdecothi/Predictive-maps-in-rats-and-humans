function [new_M] = TD_trace_update(M, E, state, next_state, gamma, alpha )
%TD_UPDATE Summary of this function goes here
%   Detailed explanation goes here

new_M = M + alpha * E' * ((1:100 == state) + gamma * M(next_state,:) - M(state,:));

end

