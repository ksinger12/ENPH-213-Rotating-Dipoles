function [Ex,Ey] = electricField(d,alpha, omega, radius, q1, q2, t)
%Written by: Kyle Singer
%This function should take in the angular acceleration, angular velocity, 
%radius between the charges, and the charges themselves. The system will
%output the electric field at a given position at a given time.

Ei = @(e0,q,r1) (1./(4*pi*e0)).*(abs(q)./r1);

%alpha is the angular acceleration given by the user
%omega is the angular velocity given by the user
%radius is the distance between the particles
%q1 and q2 are the particle charges

%setting user inputs (for now)
%q1 = 1.67*10.^-19; %coulomb
%q2 = -1.67*10.^-19;
%d = 50*10.^-12; %100pm each particle from the centre of the dipole
r0 = radius;

%permeability of free space
e0 = 1.257*10.^-6; %Henry per meter

%getting angle
thetaB = @(w,a,t) w*t + (1/2)*a*t.^2;
%getting distance from each charge to observer
r = @(r0,d,theta) d.^2 + r0.^2 - 2*d.*r0.*cos(theta);
r1 = r(r0,d./2,thetaB(omega,alpha,t));
r2 = r(r0,d./2,180-thetaB(omega,alpha,t));

E1 = Ei(e0,q1,r1);
E2 = Ei(e0,q2,r2);

%getting the angle to break up the postive charge into x and y components
x = acos((d.^2 - r1.^2 - r0.^2)./(-2*r1*r0));
y = acos((d.^2 - r2.^2 - r0.^2)./(-2*r2*r0));

Ex1 = E1.*sin(x);
Ey1 = E1.*cos(x);
Ex2 = E2.*sin(y);
Ey2 = E2.*cos(y);

Ex = abs(Ex1 - Ex2);
Ey = abs(Ey1 + Ey2);

end