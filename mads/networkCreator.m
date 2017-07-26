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

save('twoTowns.mat','A')

%%

x = random_modular_graph(100,3,0.4,1);

G = graph(x);

moduleOne = find(conncomp(G)==1);
moduleTwo = find(conncomp(G)==2);
moduleThree = find(conncomp(G)==3);

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

for i = 1:4
    neighModuleTwo = neighbors(G,moduleTwo(i));
    neighModuleThree = neighbors(G,moduleThree(i));
    neigh = unique(cat(1,neighModuleTwo,neighModuleThree));
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
plot(G,'Layout','force')

A = adjacency(G);

save('threeTowns.mat','A')

%%

x = random_modular_graph(100,3,0.4,1);

G = graph(x);

figure()
plot(G,'Layout','force')

A = adjacency(G);

save('threeIslands.mat','A')