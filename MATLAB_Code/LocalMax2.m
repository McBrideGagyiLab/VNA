% This code was written by John Peters in the McBride-Gagyi lab
% at Saint Louis University.
% This code is licensed under the GNU General Public License v3.0 (see
% LICENSE for details).
function [val, change,valX,valY,valZ] = LocalMax2(val, valX, valY, valZ, distData)

change = false;

    for i = -1:1
       for j = -1:1
           for k = -1:1
      
               if (~(i == 0 && j == 0 && k == 0))
                   if (distData(valX+i,valY+j,valZ+k) > val)
                       
                        val = distData(valX+i,valY+j,valZ+k);
                        change = true;
                       
                   end
               end
               
           end
       end
    end
   
end