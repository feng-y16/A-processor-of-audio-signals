function [ str ] = decode_GUI(filename,varargin)
fid = fopen(filename, 'r');
allstr = fread(fid, 'uint8')';
fclose(fid);
addstr = allstr(1:(allstr(3)+4));
str = allstr((5+allstr(3)):end);
myseed = addstr(3);
myorder = addstr(4:(end-1));
preproc = floor(length(str)/myseed);
if preproc>0
    k = 0;
    for n1 = 1:preproc
        temp(myorder) = str(k+(1:myseed));
        str(k+(1:myseed)) = temp;
        k = k + myseed;
    end
end     
str = str + (256 - addstr(2));
myovernum = find(str>255);
str(myovernum) = str(myovernum) - 256; 
if addstr(1)>127
    str = fliplr(str);
end
fid = fopen(filename, 'w');
fwrite(fid, str, 'uint8');
fclose(fid);
end