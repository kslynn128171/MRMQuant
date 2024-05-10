clearvars
clc
fclose all;
close all;
top20_STD_Comp=cell(1,4);
boxfig = figure('Units','normalized', ...
        'Name','Boxplot', ...
        'NumberTitle','off', ...
        'Position',[0.2 0.1 0.6 0.8]);
tiledlayout(boxfig,7,1,'TileSpacing','tight','Padding','tight');
% ---------------------------------------
% Read Compound names
% ---------------------------------------
% load compounds used in the 163 compounds version
method_tbl=readtable('method_163_compound.csv','ReadRowNames',true);
compname_all=method_tbl.CompNams;
dmz=method_tbl.Daughter_m_z;
srt=method_tbl.RT;
% -------------------------------------------------------------------------
% MRMQuant quantitation using auto deconvolution with reference correction
% -------------------------------------------------------------------------
% Specify the file path
MRMQuant_file = 'result20240328_alwaysdecon_163comp_width04_ref.xlsx';
data_table = readtable(MRMQuant_file,'FileType','spreadsheet','Sheet', 1,...
    'VariableNamingRule','preserve','ReadRowNames',true);
compnames=data_table.Properties.VariableNames;
difname=setdiff(compname_all,compnames);
numdata=table2array(data_table);
data_rmavg=numdata./repmat(mean(numdata),8,1);
boxaxes=nexttile;
boxplot(boxaxes,data_rmavg);
title(boxaxes,'MRMQuant using auto deconvolution with reference correction')
stdcomp=std(data_rmavg);
[~,sid]=sort(stdcomp,'descend');
top20_STD_Comp{1}=compnames(sid(1:20))';
disp('------------------------------------------------------------')
disp('MRMQuant using auto deconvolution with reference correction');
disp('------------------------------------------------------------')
disp(['Number of unquantitated compounds:',num2str(length(difname))]);
disp(['averaged STD : ',num2str(mean(stdcomp))]); 
% ------------------------------------------------
% MRMQuant quantitation using auto deconvolution 
% ------------------------------------------------
MRMQuant_file = 'result20240328_alwaysdecon_163comp_width04.xlsx';
data_table = readtable(MRMQuant_file,'FileType','spreadsheet','Sheet', 1,...
    'VariableNamingRule','preserve','ReadRowNames',true);
compnames=data_table.Properties.VariableNames;
difname=setdiff(compname_all,compnames);
numdata=table2array(data_table);
data_rmavg=numdata./repmat(mean(numdata),8,1);
boxaxes=nexttile;
boxplot(boxaxes,data_rmavg);
title(boxaxes,'MRMQuant using auto deconvolution')
stdcomp=std(data_rmavg);
disp('----------------------------------')
disp('MRMQuant using auto deconvolution');
disp('----------------------------------')
disp(['Number of unquantitated compounds:',num2str(length(difname))]);
disp(['averaged STD : ',num2str(mean(stdcomp))]); 
% --------------------------------------------
% MRMQuant quantitation without deconvolution
% --------------------------------------------
% Specify the file path
MRMQuant_file = 'result20240227_nodecon_163comp_width04.xlsx';
data_table = readtable(MRMQuant_file,'FileType','spreadsheet','Sheet', 1,...
    'VariableNamingRule','preserve','ReadRowNames',true);
compnames=data_table.Properties.VariableNames;
difname=setdiff(compname_all,compnames);
numdata=table2array(data_table);
data_rmavg=numdata./repmat(mean(numdata),8,1);
boxaxes=nexttile;
boxplot(boxaxes,data_rmavg);
title(boxaxes,'MRMQuant quantitation without deconvolution')
stdcomp=std(data_rmavg);
disp('------------------------------')
disp('MRMQuant without deconvolution');
disp('------------------------------')
disp(['Number of unquantitated compounds:',num2str(length(difname))]);
disp(['averaged STD : ',num2str(mean(stdcomp))]);
% ---------------------------------------
% MRMKit quantitation
% ---------------------------------------
opts = detectImportOptions('MRMkit_quant_raw.tsv','FileType','delimitedtext',...
    'Delimiter','\t','ReadRowNames',true,'VariableNamingRule','preserve');
