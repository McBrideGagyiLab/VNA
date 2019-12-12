% This code was modified by John Peters in the McBride-Gagyi lab
% at Saint Louis University.
% This code is licensed under the GNU General Public License v3.0 (see
% LICENSE for details).
function varargout = VesselAnalysis(varargin)
% VESSELANALYSIS MATLAB code for VesselAnalysis.fig
%      VESSELANALYSIS, by itself, creates a new VESSELANALYSIS or raises the existing
%      singleton*.
%
%      H = VESSELANALYSIS returns the handle to a new VESSELANALYSIS or the handle to
%      the existing singleton*.
%
%      VESSELANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VESSELANALYSIS.M with the given input arguments.
%
%      VESSELANALYSIS('Property','Value',...) creates a new VESSELANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VesselAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VesselAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VesselAnalysis

% Last Modified by GUIDE v2.5 28-Dec-2017 13:31:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VesselAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @VesselAnalysis_OutputFcn, ...
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


% --- Executes just before VesselAnalysis is made visible.
function VesselAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VesselAnalysis (see VARARGIN)

% Choose default command line output for VesselAnalysis
handles.output = hObject;
handles.bRun = false;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VesselAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VesselAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbRun.
function pbRun_Callback(hObject, eventdata, handles)
% hObject    handle to pbRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get branch info
inc = 6;
waitBar = waitbar(1/inc,'Vessel Analysis: Loading raw data...');
filePath = get(handles.tbPath,'String');
handles.branchInfoOrig = xlsread(filePath);

index = 1;
[biN, biM, biZ] = size(handles.branchInfoOrig);
for i = 1:biN
    if (handles.branchInfoOrig(i,15) == -1 && handles.branchInfoOrig(i,16) == -1 && handles.branchInfoOrig(i,17) == -1)
        
    elseif (handles.branchInfoOrig(i,15) == 0 && handles.branchInfoOrig(i,16) == 0 && handles.branchInfoOrig(i,17) == 0)
        
    else 
        handles.branchInfo(index,:) = handles.branchInfoOrig(i,:);
        index = index + 1;
    end
end

% get/set number of vessels
waitbar(2/inc,waitBar,'Vessel Analysis: Getting number of vessels...');
handles.numVessels = length(handles.branchInfo(:,1));
set(handles.txtNumVessels,'String',num2str(handles.numVessels));

% set total volume
waitbar(3/inc,waitBar,'Vessel Analysis: Calculating total volume...');
handles.scale = 1;
if (handles.tif == true)
    info = imfinfo(strcat(handles.fileDataPath,handles.fileDataName));
    if (~isempty(info.XResolution))
        handles.scale = 1/info.XResolution;
    end
end
handles.totalVol = sum(sum(sum(handles.images)));
[M N K] = size(handles.images);
tempVol = M*N*K - handles.totalVol;
if (handles.totalVol > tempVol)
    handles.totalVol = tempVol;
end
handles.totalVol = handles.totalVol*handles.scale;
set(handles.txtTotalVolume,'String',num2str(handles.totalVol));

% set average diameter
waitbar(4/inc,waitBar,'Vessel Analysis: Calculating vessel diameters...');
handles.branchInfo = CalculateDiameter(handles.images,filePath);
handles.avgDiam = mean(handles.branchInfo(:,18));
handles.avgDiam = handles.avgDiam*handles.scale;
set(handles.txtDiameter,'String',num2str(handles.avgDiam));

% set network length
waitbar(5/inc,waitBar,'Vessel Analysis: Getting total network length...');
handles.networkLength = sum(handles.branchInfo(:,3));
set(handles.txtNL,'String',num2str(handles.networkLength));

waitbar(6/inc,waitBar,'Vessel Analysis: Finished');
delete(waitBar);
handles.bRun = true;
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
function pbBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to pbBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.fileName, handles.filePath] = uigetfile({'*.csv';'*xls';'*.xlsx';'*.xlsm'});
set(handles.tbPath, 'string',strcat(handles.filePath,handles.fileName));
guidata(hObject, handles);


