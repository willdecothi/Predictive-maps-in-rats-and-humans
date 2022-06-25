%% converts from 1-100 states (starting in north-west corner and moving east) to (x,y) grid (starting in north-west corner)
function [x,y] = state2coords(state)

x = mod(state - 1,10) + 1;
y = ceil(state/10);
end