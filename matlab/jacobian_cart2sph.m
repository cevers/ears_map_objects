function jacobian = jacobian_cart2sph( x, y, z, iVec )
%jacobian_cart2sph Summary of this function goes here
%   Detailed explanation goes here

% Jacobian for conversion from Cartesian to spherical:
% [                                            -y/(x^2*(y^2/x^2 + 1)),                                               1/(x*(y^2/x^2 + 1)),                                                                                            0, 0, 0, 0]
% [ (x*z)/((1 - z^2/(x^2 + y^2 + z^2))^(1/2)*(x^2 + y^2 + z^2)^(3/2)), (y*z)/((1 - z^2/(x^2 + y^2 + z^2))^(1/2)*(x^2 + y^2 + z^2)^(3/2)), -(1/(x^2 + y^2 + z^2)^(1/2) - z^2/(x^2 + y^2 + z^2)^(3/2))/(1 - z^2/(x^2 + y^2 + z^2))^(1/2), 0, 0, 0]
% [                                         x/(x^2 + y^2 + z^2)^(1/2),                                         y/(x^2 + y^2 + z^2)^(1/2),                                                                    z/(x^2 + y^2 + z^2)^(1/2), 0, 0, 0]
%  

r = sqrt(x^2 + y^2 + z^2);
a = x^2 + y^2;

Jazx    = -y/a;
Jazy    = x/a;
Jazz    = 0;
% Jelx    = (x*z)/(r^2*sqrt(a));
Jelx    = (x*z)/((x^2+y^2+z^2)^(3/2)*sqrt(1-z^2/(x^2+y^2+z^2)));
% Jely    = (y*z)/(r^2*sqrt(a));
Jely    = (y*z)/((x^2+y^2+z^2)^(3/2)*sqrt(1-z^2/(x^2+y^2+z^2)));
% Jelz    = -sqrt(a)/r^2;
Jelz    = -(-z^2/(x^2+y^2+z^2)^(3/2)+1/sqrt(x^2+y^2+z^2))/sqrt(1-z^2/(x^2+y^2+z^2));
Jrx     = x/r;
Jry     = y/r;
Jrz     = z/r;

jacobian = zeros( 3, length(iVec.state_vec) );
jacobian(iVec.az,[iVec.x,iVec.y,iVec.z])    = [Jazx, Jazy, Jazz];
jacobian(iVec.incl,[iVec.x,iVec.y,iVec.z])  = [Jelx, Jely, Jelz];
jacobian(iVec.r,[iVec.x,iVec.y,iVec.z])     = [Jrx, Jry, Jrz];

% [                                            -y/(x^2*(y^2/x^2 + 1)),                                               1/(x*(y^2/x^2 + 1)),                                                                                            0, 0, 0, 0]
% [ (x*z)/((1 - z^2/(x^2 + y^2 + z^2))^(1/2)*(x^2 + y^2 + z^2)^(3/2)), (y*z)/((1 - z^2/(x^2 + y^2 + z^2))^(1/2)*(x^2 + y^2 + z^2)^(3/2)), -(1/(x^2 + y^2 + z^2)^(1/2) - z^2/(x^2 + y^2 + z^2)^(3/2))/(1 - z^2/(x^2 + y^2 + z^2))^(1/2), 0, 0, 0]
% [                                         x/(x^2 + y^2 + z^2)^(1/2),                                         y/(x^2 + y^2 + z^2)^(1/2),                                                                    z/(x^2 + y^2 + z^2)^(1/2), 0, 0, 0]
%  

end