N=500;
Nx=100;

w=2*pi/20;

% Variante 1: eine ganze Zahl an Wellenlängen passt zwischen Wand und Sender:
k=2*pi/10;
% Variante 2: ... und jetzt nicht mehr...
k=2*pi/15;


c=w/k;
dt=1;

DiffA=zeros(Nx,1);
DiffA2x=zeros(Nx,1);
A=zeros(Nx,1);

for(t=1:N);

    % QUelle
    A(Nx/2)=cos(w*t);

    % Berechne 2. räumliche Ableitung aus aktuellen Amplituden
    DiffA2x(2:Nx-1)=A(1:Nx-2)+A(3:Nx)-2*A(2:Nx-1);
    
    % Berechne nun die Änderung der 1. zeitlichen Ableitung 
    DiffA = DiffA + c.^2*DiffA2x*dt;

    % Daraus können wir nun die neuen Amplituden berechen
    A=DiffA*dt+A;

plot(A)
    ylim([-4 4])
    pause(0.1);
end