opts.DataLines = 5;
opts.VariableNamesLine = 1;
tbl=readtable('MRMkit_quant_raw.tsv',opts);
compname=tbl.Properties.VariableNames';
difname=setdiff(compname_all,compname);
abund_tmp=table2array(tbl);
abund_mtx=abund_tmp(1:8,:);
data_rmavg=abund_mtx./repmat(mean(abund_mtx,"omitnan"),8,1);
boxaxes=nexttile;
boxplot(boxaxes,data_rmavg);
title(boxaxes,'MRMKit')
stdcomp=std(data_rmavg);
[~,sid]=sort(stdcomp,'descend');
top20_STD_Comp{2}=compname(sid(1:20));
stdcomp=std(data_rmavg);
disp('-----------------------------------')
disp('MRMKit');
disp('-----------------------------------')
disp(['Number of unquantitated compounds:',num2str(length(difname))]);
disp(['averaged STD : ',num2str(mean(stdcomp,"omitnan"))]); 
% ---------------------------------------
% Skyline quantitation
% ---------------------------------------
quant_tbl=readtable('Skyline_Molecule Transition Results.csv','ReadRowNames',true);
abund_all=quant_tbl.Area;
compnamelist=quant_tbl.MoleculeListName;
compname=compnamelist(1:12:end);
difname=setdiff(compname_all,compname);
filelist=quant_tbl.ReplicateName;
filename=filelist(1:8);
abund_tmp=reshape(abund_all,12,length(abund_all)/12);
abund_mtx=abund_tmp(1:8,:);
data_rmavg=abund_mtx./repmat(mean(abund_mtx,"omitnan"),8,1);
boxaxes=nexttile;
boxplot(boxaxes,data_rmavg);
title(boxaxes,'Skyline')
stdcomp=std(data_rmavg);
[~,sid]=sort(stdcomp,'descend');
top20_STD_Comp{3}=compname(sid(1:20));
stdcomp=std(data_rmavg);
disp('-----------------------------------')
disp('Skyline');
disp('-----------------------------------')
disp(['Number of unquantitated compounds:',num2str(length(difname))]);
disp('Not quantitated compounds:');
disp(difname);
disp(['averaged STD : ',num2str(mean(stdcomp,"omitnan"))]); 
% ---------------------------------------
% TargetLynx quantitation
% ---------------------------------------
opts = detectImportOptions('20200426_plate2_QC3 A1~A8 by targetlynx.xlsx','FileType','spreadsheet',...
    'Sheet','Conc','DataRange','B4:FV11','VariableNamesRange','B3:FV3','VariableNamingRule','preserve');
tbl=readtable('20200426_plate2_QC3 A1~A8 by targetlynx.xlsx',opts);
compname_org=tbl.Properties.VariableNames';
compname_tmp=cellfun(@(x) x(5:length(x)),compname_org,'UniformOutput',false);
compname=cellfun(@(x) strtrim(x),compname_tmp,'UniformOutput',false);
difname=setdiff(compname_all,compname);
[tf,loc]=ismember(compname_all,compname);
abund_tmp=table2array(tbl);
abund_mtx=nan(size(abund_tmp,1),length(compname_all));
abund_mtx(:,tf)=abund_tmp(:,loc~=0);
data_rmavg=abund_mtx./repmat(mean(abund_mtx,"omitnan"),8,1);
boxaxes=nexttile;
boxplot(boxaxes,data_rmavg);
title(boxaxes,'TargetLynx')
stdcomp=std(data_rmavg);
[~,sid]=sort(stdcomp,'descend');
top20_STD_Comp{4}=compname(sid(1:20));
stdcomp=std(data_rmavg);
disp('-----------------------------------')
disp('TargetLynx');
disp('-----------------------------------')
disp(['Number of unquantitated compounds:',num2str(length(difname))]);
disp('Not quantitated compounds:');
disp(difname);
disp(['average: ',num2str(mean(stdcomp,"omitnan"))]); 
% ---------------------------------------
% OpenMS quantitation
% ---------------------------------------
path2='OpenMS_output\';
compnum=length(compname_all);
abund=nan(compnum,8);
for i=1:8
    data=readtable([path2,'20200426_plate2_QC3_A',num2str(i),'.unknown'],...
        'FileType','text','VariableNamingRule','preserve','ReadRowNames',true,...
        'Delimiter','\t','NumHeaderLines',3,'VariableDescriptionsLine',5);
    trt=data.rt/60;
    tmz=data.mz;
    mag=data.intensity;
    matchid=zeros(compnum,1);
    for j=1:compnum
        diff=abs(tmz-dmz(j))+abs(trt-srt(j));
        [~,sortid]=sort(diff,'ascend');
        count=1;
        if j>1
            while (matchid(j)==0) && (count <= length(sortid))
                tid=find(matchid(1:j-1)==sortid(count));
                if isempty(tid) && diff(sortid(count)) < 1
                    matchid(j)=sortid(count);
                else
                    count=count+1;
                end
            end
        else
            matchid(1)=sortid(1);
        end
    end
    abund(matchid>0,i)=mag(matchid(matchid>0));
end
data_rmavg=(abund./mean(abund,2,'omitnan'))';
boxaxes=nexttile;
boxplot(boxaxes,data_rmavg);
title(boxaxes,'OpenMS')
stdcomp=std(data_rmavg);
disp('-----------------------------------')
disp('OpenMS');
disp('-----------------------------------')
disp(['Number of unquantitated compounds: ',num2str(compnum-sum(~isnan(stdcomp)))]);
[sortstd,sid]=sort(stdcomp,'descend');
disp(['average: ',num2str(mean(stdcomp,2,'omitnan'))]); 