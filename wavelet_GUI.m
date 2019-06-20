function [time,s,signal,output,fs] = wavelet_GUI(filename,SNR,varargin)
[s, fs] = audioread(filename);               % ���������ļ�
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
end

