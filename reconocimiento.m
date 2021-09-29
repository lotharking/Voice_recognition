function varargout = reconocimiento(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @reconocimiento_OpeningFcn, ...
                   'gui_OutputFcn',  @reconocimiento_OutputFcn, ...
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


% --- Executes just before reconocimiento is made visible.
function reconocimiento_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to reconocimiento (see VARARGIN)

% Choose default command line output for reconocimiento
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes reconocimiento wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = reconocimiento_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Ingresar.
function Ingresar_Callback(hObject, eventdata, handles)
% hObject    handle to Ingresar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
global Fs t;
Fs=44100;
recObj = audiorecorder(Fs,24,2);
recObj.StartFcn = 'disp(''   iniciando grabación'')';
recObj.StopFcn = 'disp(''   terminando grabación'')';

recordblocking(recObj,2);

y = recObj.getaudiodata();

ts=1/Fs;
t=0:ts:2-ts;
len = length(y);
audiowrite('audios/prueba.wav',y,Fs); 
sound(y,Fs)
axes(handles.axes1);
plot(t,y);
grid on


% --- Executes on button press in Comparar.
function Comparar_Callback(hObject, eventdata, handles)
% hObject    handle to Comparar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
global Fs t;
s = audioread('audios/prueba.wav');
%comparacion
s_norm= normalizar(s);
min_error=100000;
coeffs1=abs(fft(s_norm));
coeffs3=coeffs1(1:end/2);
nombre=' ';
cant_audios = dir(['audios/' '*.wav']); 

for k = 1:length(cant_audios)
    audio_nom = cant_audios(k).name; 
    
    if ~strcmp(audio_nom,'prueba.wav')
        voz = audioread(strcat('audios/',audio_nom));
        voz_norm=normalizar(voz);
        coeffs2=abs(fft(voz_norm));
        coeffs4=coeffs2(1:end/2);
        actual_error=mean(abs(coeffs3 - coeffs4));
        if actual_error < min_error 
            min_error=actual_error;
            if min_error>8.7
            nombre="No hay coincidencias";
            else
            nombre=audio_nom;  
            end
        end  
    end       
end

disp(min_error);
disp(nombre);
axes(handles.axes2);
plot(coeffs3);
grid on

axes(handles.axes3);
plot(coeffs4);
grid on

%normalizacion
function sonN=normalizar(sonido)
maximo = max(abs(sonido));
len = length(sonido);
sonN = zeros(len,1);

for i = 1:1:len
    sonN(i) = sonido(i)/maximo(1);
end

function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Fs;
leer=get(handles.Nombre,'String');
leer=strcat(leer,'.wav');
leer=strcat('audios/',leer)

Fs=44100;
recObj = audiorecorder(Fs,24,1);
recObj.StartFcn = 'disp(''   iniciando grabación'')';
recObj.StopFcn = 'disp(''   terminando grabación'')';
recordblocking(recObj,2);
y = recObj.getaudiodata();
audiowrite(leer,y,Fs); 
sound(y,Fs);
ts=1/Fs;
t=0:ts:2-ts;
axes(handles.axes1);
plot(t,y);
grid on

function Nombre_Callback(hObject, eventdata, handles)
% hObject    handle to Nombre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nombre as text
%        str2double(get(hObject,'String')) returns contents of Nombre as a double


% --- Executes during object creation, after setting all properties.
function Nombre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nombre (see GCBO)
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


% --- Executes on button press in borrar.
function borrar_Callback(hObject, eventdata, handles)
leer=get(handles.edit2,'String');
leer=strcat(leer,'.wav');
leer=strcat('audios/',leer);
delete(leer);
