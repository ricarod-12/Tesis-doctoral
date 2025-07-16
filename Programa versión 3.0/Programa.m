function varargout = Programa(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Programa_OpeningFcn, ...
                   'gui_OutputFcn',  @Programa_OutputFcn, ...
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


% --- Executes just before Programa is made visible.
function Programa_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Programa_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
set(hObject,'String','Calculando...')
set(hObject,'BackgroundColor',[1.0 0.0 0.0])
set(hObject,'Enable','off')

axes(handles.axes2)
title("Path loss -- GHz")

cla(handles.axes2)


axes(handles.axes4)
imshow('img\loading.jpg')
pause(0.1)

global BW;
global polarizacion;

f_0 = str2double(get(handles.edit1,'String'))*1e9;
BW  = str2double(get(handles.edit2,'String'))*1e9;
N   = str2double(get(handles.edit3,'String'));
P_0 = str2double(get(handles.edit31,'String'));


dist = linspace(1,str2double(get(handles.edit4,'String')),str2double(get(handles.edit28,'String')));

e_hoja_real       = str2double(get(handles.edit5,'String'));
e_hoja_img        = str2double(get(handles.edit6,'String'));
perm_real_suelo   = str2double(get(handles.edit9,'String'));


a    = str2double(get(handles.edit11,'String'))*(1e-2);
t    = str2double(get(handles.edit12,'String'))*(1e-3);
p    = str2double(get(handles.edit13,'String'));
teta = (str2double(get(handles.edit14,'String'))*pi)/180;


hrx         = str2double(get(handles.edit16,'String'));
drx_der     = str2double(get(handles.edit17,'String'));
drx_izq     = str2double(get(handles.edit18,'String'));
htx         = str2double(get(handles.edit22,'String'));
dtx_der     = str2double(get(handles.edit23,'String'));
dtx_izq     = str2double(get(handles.edit24,'String'));


Gto         = str2double(get(handles.edit25,'String')); 
Gro         = str2double(get(handles.edit26,'String'));


% Añadimo la ruta de las funciones
addpath(genpath('funciones'))


% Se realiza los calculos de pathloss
global perdidas_suelo perdidas_arboles perdidas_totales perdidas_free_space offset

[perdidas_free_space, offset] = free_space_loss(str2double(get(handles.edit4,'String')),f_0,Gto,Gro,P_0);

[perdidas_suelo, perdidas_arboles, perdidas_totales] = pathloss(f_0,BW,N,dist,e_hoja_real,e_hoja_img,perm_real_suelo,a,t,p,teta,hrx,drx_der,drx_izq,htx,dtx_der,dtx_izq,Gto,Gro,offset,polarizacion);



%Se realiza las regresiones
global regresion_r alfa_r beta_r sigma_r regresion_ra alfa_ra beta_ra sigma_ra regresion_t alfa_t beta_t sigma_t;

[regresion_r,  alfa_r,  beta_r,  sigma_r]  = modelo_abg(dist', perdidas_suelo');
[regresion_ra, alfa_ra, beta_ra, sigma_ra] = modelo_abg(dist', perdidas_arboles');
[regresion_t,  alfa_t, beta_t,   sigma_t]  = modelo_abg(dist', perdidas_totales');


set(handles.uitable1,'Data',[ alfa_r beta_r sigma_r;alfa_ra beta_ra sigma_ra; alfa_t, beta_t, sigma_t]);

% Actualizamos los valores de la ventana cálculos
set(handles.edit32,'String',perdidas_free_space(str2double(get(handles.edit4,'String'))));
set(handles.text51,'String',perdidas_suelo(str2double(get(handles.edit4,'String'))));
set(handles.text54,'String',perdidas_totales(str2double(get(handles.edit4,'String'))));
set(handles.text57,'String',offset);

%Guardamos las variables globales
global distancia_plot;
distancia_plot = dist;
global plot_f0;
plot_f0 = f_0;
global escala_plot;


set(hObject,'BackgroundColor',[0.3020    0.7490    0.929])
set(hObject,'String','Lanzar simulación!')
set(hObject,'Enable','on')


axes(handles.axes2)
if (escala_plot)
    if get(handles.checkbox1,'Value')
        semilogx(distancia_plot,perdidas_suelo,'--m','LineWidth',1.5,'DisplayName','Directo+reflejado suelo')  % directo reflejado suelo
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_r,':m','LineWidth',1.4,'DisplayName','Directo+reflejado suelo regresión')
        end
    end
    if get(handles.checkbox2,'Value')
        semilogx(distancia_plot,perdidas_arboles,'--g','LineWidth',1.5,'DisplayName','Directo+reflejado árboles') % directo reflejados árboles
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_ra,':g','LineWidth',1.4,'DisplayName','Directo+reflejado árboles regresión')
        end
    end
    if get(handles.checkbox3,'Value')
        semilogx(distancia_plot,perdidas_totales,'b','LineWidth',2,'DisplayName','Directo+reflejado totales')    % Perdidas totales
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_t,':b','LineWidth',1.4,'DisplayName','Directo+reflejado totales regresión')
        end
    end
    hold off
        