% --- Executes on button press in pbBrowseData.
function pbBrowseData_Callback(hObject, eventdata, handles)
% hObject    handle to pbBrowseData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.tif = false;
[handles.fileDataName, handles.fileDataPath] = uigetfile({'*.tif';'*.mat',});
if (handles.fileDataName(end-3:end) == '.tif')
%     numImages = inputdlg('Number of Slices: ','Input', [1 50]);
    d=dir(handles.fileDataPath);
    sortD = natsortfiles({d.name});
    for i=1:(size(d)-2) 
        strCell = strcat(d(i+2).folder, '\',sortD(i+2));
        handles.images(:,:,i)=imread(strCell{1}); 
    end
    handles.tif = true;
end
[M N K] = size(handles.images);
for j = 1:K
    handles.images(:,:,j) = im2bw(handles.images(:,:,j));
end
guidata(hObject, handles);


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


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pmHistogram.
function pmHistogram_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pmHistogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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

switch get(handles.pmHistogram,'Value');
    case 1
        switch get(handles.pmAuto,'Value')
            case 1
                figure; histogram(handles.branchInfo(:,18));
            case 2 
                numBins = str2num(get(handles.tbNumBins,'String'));
                figure; histogram(handles.branchInfo(:,18),numBins);
        end
    case 2
        switch get(handles.pmAuto,'Value')
            case 1
                figure; histogram(handles.branchInfo(:,3));
            case 2 
                numBins = str2num(get(handles.tbNumBins,'String'));
                figure; histogram(handles.branchInfo(:,3),numBins);
        end
end


% --- Executes on button press in cbScale.
function cbScale_Callback(hObject, eventdata, handles)
% hObject    handle to cbScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbScale

if (handles.bRun == true)
    if (handles.cbScale.Value == 1)
        % volume
        handles.totalVol = handles.totalVol/handles.scale;
        set(handles.txtTotalVolume,'String',num2str(handles.totalVol));
        % length
        handles.networkLength = handles.networkLength/handles.scale;
        set(handles.txtNL,'String',num2str(handles.networkLength));
        % diameter
        handles.avgDiam = handles.avgDiam/handles.scale;
        set(handles.txtDiameter,'String',num2str(handles.avgDiam));
    else
        % volume
        handles.totalVol = handles.totalVol*handles.scale;
        set(handles.txtTotalVolume,'String',num2str(handles.totalVol));
        % length
        handles.networkLength = handles.networkLength*handles.scale;
        set(handles.txtNL,'String',num2str(handles.networkLength));
        % diameter
        handles.avgDiam = handles.avgDiam*handles.scale;
        set(handles.txtDiameter,'String',num2str(handles.avgDiam));
    end
    if (handles.cbScale.Value == 1)
        set(handles.txtMeasure,'String','Measurements are in voxels');
    else
        set(handles.txtMeasure,'String','Measurements are in mm');
    end
else
    set(handles.cbScale,'Value',0);
end
guidata(hObject, handles);


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


% --- Executes on button press in pbView.
function pbView_Callback(hObject, eventdata, handles)
% hObject    handle to pbView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f = figure;
 t = uitable(f);
 t.ColumnName = {'ID','Skeleton','Branch Length','v1x','v1y','v1z','v2x','v2y','v2z','Euclidean Distance','Running Average','Intensity (inner 1/3)','Average Intensity','mpX','mpY','mpZ','Diameter','dX','dY','dZ'};
 [M,N] = size(handles.branchInfo);
 for i = 1:M
     for j = 1:N-1
        if (j < 14)
            t.Data(i,j) = handles.branchInfo(i,j);
        else
            t.Data(i,j) = handles.branchInfo(i,j+1);
        end
     end  
 end


% --- Executes on button press in pbExport.
function pbExport_Callback(hObject, eventdata, handles)
% hObject    handle to pbExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uiputfile('*.csv','*.xls');
[M,N] = size(handles.branchInfo);
 cellInfo = cell(M+1,20);
 cellInfo(1,:) = {'ID','Skeleton','Branch Length','v1x','v1y','v1z','v2x','v2y','v2z','Euclidean Distance','Running Average','Intensity (inner 1/3)','Average Intensity','mpX','mpY','mpZ','Diameter','dX','dY','dZ'};
 for i = 2:M+1
    for j = 1:20
        if (j < 14)
            cellInfo{i,j} = handles.branchInfo(i-1,j);
        else 
            cellInfo{i,j} = handles.branchInfo(i-1,j+1);
        end
    end
 end
 xlswrite(strcat(PathName,FileName),cellInfo);


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
