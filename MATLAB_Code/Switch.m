
function [old] = Switch(old,pos1,pos2)

    temp = old(pos1,:);
    old(pos1,:) = old(pos2,:);
    old(pos2,:) = temp;

end