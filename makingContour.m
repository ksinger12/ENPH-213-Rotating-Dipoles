function [] = makingContour(alpha,omega,d,q1,q2,dip)
%Written by: Kyle Singer

%Making the contour plot over the frame for different observers

t = 1:0.01:10;
[~,p] = size(t);

a = 300; 

E = zeros(1,p);
Ex = zeros(a,a,p);
Ey = zeros(a,a,p);
 
z = 0;

X = zeros(a);
Y = zeros(a);

for o = 1:a
    X(o,:) = linspace(-a/2,a/2,a);
    Y(:,o) = linspace(-a/2,a/2,a);
end

radius = sqrt(X.^2 + Y.^2);
radius = radius.*10.^-12;


for i = 1:p
 [Ex(:,:,i),Ey(:,:,i)] = electricField(d,alpha, omega, radius, q1, q2, z);
 omega = omega+alpha*z;
 z = z+0.01;
end

Ed = sqrt(Ex.^2 + Ey.^2);
y=0; 

for i = 1:p
    figure(3);
    contour(Ed(:,:,i));
    F(i) = getframe(gcf);
    drawnow
    pause(1.0);
end

writerObj = VideoWriter('contourVideo.avi');
writerObj.FrameRate = 1; %seconds per image

open(writerObj);
for j = 1:length(F) %writing the frames to the video
    frame = F(j);
    writeVideo(writerObj,frame);
end
close(writerObj);
end