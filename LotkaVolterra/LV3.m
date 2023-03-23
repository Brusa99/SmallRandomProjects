function dN = LV3(t, N)
% modello di Lotka-Volterra a 3 specie
% INPUT:
% N e epsilon sono vettori a 3 dim
% gamma è una matrice 3x3
% SISTEMA:
% N1' = N1(eps1 - y12 N2 - y13 N3)
% N2' = N2(eps2 + y21 N1 - y23 N3)
% N3' = N3(eps3 + y31 N1 + y32 N3)

global epsilon gamma

epsilon = [1/4 -1/4 -1/2];
gamma = [0 1/200 1/200; 1/200 0 1/150; 1/200 1/200 0];

dN(1)=epsilon(1)*N(1)-gamma(1,2)*N(1)*N(2)-gamma(1,3)*N(1)*N(3);
dN(2)=epsilon(2)*N(2)+gamma(2,1)*N(2)*N(1)-gamma(2,3)*N(2)*N(3);
dN(3)=epsilon(3)*N(3)+gamma(3,1)*N(3)*N(1)+gamma(3,2)*N(3)*N(2);
dN=dN';
end

