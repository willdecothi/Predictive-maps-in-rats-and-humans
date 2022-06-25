load('rat.mat')
load('SR.mat')
load('MB.mat')
load('Q.mat')


rat_diff = cellfun(@diffusivity,rat);
SR_diff = cellfun(@diffusivity,SR);
MB_diff = cellfun(@diffusivity,MB);
Q_diff = cellfun(@diffusivity,Q);

[rat_sin_ang, rat_cos_ang] = cellfun(@AngleDiff,rat);
[SR_sin_ang, SR_cos_ang] = cellfun(@AngleDiff,SR);
[MB_sin_ang, MB_cos_ang] = cellfun(@AngleDiff,MB);
[Q_sin_ang, Q_cos_ang] = cellfun(@AngleDiff,Q);

function [ D ] = diffusivity( x )
%DIFFUSIVITY Summary of this function goes here
%   Detailed explanation goes here
delta = 3;
if (isempty(x))
    D = NaN;
else
    y = [];
    for i = 1:(length(x)-delta)
        [x1,y1] = state2coords(x(i));
        [x2,y2] = state2coords(x(i+delta));
        y = [y, (x2-x1)^2 + (y2-y1)^2];
    end
    D = 20^2 * mean(y)/delta;
end
end

function [sin_D, cos_D] = AngleDiff( x )
%ANGLE Summary of this function goes here
%   clockwise is +ive, acw is -ive
delta = 3;

if (isempty(x))
    [sin_D, cos_D] = deal(NaN);
else
    y = [];
    for i = 1:(length(x)-delta)
        [x1,y1] = state2coords(x(i));
        [x2,y2] = state2coords(x(i+delta));
        y = [y, atan2d((y2-y1),(x2-x1))];
    end
    sin_D = mean(sind(y));
    cos_D = mean(cosd(y));
end
end