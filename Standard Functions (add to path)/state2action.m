function action = state2action(state,next_state)
%STATE2ACTION Summary of this function goes here
%   Detailed explanation goes here

for i = 1:length(state)
    if (next_state(i) - state(i) == -10)
        action(i) = "N";
    elseif (next_state(i) - state(i) == 10)
        action(i) = "S";
    elseif (next_state(i) - state(i) == -1)
        action(i) = "W";
    elseif (next_state(i) - state(i) == 1)
        action(i) = "E";
    else 
        action(i) = "";
        warning('discontinuous input trajectory')
    end
end

