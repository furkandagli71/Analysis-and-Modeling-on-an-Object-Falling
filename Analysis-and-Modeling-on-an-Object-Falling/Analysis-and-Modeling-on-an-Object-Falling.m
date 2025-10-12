clc
close all
clear all

xi = [0; 1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12; 13];
Yi = [202.36; 239.03; 280.71; 309.12; 323.15; 332.78; 328.45; 
     306.40; 287.36; 247.97; 202.89; 161.11; 93.68; 20.78];

pol = [xi.^2, xi, ones(length(xi), 1)];
coeffpol = (pol' * pol) \ (pol' * Yi);
a = coeffpol(1);  
b = coeffpol(2);  
c = coeffpol(3); 

t = linspace(0, 15, 300); 
Ypol = a * t.^2 + b * t + c; 
Ypol = max(Ypol, 0); 
Vpol = 2 * a * t + b;

Vdiff = zeros(1, length(Yi) - 1); 
for i = 1:length(Vdiff)
    Vdiff(i) = (Yi(i+1) - Yi(i)) / (xi(i+1) - xi(i));
end
Vhw = interp1(xi(1:end-1), Vdiff, t);
Yhw = interp1(xi, Yi, t);
Yhw = max(Yhw, 0);

figure;

subplot(1, 3, 1);
polobject = plot(1, Ypol(1), 'ko', 'MarkerSize', 10, MarkerFaceColor = 'k');
hold on;
hwobject = plot(2, Yhw(1), 'ro', 'MarkerSize', 10, MarkerFaceColor = 'r');
xlim([0, 3]); 
ylim([0, 350]); 
xlabel('location of objects');
ylabel('height of objects');
title('pol object       /      hw object');
grid on;

subplot(1, 3, 2);
polheight = plot(t(1), Ypol(1), 'k', 'LineWidth', 1);
hold on;
hwheight = plot(t(1), Yhw(1), 'r', 'LineWidth', 1);
xlabel('time');
ylabel('height');
title('height-time graph');
grid on;

subplot(1, 3, 3);
polspeed = plot(t(1), Vpol(1), 'k', 'LineWidth', 1);
hold on;
hwspeed = plot(t(1), Vhw(1), 'r', 'LineWidth', 1);
xlabel('time');
ylabel('speed');
title('speed-time graph');
grid on;

for i = 1:length(t)
    
    if Yhw(i) < 0
        set(hwobject, 'YData', 0); 
    else
        set(hwobject, 'YData', Yhw(i));
    end

    if Ypol(i) < 0
        set(polobject, 'YData', 0); 
    else
        set(polobject, 'YData', Ypol(i));
    end
   
    set(hwheight, 'XData', t(1:i), 'YData', Yhw(1:i));
    set(polheight, 'XData', t(1:i), 'YData', Ypol(1:i));
    
    set(hwspeed, 'XData', t(1:i), 'YData', Vhw(1:i));
    set(polspeed, 'XData', t(1:i), 'YData', Vpol(1:i));
 
    drawnow;
    pause(0.02);
end

v0 = b;
g = -2 * a;

fprintf('initial speed is %.4f m/s\n', v0);
fprintf('gravitational acceleration (g) is %.4f m/s^2\n', g);
fprintf('mathematical model of the motion is %.4f*t^2 + %.4f*t + %.4f\n', a, b, c);
