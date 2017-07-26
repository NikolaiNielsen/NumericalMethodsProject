clear all
close all
clc

R0 = 1;
mortality = 0.575;
name = 'Ebola';

N = 1000;
T = 100;
tCured = 5;
sigCured = 0.5;
% pImmune = 0.5;
numSims = 50;
numNetworks = 50;
nNeigh = 15;
pImmune = 0.0:0.05:0.95;


%% Random
sickNet = cell(length(pImmune),numNetworks);
for p = 1:length(pImmune)
for j = 1:numNetworks
	a = adjmatrix(N,nNeigh);
	sicks = zeros(1,numSims);
	for i = 1:numSims
		[sickCount, ~, ~] = disease(a,T,tCured,sigCured,R0,pImmune(p),mortality);

		% index = 1:length(a);
		% T = size(immuneCount,1);
		% figure
		% h = plot(g);
		% for t = 1:T
		% 	sick = sickCount(t,:);
		% 	immune = immuneCount(t,:);
		% 	highlight(h,index(sick),'NodeColor','r')
		% 	highlight(h,index(immune),'NodeColor','g')
		% 	pause(0.5)
		% end
		sicks(1,i) = sum(sum(sickCount,1)>0);
    end
	sickNet{p,j} = sicks;
    fprintf('r:  %02d to go. p = %d/%d\n',numNetworks-j,p,length(pImmune))
end
end
try
    save(sprintf('../data/r%s.mat',name),'sickNet','nNeigh','pImmune')
catch
    save(sprintf('../data/r%s.mat',name),'sickNet','nNeigh','pImmune')
end

%% Scale free
sickNet = cell(length(pImmune),numNetworks);
for p = 1:length(pImmune)
for j = 1:numNetworks
	[s,t] = scalefree(N,nNeigh);
    a = [s,t];
	sicks = zeros(1,numSims);
	for i = 1:numSims
		[sickCount, ~, ~] = disease(a,T,tCured,sigCured,R0,pImmune(p),mortality);

		% index = 1:length(a);
		% T = size(immuneCount,1);
		% figure
		% h = plot(g);
		% for t = 1:T
		% 	sick = sickCount(t,:);
		% 	immune = immuneCount(t,:);
		% 	highlight(h,index(sick),'NodeColor','r')
		% 	highlight(h,index(immune),'NodeColor','g')
		% 	pause(0.5)
		% end
		sicks(1,i) = sum(sum(sickCount,1)>0);
    end
	sickNet{p,j} = sicks;
    fprintf('sf: %02d to go. p = %d/%d\n',numNetworks-j,p,length(pImmune))
end
end
try
    save(sprintf('../data/sf%s.mat',name),'sickNet','nNeigh','pImmune')
catch
    save(sprintf('../data/sf%s.mat',name),'sickNet','nNeigh','pImmune')
end

%% Small world
sickNet = cell(length(pImmune),numNetworks);
for p = 1:length(pImmune)
for j = 1:numNetworks
	[s,t] = smallworld(N,nNeigh,0.2);
    a = [s,t];
	sicks = zeros(1,numSims);
	for i = 1:numSims
		[sickCount, ~, ~] = disease(a,T,tCured,sigCured,R0,pImmune(p),mortality);

		% index = 1:length(a);
		% T = size(immuneCount,1);
		% figure
		% h = plot(g);
		% for t = 1:T
		% 	sick = sickCount(t,:);
		% 	immune = immuneCount(t,:);
		% 	highlight(h,index(sick),'NodeColor','r')
		% 	highlight(h,index(immune),'NodeColor','g')
		% 	pause(0.5)
		% end
		sicks(1,i) = sum(sum(sickCount,1)>0);
    end
	sickNet{p,j} = sicks;
    fprintf('sw: %02d to go. p = %d/%d\n',numNetworks-j,p,length(pImmune))
end
end
try
    save(sprintf('../data/sw%s.mat',name),'sickNet','nNeigh','pImmune')
catch
    save(sprintf('../data/sw%s.mat',name),'sickNet','nNeigh','pImmune')
end


% figure
% hold on
% plot(sicks,'.')
% plot([1,100],[nNeigh,nNeigh])