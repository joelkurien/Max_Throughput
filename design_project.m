%node names: 1 2 3 4
%distance of nodes from broadcasting station: 
distBS = [1 2 3 4];
sourceNode = [1 1 2 3 3 4 4];
destNode = [2 3 1 2 4 2 3];
graph = digraph(sourceNode, destNode);
plot(graph, "Source", "Destination")