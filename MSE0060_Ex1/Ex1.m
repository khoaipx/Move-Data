function varargout = Ex1(varargin)
% EX1 MATLAB code for Ex1.fig
%      EX1, by itself, creates a new EX1 or raises the existing
%      singleton*.
%
%      H = EX1 returns the handle to a new EX1 or the handle to
%      the existing singleton*.
%
%      EX1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EX1.M with the given input arguments.
%
%      EX1('Property','Value',...) creates a new EX1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Ex1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Ex1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Ex1

% Last Modified by GUIDE v2.5 06-Mar-2017 13:53:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Ex1_OpeningFcn, ...
                   'gui_OutputFcn',  @Ex1_OutputFcn, ...
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


% --- Executes just before Ex1 is made visible.
function Ex1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Ex1 (see VARARGIN)

% Choose default command line output for Ex1
handles.output = hObject;
handles.n = -10:0.01:10;
handles.x1 = sin(2*handles.n);
handles.x2 = sin(handles.n + 5);
handles.A1 = 2;
handles.A2 = 3;
% y = 2sin(2n) + 3sin(n+5)
handles.y = handles.A1*handles.x1 + handles.A2*handles.x2;
handles.noise = rand(1, length(handles.y));

handles.cnt = 0;

axis(handles.sum_axes,[-10 10 -5 5]);
axis(handles.func1_axes,[-10 10 0 50]);
axis(handles.func2_axes,[-10 10 0 50]);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Ex1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Ex1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in draw_btn.
function draw_btn_Callback(hObject, eventdata, handles)
% hObject    handle to draw_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla();
plot(handles.sum_axes,handles.n,handles.y,'b-');
grid on


% --- Executes on button press in noise_btn.
function noise_btn_Callback(hObject, eventdata, handles)
% hObject    handle to noise_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla();
y_noise = handles.y + handles.noise;
plot(handles.sum_axes,handles.n,y_noise);
histogram(handles.func1_axes,y_noise);
grid on


% --- Executes on button press in filter_btn.
function filter_btn_Callback(hObject, eventdata, handles)
% hObject    handle to filter_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla();
y_noise = handles.y + handles.noise;
y_noise_filtered = medfilt1(y_noise);
plot(handles.sum_axes,handles.n,y_noise_filtered);
histogram(handles.func1_axes,y_noise_filtered);
grid on


% --- Executes on button press in close_btn.
function close_btn_Callback(hObject, eventdata, handles)
% hObject    handle to close_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;


% --- Executes on button press in analysis_error_btn.
function analysis_error_btn_Callback(hObject, eventdata, handles)
% hObject    handle to analysis_error_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla();
y_noise = handles.y + handles.noise;
y_noise_filtered = medfilt1(y_noise);
% plot(handles.sum_axes,handles.n,y_noise_filtered);
% histogram(handles.func1_axes,y_noise_filtered);
snr(handles.y, y_noise_filtered)
grid on


% --- Executes on button press in cmp_hist_btn.
function cmp_hist_btn_Callback(hObject, eventdata, handles)
% hObject    handle to cmp_hist_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla();
y_noise = handles.y + handles.noise;
y_noise_filtered = medfilt1(y_noise);
histogram(handles.func1_axes,y_noise);
histogram(handles.func2_axes,y_noise_filtered);
grid on


% --- Executes on button press in shift_func_btn.
function shift_func_btn_Callback(hObject, eventdata, handles)
% hObject    handle to shift_func_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% x1(n) = x(n-20)
y1 = handles.A1*sin(2*(handles.n - 20)) + handles.A2*sin((handles.n - 20) + 5);
% x2(n) = x(n+20)
y2 = handles.A1*sin(2*(handles.n + 20)) + handles.A2*sin((handles.n + 20) + 5);
% x3(n) = x(4n)
y3 = handles.A1*sin(2*(4*handles.n)) + handles.A2*sin((4*handles.n) + 5);
% x4(n) = x(-n-20)
y4 = handles.A1*sin(2*(-handles.n - 20)) + handles.A2*sin((-handles.n - 20) + 5);
hold on
if handles.cnt==0
    cla();
    plot(handles.sum_axes,handles.n,handles.y,'b-');
    plot(handles.sum_axes,handles.n,y1,'r-');
    legend(handles.sum_axes,'y = x(n)','y = x(n-20)')
    handles.cnt=1;
    guidata(hObject, handles);
elseif handles.cnt==1
    cla();
    plot(handles.sum_axes,handles.n,handles.y,'b-');
    plot(handles.sum_axes,handles.n,y2,'r-');
    legend(handles.sum_axes,'y = x(n)','y = x(n+20)')
    handles.cnt=2;
    guidata(hObject, handles);
elseif handles.cnt==2
    cla();
    plot(handles.sum_axes,handles.n,handles.y,'b-');
    plot(handles.sum_axes,handles.n,y3,'r-');
    legend(handles.sum_axes,'y = x(n)','y = x(4n)')
    handles.cnt=3;
    guidata(hObject, handles);
elseif handles.cnt==3
    cla();
    plot(handles.sum_axes,handles.n,handles.y,'b-');
    plot(handles.sum_axes,handles.n,y4,'r-');
    legend(handles.sum_axes,'y = x(n)','y = x(-n-20)')
    handles.cnt=0;
    guidata(hObject, handles);
end
grid on
hold off
