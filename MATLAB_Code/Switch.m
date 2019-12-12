% This code was written by John Peters in the McBride-Gagyi lab
% at Saint Louis University.
% This code is licensed under the GNU General Public License v3.0 (see
% LICENSE for details).
function [old] = Switch(old,pos1,pos2)

    temp = old(pos1,:);
    old(pos1,:) = old(pos2,:);
    old(pos2,:) = temp;

end