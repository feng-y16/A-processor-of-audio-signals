clear
%filedir=[];                             % 设置路径
%filename='test.wav';                % 设置文件名
%fle=[filedir filename];                 % 构成完整的路径和文件名

%[x, fs] = audioread(fle);               % 读入数据文件
%FS=fs/441;
%x = resample(x,FS,fs);
%fs=FS;

sqrt_snr=3;
init=231434;
[x,~]=wnoise(3,11,sqrt_snr,init);
x=x';
fs=1/length(x);

N = length(x);       % 帧长
max_x = max(x);
noise_add = random('norm', 0, 0.1*max_x, [N,1]); % 添加高斯噪声
y = x + noise_add;
noise_estimated = random('norm', 0, 0.1*max_x, [N,1]);
fft_y = fft(y);
fft_n = fft(noise_estimated);
E_noise = sum(abs(fft_n)) / N;
mag_y = abs(fft_y);
phase_y = angle(fft_y);   % 保留相位信息
mag_s = mag_y - E_noise;
mag_s(mag_s<0)=0; % 恢复
fft_s = mag_s .* exp(1i.*phase_y);
s = ifft(fft_s); 
subplot(311);
plot(x);
%ylim([-1.5,1.5]);
title('原始信号');
subplot(312);
plot(y);
%ylim([-1.5,1.5]);
title('加噪信号');
subplot(313);
plot(real(s));
%ylim([-1.5,1.5]);
title('谱减法去噪后信号');