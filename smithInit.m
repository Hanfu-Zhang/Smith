function smithInit()
% 注：此函数画的是背景，所有线条颜色为淡灰色，即RGB[0.7 0.7 0.7]
clear; clc; %close;
figure(1);
% 画单位圆
theta = 0: pi/100: 2*pi;
r = 1;
x = r * cos(theta);
y = r * sin(theta);
plot(x, y, 'Color', [0.7 0.7 0.7]);
title('Smith图演示');
axis equal;
axis([-1.2 1.2 -1.2 1.2]);
hold on;
% 画中心线
x = -1.2: 0.1: 1.2; y = x; y(:) = 0;
plot(x, y, 'Color', [0.7 0.7 0.7]);
hold on;
y = -1.2: 0.1: 1.2; x = y; x(:) = 0;
plot(x, y, 'Color', [0.7 0.7 0.7])
hold on;
% 画几个等电阻圆
plotCofR(1, 0);
plotCofR(3, 0);
plotCofR(0.3, 0);
% 画几个等电抗圆
plotCofX(0.2, 0); plotCofX(-0.2, 0);
plotCofX(0.5, 0); plotCofX(-0.5, 0);
plotCofX(1, 0); plotCofX(-1, 0);
plotCofX(2, 0); plotCofX(-2, 0);
end