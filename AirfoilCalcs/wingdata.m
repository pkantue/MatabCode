function varargout = wingdata(varargin)
% WINGDATA M-file for wingdata.fig
%      WINGDATA, by itself, creates a new WINGDATA or raises the existing
%      singleton*.
%
%      H = WINGDATA returns the handle to a new WINGDATA or the handle to
%      the existing singleton*.
%
%      WINGDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WINGDATA.M with the given input arguments.
%
%      WINGDATA('Property','Value',...) creates a new WINGDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wingdata_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wingdata_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wingdata

% Last Modified by GUIDE v2.5 23-Feb-2011 12:06:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wingdata_OpeningFcn, ...
                   'gui_OutputFcn',  @wingdata_OutputFcn, ...
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


% --- Executes just before wingdata is made visible.
function wingdata_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wingdata (see VARARGIN)

% Choose default command line output for wingdata
handles.output = hObject;

% initialization
set(handles.weight,'String','0');
set(handles.velocity,'String','0');
set(handles.span,'String','0');
set(handles.rchord,'String','0');
set(handles.taper,'String','1');

handles.data.weight = str2double(get(handles.weight,'String'));
handles.data.V = str2double(get(handles.velocity,'String'));
handles.data.b = str2double(get(handles.span,'String'));
handles.data.c_r= str2double(get(handles.rchord,'String'));
handles.data.t_r = str2double(get(handles.taper,'String'));

% run program
[LD,CD,CLminD,CL_desc,VminD,alpha] = wingdesign(handles.data.weight,handles.data.b,...
    handles.data.c_r,handles.data.t_r,handles.data.V);

handles.data.transfer = [LD,CD,CLminD,CL_desc,VminD,alpha];

% display data
set(handles.CD,'String',num2str(CD));
set(handles.CLminD,'String',num2str(CLminD));
set(handles.CL_desc,'String',num2str(CL_desc));
set(handles.VminD,'String',num2str(VminD));
set(handles.alpha,'String',num2str(alpha));
set(handles.LD,'String',num2str(LD));
clc

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wingdata wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = wingdata_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function weight_Callback(hObject, eventdata, handles)
% hObject    handle to weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of weight as text
%        str2double(get(hObject,'String')) returns contents of weight as a double
handles.data.weight = str2double(get(hObject,'String'));

% run program
[LD,CD,CLminD,CL_desc,VminD,alpha] = wingdesign(handles.data.weight,handles.data.b,...
    handles.data.c_r,handles.data.t_r,handles.data.V);

handles.data.transfer = [LD,CD,CLminD,CL_desc,VminD,alpha];

% display data
set(handles.CD,'String',num2str(CD));
set(handles.CLminD,'String',num2str(CLminD));
set(handles.CL_desc,'String',num2str(CL_desc));
set(handles.VminD,'String',num2str(VminD));
set(handles.alpha,'String',num2str(alpha));
set(handles.LD,'String',num2str(LD));


% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function velocity_Callback(hObject, eventdata, handles)
% hObject    handle to velocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of velocity as text
%        str2double(get(hObject,'String')) returns contents of velocity as a double
handles.data.V = str2double(get(hObject,'String'));

% run program
[LD,CD,CLminD,CL_desc,VminD,alpha] = wingdesign(handles.data.weight,handles.data.b,...
    handles.data.c_r,handles.data.t_r,handles.data.V);

handles.data.transfer = [LD,CD,CLminD,CL_desc,VminD,alpha];

