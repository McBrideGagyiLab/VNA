% This code was written by John Peters in the McBride-Gagyi lab
% at Saint Louis University.
% This code is licensed under the GNU General Public License v3.0 (see
% LICENSE for details).
%% read in images from ImageJ and create a stack

for i = 1:500
    %2**
    file_name = strcat('C:\Users\peter\Documents\Masters Work\Test Images\C0001346_00', num2str(473+i)); 
    file_name = strcat(file_name, '.DCM;1.tif');
    data(:,:,i) = imread(file_name);
    I(:,:,i) = im2bw(data(:,:,i),.9);
end

%%
for i = 1:500
    if (i < 402)
        file_name = strcat('C:\Users\peter\Documents\Masters Work\Test Images\C0001346_00', num2str(598+i)); 
        file_name = strcat(file_name, '.DCM;1.tif');
        data(:,:,i) = imread(file_name);
    else
        file_name = strcat('C:\Users\peter\Documents\Masters Work\Test Images\C0001346_0', num2str(598+i)); 
        file_name = strcat(file_name, '.DCM;1.tif');
        data(:,:,i) = imread(file_name);
    end
end

%%
for i = 1:100
    %2**
    file_name = strcat('C:\Users\peter\Documents\Masters Work\Phantom\Tiff Skeleton\image', num2str(i),'.tif'); ;
    data2(:,:,i) = imread(file_name);
end

%% save as .mat

save('C:\Users\peter\Documents\MATLAB\phantomSkel.mat','phantomSkel');


%% 3D viewer

figure;
    xlabel('X-axis'); 
    ylabel('Y-axis');
    zlabel('Z-axis');
    fv = isosurface(dataL,.5);
    p1 = patch(fv,'FaceColor','red','EdgeColor','none');
    view(3)
    daspect([1,1,1])
    camlight(-80,80)
    lighting gouraud
    title('Input Data Rendering')
    
    %%
    
    javaaddpath 'C:\Program Files\MATLAB\R2017a\java\mij.jar'
    javaaddpath 'C:\Program Files\MATLAB\R2017a\java\ij.jar'
    MIJ.start
    
    %%
    
    branchInfo = xlsread('C:\Program Files\Branch Data\Branch information.csv');
    
    %%
    
    for i = 1:500
        data2(:,:,i) = im2bw(data(:,:,i),.95);
    end
 
    
 %% Voxelise Mesh
 x = 893;
 y = 763;
 z = 528;
 
 dataVox = VOXELISE(x,y,z,'C:\Users\peter\Documents\Blood_Vessel\CT_Cone_JJP.stl');
 %dataVox = VOXELISE(236,217,276,'C:\Users\peter\Documents\Blood_Vessel\Network_01.stl');
 %dataP = permute(dataVox,[2 3 1]);
 dataP = padarray(dataVox,[3 3 3], 0, 'both');
 
 %%
 for i = 1:(z+6)
    dataC(:,:,i) = im2uint16(dataP(:,:,i));
    imwrite(dataC(:,:,i), strcat('C:\Users\peter\Documents\Masters Work\CT_Cone_JP\slice', num2str(i), '.tif'));
 end
 
 %%
  for i = 1:260
    file_name = strcat('C:\Users\peter\Documents\Masters Work\Mesh Skeletons\slice', num2str(i),'.tif'); 
    data(:,:,i) = imread(file_name);
    %I(:,:,i) = im2bw(data(:,:,i),.9);
 end
 
 
 %% 
 
 for i = 1:492
     temp(:,:,i) = im2uint8(data(:,:,i));
    imwrite(temp(:,:,i),strcat('C:\Users\peter\Documents\Masters Work\FinalModel2\slice',num2str(i),'.tif')); 
 end
    
 %%
 
 for i = 1:260
     data(:,:,i) = imread(strcat('C:\Users\peter\Documents\Masters Work\Network_02 Slices\slice',num2str(i),'.tif'));
     %dataL(:,:,i) = im2bw(data(:,:,i),.5);
 end
 
 %%
 
