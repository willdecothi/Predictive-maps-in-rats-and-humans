load('rat.mat')
load('humans.mat')

x0 = [0.5,0.5];
lb = [0,0]; ub = [1,1];
A = []; b = []; Aeq = []; beq = [];

dat = humans;
% dat = rat;

n_ppt = size(dat,1);
n_params = length(x0);
ppt_params = zeros(n_ppt, n_params);
ll = 0;

parfor i = 1:n_ppt
    fun = @(x)-SR_lik(x,dat(i,:,:));
    options = optimset('Display','iter','PlotFcns',@optimplotfval);
    [x,f_val] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,[],options);

    ppt_params(i,:) = x;
    ll = f_val + ll;
end