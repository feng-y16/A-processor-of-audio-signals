function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
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
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 19-Jun-2019 10:10:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;
handles.tabManager = TabManager( hObject );
tabGroups = handles.tabManager.TabGroups;
for tgi=1:length(tabGroups)
    set(tabGroups(tgi),'SelectionChangedFcn',@tabChangedCB)
end
set(handles.edit1,'String','audio1.wav');
set(handles.edit3,'String','audio2.wav');
set(handles.edit6,'String','audio2.wav');
set(handles.slider1,'value',36);
set(handles.edit8,'String',num2str(get(handles.slider5,'value')));
set(handles.edit9,'String',num2str(get(handles.slider1,'value')));
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.Tag1);
function tabChangedCB(src, eventdata)

disp(['Changing tab from ' eventdata.OldValue.Title ' to ' eventdata.NewValue.Title ] );

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(handles.axes1,'FontSize',1)
var=get(handles.listbox2,'value');
filename=get(handles.edit1,'String');
SNR=get(handles.slider1,'value');
switch var
    case 1
        [time,s,signal,output,fs]=wavelet_GUI(filename,SNR);
    case 2
        [time,s,signal,output,fs]=subtraction_GUI(filename,SNR);
    case 3
        [time,s,signal,output,fs]=weiner_filter_GUI(filename,SNR);
end
plot(handles.axes1,time(1:round(length(time)*get(handles.slider4,'value'))),signal(1:round(length(signal)*get(handles.slider4,'value'))),'color','r','LineWidth',get(handles.slider5,'value'));
hold on
plot(handles.axes1,time(1:round(length(time)*get(handles.slider4,'value'))),output(1:round(length(output)*get(handles.slider4,'value'))),'color','y','LineWidth',get(handles.slider5,'value'));
plot(handles.axes1,time(1:round(length(time)*get(handles.slider4,'value'))),s(1:round(length(s)*get(handles.slider4,'value'))),'color','b','LineWidth',get(handles.slider5,'value'));
xlabel(handles.axes1,'t/s');
ylabel(handles.axes1,'Signals');
legend('加噪信号','去噪信号','原信号')
hold off
new_f_handle=figure('visible','off');
new_axes=copyobj(handles.axes1,new_f_handle); 
set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);
file=[num2str(now) '.png'];
legend(new_axes,'加噪信号','去噪信号','原信号')
print(new_f_handle,'-dpng',file);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
var1=get(handles.listbox2,'value');
filename=get(handles.edit1,'String');
SNR=get(handles.slider1,'value');
switch var1
    case 1
        [time,s,signal,output,fs]=wavelet_GUI(filename,SNR,1500);
    case 2
        [time,s,signal,output,fs]=subtraction_GUI(filename,SNR,1500);
    case 3
        [time,s,signal,output,fs]=weiner_filter_GUI(filename,SNR,1500);
end
var2=get(handles.listbox4,'value');
switch var2
    case 1
        sound(s,fs);
    case 2
        sound(signal,fs);
    case 3
        sound(output,fs);
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=code_GUI(get(handles.edit3,'String'));
t=0:1:length(s)-1;
plot(handles.axes1,t(1:round(length(t)*get(handles.slider4,'value'))),s(1:round(length(s)*get(handles.slider4,'value'))),'color','b','LineWidth',get(handles.slider5,'value'));
xlabel(handles.axes1,'order number')
ylabel(handles.axes1,'Signal')
new_f_handle=figure('visible','off');
new_axes=copyobj(handles.axes1,new_f_handle); 
set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);
file=[num2str(now) '.png'];
print(new_f_handle,'-dpng',file);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=decode_GUI(get(handles.edit3,'String'));
t=0:1:length(s)-1;
plot(handles.axes1,t(1:round(length(t)*get(handles.slider4,'value'))),s(1:round(length(s)*get(handles.slider4,'value'))),'color','b','LineWidth',get(handles.slider5,'value'));
xlabel(handles.axes1,'order number')
ylabel(handles.axes1,'Signal')
new_f_handle=figure('visible','off');
new_axes=copyobj(handles.axes1,new_f_handle); 
set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);
file=[num2str(now) '.png'];
print(new_f_handle,'-dpng',file);

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[s, fs] = audioread(get(handles.edit3,'String'));
sound(s,fs);


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.edit9,'String',num2str(get(handles.slider1,'value')));
var=get(handles.listbox2,'value');
filename=get(handles.edit1,'String');
SNR=get(handles.slider1,'value');
switch var
    case 1
        [time,s,signal,output,fs]=wavelet_GUI(filename,SNR);
    case 2
        [time,s,signal,output,fs]=subtraction_GUI(filename,SNR);
    case 3
        [time,s,signal,output,fs]=weiner_filter_GUI(filename,SNR);
