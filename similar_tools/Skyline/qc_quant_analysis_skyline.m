% Skyline test results
clearvars
clc
close all
method_tbl=readtable('method.csv','ReadRowNames',true);
%method_tbl=readtable('method_184comp.csv','ReadRowNames',true);
compname_all=method_tbl.MoleculeListName;
quant_tbl=readtable('Molecule Transition Results.csv','ReadRowNames',true);
%quant_tbl=readtable('Molecule Transition Results_184comps.csv','ReadRowNames',true);
abund_all=quant_tbl.Area;
compnamelist=quant_tbl.MoleculeListName;
compname=compnamelist(1:12:end);%unique(compnamelist);
difname=setdiff(compname_all,compname);
disp('Not quantitated compounds:');
disp(difname);
filelist=quant_tbl.ReplicateName;
filename=filelist(1:8);
abund_tmp=reshape(abund_all,12,length(abund_all)/12);
abund_mtx=abund_tmp(1:8,:);
data_rmavg=abund_mtx./repmat(mean(abund_mtx,"omitnan"),8,1);
missnum=sum(sum(isnan(abund_mtx)));
disp(['Number of unquantitated compounds:',num2str(missnum)]);%(11 for 164comp, 34 for 184comp)
for i=1:size(data_rmavg,1)
    for j=1:size(data_rmavg,2)
        if isnan(abund_mtx(i,j))
            disp([filename{i},' ',compname{j}])
        end
    end
end
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
disp(['average: ',num2str(mean(stdcomp,"omitnan"))]); % average: 0.090216
disp(['STD: ',num2str(std(stdcomp,"omitnan"))]); % STD: 0.050966
