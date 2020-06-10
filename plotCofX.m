% 给定归一化电抗，画等电kang圆
function plotCofX(X2Zero, choose)
c_ofCofX = 1 / X2Zero;
r_ofCofX = 1 / X2Zero;
% 解等电抗圆与单位圆交点坐标intersectionX、intersectionY
syms a
syms b
[a, b] =(solve(a^2+b^2-1,...
        (a-1)^2+(b-c_ofCofX)^2-r_ofCofX^2));
a = eval(a); b = eval(b);
if a(1) == 1
    intersectionX = a(2); 
else
    intersectionX = a(1);
end
if b(1) == 0
    intersectionY = b(2); 
else
    intersectionY = b(1);
end
hold on;
% 分X2Zero>=0或<0讨论，各自再分交点高度是否高于等阻抗圆圆心讨论
% 最终得到theta范围，在这个范围内画图可以画出点(1,0)到等阻抗圆、单位圆交点
% 的那一部分圆弧
if X2Zero >= 0
    if intersectionY >= r_ofCofX
        theta1 = acos( (intersectionX - 1) / r_ofCofX );
    else
        theta1 = 2 * pi - acos( (intersectionX - 1) / r_ofCofX );
    end
    theta = theta1: 0.1: 3*pi/2;
else
    if abs(intersectionY) <= abs(r_ofCofX)
        theta1 = -acos( (intersectionX - 1) / r_ofCofX );
    else
        theta1 =  acos( (intersectionX - 1) / r_ofCofX );
    end
    theta = -pi/2: 0.001: theta1;
   
end
x = 1 + r_ofCofX * cos(theta);
y = c_ofCofX + r_ofCofX * sin(theta);
if choose == 0
    plot(x, y, 'Color', [0.7 0.7 0.7]);
    text(intersectionX, intersectionY,['X = ', num2str(X2Zero)], 'Color', [0.7 0.7 0.7]);
elseif choose == 1
    plot(x, y);
    text(intersectionX, intersectionY,['X = ', num2str(X2Zero)]);
end
hold on;
end