else
    if get(handles.checkbox1,'Value')
        plot(distancia_plot,perdidas_suelo,'--m','LineWidth',1.5,'DisplayName','Directo+reflejado suelo')  % directo reflejado suelo
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_r,':m','LineWidth',1.4,'DisplayName','Directo+reflejado suelo regresión')
        end
    end
    if get(handles.checkbox2,'Value')
        plot(distancia_plot,perdidas_arboles,'--g','LineWidth',1.5,'DisplayName','Directo+reflejado árboles') % directo reflejados árboles
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_ra,':g','LineWidth',1.4,'DisplayName','Directo+reflejado árboles regresión')
        end
    end
    if get(handles.checkbox3,'Value')
        plot(distancia_plot,perdidas_totales,'b','LineWidth',2,'DisplayName','Directo+reflejado totales')    % Perdidas totales
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_t,':b','LineWidth',1.4,'DisplayName','Directo+reflejado totales regresión')
        end
    end
    hold off
    
end
title("Path loss " + num2str(f_0/1e9) + " GHz")
xlabel('Distancia Tx-Rx (m)')
ylabel('Path loss (dB)')
grid on
xlim([0 str2double(get(handles.edit4,'String'))])
legend('Location','southeast')


function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit9_Callback(hObject, eventdata, handles)

function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)

function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit6_Callback(hObject, eventdata, handles)

function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit11_Callback(hObject, eventdata, handles)

function edit11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit12_Callback(hObject, eventdata, handles)

function edit12_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit13_Callback(hObject, eventdata, handles)

function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)

function edit14_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
global distancia_plot plot_f0 perdidas_suelo perdidas_arboles perdidas_totales escala_plot regresion_r regresion_ra regresion_t;

axes(handles.axes2)

if (escala_plot)
    if get(handles.checkbox1,'Value')
        semilogx(distancia_plot,perdidas_suelo,'--m','LineWidth',1.5,'DisplayName','Directo+reflejado suelo')  % directo reflejado suelo
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_r,':m','LineWidth',1.4,'DisplayName','Directo+reflejado suelo regresión')
        end
    end
    if get(handles.checkbox2,'Value')
        semilogx(distancia_plot,perdidas_arboles,'--g','LineWidth',1.5,'DisplayName','Directo+reflejado árboles') % directo reflejados árboles
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_ra,':g','LineWidth',1.4,'DisplayName','Directo+reflejado árboles regresión')
        end
    end
    if get(handles.checkbox3,'Value')
        semilogx(distancia_plot,perdidas_totales,'b','LineWidth',2,'DisplayName','Directo+reflejado totales')    % Perdidas totales
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_t,':b','LineWidth',1.4,'DisplayName','Directo+reflejado totales regresión')
        end
    end
    hold off
        