for i = 1:260
    
    if (i < 10)
         file_name = strcat('C:\Users\peter\Documents\Masters Work\JOHNNY\SLICE00', num2str(i),'.dcm');
     elseif (i>=10 && i < 100)
         file_name = strcat('C:\Users\peter\Documents\Masters Work\JOHNNY\SLICE0', num2str(i),'.dcm');
     elseif (i >=100)
         file_name = strcat('C:\Users\peter\Documents\Masters Work\JOHNNY\SLICE', num2str(i),'.dcm');
     end
    dicomwrite()
end
 
 
 %%
 for i = 1:260
     
     data(:,:,i) = imread(strcat('C:\Users\peter\Documents\Masters Work\Network_02 Slices\slice',num2str(i),'.tif'));
     %dataL(:,:,i) = im2bw(data(:,:,i),.5);
 end
 
 %%
 for i = 1:260
     if (i < 10)
         file_name = strcat('C:\Users\peter\Documents\Masters Work\JOHNNY\SLICE00', num2str(i),'.DCM');
     elseif (i>=10 && i < 100)
         file_name = strcat('C:\Users\peter\Documents\Masters Work\JOHNNY\SLICE0', num2str(i),'.DCM');
     elseif (i >=100)
         file_name = strcat('C:\Users\peter\Documents\Masters Work\JOHNNY\SLICE', num2str(i),'.DCM');
     end
     dicomwrite(data(:,:,i), file_name,info2);
 end
 
 %%
  for i = 1:260
      if (i < 10)
         file_name = strcat('C:\Users\peter\Documents\Masters Work\JOHNNY\SLICE00', num2str(i),'.dcm');
     elseif (i>=10 && i < 100)
         file_name = strcat('C:\Users\peter\Documents\Masters Work\JOHNNY\SLICE0', num2str(i),'.dcm');
     elseif (i >=100)
         file_name = strcat('C:\Users\peter\Documents\Masters Work\JOHNNY\SLICE', num2str(i),'.dcm');
     end
     data(:,:,i) = dicomread(file_name);
  end
 
  %%
  
  for i = 24:634
      file_name_tif = strcat('C:\Users\peter\Documents\Masters Work\FinalModelCT\Network\slice', num2str(i),'.tif');
      data = imread(file_name_tif);
      info2.Filename = strcat('slice', num2str(i));
      [M N] = size(data);
      info2.Width = N;
      info2.Height = M;
       if (i < 10)
         file_name_dicom = strcat('C:\Users\peter\Documents\Masters Work\JOHNNY\SLICE00', num2str(i),'.dcm');
     elseif (i>=10 && i < 100)
         file_name_dicom = strcat('C:\Users\peter\Documents\Masters Work\JOHNNY\SLICE0', num2str(i),'.dcm');
     elseif (i >=100)
         file_name_dicom = strcat('C:\Users\peter\Documents\Masters Work\JOHNNY\SLICE', num2str(i),'.dcm');
       end
      dicomwrite(data, file_name_dicom,info2);
  end
 
 %%
 count = zeros(1,31);
 for i = 1:31
     for n = 1:7
         if (info(i,3) ~= info(i+31*n,3))
             count(1,i) = 100*n;
         elseif (info(i,17) ~= info(i+31*n,17))
             count(1,i) = 2*n;
         end
     end
 end
 
 %% Diameter % error
 
 a = xlsread('C:\Users\peter\Documents\Branch Information\test.csv');
 b = xlsread('C:\Users\peter\Documents\Branch Information\Actual Network_02.xlsx');
 totLA = 0;
 totLT = 0;
 for i = 1:31
    
     error(i) = abs((a(i,17)-b(i,3))/b(i,3))*100;
     totLA = totLA + b(i,2);
     totLT = totLT + a(i,3);
 end
 
 diaErr = sum(error)/31;
 lenErr = abs((totLA - totLT)/totLT)*100;
 
%% find nearest point

x1 = 14; 
y1 = 482; 
z1 = 281;

x2 = 23; 
y2 = 506; 
z2 = 193;

