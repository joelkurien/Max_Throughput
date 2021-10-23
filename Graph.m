%node names: 1 2 3 4
%distance of nodes from broadcasting station: 
distBS = [1 2 3 4];
sourceNode = [1 1 2 3 3 4 4];
destNode = [2 3 1 2 4 2 3];
graph = digraph(sourceNode, destNode);
hii = [0 0 0 0];
for i=1:4
    hii(i)=0.97 * distBS(i).^-3;
end
r = normrnd(0.707,0.707);
gii=[0 0 0 0];
for i=1:4
    sumgii=0;
    for j=1:10
        sumgii=sumgii+(hii(i)*10.^(0.1*r));
    end
    gii(i)=sumgii/10;
end
gii