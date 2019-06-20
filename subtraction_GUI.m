function [time,s,signal,output,fs] = subtraction_GUI(filename,SNR,varargin)
[s, fs] = audioread(filename);               % 读入数据文件
% if nargin<=2
%     FS=round(fs/441);
%     s = resample(s,FS,fs);
%     fs=FS;
% else
%     FS=varargin{1};
%     s = resample(s,FS,fs);
%     fs=FS;
% end
s=s-mean(s);                            % 消除直流分量
s=s/max(abs(s));                        % 幅值归一
N=length(s);                            % 语音长度
time=(0:N-1)./fs;                        % 设置时间刻度
noise = random('norm', 0, 1, [N,1]); % 添加高斯噪声
[signal,~]=add_noisedata(s,noise,fs,fs,SNR);% 产生带噪语音，信噪比为SNR
noise_estimated = random('norm', 0, 1, [N,1]);
[~,noise_estimated]=add_noisedata(s,noise_estimated,fs,fs,SNR);
fft_signal = fft(signal);
fft_noise_estimated = fft(noise_estimated);
E_noise_estimated = sum(abs(fft_noise_estimated)) / N;
mag_signal = abs(fft_signal);
phase_signal = angle(fft_signal);   % 保留相位信息
mag_signal = mag_signal - E_noise_estimated;
mag_signal(mag_signal<0)=0; % 恢复
fft_signal = mag_signal .* exp(1i.*phase_signal);
output = real(ifft(fft_signal)); 
end