function varargout = attendance(varargin)
% ATTENDANCE MATLAB code for attendance.fig
%      ATTENDANCE, by itself, creates a new ATTENDANCE or raises the existing
%      singleton*.
%
%      H = ATTENDANCE returns the handle to a new ATTENDANCE or the handle to
%      the existing singleton*.
%
%      ATTENDANCE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ATTENDANCE.M with the given input arguments.
%
%      ATTENDANCE('Property','Value',...) creates a new ATTENDANCE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before attendance_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to attendance_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
 
% Edit the above text to modify the response to help attendance
 
% Last Modified by GUIDE v2.5 27-Feb-2020 12:38:22
 
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @attendance_OpeningFcn, ...
                   'gui_OutputFcn',  @attendance_OutputFcn, ...
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
 
 
% --- Executes just before attendance is made visible.
function attendance_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to attendance (see VARARGIN)
 
% Choose default command line output for attendance
handles.output = hObject;
set(handles.table, 'Data', {})
handles.st = [];
handles.counter = 0;
% Update handles structure
guidata(hObject, handles);
 
% UIWAIT makes attendance wait for user response (see UIRESUME)
% uiwait(handles.figure1);
 
 
% --- Outputs from this function are returned to the command line.
function varargout = attendance_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Get default command line output from handles structure
global co
clc
warning off
st = version;
if str2double(st(1)) < 8 
    beep
    hx  = msgbox('PLEASE RUN IT ON MATLAB 2013 or Higher','INFO...!!!','warn','modal');
    pause(3)
    delete(hx)
    close(gcf)
    return
end
co = get(hObject,'color');
addpath(pwd,'database','codes')
if size(ls('database'),2) == 2
    delete('features.mat');
    delete('info.mat');
end
% Get default command line output from handles structure
varargout{1} = handles.output;
% --- Executes on button press in MARK_ATTENDANCE.
 
% --- Executes when entered data in editable cell(s) in table.
function table_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%   Indices: row and column indices of the cell(s) edited
%   PreviousData: previous data for the cell(s) edited
%   EditData: string(s) entered by the user
%   NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%   Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
 
% --- Executes on button press in CLASSIFY.
function LOAD_PICTURE_Callback(hObject, eventdata, handles)
% hObject    handle to CLASSIFY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global co
clc;
% directory = uigetdir();
% dInfo = dir(directory);
[files, path] = uigetfile ({'*.jpg';'*.bmp';'*.png'}, 'File Selector');
fullFileName = fullfile(path, files); 
%len = length(dInfo)
img = imread(fullFileName); 
% figure(1);
axes(handles.axes1);
imshow(img); 
FaceDetect = vision.CascadeObjectDetector; 
FaceDetect.MergeThreshold = 7 ;
BB = step(FaceDetect, img); 
% figure(2);
axes(handles.axes2);
imshow(img);
for i = 1 : size(BB,1)     
  rectangle('Position', BB(i,:), 'LineWidth', 3, 'LineStyle', '-', 'EdgeColor', 'r'); 
end 
for i = 1 : size(BB, 1) 
  J = imcrop(img, BB(i, :));
  res = imresize(J,[300 300]);
  D = ['test/' date '/'];
  if not(exist(D,'dir'))
    mkdir(D);
  end
  n = ['test/' date '/' int2str(i) '.jpg'];
  imwrite(res,n);
  % figure(3);
  % subplot(6, 6, i);
  % imshow(J); 
end
%Code End
 
% --- Executes on button press in CAPTURE_DATABASE.
function CAPTURE_DATABASE_Callback(hObject, eventdata, handles)
% hObject    handle to CAPTURE_DATABASE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global co
clc;
% directory = uigetdir();
% dInfo = dir(directory)
% [files, path] = uigetfile ({'*.jpg';'*.bmp';'*.png'}, 'File Selector');
% fullFileName = fullfile(path, files);
D = 'database/';
Data = 'database/data/';
f_dir = dir(fullfile(Data,'*.jpg'));
f = dir(fullfile(D,'*.jpg'));
len = length(f);
len_1 = length(f_dir);
% len = length(dInfo)
for i= 1:length(f)
    img = imread(fullfile(D,f(i).name)); 
    % figure(1);
    axes(handles.axes1);
    imshow(img); 
    FaceDetect = vision.CascadeObjectDetector; 
    FaceDetect.MergeThreshold = 7 ;
    BB = step(FaceDetect, img); 
    % figure(2);
    axes(handles.axes2);
    imshow(img);
    for j = 1 : size(BB,1)     
        rectangle('Position', BB(j,:), 'LineWidth', 3, 'LineStyle', '-', 'EdgeColor', 'r'); 
    end 
    for k = 1 : size(BB, 1) 
        J = imcrop(img, BB(k, :));
        res = imresize(J,[300 300]);
%         if not(exist(D,'dir'))
%             mkdir(D);
%         end
        len_1 = len_1 + 1
        n = ['database/' 'data/' int2str(len_1) '.jpg'];
        imwrite(res,n);
        % figure(3);
        % subplot(6, 6, i);
        % imshow(J);
    end
end
%Code End
    
% hold off;
% figure(1);
% --- Executes on button press in RESET_DATA.
function RESET_DATA_Callback(hObject, eventdata, handles)
% hObject    handle to RESET_DATA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% delete('features.mat');
% delete('info.mat');
% delete('database/*.*');
% delete('test_faces/*.*');
delete('attendance.mat');
delete('persons.mat');
 
% --- Executes on button press in CLASSIFY.
function CLASSIFY_Callback(hObject, eventdata, handles)
% hObject    handle to CLASSIFY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
% clc;
% [filename, folder] = uigetfile ({'*.jpg';'*.bmp';'*.png'}, 'File Selector'); 
% fullFileName = fullfile(folder, filename); 
% img = imread(fullFileName); 
% % figure(1);
% axes(handles.axes1);
% imshow(img); 
% FaceDetect = vision.CascadeObjectDetector; 
% FaceDetect.MergeThreshold = 7 ;
% BB = step(FaceDetect, img); 
% % figure(2);
% axes(handles.axes2);
% imshow(img);
% for i = 1 : size(BB,1)     
%   rectangle('Position', BB(i,:), 'LineWidth', 3, 'LineStyle', '-', 'EdgeColor', 'r'); 
% end 
% for i = 1 : size(BB, 1)
%   J = imcrop(img, BB(i, :));
%   res = imresize(J,[300 300]);
%   n = ['temp/' int2str(i) '.jpg'];
%   imwrite(res,n);
%   % figure(3);
%   % subplot(6, 6, i);
%   % imshow(J); 
% end
set(handles.table,'Data',{});
builddatabase();
 
% --- Executes on button press in MARK_ATTENDANCE.
function MARK_ATTENDANCE_Callback(hObject, eventdata, handles)
% hObject    handle to MARK_ATTENDANCE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load data_base ps absent
at = [];
for i=1:length(ps)
    % fprintf('%s %s %s\n',ps{i},date,'Present');
    %set(handles.table)
    at = [at; {ps{i}, date, 'Present'}];
    set(handles.table,'Data',at);
end
for i=1:length(absent)
    % fprintf('%s %s %s\n',ps{i},date,'Present');
    %set(handles.table)
    at = [at; {absent{i}, date, 'Absent'}];
    set(handles.table,'Data',at);
end
filename = [date '.xlsx'];
% filename = 'attendance_data.xlsx';
xlswrite(filename,at);
save attendance at
 
% --- Executes during object creation, after setting all properties.
function COUNT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to COUNT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


