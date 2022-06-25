function allowed = map2allowed(map)
% 0's are available moves, 1's are unavailable

%A_space = [0,-1;1,-1;1,0;1,1;0,1;-1,1;-1,0;-1,-1]; % actions start at north and rotate clockwise
A_space = [0,-1;1,0;0,1;-1,0]; % actions start at north and rotate clockwise
n_actions = length(A_space);
allowed = zeros(numel(map),n_actions);

for i = 1:numel(map)
    [x,y] = state2coords(i);
    for a = 1:length(A_space)
        if (x + A_space(a,1) > 0 && x + A_space(a,1) < 11 && y + A_space(a,2) > 0 && y + A_space(a,2) < 11) %make sure we are not off the map
           if  (map(y + A_space(a,2),x + A_space(a,1)) >= 0)
               allowed(i,a) = 1;
           end
        end
    end
end
allowed = allowed == 1;
end

