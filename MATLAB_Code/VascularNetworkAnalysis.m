function varargout = VascularNetworkAnalysis(varargin)
% VASCULARNETWORKANALYSIS MATLAB code for VascularNetworkAnalysis.fig
%      VASCULARNETWORKANALYSIS, by itself, creates a new VASCULARNETWORKANALYSIS or raises the existing
%      singleton*.
%
%      H = VASCULARNETWORKANALYSIS returns the handle to a new VASCULARNETWORKANALYSIS or the handle to
%      the existing singleton*.
%
%      VASCULARNETWORKANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VASCULARNETWORKANALYSIS.M with the given input arguments.
%
%      VASCULARNETWORKANALYSIS('Property','Value',...) creates a new VASCULARNETWORKANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VascularNetworkAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VascularNetworkAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VascularNetworkAnalysis

% Last Modified by GUIDE v2.5 18-Sep-2018 20:48:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VascularNetworkAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @VascularNetworkAnalysis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before VascularNetworkAnalysis is made visible.
function VascularNetworkAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VascularNetworkAnalysis (see VARARGIN)

% Choose default command line output for VascularNetworkAnalysis
handles.output = hObject;
handles.bRun = false;
handles.cbAcc.Value = false;
handles.cbScale.Value = false;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VascularNetworkAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VascularNetworkAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbValidate.
function pbValidate_Callback(hObject, eventdata, handles)
% hObject    handle to pbValidate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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



% --- Executes on button press in pbExport.
function pbExport_Callback(hObject, eventdata, handles)
% hObject    handle to pbExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
codePath = pwd;
cd(handles.BranchFilePath)

[FileName,PathName] = uiputfile('*.csv','*.xls');
[M,N] = size(handles.branchInfo);
Names = [handles.branchInfoOrigText(1,:),'Diameter (voxels)','dX','dY','dZ'];
DetailedInfo(1,:) = Names(1, :);
 
 for i = 2:M+1
     for j=1:N
        DetailedInfo(i,j)= {handles.branchInfo(i-1,j)};
     end
 end
 xlswrite(strcat(PathName,FileName),DetailedInfo, 2);
 
 SummaryInfo(1,:) = {'File Name Analyzed', 'Vessel Volume (mm3)', 'Total Volume (mm3)', 'VV/TV', 'Vessel Number', 'Network Length (mm)', 'Ave. Vessel Diameter (mm)', 'Vessel Diameter Std (mm)', 'Scale (mm/voxel)'};
 SummaryInfo(2,:) = {handles.BranchFileName, handles.vesselVol, handles.totalVol, handles.vesselVol/handles.totalVol, handles.numVessels, handles.networkLength,  handles.avgDiam, handles.stdDiam, handles.scale};
 xlswrite(strcat(PathName,FileName),SummaryInfo, 1);
 cd(codePath)


% --- Executes on button press in pbView.
function pbView_Callback(hObject, eventdata, handles)
% hObject    handle to pbView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f = figure;
 t = uitable(f);
 Names = [handles.branchInfoOrigText(1,:),'Diameter (voxels)','dX','dY','dZ'];
 t.ColumnName = Names;
 t. Data = handles.branchInfo;



function tbNumBins_Callback(hObject, eventdata, handles)
% hObject    handle to tbNumBins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbNumBins as text
%        str2double(get(hObject,'String')) returns contents of tbNumBins as a double


% --- Executes during object creation, after setting all properties.
function tbNumBins_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbNumBins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pmAuto.
function pmAuto_Callback(hObject, eventdata, handles)
% hObject    handle to pmAuto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pmAuto contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmAuto


% --- Executes during object creation, after setting all properties.
function pmAuto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmAuto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbPlot.
function pbPlot_Callback(hObject, eventdata, handles)
% hObject    handle to pbPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
string1 = get(handles.pmHistogram,'String');
string2 = get(handles.pmAuto,'String');
if (string1{1} == 'Diameter')
    switch1 = 1;
else 
    switch1 = 2;
end
if (string2{1} == 'Automatic')
    switch2 = 1;
else 
    switch2 = 2;
end

[M N] = size(handles.branchInfoOrigText); %information to figure out diameter column
branchLengthIndex = find(strncmp(handles.branchInfoOrigText(1,:), 'Branch length', 8));