else
    if get(handles.checkbox1,'Value')
        plot(distancia_plot,perdidas_suelo,'--m','LineWidth',1.5,'DisplayName','Directo+reflejado suelo')  % directo reflejado suelo
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_r,':m','LineWidth',1.4,'DisplayName','Directo+reflejado suelo regresión')
        end
    end
    if get(handles.checkbox2,'Value')
        plot(distancia_plot,perdidas_arboles,'--g','LineWidth',1.5,'DisplayName','Directo+reflejado árboles') % directo reflejados árboles
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_ra,':g','LineWidth',1.4,'DisplayName','Directo+reflejado árboles regresión')
        end
    end
    if get(handles.checkbox3,'Value')
        plot(distancia_plot,perdidas_totales,'b','LineWidth',2,'DisplayName','Directo+reflejado totales')    % Perdidas totales
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_t,':b','LineWidth',1.4,'DisplayName','Directo+reflejado totales regresión')
        end
    end
    hold off
    
end
title("Path loss " + num2str(plot_f0/1e9) + " GHz")
xlabel('Distancia Tx-Rx (m)')
ylabel('Path loss (dB)')
grid on
xlim([0 str2double(get(handles.edit4,'String'))])
legend('Location','southeast')




function checkbox2_Callback(hObject, eventdata, handles)
global distancia_plot plot_f0 perdidas_suelo perdidas_arboles perdidas_totales escala_plot regresion_r regresion_ra regresion_t;

axes(handles.axes2)

if (escala_plot)
    if get(handles.checkbox1,'Value')
        semilogx(distancia_plot,perdidas_suelo,'--m','LineWidth',1.5,'DisplayName','Directo+reflejado suelo')  % directo reflejado suelo
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_r,':m','LineWidth',1.4,'DisplayName','Directo+reflejado suelo regresión')
        end
    end
    if get(handles.checkbox2,'Value')
        semilogx(distancia_plot,perdidas_arboles,'--g','LineWidth',1.5,'DisplayName','Directo+reflejado árboles') % directo reflejados árboles
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_ra,':g','LineWidth',1.4,'DisplayName','Directo+reflejado árboles regresión')
        end
    end
    if get(handles.checkbox3,'Value')
        semilogx(distancia_plot,perdidas_totales,'b','LineWidth',2,'DisplayName','Directo+reflejado totales')    % Perdidas totales
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_t,':b','LineWidth',1.4,'DisplayName','Directo+reflejado totales regresión')
        end
    end
    hold off
        
else
    if get(handles.checkbox1,'Value')
        plot(distancia_plot,perdidas_suelo,'--m','LineWidth',1.5,'DisplayName','Directo+reflejado suelo')  % directo reflejado suelo
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_r,':m','LineWidth',1.4,'DisplayName','Directo+reflejado suelo regresión')
        end
    end
    if get(handles.checkbox2,'Value')
        plot(distancia_plot,perdidas_arboles,'--g','LineWidth',1.5,'DisplayName','Directo+reflejado árboles') % directo reflejados árboles
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_ra,':g','LineWidth',1.4,'DisplayName','Directo+reflejado árboles regresión')
        end
    end
    if get(handles.checkbox3,'Value')
        plot(distancia_plot,perdidas_totales,'b','LineWidth',2,'DisplayName','Directo+reflejado totales')    % Perdidas totales
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_t,':b','LineWidth',1.4,'DisplayName','Directo+reflejado totales regresión')
        end
    end
    hold off
    
end
title("Path loss " + num2str(plot_f0/1e9) + " GHz")
xlabel('Distancia Tx-Rx (m)')
ylabel('Path loss (dB)')
grid on
xlim([0 str2double(get(handles.edit4,'String'))])
legend('Location','southeast')


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
global distancia_plot plot_f0 perdidas_suelo perdidas_arboles perdidas_totales escala_plot regresion_r regresion_ra regresion_t;

