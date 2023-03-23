function []=driverLV3()
% soluzione del modello di Lotka-Volterra a 3 specie

close all
clc

% intervallo temporale e griglia

int = [0 100];
n = 160;
%%% n = input('numero di passi da fare = ');

% problema di Cauchy

fun = 'LV3';
y0 = input('valore iniziale nella forma [N1 N2 N3] = ')';

[t,y] = RK4(fun,int,n,y0);

figure(1)
plot(t,y(1,:),'g')
hold on
plot(t,y(2,:),'b')
plot(t,y(3,:),'k')
hold off
legend('N1','N2','N3')
xlabel('Tempo')
ylabel('Popolazione')

figure(2)
plot3(y(1,:),y(2,:),y(3,:))
xlabel('N1')
ylabel('N2')
zlabel('N3')

end