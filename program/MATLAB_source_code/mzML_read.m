function chromdata = mzML_read(file)
% INPUT
% file: the full file path of a MRM data file in mzML format
% 
% OUTPUT
% The output is a structure 'chromdata' containing the following fields:
% - mzdata: the m/z of the chromatogram
% - peakdata: a mx2 double array where the first column contains RT data 
%   , the second column contains intensity data, and m is the number of
%   signals in the chromatogram
% Note: the first chromdata is a TIC and the remaining are SRMs
% 
% Author: Ke-Shiuan Lynn Ph.D.
% Assistant Professor
% Department of Mathematics
% Fu-Jen Catholic University
% Email: 128171@mail.fju.edu.tw
% Final Update: Jul. 24, 2022
    fileID = fopen(file,'r');
    if fileID < 0
        errordlg(['The file ',file,' is not readable!'],'File Open Error');
        return
    end
    fileData = textscan(fileID,'%s','delimiter','\n');
    fileData = fileData{1};
    fclose(fileID);
    % Get total number of scans
    tempstr = textscan(fileData{contains(fileData,'<chromatogramList')},'%s');
    try
        pid=find(tempstr{1}{2}=='"');
        chromnum=str2double(tempstr{1}{2}(pid(1)+1:pid(2)-1)); % obtain number of XICs
    catch
        errordlg(['The file ',file,' is not in the correct format!'],'File Format Error');
        return
    end
    if ~(chromnum>0)
        errordlg(['The file ',file,' is not in the correct format!'],'File Format Error');
        return
    end
    % Get line indices for chromatogram info
    infoidx=find(contains(fileData,'index=')); % start of a new chromatogram
    rtidx=find(contains(fileData,'time array'))+1;
    intidx=find(contains(fileData,'number of detector counts'))+1; % start of intensity records
    if (length(infoidx) ~= chromnum) || (length(rtidx) ~= chromnum) %|| (length(intidx) ~= chromnum)
        errordlg(['Number of chromatograms does not match with the data in ',file],'File Content Error');
        return
    end
    % Get startTimeStamp
    tempstr=textscan(fileData{contains(fileData,'startTimeStamp')},'%s');
    sectstr=tempstr{1};
    timetemp=extractBetween(sectstr(contains(sectstr,'startTimeStamp')),'"','"');
    chromdata.startTimeStamp=timetemp{1};
    % read EICs using a loop
    MRMnum=length(intidx); % actual MRM numbers
    chromdata.peakdata=cell(MRMnum,1); % create cells to store chromatography data
    chromdata.mzdata=cell(MRMnum,1); % create array to store peak data
    infoidx=[infoidx;length(fileData)];
    iskeep=true(1,MRMnum);
    for i=1:MRMnum
        data=textscan(fileData{infoidx(i)},'%s'); % get SRM info
        pid=find(data{1}{2}=='"');
        idx=str2double(data{1}{2}(pid(1)+1:pid(2)-1)); % get spectrum index
        isSRM=contains(data{1},{'SRM','SIM'});
        if any(isSRM) % if the id method contains 'SRM', then its a SRM XIC. Otherwise it's a TIC.
            sidx=find(isSRM,1,'first');
            chromdata.mzdata{idx+1}=[str2double(data{1}{sidx+2}(4:end)) str2double(data{1}{sidx+3}(4:end))]; % parent(Q1) and daughter (Q3) values
        elseif i>1
            iskeep(i)=false;
        end
        pid=find(data{1}{end}=='"');
        peaknum=str2double(data{1}{end}(pid(1)+1:pid(2)-1));
        chromdata.peakdata{idx+1}=zeros(peaknum,2);
        % extract RT information for each chromatogram
        if peaknum > 0
            for j=infoidx(i)+1:infoidx(i+1)-1
                if contains(fileData{j},"<binary>")
                    rtdata=fileData{j}(9:end-9); % extract RT info string
                    chromdata.peakdata{idx+1}(:,1)=typecast(zlibdecode(swapbytes(base64decode(rtdata))),'double');
                    intdata=fileData{j+6}(9:end-9); % extract RT info string
                    chromdata.peakdata{idx+1}(:,2)=typecast(zlibdecode(swapbytes(base64decode(intdata))),'double');
                    break;
                end
            end
        end
    end
    chromdata.mzdata=chromdata.mzdata(iskeep);
    chromdata.peakdata=chromdata.peakdata(iskeep);
    MRMnum=sum(iskeep);
    % collect data names that are NOT ion chromatagrams
    chromdata.NonMRM={};
    listidx=find(contains(fileData,'offset idRef=')); % start of a chromatogram list
    for i=(MRMnum+1):length(listidx)
        qid=strfind(fileData{listidx(i)},'"');
        chromdata.NonMRM=[chromdata.NonMRM;fileData{listidx(i)}((qid(1)+1):(qid(2)-1))];
    end
