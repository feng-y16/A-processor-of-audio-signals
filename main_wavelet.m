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
title('原始信号')
subplot(3,2,2),plot(xn)
title('加噪信号')
%产生一个长为2**11点，包含高斯白噪声的正弦信号，噪声的的标准偏差为3。
 
lev=5;
xd=wden(xn,'heursure','s','one',lev,'sym8');
% [XD,CXD,LXD] = WDEN(X,TPTR,SORH,SCAL,N,'wname') 
% returns a de-noised version XD of input signal X obtained by thresholding the % wavelet coefficients. Additional output arguments [CXD,LXD] are the wavelet % decomposition structure of de-noised signal XD.（WDEN根据信号小波分解% 结构[C,L]对信号进行去噪处理，返回处理信号XD，以及XD的小波分解% 结构 {CXD，LXD}）。
% TPTR(contains threshold selection rule)='heursure', 
% 'heursure' is an heuristic variant of the first option
% （选择基于Stein无偏估计理论的自适应域值的启发式改进）
% SORH ('s' or 'h') is for soft or hard thresholding（决定域值的使用方式）
% SCAL(='onedefines multiplicative threshold rescaling:'one' for no rescaling
%（决定域值是否随噪声变化） 'wname'='sym8'
subplot(3,2,3),plot(xd)
title('启发式SURE域值选择算法去噪')
% 利用’sym8’小波对信号分解，在分解的第5层上，利用启发式SURE域值选择法对信号去噪。
 
xd=wden(xn,'heursure','s','sln',lev,'sym8'); 
% 'sln' for rescaling using a single estimation 
% of level noise based on first level coefficients（根据第一层小波分解的噪声方% 差调整域值）
subplot(3,2,4),plot(xd)
title('软SURE域值选择算法去噪')
% 同上’sym8’小波对信号分解条件，但用软SURE域值选择算法对信号去噪。
 
xd=wden(xn,'sqtwolog','s','sln',lev,'sym8'); 
% for universal threshold sqrt(2*log(.))（固定域值选择算法去噪）.
subplot(3,2,5),plot(xd)
title('固定域值选择算法去噪')
[c,l]=wavedec(xn,lev,'sym8');