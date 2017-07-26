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

sickNet = zeros(1,numNetworks);
for j = 1:numNetworks
	a = adjmatrix(N,nNeigh);
	sicks = zeros(1,numSims);
	for i = 1:numSims
		[~, sickCount, ~, ~] = disease(a,T,tCured,sigCured,R0,pImmune);

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
		sicks(1,i) = max(sum(sickCount,2));
	end
	herd = sum(sicks<=nNeigh);
	perc = herd/numSims;
	sickNet(j) = perc;
    fprintf('%d networks tested. %d to go\n',j,numNetworks-j)
end

% figure
% hold on
% plot(sicks,'.')
% plot([1,100],[nNeigh,nNeigh])