end
function y = base64decode(x)
%BASE64DECODE Perform base64 decoding on a string.
%
%   BASE64DECODE(STR) decodes the given base64 string STR.
%
%   Any character not part of the 65-character base64 subset set is silently
%   ignored.  Characters occuring after a '=' padding character are never
%   decoded.
%
%   STR doesn't have to be a string.  The only requirement is that it is a
%   vector containing values in the range 0-255.
%
%   If the length of the string to decode (after ignoring non-base64 chars) is
%   not a multiple of 4, then a warning is generated.
%
%   This function is used to decode strings from the Base64 encoding specified
%   in RFC 2045 - MIME (Multipurpose Internet Mail Extensions).  The Base64
%   encoding is designed to represent arbitrary sequences of octets in a form
%   that need not be humanly readable.  A 65-character subset ([A-Za-z0-9+/=])
%   of US-ASCII is used, enabling 6 bits to be represented per printable
%   character.
%
%   See also BASE64ENCODE.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-09-20 08:20:50 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

%   remove non-base64 chars
x = x (   ( 'A' <= x & x <= 'Z' ) ...
    | ( 'a' <= x & x <= 'z' ) ...
    | ( '0' <= x & x <= '9' ) ...
    | ( x == '+' ) | ( x == '=' ) | ( x == '/' ) );


if rem(length(x), 4)
    warning('Length of base64 data not a multiple of 4; padding input.');
end

k = find(x == '=');
if ~isempty(k)
    x = x(1:k(1)-1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now perform the following mapping
%
%   A-Z  ->  0  - 25
%   a-z  ->  26 - 51
%   0-9  ->  52 - 61
%   +    ->  62
%   /    ->  63

y = repmat(uint8(0), size(x));
i = 'A' <= x & x <= 'Z'; y(i) =    - 'A' + x(i);
i = 'a' <= x & x <= 'z'; y(i) = 26 - 'a' + x(i);
i = '0' <= x & x <= '9'; y(i) = 52 - '0' + x(i);
i =            x == '+'; y(i) = 62 - '+' + x(i);
i =            x == '/'; y(i) = 63 - '/' + x(i);
x = y;

nebytes = length(x);         % number of encoded bytes
nchunks = ceil(nebytes/4);   % number of chunks/groups

% add padding if necessary
if rem(nebytes, 4)
    x(end+1 : 4*nchunks) = 0;
end

x = reshape(uint8(x), 4, nchunks);
y = repmat(uint8(0), 3, nchunks);            % for the decoded data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rearrange every 4 bytes into 3 bytes
%
%    00aaaaaa 00bbbbbb 00cccccc 00dddddd
%
% to form
%
%    aaaaaabb bbbbcccc ccdddddd

y(1,:) = bitshift(x(1,:), 2);                    % 6 highest bits of y(1,:)
y(1,:) = bitor(y(1,:), bitshift(x(2,:), -4));    % 2 lowest bits of y(1,:)

y(2,:) = bitshift(x(2,:), 4);                    % 4 highest bits of y(2,:)
y(2,:) = bitor(y(2,:), bitshift(x(3,:), -2));    % 4 lowest bits of y(2,:)

y(3,:) = bitshift(x(3,:), 6);                    % 2 highest bits of y(3,:)
y(3,:) = bitor(y(3,:), x(4,:));                  % 6 lowest bits of y(3,:)

% remove padding
switch rem(nebytes, 4)
    case 2
        y = y(1:end-2);
    case 3
        y = y(1:end-1);
end

% reshape to a row vector and make it a character array
%y = char(reshape(y, 1, numel(y)));

% MODIFED BY G.ERNY for comaptibility with zlibdecode
y = uint8(reshape(y, 1, numel(y)));
end

function output = zlibdecode(input)
% Copyright (c) 2012, Kota Yamaguchi
% http://www.mathworks.com/matlabcentral/fileexchange/39526-byte-encoding-utilities/content/encoder/zlibdecode.m
% ZLIBDECODE Decompress input bytes using ZLIB.
%
%    output = zlibdecode(input)
%
% The function takes a compressed byte array INPUT and returns inflated
% bytes OUTPUT. The INPUT is a result of GZIPENCODE function. The OUTPUT
% is always an 1-by-N uint8 array. JAVA must be enabled to use the function.
%
% See also zlibencode typecast
buffer = java.io.ByteArrayOutputStream();
zlib = java.util.zip.InflaterOutputStream(buffer);
zlib.write(input, 0, numel(input));
zlib.close();
output = typecast(buffer.toByteArray(), 'uint8')';

end
