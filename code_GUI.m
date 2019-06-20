function [ allstr ] = code_GUI(filename,varargin)
fid = fopen(filename, 'r');
str = fread(fid, 'uint8')';
fclose(fid);
myseed = floor(200*rand(1))+50;
addstr = zeros(1,myseed+4);
addstr(end) = mod(length(str),myseed);
addstr(1) = floor(255*rand(1));
addstr(2) = ceil(255*rand(1));
addstr(3) = myseed;
myorder = randperm(myseed);
addstr(4:(end-1)) = myorder;
if addstr(1)>127
    str = fliplr(str);
end
str = str + addstr(2);
myovernum = find(str>255);
str(myovernum) = str(myovernum) - 256;
preproc = floor(length(str)/myseed);
if preproc>0
    k = 0;
    for n1 = 1:preproc
        temp = str(k+myorder);
        str(k+(1:myseed)) = temp;
        k = k + myseed;
    end
end
allstr = [addstr,str];
fid = fopen(filename, 'w');
fwrite(fid,allstr, 'uint8');
fclose(fid);
end

