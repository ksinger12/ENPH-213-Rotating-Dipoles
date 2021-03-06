%Written by: Kyle Singer
%function Project_213

%GUI Stuff

global alphaSlider omegaSlider radiusSlider distanceSlider charge1Slider charge2Slider
global aV oV rV dV q1V q2V

g = groot;
if(isempty(g.Children))
    alphaSlider = uicontrol(figure(1),'Style','slider','Min',0,'Max',10*10.^6,'SliderStep',[1/15 1/15],'Value', 1*10.^6, 'Position', [120 20 60 20], 'Callback','Project_213');
    aV = uicontrol(figure(1),'Style','text','String', ['alpha = ' sprintf('%i', get(alphaSlider, 'Value'))], 'Position', [120 45 60 20]);
    omegaSlider = uicontrol(figure(1),'Style','slider','Min',0,'Max',10*10.^8,'SliderStep',[1/15 1/15],'Value', 1*10.^8, 'Position', [200 20 60 20], 'Callback','Project_213');
    oV = uicontrol(figure(1),'Style','text','String', ['omega = ' sprintf('%i', get(omegaSlider, 'Value'))], 'Position', [200 45 60 20]);
    radiusSlider = uicontrol(figure(1),'Style','slider','Min',0,'Max',1000*10.^-12,'SliderStep',[1/15 1/15],'Value',100*10.^-12,'Position',[280 20 60 20],'Callback','Project_213');
    rV = uicontrol(figure(1),'Style','text','String', ['r = ' sprintf('%i', get(radiusSlider, 'Value'))], 'Position', [280 45 60 20]);
    distanceSlider = uicontrol(figure(1),'Style','slider','Min',0,'Max',1000*10.^-12,'SliderStep',[1/15 1/15],'Value', 100*10.^-12, 'Position', [360 20 60 20], 'Callback','Project_213');
    dV = uicontrol(figure(1), 'Style', 'text', 'String', ['d = ' sprintf('%i', get(distanceSlider, 'Value'))], 'Position', [360 45 60 20]);
    charge1Slider = uicontrol(figure(1),'Style','slider','Min',1.6*10.^-19,'Max',8*10.^-19,'SliderStep',[1.6*10.^-19 1.6*10.^-19],'Value', 1.6*10.^-19, 'Position', [440 20 60 20], 'Callback','Project_213');
    q1V = uicontrol(figure(1), 'Style', 'text', 'String', ['q1 = ' sprintf('%i', get(charge1Slider, 'Value'))], 'Position', [440 45 60 20]);
    charge2Slider = uicontrol(figure(1),'Style','slider','Min',-8*10.^-19,'Max',-1.6*10.^-19,'SliderStep',[1.6*10.^-19 1.6*10.^-19],'Value', -1.6*10.^-19, 'Position', [520 20 60 20], 'Callback','Project_213');
    q2V = uicontrol(figure(1), 'Style', 'text', 'String', ['q2 = ' sprintf('%i', get(charge2Slider, 'Value'))], 'Position', [520 45 60 20]);
end


alpha = get(alphaSlider,'Value');
set(aV,'String',['alpha = ' sprintf('%i',alpha)]);

omega = get(omegaSlider,'Value');
set(oV,'String',['omega = ' sprintf('%i',omega)]);

radius = get(radiusSlider,'Value');
set(rV,'String',['r = ' sprintf('%i',radius)]);

d = get(distanceSlider,'Value');
set(dV,'String',['d = ' sprintf('%i',d)]);

q1 = get(charge1Slider,'Value');
set(q1V,'String',['q1 = ' sprintf('%i',q1)]);

q2 = get(charge2Slider,'Value');
set(q2V,'String',['q2 = ' sprintf('%i',q2)]);


%Evolving Time 
c = 3.0*10.^8;%for reference
t = 1:0.01:10;
[~,p] = size(t);

E = zeros(1,p);
Ex = zeros(1,p);
Ey = zeros(1,p);

% alpha = 1*10.^6; %control system, angular acceleration
% omega = 1.0*10.^8; %control system, angular velocity
% radius = 1000*10.^-12; %control system, distance of observer
% d = 100*10.^-12; %distance between charges
% q1 = 1.6*10.^-19; %control system to multiply by this
% q2 = -1.6*10.^-19; %control system to multiply by this
dip = q1*d;

z = 0;
pT = @(t,w,Ex,Ey,p0) p0*(cos(w*t).*Ey + sin(w*t).*Ex);
pTx = @(t,w,Ex,p0) p0*(sin(w*t).*Ex);
pTy =@(t,w,Ey,p0) p0*(cos(w*t).*Ey);

Ed = zeros(p);

for i = 1:p
 [Ex(i),Ey(i)] = electricField(d,alpha, omega, radius, q1, q2, z);
 omega = omega + alpha*z;
 z = z+0.01;
end

dipoleP = pT(t,omega,Ex,Ey,dip);


figure(1);
subplot('position', [0.1 0.3 0.8 0.6]);
plot(t,dipoleP);
xlabel("Time [s]");
ylabel("Electric Field [N/C]");
figure(2);
plot3(pTx(t,omega,Ex,dip),pTy(t,omega,Ey,dip),t);
zlabel("Time [s]");
ylabel("Electric Field [N/C]");
xlabel("Electric Field [N/C]");
figure(3);
makingContour(alpha,omega,d,q1,q2,dip)