switch get(handles.pmHistogram,'Value')
    case 1
        switch get(handles.pmAuto,'Value')
            case 1
                figure; histogram(handles.branchInfo(:,N+1));
            case 2 
                numBins = str2num(get(handles.tbNumBins,'String'));
                figure; histogram(handles.branchInfo(:,N+1),numBins);
        end
    case 2
        switch get(handles.pmAuto,'Value')
            case 1
                figure; histogram(handles.branchInfo(:,branchLengthIndex));
            case 2 
                numBins = str2num(get(handles.tbNumBins,'String'));
                figure; histogram(handles.branchInfo(:,branchLengthIndex),numBins);
        end
end


% --- Executes on selection change in pmHistogram.
function pmHistogram_Callback(hObject, eventdata, handles)
% hObject    handle to pmHistogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pmHistogram contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmHistogram


% --- Executes during object creation, after setting all properties.
function pmHistogram_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmHistogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbScale.
%Changes display in the GUI between mm and voxels
function cbScale_Callback(hObject, eventdata, handles)
% hObject    handle to cbScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbScale
valueCheckbox = get(hObject, 'Value');
if (handles.bRun == true)
    if (valueCheckbox == 1)
        % volume
        handles.vesselVol = handles.vesselVol/(handles.scale^3);
        set(handles.txtTotalVolume,'String',num2str(handles.vesselVol));
        % length
        handles.networkLength = handles.networkLength/handles.scale;
        set(handles.txtNL,'String',num2str(handles.networkLength));
        % diameter
        handles.avgDiam = handles.avgDiam/handles.scale;
        set(handles.txtDiameter,'String',num2str(handles.avgDiam));
    else
        % volume
        handles.vesselVol = handles.vesselVol*(handles.scale^3);
        set(handles.txtTotalVolume,'String',num2str(handles.vesselVol));
        % length
        handles.networkLength = handles.networkLength*handles.scale;
        set(handles.txtNL,'String',num2str(handles.networkLength));
        % diameter
        handles.avgDiam = handles.avgDiam*handles.scale;
        set(handles.txtDiameter,'String',num2str(handles.avgDiam));
    end
    if (valueCheckbox == 1)
        set(handles.txtMeasure,'String','Measurements are in voxels');
    else
        set(handles.txtMeasure,'String','Measurements are in mm');
    end
else
    set(handles.cbScale,'Value',0);
end
guidata(hObject, handles);


% --- Executes on button press in pbRun.
function pbRun_Callback(hObject, eventdata, handles)
% hObject    handle to pbRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inc = 6;
waitBar = waitbar(1/inc,'Vessel Analysis: Loading raw data...');
handles.scale = str2num(get(handles.ebResolution, 'String'));

%get file name from GUI
filePath = get(handles.tbPath,'String');

%import data
[handles.branchInfoOrig, handles.branchInfoOrigText, raw] = xlsread(filePath);

%Elminate non-existant 'branches' (i.e. noise)
%Find correct columns for midpoint X, Y, and Z coordiates
mPXIndex = find(strncmp(handles.branchInfoOrigText(1,:), 'mpX', 3));
mPYIndex = find(strncmp(handles.branchInfoOrigText(1,:), 'mpY', 3));
mPZIndex = find(strncmp(handles.branchInfoOrigText(1,:), 'mpZ', 3));

%clear branch Info if the program has been run before
if isfield(handles, 'branchInfo')==1
    handles = rmfield(handles, 'branchInfo');
end

%remove false branches (i.e. noise or branches of one pixel) 
index = 1;
[biM, biN] = size(handles.branchInfoOrig);
for i = 1:biM
    if (handles.branchInfoOrig(i,mPXIndex) == -1 && handles.branchInfoOrig(i,mPYIndex) == -1 && handles.branchInfoOrig(i,mPZIndex) == -1)
        
    elseif (handles.branchInfoOrig(i, mPXIndex) == 0 && handles.branchInfoOrig(i,mPYIndex) == 0 && handles.branchInfoOrig(i,mPZIndex) == 0)
        
    else 
        handles.branchInfo(index,:) = handles.branchInfoOrig(i,:);
        index = index + 1;
    end
end



% Find number of vessels
waitbar(2/inc,waitBar,'Vessel Analysis: Getting number of vessels...');
handles.numVessels = length(handles.branchInfo(:,1));
set(handles.txtNumVessels,'String',num2str(handles.numVessels));

% Find Vessel & Total volume
waitbar(3/inc,waitBar,'Vessel Analysis: Calculating total volume...');
tempImages = 1-handles.images; %change 0's to 1's, and 1's to 0's
handles.vesselVol = sum(sum(sum(tempImages)))*handles.scale^3;
[M N K]= size(handles.images);
handles.totalVol = M*N*K*handles.scale^3;

set(handles.txtTotalVolume,'String',num2str(handles.vesselVol));

