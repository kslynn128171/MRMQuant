% Skyline test results
clearvars
clc
close all
method_tbl=readtable('method_163_compound.csv','ReadRowNames',true);
compname_all=method_tbl.Properties.RowNames;
opts = detectImportOptions('20200426_plate2_QC3 A1~A8 by targetlynx.xlsx','FileType','spreadsheet',...
    'Sheet','Conc','DataRange','B4:FV11','VariableNamesRange','B3:FV3','VariableNamingRule','preserve');
tbl=readtable('20200426_plate2_QC3 A1~A8 by targetlynx.xlsx',opts);
compname_org=tbl.Properties.VariableNames';
compname_tmp=cellfun(@(x) x(5:length(x)),compname_org,'UniformOutput',false);
compname=cellfun(@(x) strtrim(x),compname_tmp,'UniformOutput',false);
[tf,loc]=ismember(compname_all,compname);
disp('Not quantitated compounds:');
disp(compname_all(tf==0));
abund_tmp=table2array(tbl);
abund_mtx=nan(size(abund_tmp,1),length(compname_all));
abund_mtx(:,tf)=abund_tmp(:,loc~=0);
data_rmavg=abund_mtx./repmat(mean(abund_mtx,"omitnan"),8,1);
missnum=sum(sum(isnan(abund_mtx)));
disp(['Number of unquantitated compounds:',num2str(missnum)]);%(11 for 164comp, 34 for 184comp)
stdcomp=std(data_rmavg);
[sortstd,sid]=sort(stdcomp,'descend');
compname(sid(1:20))
boxfig = figure('Units','normalized', ...
        'Name','Boxplot', ...
        'NumberTitle','off', ...
        'Position',[0.1 0.4 0.8 0.25]);
boxaxes=axes('Parent',boxfig,'Units','normalized','Position',[0.05 0.12 0.93 0.85]);
boxplot(boxaxes,data_rmavg);
stdcomp=std(data_rmavg);
disp(['average: ',num2str(mean(stdcomp,"omitnan"))]); % average: 0.062667
disp(['STD: ',num2str(std(stdcomp,"omitnan"))]); % 0.042998
