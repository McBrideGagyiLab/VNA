

function branchInfo = CalculateDiameter(origData, branchInfo, bAcc)
    
    [M N Z] = size(origData);
    [row col] = size(branchInfo);

    % Vessels should be 0's, empty space 1's
    sumKeep = sum(sum(sum(origData)));
    sumFlip = M*N*Z - sumKeep;
    if (sumFlip > sumKeep)
        origData = abs(1-origData);
    end
    
    tic
  
    %if (M*N*Z > 1957*1932*100)
    if (bAcc)
        if(Z > 100)
            % number of iterations that need to be made
            iter = floor((Z-50)/30) + 1;
            rem = mod((Z-50),30);
            distDataO = zeros(M,N,Z);
            first = bwdistsc(origData(:,:,1:50),[1 1 1],1,iter);
            distDataO(:,:,1:39) = first(:,:,1:39);
            clearvars first;
            for i = 2:(iter - 1)
                temp = bwdistsc(origData(:,:,(30*(i-1)+1):(30*(i-1)+50)),[1 1 1],i,iter);
                distDataO(:,:,((i-2)*30+40):((i-2)*30+69)) = temp(:,:,10:39);
                clearvars temp;
            end
            last = bwdistsc(origData(:,:,(Z-rem-49):end),[1 1 1],iter,iter);
            distDataO(:,:,(Z-rem-40):Z) = last(:,:,10:end);
            clearvars last;
        end
    else
        distDataO = bwdistsc(origData,[1 1 1],1,1);
    end
    toc
    distData = padarray(distDataO,[1 1 1], 0, 'both');
    clearvars distDataO;
    

    for index = 1:row
       % rows & columns are flipped in xyz space, row = y, col = x
       % +1 accounts for padding, +1 accounts for matrix indexes starting at 1 not 0
       x = branchInfo(index,col-1) + 2;
       y = branchInfo(index,col-2) + 2; 
       z = branchInfo(index,col) + 2; 
       
       if (x ~= 0 && x ~= 1) % x ~= -1 && x ~= 0 --> 0,1 to account for padding
            val = distData(x,y,z);
           
           [val,x,y,z] = LocalMax(val,x,y,z,distData);
% 
%        while (change)
%            [val,change,x,y,z] = LocalMax(val,x,y,z,distData);
%        end
       else
           val = -1;
       end

       branchInfo(index,col+1) = val*2; % x2 because max(3D distance transform) is the radius 
       branchInfo(index,col+2) = y;
       branchInfo(index,col+3) = x;
       branchInfo(index,col+4) = z;
       

    end
    
%     csvwrite('C:\Program Files\Branch origData\Branch information.csv', branchInfo);

    
end