function [s_syn_t]=changevoice1(filename)%����תŮ��
FL = 80;
WL = 240;     
P = 10;  
[s,fs]=audioread(filename);
% ���峣��     
s = s/max(s);             % ��һ��     
L = length(s);            % ������������      
FN = floor(L/FL)-2;       % ����֡����floor���������  
% Ԥ����ؽ��˲���  
exc = zeros(L,1);         % �����źţ�double�������L��1�� 
zi_pre = zeros(P,1);      % Ԥ���˲���״̬ 
s_rec = zeros(L,1);       % �ؽ����� 
zi_rec = zeros(P,1); 
% ����˲���  
exc_syn_t = zeros(L,1);   % �ϳɵļ����źţ�����һ��L��1�е�0���� 
s_syn_t = zeros(L,1);     % �ϳ�����  
last_syn_t = 0;           % �洢��һ���ε����һ��������±� 
zi_syn_t = zeros(P,1);    % �ϳ��˲��� 
hw = hamming(WL);         %������
%�˲���  
% ���δ���ÿ֡���� 
for n = 3:FN             %�ӵ����������鿪ʼ 
    % ����Ԥ��ϵ��  
    s_w = s(n*FL-WL+1:n*FL).*hw;    %��������Ȩ
    if all(s_w==0)
        continue;
    end
    [A,E]=lpc(s_w,P);               %����Ԥ�����Ԥ��ϵ��
    % A��Ԥ��ϵ����E�ᱻ��������ϳɼ��������� 
    s_f=s((n-1)*FL+1:n*FL);         % ��֡���� 
    %����filter�����ؽ�����       
    [exc1,zi_pre] = filter(A,1,s_f,zi_pre); 
    exc((n-1)*FL+1:n*FL) = exc1;           %���㼤��
    %����filter�����ؽ�����       
    [s_rec1,zi_rec] = filter(1,A,exc1,zi_rec); 
    s_rec((n-1)*FL+1:n*FL) = s_rec1; %�ؽ����� 
    % ����ֻ�еõ�exc��ſ���  
    s_Pitch = exc(n*FL-222:n*FL); 
    PT(n) = findpitch(s_Pitch);    %�����������pt 
    G = sqrt(E*PT(n));            %����ϳɼ���������G 
    PT1 =floor(PT(n)/2);    %��С�������� 
    poles = roots(A); 
    deltaOMG =100*2*pi/fs;  
    for p=1:P   %���ӹ���� 
        if imag(poles(p))>0  
            poles(p) = poles(p)*exp(1j*deltaOMG); 
        elseif imag(poles(p))<0   
            poles(p) = poles(p)*exp(-1j*deltaOMG); 
        end 
    end
    A1=poly(poles);  
    tempn_syn_t=(1:n*FL-last_syn_t);  
    exc_syn1_t = zeros(length(tempn_syn_t),1);
    exc_syn1_t(mod(tempn_syn_t,PT1)==0) = G; 
    exc_syn1_t = exc_syn1_t((n-1)*FL-last_syn_t+1:n*FL-last_syn_t);
    [s_syn1_t,zi_syn_t] = filter(1,A1,exc_syn1_t,zi_syn_t); 
    exc_syn_t((n-1)*FL+1:n*FL) = exc_syn1_t;        %�ϳɼ��� 
    s_syn_t((n-1)*FL+1:n*FL) = s_syn1_t;            %�ϳ����� 
    last_syn_t = last_syn_t+PT1*floor((n*FL-last_syn_t)/PT1); 
end
sound(s_syn_t,fs);
end