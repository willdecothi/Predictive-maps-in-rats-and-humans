%% This function is used as an observer to give the next state and the next reward using the current state and action
function [next_state,r] = action2state(state,a_idx, A_allowed)

%A_space = [0,-1;1,-1;1,0;1,1;0,1;-1,1;-1,0;-1,-1];
A_space = [0,-1;1,0;0,1;-1,0];
[x,y] = state2coords(state);

if (A_allowed(state,a_idx) == 1) 
    next_x = x + A_space(a_idx,1);
    next_y = y + A_space(a_idx,2);
    next_state = coords2state(next_x,next_y);
else
    next_state = state;
    next_x = x;
    next_y = y;
end

if (next_x == 4 && next_y == 4)
    r = 1;
else 
    %r = -1e-5;
    r =0;
end
end