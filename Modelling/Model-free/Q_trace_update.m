function new_Q = Q_trace_update(old_Q, trace, state, action, reward, next_state, gamma, alpha)
%Q_UPDATE Summary of this function goes here
%   Detailed explanation goes here
new_Q = old_Q;
new_Q = old_Q + trace .* alpha * (reward + gamma * max(old_Q(next_state,:)) - old_Q(state,action));

end

