clear all
close all
clc


N = 1000;
T = 100;
tCured = 5;
sigCured = 0.5;
R0 = 5;
pImmune = 0.5;
numSims = 100;
numNetworks = 100;
nNeigh = 15;
a = adjmatrix(N,nNeigh);

[sickCount, immuneCount, deadCount] = disease(a,T,tCured,sigCured,R0,pImmune,0.25);
g = graph(a);

index = 1:length(a);
T = size(immuneCount,1);
figure
h = plot(g);
for t = 1:T
	sick = sickCount(t,:);
	immune = immuneCount(t,:);
	dead = deadCount(t,:);
	living = (~sick & ~immune & ~dead);
	highlight(h,index(sick),'NodeColor','r')
	highlight(h,index(immune),'NodeColor','g')
	highlight(h,index(dead),'NodeColor','k')
	highlight(h,index(living),'NodeColor','b')
	pause(0.5)
end