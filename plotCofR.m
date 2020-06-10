% 给定归一化电阻，画等电阻圆
function plotCofR(R2Zero, choose)
theta = 0: pi/100: 2*pi;
c_ofCofR = R2Zero / (1 + R2Zero);
r_ofCofR = 1 / (1 + R2Zero);
x = c_ofCofR + r_ofCofR * cos(theta);
y = r_ofCofR * sin(theta);
if choose == 0
    plot(x, y, 'Color', [0.7 0.7 0.7]);
    text(c_ofCofR-r_ofCofR,0,['R = ', num2str(R2Zero)], 'Color', [0.7 0.7 0.7]);
elseif choose == 1
    plot(x, y);
    text(c_ofCofR-r_ofCofR,0,['R = ', num2str(R2Zero)]);
end
hold on;
end

