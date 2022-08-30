function [ new_map ] = update_bliefs_Dileep_George_request( blief_map, state, map)
%UPDATE_BLIEFS Summary of this function goes here
%   Detailed explanation goes here

alpha=1;
vis=0;

[state_x, state_y] = state2coords(state);

ids = zeros(10); ids(state_y,state_x) = 1;
ids = bwdist(ids) <= vis;

blief_map(ids) = blief_map(ids) + alpha * ((map(ids) == -1) - blief_map(ids));

new_map = blief_map;
end

