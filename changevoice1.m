function [s_syn_t]=changevoice1(filename)%男声转女声
FL = 80;
WL = 240;     
P = 10;  
[s,fs]=audioread(filename);
% 定义常数     
s = s/max(s);             % 归一化     
L = length(s);            % 读入语音长度      
FN = floor(L/FL)-2;       % 计算帧长，floor；向负无穷方向  
% 预测和重建滤波器  
exc = zeros(L,1);         % 激励信号，double类零矩阵L行1列 
zi_pre = zeros(P,1);      % 预测滤波器状态 
s_rec = zeros(L,1);       % 重建语音 
zi_rec = zeros(P,1); 
% 变调滤波器  
exc_syn_t = zeros(L,1);   % 合成的激励信号，创建一个L行1列的0脉冲 
s_syn_t = zeros(L,1);     % 合成语音  
last_syn_t = 0;           % 存储上一个段的最后一个脉冲的下标 
zi_syn_t = zeros(P,1);    % 合成滤波器 
hw = hamming(WL);         %汉明窗
%滤波器  
% 依次处理每帧语音 
for n = 3:FN             %从第三个子数组开始 
    % 计算预测系数  
    s_w = s(n*FL-WL+1:n*FL).*hw;    %汉明窗加权
    if all(s_w==0)
        continue;
    end
    [A,E]=lpc(s_w,P);               %线性预测计算预测系数
    % A是预测系数，E会被用来计算合成激励的能量 
    s_f=s((n-1)*FL+1:n*FL);         % 本帧语音 
    %利用filter函数重建语音       
    [exc1,zi_pre] = filter(A,1,s_f,zi_pre); 
    exc((n-1)*FL+1:n*FL) = exc1;           %计算激励
    %利用filter函数重建语音       
    [s_rec1,zi_rec] = filter(1,A,exc1,zi_rec); 
    s_rec((n-1)*FL+1:n*FL) = s_rec1; %重建语音 
    % 下面只有得到exc后才可以  
    s_Pitch = exc(n*FL-222:n*FL); 
    PT(n) = findpitch(s_Pitch);    %计算基音周期pt 
    G = sqrt(E*PT(n));            %计算合成激励的能量G 
    PT1 =floor(PT(n)/2);    %减小基音周期 
    poles = roots(A); 
    deltaOMG =100*2*pi/fs;  
    for p=1:P   %增加共振峰 
        if imag(poles(p))>0  
            poles(p) = poles(p)*exp(1j*deltaOMG); 
        elseif imag(poles(p))<0   
            poles(p) = poles(p)*exp(-1j*deltaOMG); 
        end 
    end
    A1=poly(poles);  
    tempn_syn_t=(1:n*FL-last_syn_t);  
    exc_syn1_t = zeros(length(tempn_syn_t),1);
    exc_syn1_t(mod(tempn_syn_t,PT1)==0) = G; 
    exc_syn1_t = exc_syn1_t((n-1)*FL-last_syn_t+1:n*FL-last_syn_t);
    [s_syn1_t,zi_syn_t] = filter(1,A1,exc_syn1_t,zi_syn_t); 
    exc_syn_t((n-1)*FL+1:n*FL) = exc_syn1_t;        %合成激励 
    s_syn_t((n-1)*FL+1:n*FL) = s_syn1_t;            %合成语音 
    last_syn_t = last_syn_t+PT1*floor((n*FL-last_syn_t)/PT1); 
end
sound(s_syn_t,fs);
end