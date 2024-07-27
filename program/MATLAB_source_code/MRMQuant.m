clearvars
clc
fclose all;
%opengl('save', 'software');
warning('off','all');
if ~isfile('default_parameter.xlsx')
    para.dir=pwd; % default working directory
    para.abs_int=1;
    para.abs_stc=0;
    para.rel_quant=0;
    para.quantifier_sel=0;
    para.bg_auto=1;
    para.bg_int=500; % signal lower than bg_int will be regarded as background noise
    para.sn_ratio=2.0; % signal larger than 3 times of background noise will be considered for peak detection
    para.min_peak_width=0.02; % min. peak width
    para.min_peak_dist=0.04; % min. distance between peaks 
    para.smooth_win=7;
    para.smooth_auto=1;
    para.show_colorbar=1;
    para.colormap='jet';
    para.take_log=1;
    para.show_grid=0;
    para.show_ambiguous_comp=1;
    para.file_num=10;
    para.comp_num=50;
    para.xlabel=0;
    para.ylabel=1;
    para.auto_deconv=1;
    para.always_deconv=0;
    para.no_deconv=0;
    para.normal=1;
    para.norm_reg_method='stepwise';
    para.heatmap_abund=0; % 0 for concentration, 1 for abundance
    para.max_int=1.3e8;
    para.lowess_span=0.1;
else
    T = readtable('default_parameter.xlsx','FileType','spreadsheet');
    para=table2struct(T);
    if strcmpi(para.dir,'pwd')
        para.dir=pwd; % default working directory;
    end
end
MRMQuant_func(para);

% UserData storages
% rec: 'Tag','MRM_Quant'
% method: 'Tag','pl_comp'
% para: 'Tag','pl_para'
% std method(exp): 'Tag','rb_abs_stc'
% std method extended with file name and conc: 'Tag','pl_std_con'
% std quant result: 'Tag','pl_file'
% test sample list: 'Tag','list_file'
% mtx: 'Tag','AX_heat_map'
% alpha: 'Tag','im_heatmap'
% quant progress: 'Tag','PB_quant'
% [fileid compoundid]:'Tag','fg_EIC'
% [file,path]: 'Tag','PB_new'
% [method.nocomp para.comp_num]: 'Tag','SL_plot_h'
% [minx maxx miny 1.05*maxy]：'Tag','cb_show_detail'
% 'Tag','txt_overlap'
% 'Tag','PB_show_more'
% YData: ax_overlap 
% current dir info: 'Tag','txt_dirinfo'
% current dir: 'Tag','edit_dir'
% colormap list: 'Tag','pp_color_map'
% whether the data has been saved: 'Tag','PB_save_result'
% whether the compound info can be changed: 'Tag','PB_sel_peak'
% whether the compound info can be changed:'Tag','PB_sel_region'
% standard componud info(exp): 'Tag','rb_abs_stc'
% whether to perform batch normalization: 'Tag','cb_normal'
