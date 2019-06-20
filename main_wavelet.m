sqrt_snr=3;
init=231434;
[x,xn]=wnoise(3,11,sqrt_snr,init);
% WNOISE generate noisy wavelet test data.
%  X= WNOISE(FUN,N) returns values of the test function given by FUN, on a
%  2^N sample of [0,1]. [X,XN] = WNOISE(FUN,N,SQRT_SNR) returns the
%  previous vector X rescaled such that std(x) = SQRT_SNR. The returned
%  vector XN contains the same test vector X corrupted by an additive Gaussian   %  white noise N(0,1). Then XN has a signal-to-noise ratio of (SQRT_SNR^2).
% [X,XN] = WNOISE(FUN,N,SQRT_SNR,INIT) returns previous vectors X and % XN, but the generator seed is set to INI value.
subplot(3,2,1),plot(x)
title('ԭʼ�ź�')
subplot(3,2,2),plot(xn)
title('�����ź�')
%����һ����Ϊ2**11�㣬������˹�������������źţ������ĵı�׼ƫ��Ϊ3��
 
lev=5;
xd=wden(xn,'heursure','s','one',lev,'sym8');
% [XD,CXD,LXD] = WDEN(X,TPTR,SORH,SCAL,N,'wname') 
% returns a de-noised version XD of input signal X obtained by thresholding the % wavelet coefficients. Additional output arguments [CXD,LXD] are the wavelet % decomposition structure of de-noised signal XD.��WDEN�����ź�С���ֽ�% �ṹ[C,L]���źŽ���ȥ�봦�����ش����ź�XD���Լ�XD��С���ֽ�% �ṹ {CXD��LXD}����
% TPTR(contains threshold selection rule)='heursure', 
% 'heursure' is an heuristic variant of the first option
% ��ѡ�����Stein��ƫ�������۵�����Ӧ��ֵ������ʽ�Ľ���
% SORH ('s' or 'h') is for soft or hard thresholding��������ֵ��ʹ�÷�ʽ��
% SCAL(='onedefines multiplicative threshold rescaling:'one' for no rescaling
%��������ֵ�Ƿ��������仯�� 'wname'='sym8'
subplot(3,2,3),plot(xd)
title('����ʽSURE��ֵѡ���㷨ȥ��')
% ���á�sym8��С�����źŷֽ⣬�ڷֽ�ĵ�5���ϣ���������ʽSURE��ֵѡ�񷨶��ź�ȥ�롣
 
xd=wden(xn,'heursure','s','sln',lev,'sym8'); 
% 'sln' for rescaling using a single estimation 
% of level noise based on first level coefficients�����ݵ�һ��С���ֽ��������% �������ֵ��
subplot(3,2,4),plot(xd)
title('��SURE��ֵѡ���㷨ȥ��')
% ͬ�ϡ�sym8��С�����źŷֽ�������������SURE��ֵѡ���㷨���ź�ȥ�롣
 
xd=wden(xn,'sqtwolog','s','sln',lev,'sym8'); 
% for universal threshold sqrt(2*log(.))���̶���ֵѡ���㷨ȥ�룩.
subplot(3,2,5),plot(xd)
title('�̶���ֵѡ���㷨ȥ��')
[c,l]=wavedec(xn,lev,'sym8');