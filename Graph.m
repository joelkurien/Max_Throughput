%node names: 1 2 3 4
%distance of nodes from broadcasting station: 
distBS = [1 1.5 1.25 1.75];
sourceNode = [1 1 2 3 3 4 4];
destNode = [2 3 1 2 1 2 3];
graph = digraph(sourceNode, destNode);
gii = [0 0 0 0];
mean = 0;
variance = 6;
r = normrnd(mean,variance);
for i=1:4
    hii=0.97 * distBS(i).^-3;
    sumgii=0;
    for j=1:10
        sumgii=sumgii+(hii*10.^(0.1*r));
    end
    gii(i)=sumgii/10;
end
gij = zeros(7,1)';
for i=1:7
   hij=0.97 * abs(distBS(sourceNode(i))-distBS(destNode(i))).^-3;
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
for i=2:7
    if(sourceNode(i) == sourceNode(i-1))
        Gij(sourceNode(i)) = gij(i-1)/gii(sourceNode(i-1)) + gij(i)/gii(sourceNode(i));
    else
        if(i<7)
            if(sourceNode(i) ~= sourceNode(i+1))
                Gij(sourceNode(i)) = gij(i)/gii(sourceNode(i)); 
            end
        end
    end
end

threshold = 10^(-20);
newpower = [0.01 0.01 0.01 0.01];
%implementation of optimal power for maximum throughput
for i=1:4
    while 1
        if (newpower(i)<=2)
            avg_SINR = averageSINRfn(gii, gij, sourceNode, destNode, newpower);
            gijsum = GijFunction(gii, gij, sourceNode, destNode, newpower);
            omega = 1+newpower(i)/(targetSINR.*(gijsum(i) + awgn/gii(i)));
            u_value = (newpower(i)*omega).^2/(newpower(i) + targetSINR.*(gijsum(i) + awgn/gii(i))).^4;
            powert1 = omega.^2/(u_value.*(1+targetSINR*Gij(i)).^2);
        end
        if(abs(powert1-newpower(i))>threshold)
            newpower(i) = powert1;
        else
            break;
        end
    end
end
newpower
% powerMatrix = [nodePower; newpower];
bar(newpower);
