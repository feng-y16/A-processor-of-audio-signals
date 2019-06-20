function [time,s,signal,output,fs] = wavelet_GUI(filename,SNR,varargin)
[s, fs] = audioread(filename);               % 读入数据文件
% if nargin<=2
%     FS=round(fs/441);
%     %up=1;
%     s = resample(s,FS,fs);
%     fs=FS;
% else
%     FS=varargin{1};
%     %up=FS/fs*441;
%     s = resample(s,FS,fs);
%     fs=FS;
% end
s=s-mean(s);                            % 消除直流分量
s=s/max(abs(s));                        % 幅值归一
N=length(s);                            % 语音长度
time=(0:N-1)/fs;                        % 设置时间刻度
%noise = random('norm', 0, 1-SNR, [N,1]); % 添加高斯噪声
noise=randn(size(s));                      % 产生随机噪声
%b=fir1(31,0.5);                         % 设计FIR滤波器,代替H
%noise=filter(b,1,noise);                     % FIR滤波
[signal,~]=add_noisedata(s,noise,fs,fs,SNR);% 产生带噪语音，信噪比为SNR
lev=4;
output=wden(signal,'sqtwolog','s','one',lev,'sym8');
output=output/max(abs(output)); 
end

