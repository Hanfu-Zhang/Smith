function [rEqGama, Rin, Xin] = Smith(Zl, Z0, L0)
% clear; clc; close;
% theta——画图用
theta = 0: pi/100: 2*pi;
ReIm = regexp(Zl, '+', 'split');
ImZl = regexp(char(ReIm(2)), 'j', 'split');
% 提取出终端负载R、X
ReZl = str2num(char(ReIm(1)));
ImZl = str2num(char(ImZl(1)));
% 计算归一化R、X
R2Zero = ReZl / Z0;
X2Zero = ImZl / Z0;
%调用画背景函数
smithInit();
% 算R圆圆心半径
c_ofCofR = R2Zero / (1 + R2Zero);
r_ofCofR = 1 / (1 + R2Zero);
pause(0.7);
% 画R圆
x = c_ofCofR + r_ofCofR * cos(theta);
y = r_ofCofR * sin(theta);
Rl2ZeroObj = plot(x, y, 'LineWidth', 1);
hold on;
pause(0.7);
% 算X圆圆心半径
c_ofCofX = 1 / X2Zero;
r_ofCofX = 1 / X2Zero;
% 画X圆
x = 1 + r_ofCofX * cos(theta);
y = c_ofCofX + r_ofCofX * sin(theta);
Xl2ZeroObj = plot(x, y, 'LineWidth', 1);
hold on;
pause(0.7);
% 解R、X圆交点坐标
syms a b
[a, b] =(solve((a-c_ofCofR)^2+b^2-r_ofCofR^2,...
        (a-1)^2+(b-c_ofCofX)^2-r_ofCofX^2));
a = eval(a); b = eval(b);
% 确定有意义的交点坐标(非1,0)
if (a(1) - 1) < 10^(-8)
    intersectionX = a(2); 
else
    intersectionX = a(1);
end
if (b(1) - 0) < 10^(-8)
    intersectionY = b(2); 
else
    intersectionY = b(1);
end
% 标注交点，并删除R、X圆
text(intersectionX, intersectionY, 'ZinGiven', 'color', 'b');
pause(0.7);
% 画原点与该交点连线
line([0, intersectionX], [0, intersectionY], 'LineWidth', 1);
hold on;
pause(0.7);
% 画该点的等反射系数圆
rEqGama = sqrt(intersectionX^2 + intersectionY^2);
output1 = ['给定点反射系数: ', num2str(rEqGama)];
disp(output1);
text(0.7, 1.1, output1, 'color', 'b');
x = rEqGama * cos(theta);
y = rEqGama * sin(theta);
rEqGamaObj = plot(x, y, 'LineWidth', 1);
pause(0.7);

%延长原点和交点的连线，读出向电源波长数
syms c d
eq1 = c^2 + d^2 - 1;
eq2 = intersectionY  * c - d *  intersectionX;
[c, d] = solve(eq1, eq2);
c1 = c(1); c2 = c(2);
d1 = d(1); d2 = d(2); 
%考虑到此时直线与圆必有两个交点，得到我们所需交点(c,d),并作图
if (c1-intersectionX)^2 + (d1-intersectionY)^2 < (c2-intersectionX)^2 + (d2-intersectionY)^2
    c = c1; d = d1;
else 
    c = c2; d = d2;
end
c = eval(c); d = eval(d);
line([intersectionX, c], [intersectionY, d], 'LineWidth', 1);
pause(0.7);
set(Rl2ZeroObj, 'Color', 'none');
set(Xl2ZeroObj, 'Color', 'none');
hold on;
pause(0.7);
%算出此时角度
if c > 0 && d > 0
   theta0 = asin(d);
elseif c < 0 && d > 0
   theta0 = pi - asin(d);
elseif c < 0 && d < 0
    theta0 = pi + asin(abs(d));
elseif c > 0 && d < 0
    theta0 = -asin(abs(d));
elseif c == 0
    if d > 0
        theta0 = pi/2;
    else
        theta0 = -pi/2;
    end 
end

%算出此时距离波源波长数l
if L0 > 0
    if (c > 0)
       l = 0.25 - asin(d)*2/pi*0.125;
    elseif (c < 0 && d > 0)
       l = asin(d)*2/pi*0.125;
    elseif (c < 0 && d < 0)
       l = 0.5 + asin(d)*2/pi*0.125 ;
    elseif c == 0
        if d > 0
            l = 0.25;
        else
            l = 0.75;
        end     
    end
