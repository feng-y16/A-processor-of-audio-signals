function [s,fs] = changevoice_GUI(filename,var)
[s,fs]=audioread(filename);
N=length(s);
n=0:N-1;
S=fft(s);
Fs=1*fs;
T=1/Fs;
f=n/N*Fs;
switch var
    case 1
        fs=1.5*fs;
    case 2
        fs=0.8*fs;
    case 3
        fs=1.5*1/0.8*fs;
    case 4
        fs=1/0.8*fs;
    case 5
        fs=1/1.5*fs;
    case 6
        fs=1/1.5*0.8*fs;
end
end

