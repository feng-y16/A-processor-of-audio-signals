%%
clear;
clc;
SNR=36;
filename='audio1.wav';
[s, fs] = audioread(filename);               % ���������ļ�
s=s-mean(s);                            % ����ֱ������
s=s/max(abs(s));                        % ��ֵ��һ
N=length(s);                            % ��������
time=(0:N-1)/fs;                        % ����ʱ��̶�
%noise = random('norm', 0, 1-SNR, [N,1]); % ��Ӹ�˹����
noise=randn(size(s));                      % �����������
%b=fir1(31,0.5);                         % ���FIR�˲���,����H
%noise=filter(b,1,noise);                     % FIR�˲�
[signal,~]=add_noisedata(s,noise,fs,fs,SNR);% �������������������ΪSNR
lev=4;
output=wden(signal,'sqtwolog','s','one',lev,'sym8');
output=output/max(abs(output)); 
audiowrite('wav1.wav',signal,fs);
audiowrite('wav2.wav',output,fs);
%%
clear;
clc;
SNR=36;
filename='audio1.wav';
[s, fs] = audioread(filename);               % ���������ļ�
s=s-mean(s);                            % ����ֱ������
s=s/max(abs(s));                        % ��ֵ��һ
N=length(s);                            % ��������
time=(0:N-1)./fs;                        % ����ʱ��̶�
noise = random('norm', 0, 1, [N,1]); % ��Ӹ�˹����
[signal,~]=add_noisedata(s,noise,fs,fs,SNR);% �������������������ΪSNR
noise_estimated = random('norm', 0, 1, [N,1]);
[~,noise_estimated]=add_noisedata(s,noise_estimated,fs,fs,SNR);
fft_signal = fft(signal);
fft_noise_estimated = fft(noise_estimated);
E_noise_estimated = sum(abs(fft_noise_estimated)) / N;
mag_signal = abs(fft_signal);
phase_signal = angle(fft_signal);   % ������λ��Ϣ
mag_signal = mag_signal - E_noise_estimated;
mag_signal(mag_signal<0)=0; % �ָ�
fft_signal = mag_signal .* exp(1i.*phase_signal);
output = real(ifft(fft_signal)); 
audiowrite('sub1.wav',signal,fs);
audiowrite('sub2.wav',output,fs);