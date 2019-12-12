% This code was written by John Peters in the McBride-Gagyi lab
% at Saint Louis University.
% This code is licensed under the GNU General Public License v3.0 (see
% LICENSE for details).
function [val, valX,valY,valZ] = LocalMax(val, valX, valY, valZ, distData)
    

    for i = -1:1
       for j = -1:1
           for k = -1:1

               if (~(i == 0 && j == 0 && k == 0))
                   if (distData(valX+i,valY+j,valZ+k) > val)

                        val = distData(valX+i,valY+j,valZ+k);
                        [val, valX,valY,valZ] = LocalMax(val,valX+i,valY+j,valZ+k,distData);

                   end
               end

           end
       end
    end
   
end