function [g,sickCount,immune,dead] = disease(a,T,tCured,R0,pImmune)

[r,c] = size(a);
if r == c % Square matrix
	N = r;
elseif c == 2 % Edgelist
	N = max(a(:));
	s = a(:,1);
	t = a(:,2);
	a = zeros(N);
    for i = 1:length(a)
       a(s(i),t(i)) = 1; 
    end
    a(end,end) = 0;
    a = a+a';
else
	error('du er dum. a skal v�re Nx2 eller NxN')
end
nNeigh = mean(sum(a));

% R0: average number of transmissions for an individual, over the period of
% sickness (tCured)
% R0/tCured = average number of transmissions for an individual, per round
% (R0/tCured)/nNeigh = probability of spreading disease to every individual
% neighbour.
p = R0/(tCured*nNeigh);


g = graph(a);


index = 1:N;
sick = false(1,N);
immune = false(1,N);
immune(rand(1,N) <= pImmune) = 1;
sick(find(~immune,1)) = 1; % make the first non-immune person sick
% immune(sick & immune) = 0;
countdown = zeros(size(sick));
countdown(sick) = tCured;
dead = false(1,N);

sickCount = zeros(T,N);
sickCount(1,:) = sick;
countCount = zeros(T,N);
countCount(1,:) = countdown;

for t = 2:T
	m = index(sick); % Get index of sick individuals
	% Loop over the sick individuals
	for i = 1:length(m)
		% Get the neighbours
		% Logical array of neighbours for the m'th node
		rawneigh = logical(a(:,m(i)));
		% index values for the neighbours for the m'th node.
		neigh = index(rawneigh);
		
		% logical array of which neighbours should get sick
		rawsick = rand(size(neigh)) <= p;
		
		% Translate to indecies for the sick vector
		newsick = neigh(rawsick);
		
		% Delete the already sick from newsick:
		alreadysick = (sick(newsick) == 1);
		newsick(alreadysick) = [];

		% initiate cure countdown for newly sick
		countdown(newsick) = tCured+1;
		
		% Include the newly sick in the sick vector
		sick(newsick) = 1;
		
		% proper Sanitation of sickness
		countdown(sick & immune) = 0;
		sick(sick & immune) = 0;
	end
	% count down the countdown (for all that are sick and therefore not 0)
	countdown(countdown ~= 0) = countdown(countdown ~= 0) - 1;
	
	% make cured people healthy
	immune(sick & ~countdown) = 1;
	sick(sick & ~countdown) = 0;
	sickCount(t,:) = sick;
	countCount(t,:) = countdown;
	
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