axes(handles.axes2)

if (escala_plot)
    if get(handles.checkbox1,'Value')
        semilogx(distancia_plot,perdidas_suelo,'--m','LineWidth',1.5,'DisplayName','Directo+reflejado suelo')  % directo reflejado suelo
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_r,':m','LineWidth',1.4,'DisplayName','Directo+reflejado suelo regresión')
        end
    end
    if get(handles.checkbox2,'Value')
        semilogx(distancia_plot,perdidas_arboles,'--g','LineWidth',1.5,'DisplayName','Directo+reflejado árboles') % directo reflejados árboles
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_ra,':g','LineWidth',1.4,'DisplayName','Directo+reflejado árboles regresión')
        end
    end
    if get(handles.checkbox3,'Value')
        semilogx(distancia_plot,perdidas_totales,'b','LineWidth',2,'DisplayName','Directo+reflejado totales')    % Perdidas totales
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_t,':b','LineWidth',1.4,'DisplayName','Directo+reflejado totales regresión')
        end
    end
    hold off
        
else
    if get(handles.checkbox1,'Value')
        plot(distancia_plot,perdidas_suelo,'--m','LineWidth',1.5,'DisplayName','Directo+reflejado suelo')  % directo reflejado suelo
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_r,':m','LineWidth',1.4,'DisplayName','Directo+reflejado suelo regresión')
        end
    end
    if get(handles.checkbox2,'Value')
        plot(distancia_plot,perdidas_arboles,'--g','LineWidth',1.5,'DisplayName','Directo+reflejado árboles') % directo reflejados árboles
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_ra,':g','LineWidth',1.4,'DisplayName','Directo+reflejado árboles regresión')
        end
    end
    if get(handles.checkbox3,'Value')
        plot(distancia_plot,perdidas_totales,'b','LineWidth',2,'DisplayName','Directo+reflejado totales')    % Perdidas totales
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_t,':b','LineWidth',1.4,'DisplayName','Directo+reflejado totales regresión')
        end
    end
    hold off
    
end
title("Path loss " + num2str(plot_f0/1e9) + " GHz")
xlabel('Distancia Tx-Rx (m)')
ylabel('Path loss (dB)')
grid on
xlim([0 str2double(get(handles.edit4,'String'))])
legend('Location','southeast')


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
set(handles.uipanel3,'visible','on')
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
set(handles.uipanel3,'visible','off')



function edit22_Callback(hObject, eventdata, handles)

function edit22_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)

function edit23_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)

function edit24_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)

function edit16_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit17_Callback(hObject, eventdata, handles)

function edit17_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit18_Callback(hObject, eventdata, handles)


function edit18_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function radiobutton2_Callback(hObject, eventdata, handles)
function edit25_Callback(hObject, eventdata, handles)


function edit25_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit26_Callback(hObject, eventdata, handles)

function edit26_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function uipanel1_CreateFcn(hObject, eventdata, handles)
function uipanel3_CreateFcn(hObject, eventdata, handles)
function uipanel3_DeleteFcn(hObject, eventdata, handles)
function uipanel3_SizeChangedFcn(hObject, eventdata, handles)
function uipanel3_ButtonDownFcn(hObject, eventdata, handles)
function edit28_Callback(hObject, eventdata, handles)




% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
set(handles.edit1,'String','2.5')
set(handles.edit2,'String','1')
set(handles.edit3,'String','2001')
set(handles.edit4,'String','50')
set(handles.edit5,'String','23.26')
set(handles.edit6,'String','7.26')
set(handles.edit9,'String','6')
set(handles.edit11,'String','5')
set(handles.edit12,'String','0.2')
set(handles.edit13,'String','200')
set(handles.edit14,'String','30')

set(handles.edit16,'String','1.5')
set(handles.edit17,'String','1.25')
set(handles.edit18,'String','1.25')
set(handles.edit22,'String','1.5')
set(handles.edit23,'String','1.25')
set(handles.edit24,'String','1.25')
set(handles.edit25,'String','1.75')
set(handles.edit26,'String','1.75')
set(handles.edit28,'String','50')

