clear all
close all
clc


% N = 100;
T = 100;
load randommat
tCured = 5;
sigCured = 0.5;
R0 = 5;
pImmune = 0.5;

[g, sickCount, immuneCount, dead] = disease(a,T,tCured,sigCured,R0,pImmune);
index = 1:length(a);
T = size(immuneCount,1);

figure
h = plot(g);
% for t = 1:T
% 	sick = sickCount(t,:);
% 	immune = immuneCount(t,:);
% 	highlight(h,index(sick),'NodeColor','r')
% 	highlight(h,index(immune),'NodeColor','g')
% 	pause(0.5)
% end

figure
yyaxis('left')
plot(sum(sickCount,2))
yyaxis('right')
plot(sum(immuneCount,2))
legend('sick','immune')