%node names: 1 2 3 4
%distance of nodes from broadcasting station: 
distBS = [1 2 3 4];

%calculating the average channel gain of a connection between the sender
%and the recieving target node
gii = [0 0 0 0];
mean = 0;
variance = 6;
r = variance*randn(1,1);
for i=1:4
    hii=0.97 * distBS(i).^-3;
    sumgii=0;
    for j=1:10
        sumgii=sumgii+(hii*10.^(0.1*r));
    end
    gii(i)=sumgii/10;
end

targetSINR = 0.1;
awgn = 0.01;
nodePower = 0.01; %power for data transmission from a node to the target node

%calculating an array for storing the values of Gij for each node
Gij = zeros(4,1)';
for i=1:4
    Gijsum = 0;
    for j=1:4
        if j ~= i
            Gijsum = Gijsum + gii(j)/gii(i);
        end
    end
    Gij(i) = Gijsum;
end

%Algorithm for finding power for maxium throughput
threshold = 10^(-20);
newpower = [0.01 0.01 0.01 0.01]; %stores the new power of data transmission between a sender and the target node

%implementation of optimal power for maximum throughput
oppower = zeros(4,1)';
j=1;
while j<=1000
    for i=1:4
        if (newpower(i)<=2)
            %gijsum is the value of Gij x power of data transmission of the
            %interfence nodes to the target node
            gijsum = GijxpFunction(gii, newpower, i);
            omega = 1+newpower(i)/(targetSINR.*(gijsum + awgn/gii(i)));
            u_value = (newpower(i)*omega).^2/(newpower(i) + targetSINR*(gijsum + awgn/gii(i))).^4;
            powert1 = omega.^2/(u_value*(1+targetSINR*Gij(i)).^2);
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
newpower

%calculate throughput for 100000000 bits per second or 10Mbps of data
throughput = zeros(4,1)';

for i=1:4
    gijsum = GijxpFunction(gii, newpower, i);
    throughput(i) = log(1+(newpower(i)/(targetSINR*(gijsum + awgn/gii(i)))));
end

throughput

bar(newpower, throughput)
title("Throughput Maximization")
xlabel("Optimized data transmission power")
ylabel("Throughput for optimized power")