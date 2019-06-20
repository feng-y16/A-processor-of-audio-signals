clear
%filedir=[];                             % ����·��
%filename='test.wav';                % �����ļ���
%fle=[filedir filename];                 % ����������·�����ļ���

%[s, fs] = audioread(fle);               % ���������ļ�
%FS=fs/441;
%s = resample(s,FS,fs);
%fs=FS;

sqrt_snr=3;
init=231434;
[s,~]=wnoise(3,11,sqrt_snr,init);
fs=1/length(s);

s=s-mean(s);                            % ����ֱ������
s=s/max(abs(s));                        % ��ֵ��һ
N=length(s);                            % ��������
time=(0:N-1)/fs;                        % ����ʱ��̶�

%% ��������������
SNR = 0.9;                                  % ���������
r2=randn(size(s));                      % �����������
b=fir1(31,0.5);                         % ���FIR�˲���,����H
r21=filter(b,1,r2);                     % FIR�˲�
% [signal_with_noise,noise]=add_noisedata(s,data,fs,fs1,snr);
[r1,r22]=add_noisedata(s,r21,fs,fs,SNR);% �������������������ΪSNR��
h = weiner_filter( N,r1-r22,r1 );
%% ����һ�׶���õ�h������

% �˲�
y = filter(h,1,r1);
output = y;

%snr1=SNR_singlech(s,r1);                % �����ʼ�����
%snr2=SNR_singlech(s,output);            % �����˲���������
%snr=snr2-snr1;

%% ��ͼ
figure;
subplot 311; 
plot(time,s,'k'); 
%ylabel('��ֵ');
%ylim([-1 1 ]); 
title('ԭʼ�ź�');
subplot 312; 
plot(time,r1,'k'); 
%ylabel('��ֵ') 
%ylim([-1 1 ]); 
title('�����ź�');
subplot 313; 
plot(time,output,'k'); 
%ylim([-1 1 ]); 
title('ά���˲�ȥ����ź�');
%xlabel('ʱ��/s'); 
%ylabel('��ֵ')

%% ��ӡSNR
%fprintf('ȥ�� \n',snr);
%fprintf('�˲�ǰ SNR = %f [dB] \n',snr1);
%fprintf('�˲��� SNR = %f [dB] \n',snr2);
%fprintf('���� %f [dB] \n',snr);

%% ��Ч��
% sound(s,fs); % �ɾ�������
% sound(r1,fs); % ���������
%sound(output,fs); % �˲��������