set(handles.checkbox1,'Value',1.0)
set(handles.checkbox2,'Value',1.0)
set(handles.checkbox3,'Value',1.0)

global escala_plot;
escala_plot = true;
set(handles.checkbox4,'Value',0.0)
set(handles.checkbox5,'Value',1.0)

axes(handles.axes2)
title("Path loss -- GHz")
xlim([0 str2double(get(handles.edit4,'String'))])

cla(handles.axes2)

set(handles.uitable1,'Data',[0 0 0;0 0 0; 0 0 0]);


global polarizacion;
polarizacion = 1;
set(handles.checkbox9,'Value',1.0)
set(handles.checkbox8,'Value',0.0)





function axes2_CreateFcn(hObject, eventdata, handles)
global escala_plot polarizacion;
escala_plot = true;      %Se inicia con true log
polarizacion = 1;

axes(hObject)
title("Path loss -- GHz")
xlabel('Distancia Tx-Rx (m)')
ylabel('Path loss (dB)')
grid on
% legend('Location','southeast')


function axes4_CreateFcn(hObject, eventdata, handles)
function uipanel1_DeleteFcn(hObject, eventdata, handles)
function axes6_CreateFcn(hObject, eventdata, handles)


function checkbox5_Callback(hObject, eventdata, handles)
global distancia_plot plot_f0 perdidas_suelo perdidas_arboles perdidas_totales escala_plot regresion_r regresion_ra regresion_t;
escala_plot = true;
set(hObject,'Value',1.0)
set(handles.checkbox4,'Value',0.0)

axes(handles.axes2)
if (escala_plot)
    if get(handles.checkbox1,'Value')
        semilogx(distancia_plot,perdidas_suelo,'--m','LineWidth',1.5,'DisplayName','Directo+reflejado suelo')  % directo reflejado suelo
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_r,':m','LineWidth',1.4,'DisplayName','Directo+reflejado suelo regresión')
        end
    end
    if get(handles.checkbox2,'Value')
        semilogx(distancia_plot,perdidas_arboles,'--g','LineWidth',1.5,'DisplayName','Directo+reflejado árboles') % directo reflejados árboles
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_ra,':g','LineWidth',1.4,'DisplayName','Directo+reflejado árboles regresión')
        end
    end
    if get(handles.checkbox3,'Value')
        semilogx(distancia_plot,perdidas_totales,'b','LineWidth',2,'DisplayName','Directo+reflejado totales')    % Perdidas totales
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_t,':b','LineWidth',1.4,'DisplayName','Directo+reflejado totales regresión')
        end
    end
    hold off    
else
    if get(handles.checkbox1,'Value')
        plot(distancia_plot,perdidas_suelo,'--m','LineWidth',1.5,'DisplayName','Directo+reflejado suelo')  % directo reflejado suelo
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_r,':m','LineWidth',1.4,'DisplayName','Directo+reflejado suelo regresión')
        end
    end
    if get(handles.checkbox2,'Value')
        plot(distancia_plot,perdidas_arboles,'--g','LineWidth',1.5,'DisplayName','Directo+reflejado árboles') % directo reflejados árboles
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_ra,':g','LineWidth',1.4,'DisplayName','Directo+reflejado árboles regresión')
        end
    end
    if get(handles.checkbox3,'Value')
        plot(distancia_plot,perdidas_totales,'b','LineWidth',2,'DisplayName','Directo+reflejado totales')    % Perdidas totales
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_t,':b','LineWidth',1.4,'DisplayName','Directo+reflejado totales regresión')
        end
    end
    hold off
    
end
title("Path loss " + num2str(plot_f0/1e9) + " GHz")
xlabel('Distancia Tx-Rx (m)')
ylabel('Path loss (dB)')
grid on
xlim([0 str2double(get(handles.edit4,'String'))])
legend('Location','southeast')




% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
global distancia_plot plot_f0 perdidas_suelo perdidas_arboles perdidas_totales escala_plot regresion_r regresion_ra regresion_t;
escala_plot = false;
set(hObject,'Value',1.0)
set(handles.checkbox5,'Value',0.0)

axes(handles.axes2)
if (escala_plot)
    if get(handles.checkbox1,'Value')
        semilogx(distancia_plot,perdidas_suelo,'--m','LineWidth',1.5,'DisplayName','Directo+reflejado suelo')  % directo reflejado suelo
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_r,':m','LineWidth',1.4,'DisplayName','Directo+reflejado suelo regresión')
        end
    end
    if get(handles.checkbox2,'Value')
        semilogx(distancia_plot,perdidas_arboles,'--g','LineWidth',1.5,'DisplayName','Directo+reflejado árboles') % directo reflejados árboles
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_ra,':g','LineWidth',1.4,'DisplayName','Directo+reflejado árboles regresión')
        end
    end
    if get(handles.checkbox3,'Value')
        semilogx(distancia_plot,perdidas_totales,'b','LineWidth',2,'DisplayName','Directo+reflejado totales')    % Perdidas totales
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_t,':b','LineWidth',1.4,'DisplayName','Directo+reflejado totales regresión')
        end
    end
    hold off
        
else
    if get(handles.checkbox1,'Value')
        plot(distancia_plot,perdidas_suelo,'--m','LineWidth',1.5,'DisplayName','Directo+reflejado suelo')  % directo reflejado suelo
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_r,':m','LineWidth',1.4,'DisplayName','Directo+reflejado suelo regresión')
        end
    end
    if get(handles.checkbox2,'Value')
        plot(distancia_plot,perdidas_arboles,'--g','LineWidth',1.5,'DisplayName','Directo+reflejado árboles') % directo reflejados árboles
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_ra,':g','LineWidth',1.4,'DisplayName','Directo+reflejado árboles regresión')
        end
    end
    if get(handles.checkbox3,'Value')
        plot(distancia_plot,perdidas_totales,'b','LineWidth',2,'DisplayName','Directo+reflejado totales')    % Perdidas totales
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_t,':b','LineWidth',1.4,'DisplayName','Directo+reflejado totales regresión')
        end
    end
    hold off
    
end

title("Path loss " + num2str(plot_f0/1e9) + " GHz")
xlabel('Distancia Tx-Rx (m)')
ylabel('Path loss (dB)')
grid on
xlim([0 str2double(get(handles.edit4,'String'))])
legend('Location','southeast')


% --- Executes during object creation, after setting all properties.
function axes9_CreateFcn(hObject, eventdata, handles)
axes(hObject)
imshow('arboles.jpg')


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
set(handles.uibuttongroup14,'visible','on')
set(handles.uibuttongroup16,'visible','off')
set(handles.uibuttongroup5,'visible','off')
set(handles.uibuttongroup3,'visible','off')
set(handles.uibuttongroup4,'visible','off')


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
set(handles.uibuttongroup14,'visible','off')
set(handles.uibuttongroup16,'visible','on')
set(handles.uibuttongroup5,'visible','off')
set(handles.uibuttongroup3,'visible','off')
set(handles.uibuttongroup4,'visible','off')

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
set(handles.uibuttongroup14,'visible','off')
set(handles.uibuttongroup16,'visible','off')
set(handles.uibuttongroup5,'visible','on')
set(handles.uibuttongroup3,'visible','off')
set(handles.uibuttongroup4,'visible','off')


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
set(handles.uibuttongroup14,'visible','off')
set(handles.uibuttongroup16,'visible','off')
set(handles.uibuttongroup5,'visible','off')
set(handles.uibuttongroup3,'visible','on')
set(handles.uibuttongroup4,'visible','on')


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
global distancia_plot plot_f0 perdidas_suelo perdidas_arboles perdidas_totales escala_plot regresion_r regresion_ra regresion_t;

