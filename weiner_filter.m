function h = weiner_filter( h_length,desired_signal,observed_signal )
%   维纳滤波器的实现
%   输入参数
%       h_length: 返回的FIR滤波器的长度
%       desired_signal: 所期望的信号,训练信号,干净信号
%       observed_signal: 观测到的信号
%   返回参数
%       h: FIR滤波器系数

% 0. 定义线性方程组的大小
row_number = h_length;
col_number = row_number;

% 1. Rx --> observed_signal
M = col_number;
% lags = -(N-1):(N-1);
Rx_c_full = xcorr(observed_signal);
[~,k] = max(Rx_c_full);
Rx_c = Rx_c_full(k:k+M-1);
Rx_c = Rx_c.';

% 2. Rdx
Rdx_c_full = xcorr(desired_signal,observed_signal);
Rdx_c = Rdx_c_full(k:k+M-1);

% 3. 求h, Ax = b
% (1) 生成自相关A阵
A = toeplitz(Rx_c,Rx_c);
b = Rdx_c;
h = A\b;

end