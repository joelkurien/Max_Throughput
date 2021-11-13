function gijsum = GijxpFunction(gii, newPower, i)
    gijsum = 0;
    j = 1;
    while j<=4 && i~=j
        gijsum = gijsum + (gii(j)/gii(i)*newPower(j));
        j = j+1;
    end
end