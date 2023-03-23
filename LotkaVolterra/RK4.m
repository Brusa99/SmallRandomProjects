function [t,y] = RK4(fun,int,n,y0)
% Metodo di Runge-Kutta a 4 livelli
% INPUT:
% fun è la funzione f di y'=f(t,y)
% int è il mio intervallo di riferimento [t0,tf]
% n è il numero di passi che voglio fare
% y0 è il valore iniziale
% OUTPUT:
% y è il mio vettore di approssimazioni
%   sulle righe ho le dim (N1,N2,N3) mentre le colonne rappresentano i valori agli
%   istanti t_i
% t è il mio vettore degli istanti

% tabella di Butcher a 4 livelli:
c = [0 1/2 1/2 1];
A = [0 0 0 0; 1/2 0 0 0; 0 1/2 0 0; 0 0 1 0];
w = [1/6 1/3 1/3 1/6]';

h = (int(2)-int(1))/n; % passo di integrazione
t(1) = int(1); %tempo iniziale t0
y(:,1) = y0; %il primo livello è già noto e lo uso per calcolare quelli dopo 

for j=1:n %ad ogni passo ottengo il valore y_n
    % Calcolo i livelli K_j
    K(:,1)=feval(fun,t(j),y(:,j)); %K_j^1 il primo livello
    K(:,2)=feval(fun,t(j)+c(2)*h,y(:,j)+h*K(:,1)*A(2,1)'); %K_j^2 il secondo livello etc..
    K(:,3)=feval(fun,t(j)+c(3)*h,y(:,j)+h*K(:,1:2)*A(3,1:2)');
    K(:,4)=feval(fun,t(j)+c(4)*h,y(:,j)+h*K(:,1:3)*A(4,1:3)');
    % calcolo il valore della soluzione
    y(:,j+1)=y(:,j)+h*K*w;
    t(j+1)=t(j)+h;
end

end

