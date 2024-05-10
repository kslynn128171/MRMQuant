function chromdata = MRM_read_fast(file)
% INPUT
% file: the full file path of a MRM data file
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
tempstr = textscan(fileData{contains(fileData,'chromatogramList')},'%s');
try
    chromnum=str2double(tempstr{1}{2}(2:end)); % obtain number of XICs
catch
    errordlg(['The file ',file,' is not in the correct format!'],'File Format Error');
    return
end
if ~(chromnum>0)
    errordlg(['The file ',file,' is not in the correct format!'],'File Format Error');
    return
end
chromdata.peakdata=cell(chromnum,1); % create cells to store chromatography data
chromdata.mzdata=cell(chromnum,1); % create array to store peak data
% Get line indices for chromatogram info
infoidx=find(contains(fileData,'index:')); % start of a new chromatogram
rtidx=find(contains(fileData,'cvParam: time array, minute'))+1;
intidx=find(contains(fileData,'cvParam: intensity array, number of detector counts'))+1; % start of intensity records
if (length(infoidx) ~= chromnum) || (length(rtidx) ~= chromnum) || (length(intidx) ~= chromnum)
    errordlg(['Number of chromatograms does not match with the data in ',file],'File Content Error');
    return
end
% Get startTimeStamp
tempstr=textscan(fileData{contains(fileData,'startTimeStamp')},'%s');
chromdata.startTimeStamp=tempstr{1}{2};
% read EICs using a loop
for i=1:chromnum
    idx=str2double(fileData{infoidx(i)}(8:end));
    data=textscan(fileData{infoidx(i)+1},'%s');
    isSRM=contains(data{1},{'SRM','SIM'});
    if any(isSRM) % if the id method contains 'SRM', then its a SRM XIC. Otherwise it's a TIC.
        sidx=find(isSRM,1,'first');
        chromdata.mzdata{idx+1}=[str2double(data{1}{sidx+2}(4:end)) str2double(data{1}{sidx+3}(4:end))]; % parent(Q1) and daughter (Q3) values
    end
    data=textscan(fileData{infoidx(i)+2},'%s'); % extract peak number info
    peaknum=str2double(data{1}{2});
    chromdata.peakdata{idx+1}=zeros(peaknum,2);
    % extract RT information for each chromatogram
    if peaknum > 0
        rtdata=textscan(fileData{rtidx(i)},'%s');
        chromdata.peakdata{idx+1}(:,1)=double(string(rtdata{1}(3:end)));
        intdata=textscan(fileData{intidx(i)},'%s');
        chromdata.peakdata{idx+1}(:,2)=double(string(intdata{1}(3:end)));
    end
end