% display data
set(handles.CD,'String',num2str(CD));
set(handles.CLminD,'String',num2str(CLminD));
set(handles.CL_desc,'String',num2str(CL_desc));
set(handles.VminD,'String',num2str(VminD));
set(handles.alpha,'String',num2str(alpha));
set(handles.LD,'String',num2str(LD));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function velocity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to velocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function span_Callback(hObject, eventdata, handles)
% hObject    handle to span (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of span as text
%        str2double(get(hObject,'String')) returns contents of span as a double
handles.data.b = str2double(get(hObject,'String'));

% run program
[LD,CD,CLminD,CL_desc,VminD,alpha] = wingdesign(handles.data.weight,handles.data.b,...
    handles.data.c_r,handles.data.t_r,handles.data.V);

handles.data.transfer = [LD,CD,CLminD,CL_desc,VminD,alpha];

% display data
set(handles.CD,'String',num2str(CD));
set(handles.CLminD,'String',num2str(CLminD));
set(handles.CL_desc,'String',num2str(CL_desc));
set(handles.VminD,'String',num2str(VminD));
set(handles.alpha,'String',num2str(alpha));
set(handles.LD,'String',num2str(LD));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function span_CreateFcn(hObject, eventdata, handles)
% hObject    handle to span (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rchord_Callback(hObject, eventdata, handles)
% hObject    handle to rchord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rchord as text
%        str2double(get(hObject,'String')) returns contents of rchord as a double
handles.data.c_r = str2double(get(hObject,'String'));

% run program
[LD,CD,CLminD,CL_desc,VminD,alpha] = wingdesign(handles.data.weight,handles.data.b,...
    handles.data.c_r,handles.data.t_r,handles.data.V);

handles.data.transfer = [LD,CD,CLminD,CL_desc,VminD,alpha];

% display data
set(handles.CD,'String',num2str(CD));
set(handles.CLminD,'String',num2str(CLminD));
set(handles.CL_desc,'String',num2str(CL_desc));
set(handles.VminD,'String',num2str(VminD));
set(handles.alpha,'String',num2str(alpha));
set(handles.LD,'String',num2str(LD));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function rchord_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rchord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function taper_Callback(hObject, eventdata, handles)
% hObject    handle to taper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of taper as text
%        str2double(get(hObject,'String')) returns contents of taper as a double
handles.data.t_r = str2double(get(hObject,'String'));

% run program
[LD,CD,CLminD,CL_desc,VminD,alpha] = wingdesign(handles.data.weight,handles.data.b,...
    handles.data.c_r,handles.data.t_r,handles.data.V);

handles.data.transfer = [LD,CD,CLminD,CL_desc,VminD,alpha];

% display data
set(handles.CD,'String',num2str(CD));
set(handles.CLminD,'String',num2str(CLminD));
set(handles.CL_desc,'String',num2str(CL_desc));
set(handles.VminD,'String',num2str(VminD));
set(handles.alpha,'String',num2str(alpha));
set(handles.LD,'String',num2str(LD));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function taper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to taper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = handles.data;

[filesave,pathsave] = uiputfile('*.mat','Save Helicopter Geometry');
save([pathsave,filesave],'data');

% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fileopen,pathopen] = uigetfile('*.mat','Open Helicopter Geometry');
load([pathopen,fileopen]);


handles.data.weight = data.weight;
handles.data.V = data.V;
handles.data.b = data.b;
handles.data.c_r = data.c_r;
handles.data.t_r = data.t_r;

set(handles.weight,'String',num2str(handles.data.weight));
set(handles.velocity,'String',num2str(handles.data.V));
set(handles.span,'String',num2str(handles.data.b));
set(handles.rchord,'String',num2str(handles.data.c_r));
set(handles.taper,'String',num2str(handles.data.t_r));

% run program
[LD,CD,CLminD,CL_desc,VminD,alpha] = wingdesign(handles.data.weight,handles.data.b,...
    handles.data.c_r,handles.data.t_r,handles.data.V);

handles.data.transfer = [LD,CD,CLminD,CL_desc,VminD,alpha];

% display data
set(handles.CD,'String',num2str(CD));
set(handles.CLminD,'String',num2str(CLminD));
set(handles.CL_desc,'String',num2str(CL_desc));
set(handles.VminD,'String',num2str(VminD));
set(handles.alpha,'String',num2str(alpha));
set(handles.LD,'String',num2str(LD));


% Update handles structure
guidata(hObject, handles);