branchInfo = xlsread('C:\Users\peter\Documents\Branch Information\Branch information_03.csv');

dist1 = zeros(48,2);
dist2 = zeros(48,2);
for i = 1:48
    dist1(i,1) = sqrt((x1-branchInfo(i,4))^2 + (y1-branchInfo(i,5))^2 + (z1-branchInfo(i,6))^2);
    dist1(i,2) = sqrt((x1-branchInfo(i,7))^2 + (y1-branchInfo(i,8))^2 + (z1-branchInfo(i,9))^2);
    
    dist2(i,1) = sqrt((x2-branchInfo(i,4))^2 + (y2-branchInfo(i,5))^2 + (z2-branchInfo(i,6))^2);
    dist2(i,2) = sqrt((x2-branchInfo(i,7))^2 + (y2-branchInfo(i,8))^2 + (z2-branchInfo(i,9))^2);
end

minDist1 = min(min(dist1));
loc1 = find(dist1 == minDist1);
for i = 1:length(loc1)
    if (loc1(i) > 48)
        trueLoc1(i) = loc1(i) - 48;
    else 
        trueLoc1(i) = loc1(i);
    end
end

minDist2 = min(min(dist2));
loc2 = find(dist2 == minDist2);
for i = 1:length(loc2)
    if (loc2(i) > 48)
        trueLoc2(i) = loc2(i) - 48;
    else 
        trueLoc2(i) = loc2(i);
    end
end

%% Make 16 tree system


 for i = 1:260
     data(:,:,i) = imread(strcat('C:\Users\peter\Documents\Masters Work\Network_02 Slices\slice',num2str(i),'.tif'));
     dataL(:,:,i) = im2bw(data(:,:,i),.5);
 end
%%
dataU = data;
for i = 1:260
   dataD(:,:,i) = dataU(:,:,261-i); 
end
data2 = zeros(358,187,260);
data2(1:179,1:187,1:260) = dataU;
data2(180:358,1:187,1:260) = dataD;
dataP = permute(data2,[1 3 2]);

data4 = zeros(358,470,260);
data4(1:358,1:187,1:260) = data2;
data4(1:358,211:470,38:224) = dataP;

data8 = zeros(716, 470,260);
data8(1:358,1:470,1:260) = data4;
data8(359:716,1:470,1:260) = data4;

data16 = zeros(716,470,520);
data16(1:716,1:470,1:260) = data8;
data16(1:716,1:470,261:520) = data8;

%% Volume

 for i = 1:500
     data(:,:,i) = imread(strcat('C:\Users\peter\Documents\Masters Work\Volume 1\C0001346_00' ,num2str(473+i),'.DCM;1.tif'));
     dataL(:,:,i) = im2bw(data(:,:,i),.5);
 end
 
totalVol = sum(sum(sum(dataL)));
figure; imagesc(dataL(:,:,100)); colormap(gray);
%%

f = figure;
 t = uitable(f);
 t.ColumnName = {'ID','Branch Length','Diameter'};
 [M,N] = size(handles.branchInfo);
 for i = 1:M
     for j = 1:3
        switch j
            case 1
                t.Data(i,1) = handles.branchInfo(i,1);
            case 2
                t.Data(i,2) = handles.branchInfo(i,3); % /100 resolution
            case 3
                t.Data(i,3) = handles.branchInfo(i,18);
        end
     end  
 end
 
 %%
 
 for i = 1:840
    if (i < 802)
        file_name = strcat('C:\Users\peter\Documents\Masters Work\00001802\C0001674_00', num2str(197+i), '.DCM;1'); 
    else
        file_name = strcat('C:\Users\peter\Documents\Masters Work\00001802\C0001674_0', num2str(197+i), '.DCM;1');     
    end
    data(:,:,i) = dicomread(file_name);  
 end
 %%
 
 for i = 1:497
      if (i < 11)
         file_name_dicom = strcat('C:\Users\peter\Documents\Masters Work\CT_Cone_JP DICOM\J0000001_0000', num2str(i-1),'.DCM;1');
     elseif (i>=11 && i < 101)
         file_name_dicom = strcat('C:\Users\peter\Documents\Masters Work\CT_Cone_JP DICOM\J0000001_000', num2str(i-1),'.DCM;1');
     elseif (i >=101)
         file_name_dicom = strcat('C:\Users\peter\Documents\Masters Work\CT_Cone_JP DICOM\J0000001_00', num2str(i-1),'.DCM;1');
       end 
     data(:,:,i) = dicomread(file_name_dicom);
 end
 
 %%

 for i = 304:353
    file_name = strcat('C:\Users\peter\Documents\Masters Work\481_1398\Round 1\C0001346_00', num2str(i),'.DCM;1.tif');
    data(:,:,i-303) = imread(file_name);     
 end
 
 %%
 
 
 tic
 test123 = bwdistsc(data); 
 toc

 %%
 
