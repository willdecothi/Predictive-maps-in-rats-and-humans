%% converts from (x,y) grid (starting in north-west corner) to 1-300 states (starting in north-west corner and moving east)
function state = coords2state(x,y)

state = 10*(mod(y-1,10)) + x;

end
