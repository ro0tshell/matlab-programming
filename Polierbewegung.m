close all;
clear all;
clc;

l=1800;     % Optiklänge
b=140;      % Optikbreite
wl=1400;    % Werkzeuglänge
wb=100;     % Werkzeugbreite

x=0;        % Weg x
y=0;        % Weg y
Ax=500;     % Achsenbewegung synchron
Ay=25;      % Achsenbewegung synchron
tolx=100;   % Toleranz x-Bewegung
toly=7;     % Toleranz y-Bewegung
Vx=400;     % Geschwindigkeit x-Achse mm/s
Vy=20;      % Geschwindigkeit y-Achse mm/s
gx=1000;    % Beschleunigung x-Achse mm/s^2
gy=500;     % Beschleunigung y-Achse mm/s^2
tende=120;    % Bearbeitungszeit in s

auf=1;      % Aufläösung
ZS  = 0.01; % Zeitauflösung

atx = Vx/gx;
aty = Vy/gy;

% Programmvariablen %

loop=1;     % boolean
i=0;        % Iteration
mx=0;       % Größe Matrix x
my=0;       % Größe Matrix y

%Bewegung in x

for t=0:ZS:tende
 i=i+1;
 x=Ax*sind((1/2)*Vx*t);
 x = Ax*asin(sin((2*pi/(2*(l/Vx)))*t))/(pi/2);
 Xb(i,1)=i;
 Xb(i,2)=x;
 
 y = Ay*asin(sin((2*pi/(2*(b/Vy)))*t))/(pi/2);
 Yb(i,1)=i;
 Yb(i,2)=y;
end
Xbs=auf*Xb;
Ybs=auf*Yb;

Kxy(:,2)=Xbs(:,2);
Kxy(:,1)=Ybs(:,2);

figure(1),
plot(Kxy(:,2),Kxy(:,1))
view([0 90])

% figure(11);
% for t=0:ZS:tende
%     loop=loop+1;
%     zz = Ax*asin(sin((2*pi/(4*(l/Vx)))*t))/(pi/2);
%     ret(loop,1)=loop;
%     ret(loop,2)=zz;
% end
% zzb = auf*ret;
% plox(:,2)=zzb(:,2);
% plox(:,1)=zzb(:,1);
% plot(plox(:,1),plox(:,2));
% 
% figure(12);
% for t=0:ZS:tende
%     lop=lop+1;
%     zzy = Ay*asin(sin((2*pi/(4*(b/Vy)))*t))/(pi/2);
%     retl(lop,1)=lop;
%     retl(lop,2)=zzy;
% end
% zza = auf*retl;
% ploy(:,2)=zza(:,2);
% ploy(:,1)=zza(:,1);
% plot(ploy(:,2),ploy(:,1));


%%%%%%%%%% Politur %%%%%%%%%%%%%
mx = l+wl/2+Ax;
my = b+wb/2+Ay;

A = zeros(my,mx); % Gesamtarbeitsbereich
optikx = round((mx-l)/2):round((mx+l)/2);
optiky = round((my-b)/2):round((my+b)/2);
A(optiky,optikx) = 0.5; % Optik
% Matrixwzkg(1:wb+1,1:wl+1) = 5;
% Matrixwzkg(5:wb-4,5:wl-4) = 0;
Matrixwzkg(1:wb+1,1:wl+1) = 0.5;

for prozess = 1:i
    Posx = round(Xb(prozess,2));
    Posy = round(Yb(prozess,2));
    wkzgx = round((mx-wl)/2)+Posx:round((mx+wl)/2)+Posx;
    wkzgy = round((my-wb)/2)+Posy:round((my+wb)/2)+Posy;
    A(wkzgy,wkzgx)=A(wkzgy,wkzgx)-Matrixwzkg*0.00005;


end

A(1,1)=1.15;
A(1,2)=0;
    
A(1:my,1:round((mx-l)/2)-1)=0;
A(1:round((my-b)/2)-1,1:mx)=0;
A(round((my+b)/2)+1:my,1:mx)=0;
A(1:my,round((mx+l)/2)+1:mx)=0;
    
figure(2);
imagesc(A);
A(1,1)=0;
A(1,2)=0;
colormap('hot');
axis image;
