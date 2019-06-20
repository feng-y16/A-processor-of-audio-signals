function [time,s,signal,output,fs] = weiner_filter_GUI(filename,SNR,varargin)
[s, fs] = audioread(filename);               % ���������ļ�
% if nargin<=2
%     FS=round(fs/441);
%     s = resample(s,FS,fs);
%     fs=FS;
% else
%     FS=varargin{1};
%     s = resample(s,FS,fs);
%     fs=FS;
% end
s=s-mean(s);                            % ����ֱ������
s=s/max(abs(s));                        % ��ֵ��һ
N=length(s);                            % ��������
time=(0:N-1)/fs;                        % ����ʱ��̶�
noise=randn(size(s));                      % �����������
%b=fir1(31,0.5);                         % ���FIR�˲���,����H
%noise=filter(b,1,noise);                     % FIR�˲�
[signal,noise]=add_noisedata(s,noise,fs,fs,SNR);% �������������������ΪSNR��
h = weiner_filter( N,signal-noise,signal );
output = filter(h,1,signal);
end