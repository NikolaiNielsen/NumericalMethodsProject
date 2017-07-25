clear all
close all
clc

N = 1000;
T = 100;
p = 0.1;
tCured = 10;
pImmune = 0.5;
nNeigh = 15;

% R0: average number of transmissions for an individual, over the period of
% sickness (tCured)
% R0/tCured = average number of transmissions for an individual, per round
% (R0/tCured)/nNeigh = probability of spreading disease to every individual
% neighbour.
% pMat = (1+nNeigh/N)/2;

% a = adjmatrix(N,pMat);
[s,t] = scalefree(N,3);
% [s,t] = smallworld(N,100,0.2);
a = zeros(N);
for i = 1:length(s)
   a(s(i),t(i)) = 1; 
end
a(end,end) = 0;
a = a+a';
g = graph(a);

index = 1:N;
sick = false(1,N);
sick([16 ]) = 1;
immune = false(1,N);
immune(rand(1,N) <= pImmune) = 1;
immune(sick & immune) = 0;
countdown = zeros(size(sick));
countdown(sick) = tCured+1;


figure
h = plot(g,'Layout','circle');
highlight(h,index(sick),'NodeColor','r')
drawnow
highlight(h,index(immune),'NodeColor','g')

sickCount = zeros(T,N);
sickCount(1,:) = sick;

for t = 2:T
	m = index(sick); % Get index of sick individuals
	% Loop over the sick individuals
	for i = 1:length(m)
		% Get the neighbours
		neigh = index(logical(a(:,m(i))));
		
		% The raw index of newly sick people
		newsick = neigh(rand(size(neigh)) <= p);
		
		% sanitize the newsick, to account for immunity.
		% Doesn't work....
% 		newsick = index(~immune(newsick));
		
		% initiate cure countdown for newly sick
		countdown(newsick) = tCured+1;
		
		% Include the newly sick in the sick vector
		sick(newsick) = 1;
		
		% proper Sanitation of sickness
		sick(sick & immune) = 0;
		countdown(sick & immune) = 0;
	end
	% count down the countdown (for all that are sick and therefore not 0)
	countdown(countdown ~= 0) = countdown(countdown ~= 0) - 1;
	
	% make cured people healthy
	immune(sick & ~countdown) = 1;
	sick(sick & ~countdown) = 0;
	sickCount(t,:) = sick;
	
	% update the plot
	highlight(h,index(sick),'NodeColor','r')
	highlight(h,index(~sick & ~immune),'NodeColor','b')
	title(sprintf('t=%d',t))
	pause(0.5)
	
	% Don't wanna go to far if unnecessary (God, I butchered that)
	if sum(sick) == N || sum(sick) == 0
		break
	end
end

% figure
% h = plot(g,'Layout','circle');
highlight(h,index(sick),'NodeColor','r')
highlight(h,index(immune),'NodeColor','g')
highlight(h,index(~sick & ~immune),'NodeColor','k')

figure
plot(sum(sickCount,2))
% plot(N-sum(immune)-sum(sickCount,2))
xlabel('time')
ylabel('sick individuals')
% ylabel('healthy, non-immune individuals')