% Find network length
waitbar(4/inc,waitBar,'Vessel Analysis: Getting total network length...');
branchLengthIndex = find(strncmp(handles.branchInfoOrigText(1,:), 'Branch length', 8));
if handles.scaleNetworkLength
    handles.networkLength = sum(handles.branchInfo(:,branchLengthIndex))*handles.scale;
else
    handles.networkLength = sum(handles.branchInfo(:,branchLengthIndex));
end
set(handles.txtNL,'String',num2str(handles.networkLength));

% Find the average diameter and standard deviation
waitbar(5/inc,waitBar,'Vessel Analysis: Calculating vessel diameters...');
[row col] = size(handles.branchInfo);
colDiam = col+1;
handles.branchInfo = CalculateDiameter(handles.images,handles.branchInfo,handles.cbAcc.Value);
handles.avgDiam = mean(handles.branchInfo(:,colDiam))*handles.scale;
handles.stdDiam = std(handles.branchInfo(:,colDiam)*handles.scale);
set(handles.txtDiameter,'String',num2str(handles.avgDiam));


waitbar(6/inc,waitBar,'Vessel Analysis: Finished');
delete(waitBar);
handles.bRun = true;
guidata(hObject, handles);


% --- Executes on button press in pbBrowseData.
% Uploads the Image Stack
function pbBrowseData_Callback(hObject, eventdata, handles)
% hObject    handle to pbBrowseData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.tif = false;
codeFolder = pwd;

%Get Image Stack location and file name from User
if(isfield(handles, 'BranchFilePath')==1)
    cd(handles.BranchFilePath)
end
[handles.fileDataName, handles.ImageFilePath] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files'}, 'Select The First File in the Thresholded Image Stack');
cd(codeFolder)

%---Create list of all files in the directory
d=dir(handles.ImageFilePath); 
fileNames = natsortfiles({d.name});

%Change directories
cd (handles.ImageFilePath);

%clear out the handles.images variable incase has been previously used
ImageLogical = strncmp(handles.fileDataName, fileNames, round(length(handles.fileDataName)/2)); %Find out how many images will be uploaded
ImageNum = sum(ImageLogical);

ImageIndexes = find(ImageLogical); %Finding file indexes for images

[rows cols] = size(imread(char(fileNames(ImageIndexes(1)))));%finding image size

handles.images = zeros(rows, cols, ImageNum); %creating a blank matrix that matches how many images will be imported and their size


%Pull images that match selected name
for i=1:(length(ImageIndexes))
    handles.images(:,:,i)=imread(char(fileNames(ImageIndexes(i)))); 
end

%Convert the stack to a binary image
[I J K] = size(handles.images);

for i = 1:K
    handles.images(:,:,i) = im2bw(handles.images(:,:,i), 0.5);
end

%setting the scale for the images
handles.tif = true;

handles.scale = 1;
handles.scaleNetworkLength = 1;

if (handles.tif == true)
    info = imfinfo(handles.fileDataName);
    if (~isempty(info.XResolution))
        handles.scale = 1/info.XResolution;
        handles.scaleNetworkLength = 0;
    end
end
set(handles.ebResolution, 'string',num2str(handles.scale));

cd(codeFolder)

guidata(hObject, handles);



function tbPath_Callback(hObject, eventdata, handles)
% hObject    handle to tbPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbPath as text
%        str2double(get(hObject,'String')) returns contents of tbPath as a double


% --- Executes during object creation, after setting all properties.
function tbPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbBrowse.
%Gets the name, but does not yet upload the branch information spread sheet
function pbBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to pbBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
codeFolder = pwd;

if(isfield(handles, 'ImageFilePath')==1)
    cd(handles.ImageFilePath)
end

[handles.fileName, handles.filePath] = uigetfile({'*.csv';'*xls';'*.xlsx';'*.xlsm'});

handles.BranchFilePath = handles.filePath; %save file path for uploading images
handles.BranchFileName = handles.fileName;

set(handles.tbPath, 'string',strcat(handles.filePath,handles.fileName)); %Change name on GUI
cd(codeFolder)
guidata(hObject, handles);


% --- Executes on button press in cbAcc.
function cbAcc_Callback(hObject, eventdata, handles)
% hObject    handle to cbAcc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbAcc



function ebResolution_Callback(hObject, eventdata, handles)
% hObject    handle to ebResolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ebResolution as text
%        str2double(get(hObject,'String')) returns contents of ebResolution as a double


% --- Executes during object creation, after setting all properties.
function ebResolution_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ebResolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
