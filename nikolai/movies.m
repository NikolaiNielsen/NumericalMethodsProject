clear all
close all
clc

load('twotowns')
a = full(A);
N = length(a);
nNeigh = mean(sum(a));
T = 100;
pImmune = 0.35;
mortality = 1;
tCured = 5;
sigCured = 1;
R0 = 2;
index = 1:N;



[sickCount,immuneCount,deadCount] = disease(a,T,tCured,sigCured,R0,pImmune,mortality);

%% plotting

% load('moviedata')
g = graph(a);

filename = 'immune1.avi';
v = VideoWriter(filename,'Uncompressed AVI');
v.FrameRate = 2;
% v.Quality = 100;
open(v)
f = figure;
h = plot(g);
h.NodeLabel = [];
axis off
for t = 1:size(sickCount,1)
	sick = sickCount(t,:);
	immune = immuneCount(t,:);
	dead = deadCount(t,:);
	highlight(h,index(sick),'NodeColor','r')
	highlight(h,index(immune),'NodeColor','g')
	highlight(h,index(dead),'NodeColor','k')
	title(sprintf('t = %d',t))
	drawnow
	frame = getframe(f);
	writeVideo(v,frame);
end
close(v)