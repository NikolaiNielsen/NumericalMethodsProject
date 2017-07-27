clear all
close all
clc

R0 = 2;
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
sickData = cell(length(pImmune),numNetworks,numSims);
immuneData = sickData;
deadData = sickData;
for p = 1:length(pImmune)
for j = 1:numNetworks
	a = adjmatrix(N,nNeigh);
	sicks = zeros(1,numSims);
	for i = 1:numSims
		[sickData{p,j,i}, immuneData{p,j,i}, deadData{p,j,i}] ...
			= disease(a,T,tCured,sigCured,R0,pImmune(p),mortality);
		sicks(1,i) = sum(sum(sickData{p,i,j},1)>0);
    end
	sickNet{p,j} = sicks;
    fprintf('r:  %02d to go. p = %d/%d\n',numNetworks-j,p,length(pImmune))
end
end
try
    save(sprintf('../data/r%s.mat',name),'sickNet','nNeigh','pImmune',...
        'sickData','immuneData','deadData')
catch
    % try again
    try
        save(sprintf('../data/r%s.mat',name),'sickNet','nNeigh','pImmune',...
            'sickData','immuneData','deadData')
    catch
       error(sprintf('Could not save. name = r%s, p = %d, j = %d',name,p,j))
    end
end

% %% Scale free
% % sickNet = cell(length(pImmune),numNetworks);
% % sickData = cell(length(pImmune),numNetworks,numSims);
% % immuneData = sickData;
% % deadData = sickData;
% for p = 11:length(pImmune)
% for j = 1:numNetworks
% 	[s,t] = scalefree(N,nNeigh);
%     a = [s,t];
% 	sicks = zeros(1,numSims);
% 	for i = 1:numSims
% 		[sickData{p,j,i}, immuneData{p,j,i}, deadData{p,j,i}] ...
% 			= disease(a,T,tCured,sigCured,R0,pImmune(p),mortality);
% 		sicks(1,i) = sum(sum(sickData{p,i,j},1)>0);
%     end
% 	sickNet{p,j} = sicks;
%     fprintf('sf: %02d to go. p = %d/%d\n',numNetworks-j,p,length(pImmune))
% end
% end
% try
%     save(sprintf('../data/sf%s.mat',name),'sickNet','nNeigh','pImmune',...
%         'sickData','immuneData','deadData')
% catch
%     % try again
%     try
%         save(sprintf('../data/sf%s.mat',name),'sickNet','nNeigh','pImmune',...
%             'sickData','immuneData','deadData')
%     catch
%        error(sprintf('Could not save. name = sf%s, p = %d, j = %d',name,p,j))
%     end
% end
% 
% %% Small world
% sickNet = cell(length(pImmune),numNetworks);
% sickData = cell(length(pImmune),numNetworks,numSims);
% immuneData = sickData;
% deadData = sickData;
% for p = 1:length(pImmune)
% for j = 1:numNetworks
% 	[s,t] = smallworld(N,nNeigh,0.2);
%     a = [s,t];
% 	sicks = zeros(1,numSims);
% 	for i = 1:numSims
% 		[sickData{p,j,i}, immuneData{p,j,i}, deadData{p,j,i}] ...
% 			= disease(a,T,tCured,sigCured,R0,pImmune(p),mortality);
% 		sicks(1,i) = sum(sum(sickData{p,i,j},1)>0);
%     end
% 	sickNet{p,j} = sicks;
%     fprintf('sw: %02d to go. p = %d/%d\n',numNetworks-j,p,length(pImmune))
% end
% end
% try
%     save(sprintf('../data/sw%s.mat',name),'sickNet','nNeigh','pImmune',...
%         'sickData','immuneData','deadData')
% catch
%     % try again
%     try
%         save(sprintf('../data/sw%s.mat',name),'sickNet','nNeigh','pImmune',...
%             'sickData','immuneData','deadData')
%     catch
%        error(sprintf('Could not save. name = sw%s, p = %d, j = %d',name,p,j))
%     end
% end
% 
% 
% % figure
% % hold on
% % plot(sicks,'.')
% plot([1,100],[nNeigh,nNeigh])