end
plot(handles.axes1,time(1:round(length(time)*get(handles.slider4,'value'))),signal(1:round(length(signal)*get(handles.slider4,'value'))),'color','r','LineWidth',get(handles.slider5,'value'));
hold on
plot(handles.axes1,time(1:round(length(time)*get(handles.slider4,'value'))),output(1:round(length(output)*get(handles.slider4,'value'))),'color','y','LineWidth',get(handles.slider5,'value'));
plot(handles.axes1,time(1:round(length(time)*get(handles.slider4,'value'))),s(1:round(length(s)*get(handles.slider4,'value'))),'color','b','LineWidth',get(handles.slider5,'value'));
xlabel(handles.axes1,'t/s');
ylabel(handles.axes1,'Signals');
legend('加噪信号','去噪信号','原信号')
hold off
new_f_handle=figure('visible','off');
new_axes=copyobj(handles.axes1,new_f_handle); 
set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);
file=[num2str(now) '.png'];
legend(new_axes,'加噪信号','去噪信号','原信号')
print(new_f_handle,'-dpng',file);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
var=get(handles.listbox9,'value');
filename=get(handles.edit6,'String');
[s,fs]=changevoice_GUI(filename,var);
sound(s,fs);
N=length(s);
time=(0:N-1)/fs;
[s_original,fs_original]=audioread(filename);
N_original=length(s_original);
time_original=(0:N_original-1)/fs_original;
plot(handles.axes1,time_original(1:round(length(time_original)*get(handles.slider4,'value'))),s_original(1:round(length(s_original)*get(handles.slider4,'value'))),'color','b','LineWidth',get(handles.slider5,'value'));
hold on
plot(handles.axes1,time(1:round(length(time)*get(handles.slider4,'value'))),s(1:round(length(s)*get(handles.slider4,'value'))),'color','r','LineWidth',get(handles.slider5,'value'));
xlabel(handles.axes1,'t/s');
ylabel(handles.axes1,'Signals');
legend('原信号','变声信号')
hold off
new_f_handle=figure('visible','off');
new_axes=copyobj(handles.axes1,new_f_handle); 
set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);
file=[num2str(now) '.png'];
legend(new_axes,'原信号','变声信号')
print(new_f_handle,'-dpng',file);


% --- Executes on selection change in listbox9.
function listbox9_Callback(hObject, eventdata, handles)
% hObject    handle to listbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox9


% --- Executes during object creation, after setting all properties.
function listbox9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=get(handles.edit6,'String');
[s, fs] = audioread(filename);
N=length(s);
N=2^ceil(log2(N));
n=0:N-1;
f_mag=abs(fft(s,N))/N*2;
f=n*fs/N; 
f_mag=f_mag(1:length(f_mag)/2);
f=f(1:length(f)/2);
plot(handles.axes1,f(1:round(length(f)*get(handles.slider4,'value'))),f_mag(1:round(length(f_mag)*get(handles.slider4,'value'))),'color','b','LineWidth',get(handles.slider5,'value'));
hold off
new_f_handle=figure('visible','off');
new_axes=copyobj(handles.axes1,new_f_handle); 
set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);
legend(new_axes,'f','Magnitude')
file=[num2str(now) '.png'];
print(new_f_handle,'-dpng',file);




% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=get(handles.edit6,'String');
[s, fs] = audioread(filename);
p=size(s);
s1=s(3001:p(1),:);
s1=[s1;zeros(3000,p(2))];
s1=s1+s;
sound(s1,fs);

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=get(handles.edit6,'String');
[s, fs] = audioread(filename);
sound(s,fs);


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=get(handles.edit6,'String');
[s, fs] = audioread(filename);
N=length(s);
N=2^ceil(log2(N));
n=0:N-1;
f_mag=abs(fft(s,N))/N*2;
f=n*fs/N; 
f_mag=f_mag(1:length(f_mag)/2);
f=f(1:length(f)/2);
plot(handles.axes1,f(1:round(length(f)*get(handles.slider4,'value'))),f_mag(1:round(length(f_mag)*get(handles.slider4,'value'))),'color','r','LineWidth',get(handles.slider5,'value'));
hold on
p=size(s);
s1=s(3001:p(1),:);
s1=[s1;zeros(3000,p(2))];
s1=s1+s;
f_mag1=abs(fft(s1,N))/N*2; 
f_mag1=f_mag1(1:length(f_mag1)/2);
plot(handles.axes1,f(1:round(length(f)*get(handles.slider4,'value'))),f_mag1(1:round(length(f_mag)*get(handles.slider4,'value'))),'color','b','LineWidth',get(handles.slider5,'value'));
xlabel(handles.axes1,'t/s');
ylabel(handles.axes1,'Signals');
legend('原信号','混响信号')
hold off
new_f_handle=figure('visible','off');
new_axes=copyobj(handles.axes1,new_f_handle); 
set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);
file=[num2str(now) '.png'];
legend(new_axes,'原信号','混响信号')
print(new_f_handle,'-dpng',file);



% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=get(handles.edit6,'String');
[s, fs] = audioread(filename);
N=length(s);
time=(0:N-1)/fs;  
p=size(s);
s1=s(3001:p(1),:);
s1=[s1;zeros(3000,p(2))];
s1=s1+s;
plot(handles.axes1,time(1:round(length(time)*get(handles.slider4,'value'))),s1(1:round(length(s1)*get(handles.slider4,'value'))),'color','b','LineWidth',get(handles.slider5,'value'));
hold on
plot(handles.axes1,time(1:round(length(time)*get(handles.slider4,'value'))),s(1:round(length(s)*get(handles.slider4,'value'))),'color','r','LineWidth',get(handles.slider5,'value'));
xlabel(handles.axes1,'t/s')
ylabel(handles.axes1,'Signals')
legend('混响信号','原信号')
hold off
new_f_handle=figure('visible','off');
new_axes=copyobj(handles.axes1,new_f_handle); 
set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);
file=[num2str(now) '.png'];
legend(new_axes,'原信号','混响信号')
print(new_f_handle,'-dpng',file);





% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.edit8,'String',num2str(get(handles.slider5,'value')));

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
