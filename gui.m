function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 04-Feb-2017 12:28:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
cam_list = webcamlist;
cam_list = [{'Choose camera'};cam_list];
if size(cam_list,1) < 2
    set(handles.cam_on_btt,'Enable','off');
    set(handles.cam_list,'Enable','off');
else
    cam_list = cam_list(2:size(cam_list));
end
set(handles.cam_list,'String',cam_list,'Value',1);
set(handles.cam_off_btt,'Enable','off');
set(handles.take_pic_btt,'Enable','off');
set(handles.analyze_btt,'Enable','off');
% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in br_image_btt.
function br_image_btt_Callback(hObject, eventdata, handles)
handles.index = 1;
handles.output = hObject;
[fn pn] = uigetfile('*.jpg;*.png;*.bmp','select image file');
complete = strcat(pn,fn);
global img;
img = imread(complete);
axes(handles.raw_image);
imshow(img);
set(handles.analyze_btt,'Enable','on');


% --- Executes on button press in cam_on_btt.
function cam_on_btt_Callback(hObject, eventdata, handles)
handles.index = 2;
set(handles.cam_on_btt,'Enable','off');
set(handles.take_pic_btt,'Enable','on');
set(handles.cam_off_btt,'Enable','on');
global cam;
cam = webcam(get(handles.cam_list,'Value'));
preview(cam);


% --- Executes on button press in cam_off_btt.
function cam_off_btt_Callback(hObject, eventdata, handles)
handles.index = 3;
global cam;
closePreview(cam);
clear global cam;
set(handles.cam_on_btt,'Enable','on');
set(handles.take_pic_btt,'Enable','off');
set(handles.cam_off_btt,'Enable','off');



% --- Executes on button press in take_pic_btt.
function take_pic_btt_Callback(hObject, eventdata, handles)
handles.index = 5;
global cam;
global img;
img = snapshot(cam);
axes(handles.raw_image);
imshow(img);
set(handles.analyze_btt,'Enable','on');
% hObject    handle to take_pic_btt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in analyze_btt.
function analyze_btt_Callback(hObject, eventdata, handles)
handles.index = 4;
set(handles.analyze_btt,'Enable','off');
global img;
[rows, columns, numberOfColorChannels] = size(img);
if numberOfColorChannels > 1
    img1 = rgb2gray(img);
else
    img1 = img;
end
img1 = im2bw(img1);
axes(handles.anal_image);
imshow(img1);

% --- Executes on selection change in cam_list.
function cam_list_Callback(hObject, eventdata, handles)
% hObject    handle to cam_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cam_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cam_list


% --- Executes during object creation, after setting all properties.
function cam_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cam_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
