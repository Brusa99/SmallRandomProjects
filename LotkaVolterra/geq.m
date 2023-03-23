function [x] = geq()
% restituisce il punto di equilibrio non banale x_e^*
% !!! necessario che det(A)!=0 !!!
% il punto esiste se e solo se il determinante della matrice gamma è
% diverso da 0, altrimneti potrei avere nessuna o infinite soluzioni.

global epsilon gamma

detA = gamma(1,2)*gamma(2,3)*gamma(3,1)-gamma(2,1)*gamma(3,2)*gamma(1,3);

x(1)= (epsilon(1)*gamma(2,3)*gamma(3,2)-epsilon(2)*gamma(1,3)*gamma(3,2)+epsilon(3)*gamma(1,2)*gamma(2,3))/-detA;
x(2)= (-epsilon(1)*gamma(2,3)*gamma(3,1)+epsilon(2)*gamma(1,3)*gamma(3,1)-epsilon(3)*gamma(1,3)*gamma(2,1))/-detA;
x(3)= (epsilon(1)*gamma(2,1)*gamma(3,2)-epsilon(2)*gamma(3,1)*gamma(1,2)+epsilon(3)*gamma(1,2)*gamma(2,1))/-detA;

end