clear
%filedir=[];                             % ����·��
%filename='test.wav';                % �����ļ���
%fle=[filedir filename];                 % ����������·�����ļ���

%[x, fs] = audioread(fle);               % ���������ļ�
%FS=fs/441;
%x = resample(x,FS,fs);
%fs=FS;

sqrt_snr=3;
init=231434;
[x,~]=wnoise(3,11,sqrt_snr,init);
x=x';
fs=1/length(x);

N = length(x);       % ֡��
max_x = max(x);
noise_add = random('norm', 0, 0.1*max_x, [N,1]); % ��Ӹ�˹����
y = x + noise_add;
noise_estimated = random('norm', 0, 0.1*max_x, [N,1]);
fft_y = fft(y);
fft_n = fft(noise_estimated);
E_noise = sum(abs(fft_n)) / N;
mag_y = abs(fft_y);
phase_y = angle(fft_y);   % ������λ��Ϣ
mag_s = mag_y - E_noise;
mag_s(mag_s<0)=0; % �ָ�
fft_s = mag_s .* exp(1i.*phase_y);
s = ifft(fft_s); 
subplot(311);
plot(x);
%ylim([-1.5,1.5]);
title('ԭʼ�ź�');
subplot(312);
plot(y);
%ylim([-1.5,1.5]);
title('�����ź�');
subplot(313);
plot(real(s));
%ylim([-1.5,1.5]);
title('�׼���ȥ����ź�');