elseif L0 < 0
    if c < 0 && d < 0
        l = asin(abs(d)) / (4*pi);
    elseif c > 0 && d < 0
        l = (asin(abs(c)) + pi/2 ) / (4*pi);
    elseif c > 0 && d > 0
        l = (asin(abs(c)) + pi ) / (4*pi);
    elseif c < 0 && d > 0
        l = (-asin(abs(d)) + 2*pi ) / (4*pi);
    elseif c == 0
        if d > 0
            l = 0.75;
        else
            l = 0.25;
        end
    end
end

%输入距离该点距离L的点
% （如果输入为正，则往波源方向移动，如果输入为负，则往负载移动，输入为负时，绝对值不超过所在位置）: ', 's');

L = l + abs(L0);
while L > 0.5
      L = L - 0.5;
end

%计算距离L点后的圆图角度
if(L0 > 0)  %向波源
    if L > 0 && L < 0.25
        theta1 = pi - L/0.125*pi/2;
    elseif L>0.25&&L<0.5
        theta1 = 3*pi - L/0.125*pi/2;
    end
else        %向负载
    if L > 0 && L < 0.25
        theta1 = -pi + L/0.125*pi/2;
    elseif L>0.25&&L<0.5
        theta1 = L/0.125*pi/2 - pi;
    end
end
% 计算需要转动的角度
thetaRotate = 4*pi*abs(L0);
for countRotate = 0: pi/40: thetaRotate
    if L0 > 0
        thetaNow = theta0 - countRotate;
    else
        thetaNow = theta0 + countRotate;
    end
    xNow = cos(thetaNow);
    yNow = sin(thetaNow);
    lineNow = line([0, xNow], [0, yNow], 'LineWidth', 1); 
    pause(0.05);
    set(lineNow, 'Color', 'none');
end

syms e f
e=cos(theta1);
f=sin(theta1);
line([e, 0], [f, 0], 'LineWidth', 1);

hold on;


%计算交点(g,h)
syms g h
eq1 = g^2 + h^2 - rEqGama^2 ;
eq2 = f*g - h*e;
[g, h] = solve(eq1, eq2);
g1 = g(1); g2 = g(2);
h1 = h(1); h2 = h(2); 
%考虑到此时直线与圆也必有两个交点，得到我们所需交点(g,h)
if (g1-e)^2 + (h1-f)^2 > (g2-e)^2 + (h2-f)^2
    g = g2; h = h2;
else 
    g = g1; h = h1;
end
g = eval(g); h = eval(h);
pause(0.7);
text(g, h, 'ZinFound', 'color', 'b');
pause(0.7);
set(rEqGamaObj, 'Color', 'none');
pause(0.7);
% 算归一化Rin并画图
if g < 0
    r_ofCofRofZin = ((abs(g)+1)^2 + h^2) / (2*(abs(g) + 1));
elseif g >= 0
    r_ofCofRofZin = ((1-g)^2 + h^2) / (2*(1 - g));
end
Rin2Zero = 1 / r_ofCofRofZin - 1;
plotCofR(Rin2Zero, 1);
Rin = num2str(Rin2Zero * Z0);
output2 = ['待求点Rin = ', num2str(Rin2Zero * Z0)];
text(0.7, 1, output2, 'color', 'b');
disp(output2);
pause(0.7);
% 算归一化Xin并画图
Xin2Zero = 2*h / (h^2 + (g-1)^2);
plotCofX(Xin2Zero, 1);
Xin = num2str(Xin2Zero * Z0);
output3 = ['待求点Xin = ', num2str(Xin2Zero * Z0)];
disp(output3);
text(0.7, 0.9, output3, 'color', 'b');
if(num2str(Xin2Zero * Z0) > 0)
    output4 = ['待求点Zin = ', num2str(Rin2Zero * Z0), '+', num2str(Xin2Zero * Z0), 'j'];
elseif  num2str(Xin2Zero * Z0) < 0
    output4 = ['待求点Zin = ', num2str(Rin2Zero * Z0), num2str(Xin2Zero * Z0), 'j'];
else
    output4 = ['待求点Zin = ', num2str(Rin2Zero * Z0)];
end
text(0.7, 0.8, output4, 'color', 'b');
end