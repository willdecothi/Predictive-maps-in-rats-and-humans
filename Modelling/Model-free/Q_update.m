function new_Q = Q_update(old_Q, state, action, reward, next_state, gamma, alpha)
%Q_UPDATE Summary of this function goes here
%   Detailed explanation goes here
new_Q = old_Q;
new_Q(state, action) = old_Q(state,action) + alpha * (reward + gamma * max(old_Q(next_state,:)) - old_Q(state,action));

end

