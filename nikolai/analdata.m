clear all
close all
clc

names = {'Measles','Ebola','Polio'};
thresh = 5;
pImmune = 0:0.05:0.95;

for i = 1:length(names)
	name = names{i};
	load(sprintf('../data/tc%s.mat',name),'sickNet')
	[r,c] = size(sickNet);

	Herd = zeros(r,c);
	for p = 1:r
		for j = 1:c
			Herd(p,j) = sum(sickNet{p,j} <= thresh)/length(sickNet{p,j});
		end
	end
	means = mean(Herd,2);
	stds = std(Herd,0,2);

	% figure
	% hold on
	% errorbar(pImmune,means,stds,'.')
	% xlabel('percentage immune')
	% ylabel('percent of runs with num. sick $\leq$ 5')
	% title(sprintf(' on a small world network. N = 1000'))

	dlmwrite(sprintf('%s_twoCity.csv',name), ... 
		cat(2,pImmune',means,stds),'delimiter', ',','precision', 9);
end