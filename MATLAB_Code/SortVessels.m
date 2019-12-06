
%% Sort Vessels

ind = xlsread('C:\Users\peter\Documents\Branch Information\Actual Network_02_2');
outd = xlsread('C:\Users\peter\Documents\Branch Information\Network_02_2R_F_Out.csv');
saveIn = ind;

for i = 1:(length(ind)-3)
    
    err_d = zeros(1,4);
    err_l = zeros(1,4);
    
    err_d(1) = abs(outd(i,17)-ind(i,3));%/ind(i,3);
    err_d(2) = abs(outd(i+1,17)-ind(i,3));%/ind(i+1,3);
    err_d(3) = abs(outd(i+2,17)-ind(i,3));%/ind(i+2,3);
    err_d(4) = abs(outd(i+3,17)-ind(i,3));%/ind(i+3,3);
    x_d = find(err_d == min(err_d));
    
    err_l(1) = abs(outd(i,3)-ind(i,2));%/ind(i,2);
    err_l(2) = abs(outd(i+1,3)-ind(i+1,2));%/ind(i+1,2);
    err_l(3) = abs(outd(i+2,3)-ind(i+2,2));%/ind(i+2,2);
    err_l(4) = abs(outd(i+3,3)-ind(i+3,2));%/ind(i+3,2);
    x_l = find(err_l == min(err_l));
    
    err_t = err_d + err_d;
    x_t = find(err_t == min(err_t));
    
    if (x_t~=1)
        temp = ind(i,:);
        ind(i,:) = ind(i+x-1,:);
        ind(i+x-1,:) = temp;
    end
    
end