%--------------------------------------------普通光子筛小孔数据生成程序-----------------------------------------------

%------------------------------------------------2019-05-23---------------------------------------------------------
clear all
clear
clc
%----------------------------第一部分：若需要绘图，需提前设置好以下参数----------------------------------------------------
%输入设定(mm)
f=20000;           %焦距
lambda=550e-6; k=2*pi/lambda;    %波长、波数
D=1000.0;             %口径
d=f;                  %观察位置（焦平面）

%临界采样
L=D;                            
M_1=8192;        %采样精度！！注意选择数值，权衡计算量与精度！！！
dx=L/M_1; 
dx=0.1

x0=-L/2:dx:L/2-dx;y0=x0;
[x,y]=meshgrid(x0,y0);%衍射面坐标
X0=-L/2:dx:L/2-dx;Y0=X0;
[X,Y]=meshgrid(X0,Y0); %焦平面坐标（观察面）


%---------------------------------------第二部分：相位分布函数的分析-----------------------------------------
%----------------------------------------------------------------------------------------------------------
%单位：mm
R0=2.970;%归一化半径
D=1000.000;%口径
r=0:0.00001:D/2;
p=r/R0;
a2_phase=-2.519243;
a4_phase=1.388873*10^(-8);
a6_phase=-1.526679*10^(-16);
phase_function0=a2_phase*p.^2+a4_phase*p.^4+a6_phase*p.^6+11362*2*pi;
m=floor(phase_function0/(2*pi));
M=max(m)  %周期数
n=size(r);
y1=pi*ones(1,n(:,2));
phase0=phase_function0-floor(phase_function0/(2*m*pi))*2*m*pi;%位相归一化
 phase1=abs(phase0-pi);%
 
% 微分变号信息-----第一步  
c=findpeaks(phase1);  
IndMin1=find(diff(sign(diff(phase1)))>0)+1;  %获得局部最小值的位置  
IndMax=find(diff(sign(diff(phase1)))<0)+1;  %获得局部最大值的位置  
r1_min=r(IndMin1);


 phase2=abs(phase0-2*pi)-pi;%
 % 微分变号信息------第二步  
c=findpeaks(phase2);  
IndMin2=find(diff(sign(diff(phase2)))>0)+1;  %获得局部最小值的位置  
IndMax=find(diff(sign(diff(phase2)))<0)+1;  %获得局部最大值的位置  
r2_min=r(IndMin2);

%--------------------相位分布函数的绘图------------------------
%figure; hold on; box on;  
%plot(r,phase0,r,phase2,'y');  
%plot(r(IndMin1),phase1(IndMin1),'r^')  
%plot(r(IndMin2),phase2(IndMin2),'k*')  
%legend('原始曲线','平移后曲线','波谷点','波峰点')  
%title('计算离散节点的波峰波谷信息', 'FontWeight', 'Bold');  
%----------------------------------------------------第三部：光子筛的参数计算----------------------------------------
%------------------------------------------------------------------------------------------------------------------

R0=r1_min;
W=r1_min-r2_min;    %透光环带宽度矩阵
n=size(W);
N=n(:,2)

%------------------------------------------------第四部：光子筛小孔数据的生成和存储------------------------------------------
%disp(M);
u_PS0=0;
R1=R0-W/2;
PMTR=zeros(1,3);   %存放小孔坐标和半径的数组：第一列是小孔横坐标，第二列是小孔纵坐标，第三列是小孔半径
data=0;      %小孔数量统计
K=1.2;       %小孔直径与带宽的比例系数
fid=fopen('D:/matlab/data_cps.scr','a'); 
str0='circle';
for I=2:M
    
    m=floor(8*(2*R0(I)-W(I))/(3*K*K*W(I)))
    n=2*pi/m:2*pi/m:2*pi;
    cos_n=cos(n);
    sin_n=sin(n);
    x_0=R1(I).*cos_n;
    y_0=R1(I).*sin_n;
    r=K*W(I)/2;
    size_n=size(n);
    r_0=r*ones(1,size_n(2));
    PMTR0(:,1)=x_0;
    PMTR0(:,2)=y_0;
    PMTR0(:,3)=r_0;
    L=length(PMTR0(:,1));
    for i=1:L
      fprintf(fid,'%s %g,%g\r\n',str0,PMTR0(i,1),PMTR0(i,2));
      fprintf(fid,'%g\r\n',PMTR0(i,3));
    end 
    clear PMTR0;
    data=data+m;
    disp(I);
end
fclose(fid); 

% PMTR(1,:)=[]
% %-----------------------------------生成小孔数据文件------------------------------
% L=length(PMTR(:,1))
% fid=fopen('E:/data_cps.scr','w');  %文件存放目录及文件名称可根据需要修改。
% 
% str0='circle';
% for i=1:L  
% fprintf(fid,'%s %g,%g %g\r\n',str0,PMTR(i,1),PMTR(i,2),PMTR(i,3));%文件格式为CAD可执行的脚本文件。
% 
% end
% fclose(fid); 


