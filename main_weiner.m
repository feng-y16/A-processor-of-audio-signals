clear
%filedir=[];                             % 设置路径
%filename='test.wav';                % 设置文件名
%fle=[filedir filename];                 % 构成完整的路径和文件名

%[s, fs] = audioread(fle);               % 读入数据文件
%FS=fs/441;
%s = resample(s,FS,fs);
%fs=FS;

sqrt_snr=3;
init=231434;
[s,~]=wnoise(3,11,sqrt_snr,init);
fs=1/length(s);

s=s-mean(s);                            % 消除直流分量
s=s/max(abs(s));                        % 幅值归一
N=length(s);                            % 语音长度
time=(0:N-1)/fs;                        % 设置时间刻度

%% 产生噪声并加入
SNR = 0.9;                                  % 设置信噪比
r2=randn(size(s));                      % 产生随机噪声
b=fir1(31,0.5);                         % 设计FIR滤波器,代替H
r21=filter(b,1,r2);                     % FIR滤波
% [signal_with_noise,noise]=add_noisedata(s,data,fs,fs1,snr);
[r1,r22]=add_noisedata(s,r21,fs,fs,SNR);% 产生带噪语音，信噪比为SNR　
h = weiner_filter( N,r1-r22,r1 );
%% 用上一阶段求得的h，降噪

% 滤波
y = filter(h,1,r1);
output = y;

%snr1=SNR_singlech(s,r1);                % 计算初始信噪比
%snr2=SNR_singlech(s,output);            % 计算滤波后的信噪比
%snr=snr2-snr1;

%% 画图
figure;
subplot 311; 
plot(time,s,'k'); 
%ylabel('幅值');
%ylim([-1 1 ]); 
title('原始信号');
subplot 312; 
plot(time,r1,'k'); 
%ylabel('幅值') 
%ylim([-1 1 ]); 
title('加噪信号');
subplot 313; 
plot(time,output,'k'); 
%ylim([-1 1 ]); 
title('维纳滤波去噪后信号');
%xlabel('时间/s'); 
%ylabel('幅值')

%% 打印SNR
%fprintf('去噪 \n',snr);
%fprintf('滤波前 SNR = %f [dB] \n',snr1);
%fprintf('滤波后 SNR = %f [dB] \n',snr2);
%fprintf('提升 %f [dB] \n',snr);

%% 听效果
% sound(s,fs); % 干净的语音
% sound(r1,fs); % 含噪的语音
%sound(output,fs); % 滤波后的语音