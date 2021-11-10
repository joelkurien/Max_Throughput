%node names: 1 2 3 4
%distance of nodes from broadcasting station: 
distBS = [0.1 0.15 0.125 0.175];
sourceNode = [1 1 1 2 2 2 3 3 3 4 4 4];
destNode =   [2 3 4 1 3 4 1 2 4 1 2 3];
graph = digraph(sourceNode, destNode);
gii = [0 0 0 0];
mean = 0;
variance = 2;
r = variance*randn(1,1);
size_mat = size(sourceNode);
length = size_mat(2);
for i=1:4
    hii=0.97 * distBS(i).^-3;
    sumgii=0;
    for j=1:10
        sumgii=sumgii+(hii*10.^(0.1*r));
    end
    gii(i)=sumgii/10;
end
gij = zeros(length,1)';
for i=1:length
   hij=0.97* abs(distBS(sourceNode(i))-distBS(destNode(i))).^-3;
   sumgij=0;
   for j=1:10
       sumgij=sumgij+(hij*10.^(0.1*r));
   end
   gij(i)=sumgij/10; 
end
targetSINR = -25;
awgn = 0.01;
nodePower = [0.01 0.01 0.01 0.01];

Gij = zeros(4,1)';
for i=2:length
    if(sourceNode(i) == sourceNode(i-1))
        Gij(sourceNode(i)) = gij(i-1)/gii(sourceNode(i-1)) + gij(i)/gii(sourceNode(i));
    else
        if(i<length)
            if(sourceNode(i) ~= sourceNode(i+1))
                Gij(sourceNode(i)) = gij(i)/gii(sourceNode(i)); 
            end
        end
    end
end

%Algorithm for finding power for maxium throughput
threshold = 10^(-20);
newpower = [0.01 0.01 0.01 0.01];
%implementation of optimal power for maximum throughput
oppower = zeros(4,1)';
j=1;
while j<=10
    for i=1:4
        if (newpower(i)<=2)
%               avg_SINR = averageSINRfn(gii, gij, sourceNode, destNode, newpower);
            gijsum = GijxpFunction(gii, gij, sourceNode, destNode, newpower, i);
            omega = 1+newpower(i)/(targetSINR.*(gijsum + awgn/gii(i)));
            u_value = (newpower(i)*omega).^2/(newpower(i) + targetSINR.*(gijsum + awgn/gii(i))).^4;
            powert1 = omega.^2/(u_value.*(1+targetSINR*Gij(i)).^2);
            oppower(i) = powert1;
        end
    end
    for i=1:4
        if (abs(oppower(i)-newpower(i))>threshold)
            newpower(i) = oppower(i);
        else
            continue;
        end
    end
    j=j+1;
end
powerMatrix = [nodePower; newpower];
newpower
bar(powerMatrix);

%calculate throughput for 100000000 bits per second or 10Mbps of data
throughput = zeros(4,1)';
dataRate = 1000000;
for i=1:4
    throughput(i) = dataRate/newpower(i);
end
throughput
bar(throughput)