function h = weiner_filter( h_length,desired_signal,observed_signal )
%   ά���˲�����ʵ��
%   �������
%       h_length: ���ص�FIR�˲����ĳ���
%       desired_signal: ���������ź�,ѵ���ź�,�ɾ��ź�
%       observed_signal: �۲⵽���ź�
%   ���ز���
%       h: FIR�˲���ϵ��

% 0. �������Է�����Ĵ�С
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

% 3. ��h, Ax = b
% (1) ���������A��
A = toeplitz(Rx_c,Rx_c);
b = Rdx_c;
h = A\b;

end