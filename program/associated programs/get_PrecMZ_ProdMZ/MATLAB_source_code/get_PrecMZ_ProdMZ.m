clearvars
clc
close all
mainwin = figure('Units','normalized', ...
        'Menubar','none',...
        'Name','Get Precursor MZ and Product MZ Values', ...
        'NumberTitle','off', ...
        'Position',[0.3 0.4 0.4 0.3]);
uicontrol('Parent',mainwin, ...
        'Units','normalized', ...
        'Fontsize',14, ...
        'HorizontalAlignment','left',...
        'Position',[0.05 0.8 0.9 0.12],...
        'String','Select a MRM file', ...
        'Style','text');
uicontrol('Parent',mainwin, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor','w', ...
        'Position',[0.05 0.65 0.7 0.15],...
        'Style','edit',...
        'Tag','ed_filename');
uicontrol('Parent',mainwin, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'Callback',@open_MRM_mz, ...
        'Position',[0.76 0.65 0.19 0.15], ...
        'String','Browse...', ...
        'Style','pushbutton');
uicontrol('Parent',mainwin, ...
        'Units','normalized', ...
        'Fontsize',14, ...
        'HorizontalAlignment','left',...
        'Position',[0.05 0.45 0.9 0.12],...
        'String','Select an output file', ...
        'Style','text');
uicontrol('Parent',mainwin, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor','w', ...
        'Position',[0.05 0.3 0.7 0.15],...
        'Style','edit',...
        'Tag','ed_outputname');
uicontrol('Parent',mainwin, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'Callback',@select_output_file, ...
        'HorizontalAlignment','center',...
        'Position',[0.76 0.3 0.19 0.15], ...
        'String','Browse...', ...
        'Style','pushbutton');
uicontrol('Parent',mainwin, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'Callback',@read_MRM_mz, ...
        'HorizontalAlignment','center',...
        'Position',[0.2 0.07 0.6 0.15], ...
        'String','Get m/z values', ...
        'Style','pushbutton');
function open_MRM_mz(~,~)
    % let the user select a mzml or a txt file
    [filename,path] = uigetfile({'*.mzml;*.txt';'*.mzml';'*.txt'},...
        'Select a MRM file',pwd,'MultiSelect','off');
    if isnumeric(filename)
        return
    else
        set(findobj('Tag','ed_filename'),'String',[path,filename]);
    end
end
function select_output_file(~,~)
    fullMRMname=get(findobj('Tag','ed_filename'),'String');
    [path,~,~] = fileparts(fullMRMname);
    % let the user select a mzml or a txt file
    [filename,path] = uiputfile('*.csv',...
        'Select a output file',path);
    if isnumeric(filename)
        return
    else
        set(findobj('Tag','ed_outputname'),'String',[path,filename]);
    end
end
function read_MRM_mz(~,~)
    % read MRM path and filename
    fullMRMname=get(findobj('Tag','ed_filename'),'String');
    if isempty(fullMRMname)
        errordlg('File Name Error','No MRM file is selected!','modal');
        return
    elseif ~isfile(fullMRMname)
        errordlg('File Name or Path Error','Incorrect MRM file name or path is given!','modal');
        return
    end
    fullOutputName=get(findobj('Tag','ed_outputname'),'String');
    if isempty(fullOutputName)
        errordlg('File Name Error','No output file is specified!','modal');
        return
    end
    [outpath,~,~] = fileparts(fullOutputName);
    if ~exist(outpath,'dir')
        errordlg('File Path Error','The output path does Not exist!','modal');
        return
    end
    [path,filename,ext] = fileparts(fullMRMname);
    if strcmpi(ext,'.txt')
        data=MRM_read_fast([path,'\',filename,ext]);
    elseif strcmpi(ext,'.mzml')
        data=mzML_read([path,'\',filename,ext]);
    else
        errordlg('File Format Error',{'The MRM format is incorrect!';' Only ".txt" or ".mzml" is allowed.'},'modal');
        return
    end
    nos=length(data.peakdata)-1;
    mz=zeros(nos,2);
    for j=1:nos
        mz(j,:)=data.mzdata{j+1};
    end   
    writematrix(mz,fullOutputName,'FileType','text','Delimiter',',');
    msgbox({'Operation Completed!';['Totally ',num2str(nos),' ion chromatograms were found.']},'Success','modal');
end