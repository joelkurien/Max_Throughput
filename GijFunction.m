function gijsum = GijFunction(gii, gij, sourceNode, destNode, nodePower)
    Gijxp = zeros(4,1)';
    for i=2:7
        if(sourceNode(i) == sourceNode(i-1))
            Gijxp(sourceNode(i)) = gij(i-1)/gii(sourceNode(i-1))*nodePower(destNode(i-1)) + gij(i)/gii(sourceNode(i))*nodePower(destNode(i-1));
        else
            if(i<7)
                if(sourceNode(i) ~= sourceNode(i+1))
                    Gijxp(sourceNode(i)) = gij(i)/gii(sourceNode(i))*nodePower(destNode(i)); 
                end
            end
        end
    end
    gijsum = Gijxp;
end