test1 = zeros(1952,1932,201);
test1(:,:,1:39) = test1_1_50(:,:,1:39);
test1(:,:,40:69) = test1_30_80(:,:,11:40);
test1(:,:,70:99) = test1_60_110(:,:,11:40);
test1(:,:,100:129) = test1_90_140(:,:,11:40);
test1(:,:,130:159) = test1_120_170(:,:,11:40);
test1(:,:,160:201)  = test1_150_200(:,:,11:end);
 
 %% aa - main bb - compare
 
 clearvars count total error_abs error index i j k
 
 total = 0;
 count = 0;
 index = 1;
 for i = 1:1932
     for j = 1:1952
         for k = 1:50
             if ((aa(j,i,k) ~= 0))
                 total = total + 1;
                 if (bb(j,i,k) == aa(j,i,k))
                     count = count + 1;
                 else
                     error_abs(index) = abs(bb(j,i,k) - aa(j,i,k));
                     error(index) = aa(j,i,k)-bb(j,i,k);
                     index = index + 1;
                 end
             end
         end
     end
 end
 
 
 %%
 z = ones(10000,10000);
 tic
 for j = 1:10000
     for i = 1:10000
        x = z(i,j) * 2;
     end
 end
 toc
         
 %%
 
 data = xlsread('C:\Users\peter\Documents\Masters Work\HistDataCTCone.xlsx');
 total = sum(data(:,2));
 for i = 1:48
    dataF(i,1) = data(i,2)/total;     
 end

figure(20); j = histogram('BinEdges',0:.01:.48,'BinCounts', dataF); axis([0 .6 0 .25]); title('uCT','fontweight','bold'); xlabel('Diameter (mm)'); ylabel('Percentage of Total');
 
%%

data = xlsread('C:\Users\peter\Documents\Masters Work\CT_Cone_JJP_ALL.xlsx');
%data(:,3) = data(:,3)/100;
edges = 0:.01:.51;
bincount = discretize(data(:,3),edges);
binz = zeros(1,52);
for i = 1:95
    binz(bincount(i)) = binz(bincount(i)) + 1;
end
total = sum(binz);
for i = 1:52
    binz(i) = binz(i)/total;
end
figure(10); j = histogram('BinEdges',0:.01:.52,'BinCounts', binz(1:end)); title('Input Values','fontweight','bold'); xlabel('Diameter (mm)'); ylabel('Percentage of Total');
 
%%


data = xlsread('C:\Users\peter\Documents\Masters Work\Results_CT_Cone.csv');
data(:,17) = data(:,17)/100;
edges = 0:.01:.51;
bincount = discretize(data(:,17),edges);
binz = zeros(1,52);
for i = 1:97
    binz(bincount(i)) = binz(bincount(i)) + 1;
end
total = sum(binz);
for i = 1:52
    binz(i) = binz(i)/total;
end
figure(17); j = histogram('BinEdges',0:.01:.52,'BinCounts', binz(1:end)); title('Vascular Network Analysis','fontweight','bold'); xlabel('Diameter (mm)'); ylabel('Percentage of Total');
 
%%

for i = 1:341
    skel(:,:,i) = imread(strcat('C:\Users\peter\Documents\Masters Work\Network_03 Skel\slice', num2str(i), '.tif'));
end

 