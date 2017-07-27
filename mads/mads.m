close all

x = random_modular_graph(100,2,0.4,1);

G = graph(x);
figure()
plot(G)

moduleOne = find(conncomp(G)==1);
moduleTwo = find(conncomp(G)==2);

for i = 1:4
    neighModuleOne = neighbors(G,moduleOne(i));
    neighModuleTwo = neighbors(G,moduleTwo(i));
    neigh = unique(cat(1,neighModuleOne,neighModuleTwo));
    newGuy = ones(length(neigh),1)*(size(G.Nodes,1)+1);
    G = addedge(G,newGuy,neigh,1);
    G = rmedge(G,moduleOne(i));
    G = rmedge(G,moduleTwo(i));
    clear neighModuleOne
    clear neighModuleTwo
    clear neigh
    clear newGuy
end

figure()
plot(G)

A = adjacency(G);

save('network.mat','A')

load('twoTowns.mat')

%%


people.sick = zeros(size(G.Nodes,1),1);
people.sickTime = zeros(size(G.Nodes,1),1);
people.dead = zeros(size(G.Nodes,1),1);
people.immune = zeros(size(G.Nodes,1),1);
diseaseLength = 10;

pSick = 0.01;
pImmune = 0.5;
mortalityRate = 0.5;

maxIter = 100;

for i = 1:size(G.Nodes,1)
    if rand < pImmune
        people.immune(i) = 1;
    else
        people.immune(i) = 0;
    end
end

patientZero = find(people.immune==0);

people.sick(patientZero(1)) = 1;
people.immune(patientZero(1)) = 0;
people.sickTime(patientZero(1)) = 1;

figure()
h = plot(G);
highlight(h,find(people.immune==1),'NodeColor','g');
highlight(h,find(people.sick==1),'NodeColor','r');

k = 1;

while k < maxIter && length(find(people.sick==0 & people.immune==0)) > 0 && length(find(people.sick==1)) > 0

sickos = find(people.sick==1);

for i = 1:length(sickos)
    makeSick = neighbors(G,sickos(i));
    for j = 1:length(makeSick)
        if people.immune(makeSick(j)) == 0 && people.sick(makeSick(j)) == 0 && people.dead(makeSick(j)) == 0 && rand < pSick
            people.sick(makeSick(j)) = 1;
            people.sickTime(makeSick(j)) = 1;
        end
    end
    if people.sickTime(sickos(i)) > 0
        people.sickTime(sickos(i)) = people.sickTime(sickos(i)) + 1;
        if people.sickTime(sickos(i)) == diseaseLength
            if rand < mortalityRate
                people.sickTime(sickos(i)) = 0;
                people.dead(sickos(i)) = 1;
                people.sick(sickos(i)) = 0;
            else
                people.sickTime(sickos(i)) = 0;
                people.sick(sickos(i)) = 0;
                people.immune(sickos(i)) = 1;
            end
        end
    end
end

h = plot(G,'Layout','circle');
title(['Iter ' num2str(k) ''])
highlight(h,find(people.immune==1),'NodeColor','g');
highlight(h,find(people.sick==1),'NodeColor','r');
highlight(h,find(people.dead==1),'NodeColor','k');
drawnow

if length(find(people.dead==1 & people.immune==1)) > 0
    fprintf('stop!')
end

if length(find(people.sick==1 & people.immune==1)) > 0
    fprintf('stop!2')
end

k = k + 1;

healthy(k) = length(find(people.sick==0 & people.dead==0));

end