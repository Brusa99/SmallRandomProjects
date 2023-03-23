function lambda = auteq(x)
% restituisce gli autovalori della matrice jacobiana del sistema calcolata in x

global epsilon gamma

J = [epsilon(1)-gamma(1,2)*x(2)-gamma(1,3)*x(3) gamma(2,1)*x(2) gamma(3,1)*x(3)
    -gamma(1,2)*x(1) epsilon(2)+gamma(2,1)*x(1)-gamma(2,3)*x(3) gamma(3,2)*x(3)
    -gamma(1,3)*x(1) -gamma(2,3)*x(2) epsilon(3)+gamma(3,1)*x(1)+gamma(3,2)*x(2)];

lambda = eig(J);

end