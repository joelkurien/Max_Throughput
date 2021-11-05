function avgSINR = averageSINRfn(gii, gij, sourceNode, destNode, nodePower)
    Gijxp = zeros(4,1)';
    for i=2:7
        if(sourceNode(i) == sourceNode(i-1))
            Gijxp(sourceNode(i)) = gij(i-1)*nodePower(destNode(i-1)) + gij(i)*nodePower(destNode(i-1));
        else
            if(i<7)
                if(sourceNode(i) ~= sourceNode(i+1))
                    Gijxp(sourceNode(i)) = gij(i)*nodePower(destNode(i)); 
                end
            end
        end
    end
    awgn = 0.01;
    avgSINR = zeros(4,1);
    for i=1:4
        avgSINR(i) = (gii(i)*nodePower(sourceNode(i)))/(Gijxp(i) + awgn/gii(i));
    end
end