if (escala_plot)
    if get(handles.checkbox1,'Value')
        semilogx(distancia_plot,perdidas_suelo,'--m','LineWidth',1.5,'DisplayName','Directo+reflejado suelo')  % directo reflejado suelo
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_r,':m','LineWidth',1.4,'DisplayName','Directo+reflejado suelo regresión')
        end
    end
    if get(handles.checkbox2,'Value')
        semilogx(distancia_plot,perdidas_arboles,'--g','LineWidth',1.5,'DisplayName','Directo+reflejado árboles') % directo reflejados árboles
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_ra,':g','LineWidth',1.4,'DisplayName','Directo+reflejado árboles regresión')
        end
    end
    if get(handles.checkbox3,'Value')
        semilogx(distancia_plot,perdidas_totales,'b','LineWidth',2,'DisplayName','Directo+reflejado totales')    % Perdidas totales
        hold on
        if get(handles.checkbox7,'Value')
            semilogx(distancia_plot,regresion_t,':b','LineWidth',1.4,'DisplayName','Directo+reflejado totales regresión')
        end
    end
    hold off      
else
    if get(handles.checkbox1,'Value')
        plot(distancia_plot,perdidas_suelo,'--m','LineWidth',1.5,'DisplayName','Directo+reflejado suelo')  % directo reflejado suelo
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_r,':m','LineWidth',1.4,'DisplayName','Directo+reflejado suelo regresión')
        end
    end
    if get(handles.checkbox2,'Value')
        plot(distancia_plot,perdidas_arboles,'--g','LineWidth',1.5,'DisplayName','Directo+reflejado árboles') % directo reflejados árboles
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_ra,':g','LineWidth',1.4,'DisplayName','Directo+reflejado árboles regresión')
        end
    end
    if get(handles.checkbox3,'Value')
        plot(distancia_plot,perdidas_totales,'b','LineWidth',2,'DisplayName','Directo+reflejado totales')    % Perdidas totales
        hold on
        if get(handles.checkbox7,'Value')
            plot(distancia_plot,regresion_t,':b','LineWidth',1.4,'DisplayName','Directo+reflejado totales regresión')
        end
    end
    hold off
end

title("Path loss " + num2str(plot_f0/1e9) + " GHz")
xlabel('Distancia Tx-Rx (m)')
ylabel('Path loss (dB)')
grid on
xlim([0 str2double(get(handles.edit4,'String'))])
legend('Location','southeast')


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
set(hObject, 'Data', cell(3));
set(hObject, 'RowName', {'Suelo', 'Árboles', 'Totales'});


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
set(gcf,'PaperPositionMode','auto')
saveas(gcf,['capturas\captura ' strrep(datestr(datetime), ':', '-') ],'png')


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
global distancia_plot plot_f0 perdidas_suelo perdidas_arboles perdidas_totales BW perdidas_free_space offset;
global regresion_r alfa_r beta_r sigma_r regresion_ra alfa_ra beta_ra sigma_ra regresion_t alfa_t beta_t sigma_t polarizacion;

save(['datos\datos guardados ', strrep(datestr(datetime), ':', '-'),'.mat'],'polarizacion','distancia_plot','plot_f0','BW','perdidas_suelo','perdidas_arboles','perdidas_totales','perdidas_free_space','regresion_r','alfa_r','beta_r','sigma_r','regresion_ra','alfa_ra','beta_ra','sigma_ra','regresion_t','alfa_t','beta_t','sigma_t','offset');


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
global polarizacion;
polarizacion = 1;
set(hObject,'Value',1.0)
set(handles.checkbox8,'Value',0.0)


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
global polarizacion;
polarizacion = 0;
set(hObject,'Value',1.0)
set(handles.checkbox9,'Value',0.0)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on pushbutton11 and none of its controls.
function pushbutton11_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
