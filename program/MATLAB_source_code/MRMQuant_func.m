function MRMQuant_func(para)
    % close previous session
    global bgcolor %#ok<*GVMIS> 
    mainwin=findobj('Tag','MRM_Quant');
    if ~isempty(mainwin), close(mainwin); end
    nof=0;%length(filelist); % number of files in the folder
    bgcolor=[0.752941176470588 0.752941176470588 0.752941176470588]; % background color
    %------------------------
    % Display main GUI 
    %------------------------
    mainwin = figure('Units','normalized', ...
        'Color',bgcolor, ...
        'CloseRequestFcn',@close_check,...
        'Menubar','none',...
        'Name','MRMQuant', ...
        'NumberTitle','off', ...
        'PaperPosition',[18 180 576 432], ...
        'PaperUnits','points', ...
        'Position',[0.03 0.07 0.93 0.84], ...
        'Tag','MRM_Quant',...
        'UserData',[]);
    %------------------------
    % left panel
    %------------------------
    l_panel=uipanel('Parent',mainwin, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.0 0.03 0.15 0.97],...
        'BorderType','line',...
        'HighlightColor',[0,0,0],...
        'Tag','pl_data');
    % title of the left frame
    txt_dirinfo=uicontrol('Parent',l_panel, ...
        'Units','normalized', ...
        'Fontsize',16, ...
        'BackgroundColor',bgcolor, ...
        'FontWeight','Bold', ...
        'HorizontalAlignment','center',...
        'Position',[0.0 0.96 1.0 0.037],...
        'String','Experiment Data', ...
        'Style','text',...
        'Tag','txt_dirinfo',...
        'UserData',{});
    % button group for data type
    bg_exp = uibuttongroup('Parent',l_panel, ...
        'BackgroundColor',bgcolor, ...
        'BorderType','line',...
        'Fontsize',12,...
        'Position',[0.02 0.805 0.96 0.16],...
        'SelectionChangedFcn',@experiment_type_change,...
        'Title','Data Type',...
        'Visible','on');
    % radiobutton for experiment type of absolute quantitation with internal
    % standard
    uicontrol('Parent',bg_exp, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.77 0.9 0.2],...
        'String','Abs. quant. w/ int. std.',...
        'Style','radiobutton',...
        'Tag','rb_abs_int',...
        'Tooltip','<html>Absolute quantitation<br />using internal standards</html>',...
        'Value',para.abs_int);
    % radiobutton for experiment type of absolute quantitation with standard
    % curves
    rb_abs_stc=uicontrol('Parent',bg_exp, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.53 0.9 0.2],...
        'String','Abs. quant. w/ std. curve',...
        'Style','radiobutton',...
        'Tag','rb_abs_stc',...
        'Tooltip','<html>Absolute quantitation<br />using standard curves</html>',...
        'Value',para.abs_stc);
    % radiobutton for experiment type of relative quantitation 
    uicontrol('Parent',bg_exp, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.29 0.9 0.2],...
        'String','Relative quantitation', ...
        'Style','radiobutton',...
        'Tag','rb_rel_quant',...
        'Tooltip','<html>Relative quantitation via <br />computed peak abundance</html>',...
        'Value',para.rel_quant);
    % radiobutton for experiment type of compound selection 
    uicontrol('Parent',bg_exp, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.05 0.9 0.2],...
        'String','Quantifier Ion Selection', ...
        'Style','radiobutton',...
        'Tag','rb_quantifier_sel',...
        'Tooltip','<html>Quantifier ion selection via <br />abundance ratios of fragments</html>',...
        'Value',para.quantifier_sel);
    pl_file=uipanel('Parent',l_panel, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor, ...
        'BorderType','line',...
        'Fontsize',12,...
        'Position',[0.02 0.01 0.96 0.79], ...
        'Title','Data Files',...
        'Tag','pl_file');
    % description of the used files
    uicontrol('Parent',pl_file, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor, ...
        'Fontsize',12,...
        'HorizontalAlignment','center',...
        'Position',[0.01 0.95 0.43 0.03], ...
        'String','Load files in', ...
        'Style','text');     
    % radiobutton for using all files in the folder
    uicontrol('Parent',pl_file, ...
        'Units','normalized', ...
        'Fontsize',12,...
        'BackgroundColor',bgcolor, ...
        'Callback',@change_file_order,...
        'HorizontalAlignment','center',...
        'Position',[0.44 0.97 0.37 0.03],...
        'String','acquiring',...
        'Style','radiobutton',...
        'Tag','rb_acquiring_order',...
        'Tooltip','Load files in the order when the sample was analyzed.',...
        'Value',1);
    % radiobutton for using only some files in the folder
    uicontrol('Parent',pl_file, ...
        'Units','normalized', ...
        'Fontsize',12,...
        'BackgroundColor',bgcolor, ...
        'Callback',@change_file_order,...
        'HorizontalAlignment','center',...
        'Position',[0.44 0.935 0.37 0.03],...
        'String','filename',...
        'Style','radiobutton',...
        'Tag','rb_filename_order',...
        'Tooltip','Load files in the filename order.',...
        'Value',0);
    uicontrol('Parent',pl_file, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor, ...
        'Fontsize',12,...
        'HorizontalAlignment','center',...
        'Position',[0.81 0.95 0.19 0.03], ...
        'String','order.', ...
        'Style','text'); 
    % description of the used files
    uicontrol('Parent',pl_file, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor, ...
        'Fontsize',12,...
        'HorizontalAlignment','center',...
        'Position',[0.02 0.89 0.15 0.03], ...
        'String','Use ', ...
        'Style','text');     
    % radiobutton for using all files in the folder
    uicontrol('Parent',pl_file, ...
        'Units','normalized', ...
        'Fontsize',12,...
        'BackgroundColor',bgcolor, ...
        'Callback',@change_proportion,...
        'HorizontalAlignment','center',...
        'Position',[0.18 0.91 0.25 0.03],...
        'String','all',...
        'Style','radiobutton',...
        'Tag','rb_all',...
        'Tooltip','Use all files in the folder.',...
        'Value',1);
    % radiobutton for using only some files in the folder
    uicontrol('Parent',pl_file, ...
        'Units','normalized', ...
        'Fontsize',12,...
        'BackgroundColor',bgcolor, ...
        'Callback',@change_proportion,...
        'HorizontalAlignment','center',...
        'Position',[0.18 0.875 0.25 0.03],...
        'String','some',...
        'Style','radiobutton',...
        'Tag','rb_some',...
        'Tooltip','Only use some of files in the folder.',...
        'Value',0);
    uicontrol('Parent',pl_file, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor, ...
        'Fontsize',12,...
        'HorizontalAlignment','center',...
        'Position',[0.44 0.89 0.55 0.03], ...
        'String','files in the folder.', ...
        'Style','text'); 
    % entry for file path 
    uicontrol('Parent',pl_file, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'FontUnits','normalized', ...
        'ListboxTop',0, ...
        'Position',[0.02 0.815 0.66 0.04], ...
        'String',para.dir,...
        'Style','edit', ...
        'Tag','edit_dir',...
        'UserData',pwd);
    % button to change the file path
    uicontrol('Parent',pl_file, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@browse_test_folder,mainwin,txt_dirinfo}, ...
        'Position',[0.7 0.81 0.28 0.05], ...
        'String','Browse...',...
        'Tooltip','Browse MRM files for quantitation');
    % description of the file list
    uicontrol('Parent',pl_file, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor, ...
        'Fontsize',12,...
        'HorizontalAlignment','left',...
        'Position',[0.02 0.77 0.96 0.03], ...
        'String',['File list: ',num2str(nof),' files found.'], ...
        'Style','text',...
        'Tag','label1');
    % listbox for displaying sample files
    uicontrol('Parent',pl_file, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.8 0.8 0.8], ...
        'Min',0,...
        'Max',10,...
        'Position',[0.02 0.005 0.96 0.76], ...
        'String','', ...
        'Style','listbox', ...
        'Tag','list_file',...
        'CallBack',{@change_plot,'TIC'},...
        'UserData','');
    %------------------------
    % top-left frame (Compound Information)
    %------------------------
    pl_comp=uipanel('Parent',mainwin, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','line',... 
        'HighLightColor','k',...
        'Position',[0.15 0.8 0.3 0.2],...
        'Tag','pl_comp',...
        'UserData',{});
    % title of the top-left frame
    uicontrol('Parent',pl_comp, ...
        'Units','normalized', ...
        'Fontsize',16, ...
        'BackgroundColor',bgcolor, ...
        'FontWeight','Bold', ...
        'HorizontalAlignment','center',...
        'Position',[0 0.8 1 0.2],...
        'String','Compound Information', ...
        'Style','text',...
        'Tag','txt_comp');
    % text to show number of detected compounds
    uicontrol('Parent',pl_comp, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'HorizontalAlignment','center',...
        'Position',[0.75 0.67 0.25 0.13],...
        'String', '0 Compounds', ...
        'Style','text',...
        'Tag','compound_loc');
    % table of the detected compounds
    cnames={['Comp.' char(160) 'Name'],'RT',['RT' char(160) 'Tol.'],['Prec.' char(160) 'mz'],['Prod.' char(160) 'mz']};
    uitable('Parent',pl_comp,...
        'Units','normalized',...
        'Position',[0.02 0.05 0.73 0.75],...
        'ColumnName',cnames,...
        'FontSize',12,...
        'Tag','tbl_comp_list');
    % button to change the expected compound list
    uicontrol('Parent',pl_comp, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@change_method,'sample',pl_comp,txt_dirinfo},...
        'Position',[0.78 0.46 0.2 0.17], ...
        'String','Load', ...
        'Tag','PB_new',...
        'Tooltip','Browse the method file for quantitation');
    % button to modify the compound list
    uicontrol('Parent',pl_comp, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',@modify_compound_parameters, ...
        'Position',[0.78 0.25 0.2 0.17], ...
        'String','Modify', ...
        'Tag','PB_modify',...
        'Tooltip','Modify the method file for quantitation');
    % button to expand the diaplay window of compound list
    uicontrol('Parent',pl_comp, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',@expand_compound_information, ...
        'Position',[0.78 0.04 0.2 0.17], ...
        'String','Expand');
    %------------------------
    % the top-middle frame (parameters)
    %------------------------
    pl_para=uipanel('Parent',mainwin, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','line',... 
        'HighLightColor','k',...
        'Position',[0.45 0.8 0.45 0.2],...
        'Tag','pl_para');
    % title of the top-middle frame
    uicontrol('Parent',pl_para, ...
        'Units','normalized', ...
        'Fontsize',16, ...
        'BackgroundColor',bgcolor, ...
        'FontWeight','Bold', ...
        'HorizontalAlignment','center',...
        'Position',[0 0.8 1 0.2],...
        'String','Quantitation Parameters', ...
        'Style','text',...
        'Tag','txt_para');
    % -----------------------------------
    % panel for peak finding parameters
    % -----------------------------------
    pl_peakdet=uipanel('Parent',pl_para, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','line',... 
        'Fontsize',12, ...
        'Position',[0.01 0.05 0.5 0.8],...
        'Tag','pl_peakdet',...
        'Title','Peak Finding');
    % description of the first parameter (background intensity)
    uicontrol('Parent',pl_peakdet, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'HorizontalAlignment','left',...
        'Position',[0.02 0.8 0.42 0.2],...
        'String','Background Intensity', ...
        'Style','text');
    % entry for the background intensity
    ed_bg_int=uicontrol('Parent',pl_peakdet, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'Enable','off',...
        'FontUnits','normalized', ...
        'Position',[0.44 0.8 0.26 0.2], ...
        'String',para.bg_int,...
        'Style','edit', ...
        'Tag','ed_bg_int',...
        'ToolTip','Signals lower than this number are regarded as background noise.');
    % checkbox for altering background intensity detection method
    uicontrol('Parent',pl_peakdet, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Callback',{@change_background_detect,ed_bg_int},...
        'Position',[0.77 0.82 0.21 0.18],...
        'String','Auto', ...
        'Style','checkbox',...
        'Tag','cb_auto_bg',...
        'Tooltip','Automatically determine the background intensity of a EIC',...
        'Value',para.bg_auto);
    % description of the second parameter (smoothing window size)
    uicontrol('Parent',pl_peakdet, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'HorizontalAlignment','left',...
        'Position',[0.02 0.53 0.48 0.2],...
        'String','Smoothing Window Size', ...
        'Style','text');
    % entry for the smoothing window size
    ed_smooth_win=uicontrol('Parent',pl_peakdet, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'FontUnits','normalized', ...
        'Position',[0.5 0.55 0.2 0.2],...
        'String',para.smooth_win,...
        'Style','edit', ...
        'Tag','ed_smooth_win',...
        'ToolTip','Window size for smoothing the signal'); 
    % checkbox for altering background intensity detection method
    uicontrol('Parent',pl_peakdet, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Callback',{@change_smoothing_window_size,ed_smooth_win},...
        'Position',[0.77 0.55 0.21 0.2],...
        'String','Auto', ...
        'Style','checkbox',...
        'Tag','cb_auto_smooth',...
        'Tooltip','Automatically determine the window size for smoothing',...
        'Value',para.smooth_auto);
    % description of the third parameter (Signal To Noise (S/N) Ratio)
    uicontrol('Parent',pl_peakdet, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'HorizontalAlignment','left',...
        'Position',[0.02 0.28 0.55 0.2],...
        'String','Signal To Noise (S/N) Ratio', ...
        'Style','text');
    % entry for the Signal To Noise (S/N) Ratio
    uicontrol('Parent',pl_peakdet, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'FontUnits','normalized', ...
        'Position',[0.57 0.3 0.2 0.2],...
        'String',para.sn_ratio,...
        'Style','edit', ...
        'Tag','ed_sn_ratio',...
        'ToolTip','Signals higher than this ratio are regarded as possible peaks');
    % description of the 4th parameter (min peak width)
    uicontrol('Parent',pl_peakdet, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'HorizontalAlignment','left',...
        'Position',[0.02 0.03 0.33 0.2],...
        'String','Min. Peak Width', ...
        'Style','text');
    % entry for the minimum peak width
    uicontrol('Parent',pl_peakdet, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'Callback',{@change_min_peak_width,pl_para},...
        'FontUnits','normalized', ...
        'Position',[0.35 0.05 0.15 0.2],...
        'String',para.min_peak_width,...
        'Style','edit', ...
        'Tag','ed_min_peak_width',...
        'ToolTip','Mininum peak width at half height');
    % description of the 5th parameter (min peak width)
    uicontrol('Parent',pl_peakdet, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'HorizontalAlignment','left',...
        'Position',[0.52 0.03 0.32 0.2],...
        'String',' Min. Peak Dist.', ...
        'Style','text');
    % entry for the min. peak distance
    uicontrol('Parent',pl_peakdet, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'Callback',{@change_min_peak_dist,pl_para},...
        'FontUnits','normalized', ...
        'Position',[0.84 0.05 0.15 0.2],...
        'String',para.min_peak_dist,...
        'Style','edit', ...
        'Tag','ed_min_peak_dist',...
        'ToolTip','Mininum distance between peaks');
    % button group for deconvolution options
    bg_conv = uibuttongroup('Parent',pl_para, ...
        'BackgroundColor',bgcolor, ...
        'BorderType','line',...
        'Fontsize',12,...
        'Position',[0.52 0.2 0.27 0.65],...
        'SelectionChangedFcn',{@deconvolution_strategy_change,pl_para},...
        'Title','Deconvolution',...
        'Tag','bg_conv');
    % radiobutton for auto deconvolution (default)
    uicontrol('Parent',bg_conv, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.67 0.9 0.33],...
        'String','Auto. deconvolution',...
        'Style','radiobutton',...
        'Tag','rb_auto_deconv',...
        'Tooltip','<html>Automatically determine whether to perform<br /> deconvolution on coeluted peaks.</html>',...
        'Value',para.auto_deconv);
    % radiobutton for always deconvolution
    uicontrol('Parent',bg_conv, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.34 0.9 0.33],...
        'String','Always deconvolution',...
        'Style','radiobutton',...
        'Tag','rb_always_deconv',...
        'Tooltip','<html>Perform deconvolution<br />on all peaks</html>',...
        'Value',para.always_deconv);
    % radiobutton for no deconvolution
    uicontrol('Parent',bg_conv, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.01 0.9 0.33],...
        'String','No deconvolution', ...
        'Style','radiobutton',...
        'Tag','rb_no_deconv',...
        'Tooltip','<html>Never deconvolution<br />on the peaks</html>',...
        'Value',para.no_deconv);
    % check button for batch effect correction
    uicontrol('Parent',pl_para, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Callback',{@change_normalization,pl_para},...
        'Position',[0.53 0.02 0.45 0.17],...
        'String','Batch Effect Correction', ...
        'Style','checkbox',...
        'Tag','cb_normal',...
        'Tooltip','<html>Perform batch effect correction<br />across samples using QC</html>',...
        'Value',para.normal, ...
        'UserData',1);
    % -----------------------------------
    % panel for parameter buttons
    % -----------------------------------
    pl_parabut=uipanel('Parent',pl_para, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','none',... 
        'Position',[0.8 0.0 0.2 0.8],...
        'Tag','pl_parabut');
    uicontrol('Parent',pl_parabut, ...
        'Units','normalized', ...
        'Enable','off',...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@show_quantitation_message,'',pl_para}, ...
        'HorizontalAlignment','center',...
        'Position',[0.01 0.76 0.98 0.24], ...
        'String','< Show Message', ...
        'Style','pushbutton',...
        'UserData',0,...
        'Tag','PB_show_msg',...
        'Tooltip','Show/Hide message window');
    uicontrol('Parent',pl_parabut, ...
        'Units','normalized', ...
        'Enable','off',...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@load_parameter,txt_dirinfo}, ...
        'HorizontalAlignment','center',...
        'Position',[0.01 0.51 0.98 0.24], ...
        'String','Load', ...
        'Style','pushbutton',...
        'Tooltip','Load an existing parameter file');
    uicontrol('Parent',pl_parabut, ...
        'Units','normalized', ...
        'Enable','off',...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@save_parameter,1,txt_dirinfo,pl_para}, ...
        'HorizontalAlignment','center',...
        'Position',[0.01 0.26 0.98 0.24], ...
        'String','Save', ...
        'Style','pushbutton',...
        'Tooltip','Save the current parameters to a file');
    uicontrol('Parent',pl_parabut, ...
        'Units','normalized', ...
        'Enable','off',...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@save_parameter, 0,txt_dirinfo,pl_para}, ...
        'HorizontalAlignment','center',...
        'Position',[0.01 0.01 0.98 0.24], ...
        'String','Save As Default', ...
        'Style','pushbutton',...
        'Tooltip','Save the current parameters as default');
    pl_para.UserData=para;
    set(findall(pl_para, '-property', 'enable'), 'enable', 'off')
    %---------------------------------------------
    % the top-right frame (quantitation message)
    %---------------------------------------------
    pl_qmsg=uipanel('Parent',mainwin, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','line',... 
        'HighLightColor','k',...
        'Position',[0.9 0.8 0.0 0.2],...
        'Tag','pl_qmsg');
    % title of the top-right frame
    uicontrol('Parent',pl_qmsg, ...
        'Units','normalized', ...
        'Fontsize',16, ...
        'BackgroundColor',bgcolor, ...
        'FontWeight','Bold', ...
        'HorizontalAlignment','center',...
        'Position',[0 0.8 1 0.2],...
        'String','Quantitation Message', ...
        'Style','text');
    uicontrol('Parent',pl_qmsg, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'Fontsize',12, ...
        'Position',[0.02 0.05 0.96 0.75], ...
        'String','', ...
        'Style','listbox', ...
        'Tag','quant_msg');
    %------------------------------------------------
    % buttons EIC quantitation
    %------------------------------------------------
    pl_button=uipanel('Parent',mainwin, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','line',... 
        'HighLightColor','k',...
        'Position',[0.9 0.8 0.1 0.2]);
    uicontrol('Parent',pl_button, ...
        'Units','normalized', ...
        'Fontsize',14, ...
        'FontWeight','Bold', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@load_quantitation_result,mainwin,pl_comp,rb_abs_stc,pl_para}, ...
        'HorizontalAlignment','center',...
        'Position',[0.02 0.73 0.96 0.25], ...
        'String','Load Result', ...
        'Style','pushbutton',...
        'Tooltip','Load an existing result to the system');
    uicontrol('Parent',pl_button, ...
        'Units','normalized', ...
        'Enable','off',...
        'Fontsize',14, ...
        'FontWeight','Bold', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@save_quantitation_result,mainwin,pl_comp,rb_abs_stc,pl_para}, ...
        'HorizontalAlignment','center',...
        'Position',[0.02 0.46 0.96 0.25], ...
        'String','Save Result', ...
        'Style','pushbutton',...
        'UserData',true,...
        'Tag','PB_save_result',...
        'Tooltip','Save the current to a file');
    % Perform relative/absolute quantitation 
    uicontrol('Parent',pl_button, ...
        'Units','normalized', ...
        'Enable','off',...
        'Fontsize',14, ...
        'FontWeight','Bold', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@quantitation_type,mainwin,pl_para},... 
        'HorizontalAlignment','center',...
        'Position',[0.02 0.02 0.96 0.42], ...
        'String','<html><font color="green"><p style="text-align:center;">Start<br>Quantitation</p></html>', ...
        'Style','pushbutton',...
        'Tag','PB_quant',...
        'UserData','New',...
        'Value',0,...
        'Tooltip','Start/Stop the quantitation process');
    %------------------------
    % progress bar for displaying the computation process
    %------------------------
    pl_prog=uipanel('Parent',mainwin, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','line',... 
        'HighLightColor','k',...
        'Position',[0.0 0.0 1.0 0.03]);
    pg_axes=axes('Parent',pl_prog, ...
        'Color',bgcolor, ...
        'NextPlot','replacechildren', ...
        'Position',[0.0 0.0 1.0 1.0], ...
        'XColor',bgcolor, ...
        'XLim',[0 1],...
        'YColor',bgcolor,...
        'YLim',[0 1],...
        'Units','normalized');
    pg_axes.Toolbar.Visible = 'off';
    rectangle('Parent',pg_axes,...
        'Position',[0.0 0.0 0.0 1.0],...
        'FaceColor','b',...
        'tag','pg_bar');
    text('Parent',pg_axes,...
        'Position',[0.4,0.5],...
        'Color','r',...
        'FontSize',14,...
        'FontWeight','bold',...
        'String','',...
        'Units','normalized',...
        'tag','pg_text');
    %------------------------
    % figure to show the quantitation result
    %------------------------
    pl_plot=uipanel('Parent',mainwin, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','line',... 
        'HighLightColor','k',...
        'Position',[0.15 0.03 0.85 0.77],...
        'Tag','pl_plot');
    ax1 = axes('Parent',pl_plot, ... % axes to plot heat map
        'NextPlot','replacechildren', ...
        'Position',[0.07 0.13 0.87 0.82], ...
        'Tag','AX_heat_map', ...
        'TickLength',[0 0],...
        'Visible','off', ...
        'XColor',[0 0 0], ...
        'XAxisLocation','bottom',...
        'YColor',[0 0 0], ...
        'YAxisLocation','left',...
        'YDir','reverse',...
        'ZColor',[0 0 0]);
    ax1.XLabel.String = 'Compounds';
    ax1.XLabel.FontSize = 14;
    ax1.XLim=[0.5 para.comp_num+0.5];
    ax1.YLabel.String = 'Samples';
    ax1.YLabel.FontSize = 14;
    ax1.YLim=[0.5 para.file_num+0.5];
    ax1.Toolbar.Visible = 'on';
    ax1.PositionConstraint = "outerposition";
    colormap(ax1,'jet');
    colorbar(ax1,'off');
    ax2 = axes('Parent',pl_plot, ... % axes to plot TIC
        'NextPlot','replacechildren', ...
        'Position',[0.05 0.13 0.9 0.82], ...
        'Clipping','on',...
        'Tag','AX_TIC_plot', ...
        'Visible','on', ...
        'XColor',[0 0 0], ...
        'XGrid','on', ...
        'XAxisLocation','bottom',...
        'YColor',[0 0 0], ...
        'YGrid','on', ...
        'YAxisLocation','left',...
        'UserData',0);
    ax2.XLabel.String = 'Retention Time';
    ax2.XLabel.FontSize = 14;
    ax2.YLabel.String = 'Intensity';
    ax2.YLabel.FontSize = 14;
    ax2.Toolbar.Visible = 'on';
    set(zoom(ax2),'ActionPostCallback',@TIC_zoom_change);
    uicontrol('Parent',pl_plot, ...
        'Units','normalized', ...
        'Enable','off',...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@horizontal_slider_adjust,ax1,ax2,pl_para}, ...
        'Position',[0.05 0.01 0.9 0.04], ...
        'Style','slider',...
        'Tag','SL_plot_h');
    uicontrol('Parent',pl_plot, ...
        'Units','normalized', ...
        'Enable','off',...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@vertical_slider_adjust,ax1,ax2,pl_para}, ...
        'Position',[0.97 0.1 0.02 0.85], ...
        'Style','slider',...
        'Tag','SL_plot_v');
    % Export the current EIC plot 
    uicontrol('Parent',pl_plot, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',@export_plot, ...
        'Position',[0.05 0.95 0.07 0.04], ...
        'String','Export Plot', ...
        'Style','pushbutton',...
        'Tooltip','Export the current EIC plot to an image file');
    % Expand the current plot area
    uicontrol('Parent',pl_plot, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',@expand_plot_window, ...
        'Position',[0.14 0.95 0.05 0.04], ...
        'String','Expand', ...
        'Style','pushbutton',...
        'Tooltip','Expand the current EIC plot');
    % Switch between the TIC plot and the Heat map
    uicontrol('Parent',pl_plot, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',@change_plot, ...
        'Position',[0.21 0.95 0.09 0.04], ...
        'String','Show Heat Map', ...
        'Style','togglebutton',...
        'Tag','PB_TIC_Heat',...
        'Tooltip','Show heat map of the quantitation result');
    % Activate Inspection Mode
    uicontrol('Parent',pl_plot, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@inspection_mode,mainwin}, ...
        'Position',[0.32 0.95 0.13 0.04], ...
        'String','Activate Inspection Mode', ...
        'Style','togglebutton',...
        'Tag','PB_inspect_mode',...
        'Tooltip','<html>Click on a heat map cell to<br />reveal its corresponding EIC');
    % Show batch effect correction result
    uicontrol('Parent',pl_plot, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@show_batch_effect_correction_result,mainwin,pl_comp,pl_para,ax1}, ...
        'Position',[0.47 0.95 0.15 0.04], ...
        'String','Show Batch Effect Correction', ...
        'Style','pushbutton',...
        'Tag','PB_show_norm',...
        'Tooltip','Show batch effect correction result');
    % Heat map options
    uicontrol('Parent',pl_plot, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@show_heatmap_options,mainwin,pl_comp,pl_para,ax1}, ...
        'Position',[0.64 0.95 0.1 0.04], ...
        'String','Heat Map Options', ...
        'Style','pushbutton',...
        'Tag','PB_heatmap_option',...
        'Tooltip','Display options for the heatmap');
    % show quantifier ion ratio
    uicontrol('Parent',pl_plot, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@show_quantifier_ratio}, ...
        'Position',[0.76 0.95 0.12 0.04], ...
        'String','Show Quantifier Ratios', ...
        'Style','pushbutton',...
        'Tag','PB_quantifier_ratio',...
        'Tooltip','Display the table of quantifier ratios');
    set(findall(pl_comp, '-property', 'enable'), 'enable', 'off');
    set(findall(pl_para, '-property', 'enable'), 'enable', 'off');
    set(findall(pl_plot, '-property', 'enable'), 'enable', 'off');
    cla(ax1);
end
%------------------------------------------------------------------
% function that deals with actions when experiment type is changed
%------------------------------------------------------------------
function experiment_type_change(hobj,~)
    hdlpara=findobj('Tag','pl_para');
    list1=findobj('Tag','list_file');
    save_status=get(findobj('Tag','PB_save_result'),'UserData');
    if isempty(save_status)
        is_saved=true;
    else
        is_saved=save_status;
    end
    is_new_quant=isempty(list1.String);
    hdlrec=findobj('Tag','MRM_Quant');
    % save the result of the previous quantitation if its not yet been done.
    if ~is_saved && ~is_new_quant
        opts = struct('Default','Save and proceed','WindowStyle','modal','Interpreter','tex');
        answer = questdlg('\fontsize{12}The computed/modified result has not been saved. Save it before starting a new quantitation?',...
            'Data Loss Warning','Save and proceed','Proceed without saving','Cancel',opts); 
        if strcmpi(answer,'Save and proceed')
            hdlmeth=findobj('Tag','pl_comp');
            hdlastc=findobj('Tag','rb_abs_stc');
            save_quantitation_result('','',hdlrec,hdlmeth,hdlastc,hdlpara);
            clear_existing_results;
        elseif strcmpi(answer,'Proceed without saving')
            clear_existing_results;
        else
            return;
        end
    elseif ~is_new_quant % check whether to start a new quantitation
        opts = struct('Default','Proceed','WindowStyle','modal','Interpreter','tex');
        answer = questdlg('\fontsize{12}You have selected a new experiment type. Clear the existing files and start a new quantitation?',...
            'File Clear Warning','Proceed','Cancel',opts);
        waitfor(answer);
        if strcmpi(answer,'Proceed')
            clear_existing_results;
        else
            return;
        end
    end
    % update the experiment type parameter
    para=hdlpara.UserData;
    item=hobj.SelectedObject.String;
    para.abs_int=0;
    para.abs_stc=0;
    para.rel_quant=0;
    para.quantifier_sel=0;
    switch item
        case 'Abs. quant. w/ int. std.'
            para.abs_int=1;
        case 'Abs. quant. w/ std. curve'
            para.abs_stc=1;
        case 'Relative quantitation'
            para.rel_quant=1;
        otherwise
            para.quantifier_sel=1;
    end  
%     chdhdl=hobj.Children;
%     for i=1:length(chdhdl)
%         if strcmp(hobj.Children(i).String,'Abs. quant. w/ int. std.')
%             para.abs_int=hobj.Children(i).Value;
%         end
%         if strcmp(hobj.Children(i).String,'Abs. quant. w/ std. curve')
%             para.abs_stc=hobj.Children(i).Value;
%         end
%         if strcmp(hobj.Children(i).String,'Relative quantitation')
%             para.rel_quant=hobj.Children(i).Value;
%         end
%     end
    hdlpara.UserData=para;
end
%-------------------------------------------------------------------------
% change file order so that files are quantitated in either the acquiring 
% or the filename older
%-------------------------------------------------------------------------
function change_file_order(hobj,~)
    if strcmpi(hobj.String,'acquiring')
        set(findobj('Tag','rb_filename_order'),'Value',1-hobj.Value);
    else
        set(findobj('Tag','rb_acquiring_order'),'Value',1-hobj.Value);
    end
end
%------------------------------------------------------------------------
% change different file browser that select all or some files in a folder
%------------------------------------------------------------------------
function change_proportion(hobj,~)
    if strcmpi(hobj.String,'all')
        set(findobj('Tag','rb_some'),'Value',1-hobj.Value);
    else
        set(findobj('Tag','rb_all'),'Value',1-hobj.Value);
    end
end
%--------------------------------------------------------------
% function that load MRM files
%--------------------------------------------------------------
function filelist=browse_test_folder(~,~,hdlrec,hdldirinfo)
    hdlpara=findobj('Tag','pl_para');
    % check whether an unsaved result exists
    save_status=get(findobj('Tag','PB_save_result'),'UserData');
    if isempty(save_status)
        is_saved=true;
    else
        is_saved=save_status;
    end
    if ~is_saved
        opts = struct('Default','Save and proceed','WindowStyle','modal','Interpreter','tex');
        answer = questdlg('\fontsize{12}The computed/modified result has not been saved. Save it before starting a new quantitation?',...
            'Data Loss Warning','Save and proceed','Proceed without saving','Cancel',opts); 
        if strcmpi(answer,'Save and proceed')
            hdlmeth=findobj('Tag','pl_comp');
            hdlastc=findobj('Tag','rb_abs_stc');
            save_quantitation_result('','',hdlrec,hdlmeth,hdlastc,hdlpara);
            clear_existing_results;
        elseif strcmpi(answer,'Proceed without saving')
            clear_existing_results;
        else
            return;
        end
    end
    filelist={};
    para=hdlpara.UserData;
    dirinfo=hdldirinfo.UserData;
    if isempty(dirinfo)
        filepath=para.dir;
        dirinfo={pwd;filepath};
    else
        filepath=dirinfo{2};
    end
    if ~isfolder(filepath) % the default derectory is not found
        msg={'The following default directory is not found.';filepath;'Current working directory will be used instead.'};
        hdl=warndlg(msg,'Folder Not Found',struct('WindowStyle','modal','Interpreter','tex'));
        waitfor(hdl);
        filepath=pwd;
    end
    use_all_files=get(findobj('Tag','rb_all'),'Value')==1;
    if use_all_files % all files in a folder are used. Ask user to specify a folder.
        newpath = uigetdir(filepath,'Use all MRM files in the selected folder.');
        if newpath ~= 0 % the user has selected an legitimate path
            % start to read data files from the specified folder
            cd(newpath);
            txtfileinfo=dir('*.txt');
            mzMLfileinfo=dir('*.mzML');
            if isempty(txtfileinfo) % no txt file is found, use mzml files only
                fileinfo=mzMLfileinfo;
            elseif isempty(mzMLfileinfo) % no mzML file is found, use txt files only
                fileinfo=txtfileinfo;
            else % combine txt and mzml files
                fileinfo=[txtfileinfo;mzMLfileinfo];
            end
            fileinfostr=struct2cell(fileinfo);
            filelist=fileinfostr(1:6:end);
        else
            return;
        end
    else % Use some files in a folder. Ask user to specify files in a folder.
        [filelist,newpath] = uigetfile({'*.mzml;*.txt';'*.mzml';'*.txt'},...
            'Select MRM files for quantitation',filepath,'MultiSelect','on');
        if isnumeric(filelist)
            return
        elseif ischar(filelist)
            filelist={filelist};
        end
    end
    hdldirinfo.UserData={dirinfo{1};newpath};
    cd(dirinfo{1}); % change back to program folder        
    if ~isempty(filelist) % legitimate files are found in the folder
        hdldirinfo.UserData={pwd;newpath};
        % clear existing quantitation results
        clear_existing_results;
        edit1=findobj('Tag','edit_dir');
        edit1.String=newpath;
        list1=findobj('Tag','list_file');
        list1.String=filelist;
        list1.Value=1;
        nof=length(filelist);
        % prepare progress bar
        pg_bar=findobj('Tag','pg_bar');
        pg_text=findobj('Tag','pg_text');
        rec=cell(nof,1);
        set(list1,'min',0,'max',nof,'value',[]);
        keepid=true(nof,1);
        for i=1:nof % iteratively read the MRM data from fil(filetype=='both') || (filetype=='es in the specified folder
            if contains(filelist{i},'txt')
                try
                    data=MRM_read_fast([get(edit1,'String'),'\',filelist{i}]); % read MRM data
                catch
                    errordlg(['The file named ',filelist{i},' is not a legitimate MRM file!'],'File Format Error','modal');
                    keepid(i)=false;
                end
            elseif contains(filelist{i},'mzML')
                try
                    data=mzML_read([get(edit1,'String'),'\',filelist{i}]); % read MRM data
                catch
                    errordlg(['The file named ',filelist{i},' is not a legitimate MRM file!'],'File Format Error','modal');
                    keepid(i)=false;
                end
            end
            if keepid(i)
                if (i==1) && ~isempty(data.NonMRM)
                    msg=['The following data in the file are not MRM:';data.NonMRM];
                    opts.Interpreter = 'none';
                    opts.Default = 'Ignore';
                    answer=questdlg(msg,'Data Content Warning','Ignore','Cancel',opts);
                    if strcmpi(answer,'cancel')
                        return
                    end
                end
                nos=length(data.peakdata)-1;
                if exist('prevnos','var')
                    if prevnos~=nos
                        errmsg={['The number of MRM chromatograms in ',filelist{i},' is different from the prevuous ones.'],...
                            'Please verify the data and try again'};
                        errordlg(errmsg,'Data Content Error','modal');
                        return
                    end
                end
                prevnos=nos;
                % update the record info
                rec{i}.tic=data.peakdata{1};
                rec{i}.name=filelist{i};
                rec{i}.startTimeStamp=data.startTimeStamp;
                rec{i}.data=cell(nos,1);
                rec{i}.mz=cell(nos,1);
                for j=1:nos
                    rec{i}.data{j}=data.peakdata{j+1};
                    rec{i}.mz{j}=data.mzdata{j+1};
                end
                rec{i}.batch_QC=false; % set the default QC usage for file i to false
                rec{i}.batch_ref=false; % set the default reference usage for file i to false
                rec{i}.batch_end=false; % set the default value that the record is at the end of a batch
                rec{i}.batch_no=1; % set the default batch number for file i to 0
            end
            set(list1,'min',0,'max',nof,'value',1:i);
            set(pg_bar,'Position',[0.0 0.0 (1.0*i/nof) 1.0],'FaceColor','b')
            set(pg_text,'String',['Reading ',num2str(nof),' files: ',num2str(i),'/',num2str(nof),' (',num2str(100.0*i/nof,'%5.2f'),' %) finished!']);
            pause(0.005);
        end
        % update the filelist
        filelist=filelist(keepid);
        nof=sum(keepid);
        set(findobj('Tag','label1'),'String',sprintf('File list: %d files found.',nof));
        % update the record info
        rec=rec(keepid);
        % rearrange the file order if nessary
        hdlfileorder=findobj('Tag','rb_acquiring_order');
        startTimeStamp = cellfun(@extractfield,rec,repmat({'startTimeStamp'},nof,1));
        [~,fileorder]=sortrows(startTimeStamp,1,'ascend');
        if hdlfileorder.Value==1
            filelist=filelist(fileorder);
            rec=rec(fileorder);
        end
        list1.String=filelist;
        list1.Value=1;
        set(list1,'min',0,'max',1,'value',1);
        hdlrec.UserData=rec; % update the chromatographs 
        if para.abs_stc % make a copy of the data
            set(findobj('tag','pl_file'),'UserData',rec); 
        end
        set(findall(findobj('Tag','pl_comp'),'-property','enable'),'enable','on');
        set(findobj('Tag','SL_plot_v'),'UserData',[nof para.file_num]);
        set(pg_bar,'Position',[0.0 0.0 0.0 1.0],'FaceColor','b')
        pg_text.String='';
        change_plot('','','TIC');%plot_TIC();
    else % no legitimate file is found in the folder
        set(findall(findobj('Tag','pl_comp'),'-property','enable'),'enable','off');
        set(findall(findobj('Tag','pl_para'),'-property','enable'),'enable','off');
        set(findobj('Tag','PB_quant'),'Enable','off');
        set(findobj('Tag','PB_save_result'),'Enable','off');
        warndlg('No MRM data in .txt or in .mzML format is found!','Warning',struct('WindowStyle','modal','Interpreter','tex'));
    end
end
%--------------------------------------------------------------
% function for changing the detected compound information
%--------------------------------------------------------------
function change_method(~,~,target,hdlmeth,hdldirinfo)
    dirinfo=hdldirinfo.UserData;
    % load the user expected compound file
    cd(dirinfo{2});
    [file,path] = uigetfile({'*.txt;*.csv'});
    if file == 0
        return
    end
    [~,~,ext] = fileparts(file);
    cd(dirinfo{1});
    if file
        hdldirinfo.UserData={dirinfo{1};path};% save the current folder
        % determine file format
        fid=fopen([path,file],'r');
        fgets(fid); % skip the first line
        str=fgets(fid);
        if strcmpi(ext,'.csv')
            commaloc=strfind(str,',');
            lendelimter=length(commaloc)+1;
            delimiter = ',';
        else
            spaceloc=strfind(str,' ');
            tabloc=strfind(str,'\t');
            lendelimter=max(length(spaceloc)+1,length(tabloc)+1);
            if length(spaceloc)>length(tabloc)
                delimiter = ' ';
            else
                delimiter = '\t';
            end
        end
        fclose(fid);
        hdlpara=findobj('Tag','pl_para');
        para=hdlpara.UserData;
        % check column number for experiment type
        if para.abs_int % absolute quantitation with internal standard
            if lendelimter ~= 7
                errordlg({'File content is not recognizable !';'Need to include the following fields:';'Comp. Name, RT, RT Tol. ,Prec. mz, Prod. mz, IS, Conc'},'File Error',struct('WindowStyle','modal','Interpreter','none'));
                return;
            end
        elseif para.abs_stc % absolute quantitation with standard curve
            if ~((lendelimter >= 5) && (lendelimter <= 6))
                errordlg({'File content is not recognizable !';'Need to include the following fields:';'Comp. Name, RT, RT Tol., Prec. mz, Prod. mz, IS'},'File Error',struct('WindowStyle','modal','Interpreter','none'));
                return;
            end
        else % relative quantitation
            if lendelimter ~= 5
                errordlg({'File content is not recognizable !';'Need to include the following fields:';'Comp. Names, RT, RT Tol., Prec. mz, Prod. mz'},'File Error',struct('WindowStyle','modal','Interpreter','none'));
                return;
            end
        end
        dataStartLine = 2;
        extraColRule = 'ignore';
        if lendelimter == 5 % five columns of data
            varNames = {['Comp.' char(160) 'Name'],'RT',['RT' char(160) 'Tol.'],['Prec.' char(160) 'mz'],['Prod.' char(160) 'mz']};
            varTypes = {'char','char','char','double','double'};
        elseif lendelimter == 6 % six columns of data
            varNames = {['Comp.' char(160) 'Name'],'RT',['RT' char(160) 'Tol.'],['Prec.' char(160) 'mz'],['Prod.' char(160) 'mz'],'IS'};
            varTypes = {'char','char','char','double','double','char'};
        elseif lendelimter == 7 % seven columns of data
            varNames = {['Comp.' char(160) 'Name'],'RT',['RT' char(160) 'Tol.'],['Prec.' char(160) 'mz'],['Prod.' char(160) 'mz'],'IS','Conc'};
            varTypes = {'char','char','char','double','double','char','double'};
        else
            errordlg('File content is not recognizable !','File Error',struct('WindowStyle','modal','Interpreter','tex'));
            return;
        end
        opts = delimitedTextImportOptions('VariableNames',varNames,...
            'VariableTypes',varTypes,...
            'Delimiter',delimiter,...
            'DataLines', dataStartLine,...
            'ExtraColumnsRule',extraColRule,...
            'MissingRule','fill');
        opts = setvaropts(opts,['Comp.' char(160) 'Name'],'FillValue','None');
        opts = setvaropts(opts,'RT','FillValue','-1');
        opts = setvaropts(opts,['RT' char(160) 'Tol.'],'FillValue','-1');
        opts = setvaropts(opts,{['Prec.' char(160) 'mz'],['Prod.' char(160) 'mz']},'FillValue',-1);
        if lendelimter >= 6
            opts = setvaropts(opts,'IS','FillValue','None');
        end
        if lendelimter == 7 
            opts = setvaropts(opts,'Conc','FillValue',-1);
        end
        t = readtable([path,file],opts);
        if isempty(t)
            hdl=errordlg('No valid compound information is found','File Error',struct('WindowStyle','modal','Interpreter','tex'));
            waitfor(hdl);
            return;
        elseif any(any(ismissing(t)))
            hdl=warndlg('Missing values are found in the files! Please fill in those values to avoid unquantifiable results','File Error',struct('WindowStyle','modal','Interpreter','tex'));
            waitfor(hdl);
        end
        data=table2cell(t);
        EICnum=size(data,1); % total number of EIC
        method=hdlmeth.UserData;
        method.orig_name=data(:,1);
        method.rt=cell(EICnum,1);
        method.rt_diff=cell(EICnum,1); % read the retion time tolerence
        method.mz=cell2mat(data(:,4)); % mother ion m/z
        method.dmz=cell2mat(data(:,5)); % daughter ion m/z
        method.IS=[];
        if length(varTypes) >= 6
            method.IS=data(:,6); % Internal Standard
        end
        if length(varTypes) == 7
            method.conc=cell2mat(data(:,7)); % concentraction factor
        end
        % rearrange data into a cell so as to display in a listbox
        method.nocomp=0; % total number of compounds
        for i=1:EICnum
            if ischar(data{i,2}) % if isomers elute at different retention times
                method.rt{i}=cell2mat(textscan(data{i,2},'%f','delimiter',{',',';'}));
                if ischar(data{i,3}) % if multiple RT tolerences are also given
                    method.rt_diff{i}=cell2mat(textscan(data{i,3},'%f','delimiter',{',',';'}));
                    if (length(method.rt_diff{i})==1) && (length(method.rt{i})>1)
                        method.rt_diff{i}=repmat(method.rt_diff{i},size(method.rt{i}));
                    end
                else % if only one RT tolerences is provided, replicate it to the same length as RT
                    method.rt_diff{i}=repmat(data{i,3},size(method.rt{i}));
                end
            else % only one RT
                method.rt{i}=data{i,2};
                method.rt_diff{i}=data{i,3};
            end
            method.nocomp=method.nocomp+length(method.rt{i});
        end
        method.EICidx=zeros(method.nocomp,3); % conversion matrix from EIC index to compound index
        method.indiv_name=cell(method.nocomp,1);
        count=1;
        method.ISidx=-1;
        % deal with moltiple compounds (isomers) in an EIC 
        for i=1:EICnum 
            name=strsplit(method.orig_name{i},'_'); % split compound names by "_"
            if length(name) ~= length(method.rt{i})
                errordlg(['Compound number(',method.orig_name{i},') does not match with RT number (',...
                    data{i,2},')!'],'Method File Error',struct('WindowStyle','modal','Interpreter','none'));
                return;
            end
            for j=1:length(method.rt{i}) % find the index of internal standard 
                method.EICidx(count,:)=[count,i,j];
                method.indiv_name{count}=name{j};
                if contains(name{j},["(IS)","(Is)","(iS)","(is)"]) % symbol of internal standard in the file
                    method.ISidx=count;
                end
                count=count+1;
            end
        end 
        % display info based on whether the loaded data is for testing or
        % for standard curve construction
        if strcmpi(target,'sample') % the data is a testing sample
            tblhdl=findobj('Tag','tbl_comp_list');
            % show number of loaded compound in a label
            label2=findobj('Tag','compound_loc');
            label2.String=[num2str(EICnum),' Compounds'];
            % store the data in the frame
            hdlmeth.UserData=method;
            set(findobj('Tag','PB_new'),'UserData',[file,path]);
            set(findobj('Tag','PB_modify'), 'enable', 'on');
            change_plot('','','TIC');%plot_TIC();
            % check if the XIC data is given
            filelist=get(findobj('Tag','list_file'),'String');
            % if both MRM data and the method file are provided, enable the
            % control panel for parameter input
            if ~isempty(filelist) && exist('method','var')
                set(findall(hdlpara, '-property', 'enable'), 'enable', 'on');
                set(findall(findobj('Tag','pl_plot'), '-property', 'enable'), 'enable', 'off');
                if get(findobj('Tag','cb_auto_bg'),'Value')
                    set(findobj('Tag','ed_bg_int'),'Enable','off');
                else
                    set(findobj('Tag','ed_bg_int'),'Enable','on');
                end
                if get(findobj('Tag','cb_auto_smooth'),'Value')
                    set(findobj('Tag','ed_smooth_win'),'Enable','off');
                else
                    set(findobj('Tag','ed_smooth_win'),'Enable','on');
                end
                set(findobj('Tag','PB_quant'),'Enable','on');
                set(findobj('Tag','SL_plot_h'),'UserData',[method.nocomp para.comp_num]);
            end
        else % the data is for standard curve generation
            tblhdl=findobj('Tag','tbl_std_RT');
            % check the consistency with that of experiment compounds and store
            % the data in the table
            comp=get(findobj('Tag','pl_comp'),'UserData');
            if length(comp.rt) ~= length(method.rt)
                errordlg('The number of standard compounds is not match with that of the experimental compound!','Compound Number Error');
                set(findobj('Tag','pl_std_para'),'Enable','off');
                set(findobj('Tag','PB_std_ok'),'Enable','off');
                return;
            else
                set(findobj('tag','pl_std_rt'),'UserData',method);
                set(findobj('Tag','pl_std_para'),'Enable','on');
                set(findobj('Tag','PB_std_ok'),'Enable','on');
            end
        end
        tblhdl.Data=data; % copy the data from file to table
        tblhdl.ColumnName=varNames;%t.Properties.VariableNames; % set the table column names
        set(findobj('Tag','cb_normal'),'Value',para.normal);
    else
        errordlg('File not found','File Error',struct('WindowStyle','modal','Interpreter','tex'));
        return;
    end  
end
% -------------------------------------------------
% change the parameter of min. peak width 
% -------------------------------------------------
function change_min_peak_width(hobj,~,hdlpara)
    para=hdlpara.UserData;
    try 
        min_peak_width=str2double(hobj.String);
    catch
        errordlg('The input value is not a number!','Invalid number','modal');
        return
    end
    para.min_peak_width=min_peak_width;
    % update the parameters
    hdlpara.UserData=para;
end
% -------------------------------------------------
% change the parameter of min. peak distance 
% -------------------------------------------------
function change_min_peak_dist(hobj,~,hdlpara)
    para=hdlpara.UserData;
    try 
        min_peak_dist=str2double(hobj.String);
    catch
        errordlg('The input value is not a number!','Invalid number','modal');
        return
    end
    para.min_peak_width=min_peak_dist;
    % update the parameters
    hdlpara.UserData=para;
end

%--------------------------------------------------------------
% plot a TIC data 
%--------------------------------------------------------------
function plot_TIC(~,~)
    axhdl=findobj('Tag','AX_TIC_plot');
    fileid=axhdl.UserData;
    % find number of sample files and the selected file
    lhdl=findobj('Tag','list_file');
    idx=lhdl.Value;
    textid=findobj('Tag','txt_peak'); % show compound info in TIC
    quant_state=lower(get(findobj('Tag','PB_quant'),'UserData'));
    % load standard compound info
    method=get(findobj('Tag','pl_comp'),'UserData');
    if ~isempty(method) && (fileid==idx) && ...% the TIC has been drawn before
            ((isempty(textid) && strcmpi(quant_state,'new')) || (~isempty(textid) && ~strcmpi(quant_state,'new')))
        set(findobj('Tag','SL_plot_h'),'Enable','off','Visible','on'); % disable the horizontal slider
        set(findobj('Tag','SL_plot_v'),'Enable','off','Visible','on'); % disable the vertical slider
        return
    end
    % get the axes handle
    cla(axhdl);
    % load quantation results
    rec=get(findobj('Tag','MRM_Quant'),'UserData');
    % prepare the progress bar
    pg_bar=findobj('Tag','pg_bar');
    pg_text=findobj('Tag','pg_text');
    % start drawing
    % plot original TIC
    stem(axhdl,rec{idx}.tic(:,1),rec{idx}.tic(:,2),'markersize',1,'color','k','tag','TIC_signal');
    hold on
    if ~isempty(method) % compound info has been provided
        % draw compound info
        adjy=max(1,max(rec{idx}.tic(:,2)))*1.2;
        compnum=length(method.rt);
        for i=1:compnum % combine spectra of all compounds
            peaknum=length(method.rt{i});
            for j=1:peaknum
                if method.rt{i}(j) > 0
                    compid=find((method.EICidx(:,2)==i) & (method.EICidx(:,3)==j));
                    line(axhdl,[method.rt{i}(j)'; method.rt{i}(j)'],repmat([0;adjy],1,peaknum),'color',[0.7 0.7 0.7],'linewidth',1,'tag',char(strtrim(method.indiv_name{compid}),[' @ ',num2str(method.rt{i}(j))]));
                    h=text(axhdl,method.rt{i}(j),0.6*adjy,char(method.indiv_name{compid},[' @ ',num2str(method.rt{i}(j))]),'rotation',90,'fontsize',12,'Interpreter','none','clipping','on');
                    ext=get(h,'extent');
                    if isempty(findobj('Tag','im_heatmap')) % quantitation has not been performed
                        set(h,'position',[method.rt{i}(j),adjy-ext(4)],'color',[0 0 0]);
                    else % quantitation is finished
                        set(h,'position',[method.rt{i}(j),adjy-ext(4)],'color',[0 0 1],'ButtonDownFcn',{@TIC_select_compound ,idx, compid},'tag','txt_peak');
                    end
                end
            end
            if rem(i,40)==0 % show the progress every 40 compounds
                set(findobj('Tag','pg_bar'),'Position',[0.0 0.0 (1.0*i)/(compnum) 1.0],'FaceColor','b');
                thdl=findobj('Tag','pg_text');
                thdl.String=['Annotating ',num2str(i),'/',num2str(compnum),' of Compounds in TIC (',num2str(100.0*i/(compnum),'%5.2f'),' %) finished!'];
                ext=thdl.Extent;
                set(thdl,'pos',[0.5-ext(3)/2,0.5]);
                pause(0.005);
            end
        end
        axhdl.UserData=idx;
    end
    chi=get(axhdl, 'Children');
    %Reverse the stacking order so that the patch overlays the line
    set(axhdl, 'Children',flipud(chi))
    axis('tight');
    set(findobj('Tag','SL_plot_h'),'Enable','off','Visible','on'); % disable the horizontal slider
    set(findobj('Tag','SL_plot_v'),'Enable','off','Visible','on'); % disable the vertical slider
    set(pg_bar,'Position',[0.0 0.0 0.0 1.0],'FaceColor','b')
    set(pg_text,'String',''); % clear the progress bar
end
%--------------------------------------------------------------
% plot an EIC data and its quantation result
%--------------------------------------------------------------
function plot_EIC(objectHandle , ~, par1,par2)
    hdlrec=findobj('Tag','MRM_Quant');
    hdlmeth=findobj('Tag','pl_comp');
    hdlastc=findobj('Tag','rb_abs_stc');
    hdlpara=findobj('Tag','pl_para');
    hdlmtx=findobj('Tag','AX_heat_map');
    hdlimg=findobj('Tag','im_heatmap');
    exp=hdlastc.UserData; % extract standard curve data
    % find number of sample files and the selected file
    if contains(lower(get(findobj('Tag','PB_quant'),'UserData')),'standard') % quantitation on standard compound data
        filelist=exp.fname;
    else % quantitation on testing data
        filelist=get(findobj('Tag','list_file'),'String');
    end
    filenum=length(filelist);
    % load standard compound info
    method=hdlmeth.UserData;
    compnum=method.nocomp;
    % load parameters
    para=hdlpara.UserData;
    % get the axes handle
    AX_TIC_plot=findobj('Tag','AX_TIC_plot');
    fromwhere='Heatmap';
    % end the function if the alligned values are outside the allowable limits
    if (par1 > filenum) || (par2 > compnum)
        return
    elseif strcmpi(AX_TIC_plot.Visible,'on')
        fromwhere='TIC';
        hdlmtx=AX_TIC_plot;
    end
    % close the heat map export window if exists
    fhdl=findobj('Tag','temp_fig');
    if ~isempty(fhdl), close(fhdl); end
    pbhdl=findobj('Tag','PB_inspect_mode');
    % the user has activated the inspection mode or if the current
    % experiment uses standard curve
    if (pbhdl.Value == 1) || (para.abs_stc == 1) 
        fig=findobj('Tag','fg_EIC');
        if (isempty(fig)) % if no EIC plot is shown, then create a new figure and show the contains in the specified file
            fig=create_EIC_window(fromwhere,hdlrec,hdlmeth,hdlastc,hdlmtx,hdlpara);
        else
            set(fig,'Visible','on','Hittest','on');
            set(findobj('Tag','PB_next_samp'),'BackgroundColor',[0.7500 0.7500 0.7500]);
            set(findobj('Tag','PB_prev_samp'),'BackgroundColor',[0.7500 0.7500 0.7500]);
            set(findobj('Tag','PB_next_comp'),'BackgroundColor',[0.7500 0.7500 0.7500]);
            set(findobj('Tag','PB_prev_comp'),'BackgroundColor',[0.7500 0.7500 0.7500]);
        end
        fig.Name = 'Multiple Reaction Monitoring';
        ax=findobj('Tag','AX_EIC');
        % find existing components
        cb_show_legend=findobj('Tag','cb_show_legend');
        cb_show_detail=findobj('Tag','cb_show_detail');
        % load quantation results
        rec=hdlrec.UserData;
        % draw EIC
        if par1 == 0 % the file and compound indices are to be determined
            % locate the clicked file and the corresponding compound
            axesHandle  = get(objectHandle,'Parent');
            coordinates = get(axesHandle,'CurrentPoint'); 
            coordinates = coordinates(1,1:2);
            fileid=floor(coordinates(2)-0.5)+1;
            compoundid=floor(coordinates(1)-0.5)+1;
        else % the file and compound indices are known
            fileid=par1;
            compoundid=par2;
        end
        if gca ~= ax
            axes(ax);
        end
        EICid=method.EICidx(compoundid,2);
        peakid=method.EICidx(compoundid,3);
        peaknum=length(method.rt{EICid});
        % check the validity of the given RTs
        rtnum=sum(method.rt{EICid}>0);
        if peaknum == 0
            errordlg('Invalid data is provided for the expected compound. No EIC plot can be generated!','Method File Error',struct('WindowStyle','modal','Interpreter','tex'));
            return;
        elseif peaknum ~= rtnum
            errordlg('Some of the given RTs are invalid. No EIC plot can be generated!','Method File Error',struct('WindowStyle','modal','Interpreter','tex'));
            return;
        end
        % update the heat map miniature
        rchdl1=findobj('Tag','sel_rect'); % get the handle of the selected EIC in the heat map
        lhdl1=findobj('Tag','sel_line'); % get the handle of the selected EIC in the TIC
        axm=findobj('Tag','AX_miniature'); % get the handle of the miniature
        is_TIC=any(ismember(get(get(axm,'Children'),'Type'),'stem'));
        is_change_mode=(is_TIC & strcmpi(fromwhere,'Heatmap')) | (~is_TIC & strcmpi(fromwhere,'TIC'));
        if isempty(axm) || is_change_mode
            cla(axm);
            % generate the miniature
            if strcmpi(fromwhere,'TIC')
                str=char(strtrim(objectHandle.String(1,:)),[' ',strtrim(objectHandle.String(2,:))]);
                lhdl=findobj('tag',str);
                if length(lhdl)>1
                    lhdl=lhdl(1);
                end
                stem(axm,rec{fileid}.tic(:,1),rec{fileid}.tic(:,2),'markersize',1,'color','k','tag','TIC_mini');
                line(axm,lhdl.XData,lhdl.YData,'Color','r','linewidth',2,'tag','sel_line_mini');
                set(findobj('Tag','PB_prev_samp'),'Visible','off'); % in the TIC plot mode, it is forbidden to browse the previous file
                set(findobj('Tag','PB_next_samp'),'Visible','off'); % in the TIC plot mode, it is forbidden to browse the next file
            else
                imagesc(axm,'CData',hdlimg.CData,'AlphaData',hdlimg.UserData,'Tag','im_heatmap_mini');
                rectangle(axm,'Position',rchdl1.Position,'EdgeColor',rchdl1.EdgeColor,'LineWidth',2,'LineStyle','-','Tag','sel_rect_mini');
                set(findobj('Tag','PB_prev_samp'),'Visible','on'); % in the heatmap mode, it is allowed to browse the previous file
                set(findobj('Tag','PB_next_samp'),'Visible','on'); % in the heatmap mode, it is allowed to browse the next file
            end
            set(axm,'XTick','','XLim',hdlmtx.XLim,'YTick','','YLim',hdlmtx.YLim,...
                'YDir',hdlmtx.YDir,'CLim',hdlmtx.CLim,'Colormap',hdlmtx.Colormap);
        else % update the miniature
            if strcmpi(fromwhere,'TIC') % update TIC in the the miniature
                lhdl2=findobj('Tag','sel_line_mini'); % get the handle of the selected EIC in the heat map
                if isempty(lhdl2)
                    line(axm,lhdl1.XData,axm.YLim,'Color','r','linewidth',2,'tag','sel_line_mini');
                else
                    lhdl2.XData=lhdl1.XData;
                    lhdl2.YData=lhdl1.YData;
                end
                set(findobj('Tag','PB_prev_samp'),'Visible','off'); % in the TIC plot mode, it is forbidden to browse the previous file
                set(findobj('Tag','PB_next_samp'),'Visible','off'); % in the TIC plot mode, it is forbidden to browse the next file
            else % update heatmap in the the miniature
                rchdl2=findobj('Tag','sel_rect_mini'); % get the handle of the selected EIC in the heat map
                if isempty(rchdl2)
                    rectangle(axm,'Position',rchdl1.Position,'EdgeColor',rchdl1.EdgeColor,'LineWidth',2,'LineStyle','-','Tag','sel_rect_mini');
                else
                    rchdl2.Position=rchdl1.Position;
                    rchdl2.EdgeColor=rchdl1.EdgeColor;
                end
                set(findobj('Tag','PB_prev_samp'),'Visible','on'); % in the heatmap mode, it is allowed to browse the previous file
                set(findobj('Tag','PB_next_samp'),'Visible','on'); % in the heatmap mode, it is allowed to browse the next file
            end
            % update the plot range and colormap
            set(axm,'XLim',hdlmtx.XLim,'YLim',hdlmtx.YLim,'YDir',hdlmtx.YDir,...
                'CLim',hdlmtx.CLim,'Colormap',hdlmtx.Colormap);
            % update the plots of neighboring compounds if the 'more>' is pressed
            show_compound_in_nearby_files('','',fileid,compoundid,hdlrec,hdlmeth,'',true);
        end
        % show designated compound location
        dlen=length(rec{fileid}.data{EICid}(:,2)); % EIC data length
        maxy=max(1,1.05*max(rec{fileid}.data{EICid}(:,2))); % EIC max data height
        miny=0;
        maxstdy=0;
        for i=1:peaknum % determine the height of the EIC plot and check the RTs of the designated compounds
            [~,tid]=min(abs(rec{fileid}.data{EICid}(:,1)-method.rt{EICid}(i))); % find the singal index that matches with the tip of the ith compound
            if (tid >= 5) && ((tid+5) <= dlen) %else
                maxstdy=max(max(rec{fileid}.data{EICid}((tid-5):(tid+5),2)),maxstdy); % find the max intensity of the peak
            end
        end
        adjy=maxy;
        hdl=zeros(7,1);
        % mark the location(s) of the expected compound with gray line(s)
        temphdl=findobj('tag','lc_hdl1');
        if isempty(temphdl)
            hdl(1)=stem(method.rt{EICid},repmat(adjy,1,peaknum),'color',[0.7 0.7 0.7],'linewidth',2,'tag','lc_hdl1','markersize',1);
        else
            hdl(1)=temphdl;
            set(hdl(1),'XData',method.rt{EICid},'YData',repmat(adjy,1,peaknum));
        end
        % generate the title information
        generate_title(fileid,EICid,peakid,filelist{fileid},ax,hdlrec,hdlmeth,hdlpara);
        % draw original EIC signals
        temphdl=findobj('tag','lc_hdl2');
        if isempty(temphdl) % if the signals do not exist, draw the signals
            hdl(2)=stem(ax,rec{fileid}.data{EICid}(:,1),rec{fileid}.data{EICid}(:,2),...
                'markersize',1,'color','k','linewidth',1,'tag','lc_hdl2');
        else % the signals exist, update their data
            hdl(2)=temphdl;
            set(hdl(2),'XData',rec{fileid}.data{EICid}(:,1),'YData',rec{fileid}.data{EICid}(:,2));
        end
        ax.XLim=[min(rec{fileid}.data{EICid}(:,1)) max(rec{fileid}.data{EICid}(:,1))];
        % draw smoothed EIC signals
        temphdl=findobj('tag','lc_hdl3');
        if isempty(temphdl) % if the signals do not exist, draw the signals
            hdl(3)=line(ax,rec{fileid}.data{EICid}(:,1),rec{fileid}.smoothy{EICid}+rec{fileid}.bg_int{EICid},...
                'linestyle','-','color','k','linewidth',2,'tag','lc_hdl3');
        else % the signals exist, update their data
            hdl(3)=temphdl;
            set(hdl(3),'XData',rec{fileid}.data{EICid}(:,1),'YData',rec{fileid}.smoothy{EICid}+rec{fileid}.bg_int{EICid});
        end
        % indices the detected peak
        pid=rec{fileid}.is_compound{EICid}(:,peakid);
        % indices the peak tip
        tid=rec{fileid}.is_peak{EICid}(:,peakid);
        temphdl=findobj('tag','lc_hdl4');
        if isempty(temphdl) % if the signals do not exist, draw the signals
            if ~isempty(pid) % if the peak is detected, draw the peak signals
                hdl(4)=stem(ax,rec{fileid}.data{EICid}(pid,1),rec{fileid}.data{EICid}(pid,2),...
                    'markersize',3,'color','g','linewidth',2,'tag','lc_hdl4');
            else % no peak is detected, draw the expected peak tip
                hdl(4)=stem(ax,rec{fileid}.data{EICid}(tid,1),0,...
                    'markersize',3,'color','g','linewidth',2,'tag','lc_hdl4');
            end
        else % the signals exist, update their data
            hdl(4)=temphdl;
            if ~isempty(pid) % if the peak is detected, update the peak signals
                set(hdl(4),'XData',rec{fileid}.data{EICid}(pid,1),'YData',rec{fileid}.data{EICid}(pid,2));
            else % no peak is detected, update the expected peak tip
                set(hdl(4),'XData',rec{fileid}.data{EICid}(tid,1),'YData',0);
            end
        end
        % show the peak tip
        temphdl=findobj('tag','lc_hdl5');
        if isempty(temphdl)
            hdl(5)=stem(ax,rec{fileid}.data{EICid}(tid,1),rec{fileid}.data{EICid}(tid,2),...
                'markersize',1,'color','r','linewidth',2,'tag','lc_hdl5');
        else
            hdl(5)=temphdl;
            set(hdl(5),'XData',rec{fileid}.data{EICid}(tid,1),'YData',rec{fileid}.data{EICid}(tid,2));
        end
        % show deconvoluted peak (if exists)
        temphdl=findobj('tag','lc_hdl6');
        pmtx=rec{fileid}.decomp{EICid}(:,peakid);
        if any(pmtx > 0)
            keepid=pmtx>0;
            if isempty(temphdl)
                hdl(6)=stem(ax,rec{fileid}.data{EICid}(keepid,1),pmtx(keepid),'markersize',1,'color','b',...
                    'linewidth',2,'tag','lc_hdl6','Visible','on');
            else
                hdl(6)=temphdl;
                set(hdl(6),'XData',rec{fileid}.data{EICid}(keepid,1),'YData',pmtx(keepid),'Visible','on');
            end
        else
            if isempty(temphdl)
                hdl(6)=stem(ax,rec{fileid}.data{EICid}(:,1),pmtx,'markersize',1,'color','b','linewidth',2,'tag','lc_hdl6','Visible','off');
            else
                hdl(6)=temphdl;
                set(hdl(6),'XData',rec{fileid}.data{EICid}(:,1),'YData',pmtx,'Visible','off');
            end
        end
        % show esmated background singal of the EIC
        temphdl=findobj('tag','lc_hdl7');
        if isempty(temphdl)
            hdl(7)=stem(ax,rec{fileid}.data{EICid}(:,1),rec{fileid}.bg_int{EICid},...
                'markersize',1,'color',[0.5 0.5 0.5],'linewidth',2,'tag','lc_hdl7');
        else
            hdl(7)=temphdl;
            set(hdl(7),'XData',rec{fileid}.data{EICid}(:,1),'YData',rec{fileid}.bg_int{EICid});
        end
        % collect handles of drawing components
        if any(pmtx>0) 
            objhdl=hdl;
        else
            objhdl=hdl([1:5,7]);
        end
        if cb_show_legend.Value
            if length(objhdl)==7
                legend(objhdl,{'Expected RT','Original Signal','Smoothed Signal',...
                    'Detected Compound','Peak Tip Location','Deconvoluated Signal',...
                    'Background Intensity'},'AutoUpdate','off');
            else
                legend(objhdl,{'Expected RT','Original Signal','Smoothed Signal',...
                    'Detected Compound','Peak Tip Location','Background Intensity'},...
                    'AutoUpdate','off');
            end
        else
            legend('hide');
        end
        % denote the expected compound name and RT 
        hdltx=findobj('tag','lc_hdl1_tx');
        hdlreg=findobj('tag','lc_hdl1_reg');
        hdllen=length(hdltx);
        % generate peak notations and mark RT difference windows
        for i=1:peaknum 
            % generate RT difference window
            xl=method.rt{EICid}(i)-method.rt_diff{EICid}(i);
            xr=method.rt{EICid}(i)+method.rt_diff{EICid}(i);
            str=char(method.indiv_name{compoundid-peakid+i},[' @ ',num2str(method.rt{EICid}(i))]);
            % set font color
            if i == peakid
                strcolor='k';
            else
                strcolor=[0.7 0.7 0.7];
            end
            if i > hdllen
                % generate peak notation
                set(ax,'YLim',[0 adjy]);
                h=text(ax,method.rt{EICid}(i)+0.01,0.8*adjy,str,'rotation',90,'fontsize',12);
                ext=get(h,'extent');
                set(h,'pos',[method.rt{EICid}(i)+0.01,adjy-1.05*ext(4)],'color',strcolor,'tag','lc_hdl1_tx');
                fill(ax,[xl xl xr xr xl],[0 adjy adjy 0 0],[0.8 0.8 0.8],...
                    'FaceAlpha',0.3,'LineStyle','none','tag','lc_hdl1_reg');
            else
                % update existing pea notation
                set(ax,'YLim',[0 adjy]);
                set(hdltx(i),'String',str,'Position',[method.rt{EICid}(i)+0.01,0.8*adjy]);
                ext=get(hdltx(i),'extent');
                set(hdltx(i),'String',str,'Position',[method.rt{EICid}(i)+0.01,adjy-1.05*ext(4)],'color',strcolor,'Visible','on');
                set(hdlreg(i),'XData',[xl xl xr xr xl],'YData',[0 adjy adjy 0 0],'Visible','on');
            end
        end
        % set addition texts and patches to invisible
        if peaknum < hdllen
            for i=(peaknum+1):hdllen
                set(hdltx(i),'Visible','off');
                set(hdlreg(i),'Visible','off');
            end
        end
        % find the proper axes range
        peaks_org=rec{fileid}.data{EICid}(pid,1);
        decp_int=rec{fileid}.decomp{EICid}(:,peakid);
        peaks_dec=rec{fileid}.data{EICid}(decp_int>0,1);
        peaks=[peaks_org;peaks_dec];
        if isempty(peaks) % if no peak was detected, use the RT tolerance
            diff=abs(rec{fileid}.data{EICid}(:,1)-method.rt{EICid}(peakid));
            [~,minid]=min(diff);
            lbound=rec{fileid}.data{EICid}(minid,1)-method.rt_diff{EICid}(peakid);
            diff=abs(rec{fileid}.data{EICid}(:,1)-lbound);
            [~,lid]=min(diff);
            rbound=rec{fileid}.data{EICid}(minid,1)+method.rt_diff{EICid}(peakid);
            diff=abs(rbound-rec{fileid}.data{EICid}(:,1));
            [~,rid]=min(diff);
        else
            lbound=min(peaks);
            rbound=max(peaks);
        end
        difx=(rbound-lbound)/2;
        % find left and right bounds
        minx=max(rec{fileid}.data{EICid}(1,1),lbound-difx);
        maxx=min(rec{fileid}.data{EICid}(end,1),rbound+difx);
        % find the max height
        if any(pid)
            maxy=max(rec{fileid}.data{EICid}(pid,2));
        elseif exist('lid','var')
            maxy=max(rec{fileid}.data{EICid}(lid:rid,2));
        else
            bd=rec{fileid}.bdp{EICid}(peakid,:);
            maxy=max(rec{fileid}.data{EICid}(bd(1):bd(2),2));
        end
        if isempty(maxy)
            maxy = miny + 1.0;
        elseif (maxy <= miny) 
            maxy = miny + 1.0;
        end
        cb_show_detail.UserData=[minx maxx miny 1.05*maxy];
        if cb_show_detail.Value
            axis([minx maxx miny 1.05*maxy]);
        else
            axis('tight');
        end
        % display compound quantitation status
        txthdl=findobj('tag','txt_status');
        if rec{fileid}.quant_note{EICid}(peakid)==1 % no qualified peaks
            set(txthdl,'String','No Qualified Peak','FontWeight','bold','ForegroundColor','b');
        elseif rec{fileid}.quant_note{EICid}(peakid)==2
            set(txthdl,'String','Multiple Candidate Peaks','FontWeight','bold','ForegroundColor','b');
        elseif rec{fileid}.quant_note{EICid}(peakid)==3 %saturated
            set(txthdl,'String','Saturated Signals','FontWeight','bold','ForegroundColor','r');
        elseif rec{fileid}.quant_note{EICid}(peakid)==4
            set(txthdl,'String','Defect Quantitation','FontWeight','bold','ForegroundColor','r');
        elseif rec{fileid}.quant_note{EICid}(peakid)==5
            set(txthdl,'String','Concentration Unconvertable','FontWeight','bold','ForegroundColor','r');
        else
            set(txthdl,'String','Successful Quantitation','FontWeight','bold','ForegroundColor',[0 0.8 0]);
        end
        % draw the standard curve
        axs=findobj('Tag','AX_std_curve'); % get the handle of the axes
        cla(axs);
        if para.abs_stc % quantitation via standard curve
            if ~isempty(method.IS)
                ISID=strcmpi(method.indiv_name,method.IS{EICid}); % the internal standard of the j-th compound
                ref_abund1=exp.abundance(:,ISID);
                ref_abund2=rec{fileid}.abundance{method.EICidx(ISID,2)}(method.EICidx(ISID,3));
            elseif (method.ISidx~=-1) % absolute quantitation using standard curve
                if (method.ISidx>0)
                    ref_abund1=exp.abundance(:,method.ISidx);
                    ref_abund2=rec{fileid}.abundance{method.EICidx(method.ISidx,2)}(method.EICidx(method.ISidx,3));
                else
                    ref_abund1=1;
                    ref_abund2=1;
                end
            else
                ref_abund1=1;
                ref_abund2=1;
            end
            ycoord=exp.abundance(:,compoundid)./ref_abund1;
            keepid=exp.used_for_reg(:,compoundid); %=~isnan(ycoord);
            y=feval(exp.std_curve{compoundid},exp.conc);
            norm_abunt=(rec{fileid}.abundance{EICid}(peakid)/ref_abund2);
            [compconc,flag]=find_conc_from_standard_curve(exp,compoundid,norm_abunt);
            xvalue=sort([exp.conc;compconc]);
            yvalue=[ycoord(keepid);y;norm_abunt];
            XLim=[min(xvalue) max(xvalue)];
            miny=min(yvalue);
            maxy=max(yvalue);
            if (max(y)-min(y)) < 1e-6 % to avoid small concentration variation
                YLim=[mean(y)-0.5 mean(y)+0.5];
            else
                YLim=[miny maxy];
            end
            % draw the curve links standard sample data
            tempid=findobj('tag','LN_std_pt');
            if isempty(tempid)
                line(axs,exp.conc(keepid),ycoord(keepid),'linewidth',1,'marker','+','color','b','tag','LN_std_pt');
            else
                set(tempid,'xdata',exp.conc(keepid),'ydata',ycoord(keepid))
            end
            % draw the regression line of the previous curve
            tempid=findobj('tag','LN_std_cv');
            if isempty(tempid)
                if isempty(y)
                    line(axs,exp.conc,zeros(length(exp.conc),1),'linewidth',1,'color','r','visible','off','tag','LN_std_cv');
                else
                    line(axs,xvalue,feval(exp.std_curve{compoundid},xvalue),'linewidth',1,'color','r','visible','on','tag','LN_std_cv');
                end
            else
                set(tempid,'xdata',exp.conc,'ydata',y);
            end
            tempid=findobj('tag','LN_abund_ind');
            if isempty(tempid)
                line(axs,XLim,[norm_abunt norm_abunt],'linewidth',3,'linestyle',':','color','k','tag','LN_abund_ind');
            else
                set(tempid,'xdata',XLim,'ydata',[norm_abunt norm_abunt]);
            end
            tempid=findobj('tag','LN_conc_ind');
            if isempty(tempid)
                line(axs,[compconc compconc],YLim,'linewidth',3,'linestyle',':','color','r','tag','LN_conc_ind');
            else
                set(tempid,'xdata',[compconc compconc],'ydata',YLim);
            end
            if ~flag
                title(axs,['\fontsize{12}Concentration = {\color{red}',num2str(compconc,'%.2f'),'}']);
            else
                title(axs,['\fontsize{12}Concentration = {\color{red}',num2str(compconc,'%.2f'),'(linear)}']);
            end
            xlabel(axs,'concentration','fontsize',12);
            ylabel(axs,'abundance','fontsize',12);
            axs.YAxis.Exponent=0;
            axis(axs,[XLim YLim]);
        elseif para.abs_int % quantitation via internal standard
            ISID=strcmpi(method.orig_name,method.IS{EICid});
            maxx=max([rec{fileid}.conc_org{EICid}(peakid) method.conc(EICid)]);
            maxy=max(rec{fileid}.abundance{EICid}(peakid), rec{fileid}.abundance{ISID}(1));
            XLim=[0 maxx];
            if maxy == 0
                YLim=[0 1];
            else
                YLim=[0 1.05*maxy];
            end
            % regression line
            tempid=findobj('tag','LN_reg');
            if isempty(tempid)
                line(axs,[0 maxx],YLim,'Color','k','LineStyle',':','LineWidth',1,'tag','LN_reg');
            else
                set(tempid,'xdata',[0 maxx],'ydata',YLim);
            end
            % standard abundance and concentration
            tempid=findobj('tag','LN_std_conc');
            if isempty(tempid)
                line(axs,[method.conc(EICid) method.conc(EICid)],YLim,'Color','b','LineStyle',':','LineWidth',2,'tag','LN_std_conc');
            else
                set(tempid,'xdata',[method.conc(EICid) method.conc(EICid)],'ydata',YLim);
            end
            tempid=findobj('tag','LN_std_abund');
            if isempty(tempid)
                line(axs,XLim,[rec{fileid}.abundance{ISID}(1) rec{fileid}.abundance{ISID}(1)],'Color','b','LineStyle',':','LineWidth',2,'tag','LN_std_abund');
            else
                set(tempid,'xdata',XLim,'ydata',[rec{fileid}.abundance{ISID}(1) rec{fileid}.abundance{ISID}(1)]);
            end
            % target compound abundance and concentration
            tempid=findobj('tag','LN_comp_conc');
            if isempty(tempid)
                line(axs,[rec{fileid}.conc_org{EICid}(peakid) rec{fileid}.conc_org{EICid}(peakid)],YLim,'Color','r','LineStyle',':','LineWidth',3,'tag','LN_comp_conc');
            else
                set(tempid,'xdata',[rec{fileid}.conc_org{EICid}(peakid) rec{fileid}.conc_org{EICid}(peakid)],'ydata',YLim);
            end
            tempid=findobj('tag','LN_comp_abund');
            if isempty(tempid)
                line(axs,XLim,[rec{fileid}.abundance{EICid}(peakid) rec{fileid}.abundance{EICid}(peakid)],'Color','r','LineStyle',':','LineWidth',3,'tag','LN_comp_abund');
            else
                set(tempid,'xdata',XLim,'ydata',[rec{fileid}.abundance{EICid}(peakid) rec{fileid}.abundance{EICid}(peakid)]);
            end
            tempid=findobj('tag','tx_comp');
            if isempty(tempid)
                text(axs,rec{fileid}.conc_org{EICid}(peakid),0,char(method.indiv_name{compoundid},[' @ ',num2str(method.rt{EICid}(peakid))]),'rotation',90,'fontsize',12,'Interpreter','none','clipping','on','color','r');
            else
                set(tempid,'Position',[rec{fileid}.conc_org{EICid}(peakid),0],'String',char(method.indiv_name{compoundid},[' @ ',num2str(method.rt{EICid}(peakid))]));
            end
            tempid=findobj('tag','tx_std');
            if isempty(tempid)
                text(axs,method.conc(EICid),0,char(method.orig_name{ISID},[' @ ',num2str(method.rt{ISID}(1))]),'rotation',90,'fontsize',12,'Interpreter','none','clipping','on','color','b');
            else
                set(tempid,'Position',[method.conc(EICid),0],'String',char(method.orig_name{ISID},[' @ ',num2str(method.rt{ISID}(1))]));
            end
            set(axs,'XLim',XLim,'YLim',YLim);
            title(axs,['\fontsize{12}Concentration = {\color{red}',num2str(rec{fileid}.conc_org{EICid}(peakid),'%.2f'),'}']);
            xlabel(axs,'concentration','fontsize',12);
            ylabel(axs,'abundance','fontsize',12);
            axs.YAxis.Exponent=0;
        else % plot the relative percentage of abundance 
            % find the max peak among samples
            maxv=0;
            for i=1:filenum
                maxv=max(maxv,rec{i}.abundance{EICid}(peakid));
            end
            percentage=100.0*rec{fileid}.abundance{EICid}(peakid)/maxv;
            % target compound abundance and concentration
            tempid=findobj('tag','rt_rel_abunt');
            if isempty(tempid)
                fill(axs,[0 1 1 0 0],[0 0 percentage percentage 0],[0,0,1],...
                    'LineStyle','none','PickableParts','none','tag','rt_rel_abunt');
            else
                set(tempid,'xdata',[0 1 1 0 0],'ydata',[0 0 percentage percentage 0]);
            end
            set(axs,'XLim',[-0.25 1.25],'YLim',[0 100],'xticklabel',[]);
            xlabel(axs,method.indiv_name{compoundid})
            ylabel(axs,'percentage','fontsize',12);
            title(axs,['\fontsize{12}Rel. Abundance = {\color{red}',num2str(percentage,'%.2f'),'%}']);
        end
    end
    % update the location of the current select compound in the heatmap
    set(fig,'UserData',[fileid,compoundid]);
end
%--------------------------------------------------------------
% generate title for a EIC plot
%--------------------------------------------------------------
function generate_title(fileid,EICid,peakid,filename,hdlax,hdlrec,hdlmeth,hdlpara)
    rec=hdlrec.UserData;
    method=hdlmeth.UserData;
    para=hdlpara.UserData;
    peaknum=length(method.rt{EICid});
    compid=find((method.EICidx(:,2)==EICid) & (method.EICidx(:,3)==peakid));
    try
        if isempty(rec{fileid}.is_peak) % quantitation has NOT been performed
            if peaknum==1 % only one compound in a EIC 
                th=title(hdlax,['EIC of File: ',filename,' (Q1:',num2str(rec{fileid}.mz{EICid}(1)),...
                    ', Q3:', num2str(rec{fileid}.mz{EICid}(2)),') Compound #', num2str(compid),': ',method.orig_name{EICid},' at ',...
                    num2str(method.rt{EICid}(1))], 'Interpreter', 'none');
            else 
                th=title(hdlax,['EIC of File: ',filename,'  Compound #', num2str(compid),': ',method.orig_name{EICid},'(Q1:',num2str(rec{fileid}.mz{EICid}(1)),...
                    ', Q3:', num2str(rec{fileid}.mz{EICid}(2)),') at multiple locations'], 'Interpreter', 'none');
            end
        else
            if para.abs_stc || para.abs_int % absolute quantitation via standard curve or internal standard 
                th=title(hdlax,{['EIC of File: ',filename,'(Q1:',num2str(rec{fileid}.mz{EICid}(1)),...
                    ', Q3:', num2str(rec{fileid}.mz{EICid}(2)),') Compound #', num2str(compid),': ',method.orig_name{EICid},' at ',...
                    num2str(method.rt{EICid}(peakid))],[' Abundance: ',num2str(rec{fileid}.abundance{EICid}(peakid),'%.2e'),...
                    ', Concentration: ',num2str(rec{fileid}.conc_org{EICid}(peakid),'%.2e'),...
                    ', Normalized Concentration: ',num2str(rec{fileid}.concentration{EICid}(peakid),'%.2e')]},...
                    'Interpreter', 'none');
            else % relative quantitation
                th=title(hdlax,{['EIC of File: ',filename,'(Q1:',num2str(rec{fileid}.mz{EICid}(1)),...
                    ', Q3:', num2str(rec{fileid}.mz{EICid}(2)),') Compound #', num2str(compid),': ',method.orig_name{EICid},' at ',...
                    num2str(method.rt{EICid}(peakid))],[' Abundance: ',num2str(rec{fileid}.abundance{EICid}(peakid),'%.2e'),...
                    ', Normalized Abundance: ',num2str(rec{fileid}.concentration{EICid}(peakid),'%.2e')]},...
                    'Interpreter', 'none');
            end
        end
        set(th,'Units','Normalized','position',[0.5 1.02 0],'VerticalAlignment','bottom','FontSize',12);
    catch
        warndlg('Something wrong occurred in the compound information!','Warning',struct('WindowStyle','modal','Interpreter','none'));
    end  
end
% ----------------------------------------------------------------------
% generate a new window for an EIC for inspection and correction 
% draw miniature of the TIC or the heatmap
% ----------------------------------------------------------------------
function fig=create_EIC_window(fromwhere,hdlrec,hdlmeth,hdlastc,hdlmtx,hdlpara)
    global bgcolor
    % get data handels
    hdlimg=findobj('Tag','im_heatmap');
    fig=figure('Color',bgcolor,...
        'NumberTitle','off', ...
        'Units','normalized', ...
        'Menubar','none',...
        'Position',[0.2 0.2 0.48 0.7],...
        'UserData',[1 1],...
        'Tag','fg_EIC'); % Open a new figure for a EIC plot
    % panel displaying the information of the current compound 
    pl_cur_comp=uipanel('Parent',fig, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','none',... 
        'Position',[0.0 0.0 1.0 1.0]);
    % panel displaying the information of the same compound in other files
    pl_more_comp=uipanel('Parent',fig, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','none',... 
        'Position',[0.0 0.0 0.0 1.0]);
    pl_overlap_EIC=uipanel('Parent',pl_more_comp, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','none',... 
        'Position',[0.0 0.8 1.0 0.2]);
    uicontrol('Parent',pl_overlap_EIC, ...
        'Units','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Fontsize',9,...
        'FontWeight','bold',...
        'Position',[0.2 0.91 0.6 0.09], ...
        'String','Overlapping Plot',...
        'Style','text',...
        'Tag','txt_overlap',...
        'UserData',0);
    uicontrol('Parent',pl_overlap_EIC, ...
        'Units','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Fontsize',9,...
        'FontWeight','bold',...
        'Position',[0.2 0.0 0.6 0.08], ...
        'String','Individual Plots',...
        'Style','text');
    ax_overlap=axes('Parent',pl_overlap_EIC, ...
        'Units','normalized', ...
        'Position',[0.08 0.2 0.73 0.67], ...
        'Tag','ax_overlap');
    pb_suppress_peak=uicontrol('Parent',pl_overlap_EIC, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@change_overlapping_scale,'suppress',ax_overlap}, ...
        'Position',[0.84 0.8 0.14 0.19], ...
        'Style','pushbutton',....
        'ToolTip','Show overlapping peaks as the same size as the indiv. peaks.');
    % prepare the image fot the button
    [img,~,alpha]=imread('suppress.png');
    img = im2double(img);
    alpha = im2double(alpha);
    safepict = img.*alpha + permute([0.75 0.75 0.75],[1 3 2]).*(1-alpha);
    pb_suppress_peak.CData=safepict;
    PB_expand_peak=uicontrol('Parent',pl_overlap_EIC, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@change_overlapping_scale,'expand',ax_overlap}, ...
        'Position',[0.84 0.60 0.14 0.19], ...
        'Style','pushbutton',....
        'ToolTip','Show expanded peaks by displaying the peaks only.');
    % prepare the image fot the button
    [img,~,alpha]=imread('expand.png');
    img = im2double(img);
    alpha = im2double(alpha);
    safepict = img.*alpha + permute([0.75 0.75 0.75],[1 3 2]).*(1-alpha);
    PB_expand_peak.CData=safepict; % assign the button image
    PB_normalized_peak=uicontrol('Parent',pl_overlap_EIC, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@change_overlapping_scale,'normalize',ax_overlap}, ...
        'Position',[0.84 0.40 0.14 0.19], ...
        'Style','pushbutton',....
        'ToolTip','Show normalzed peaks.');
    % prepare the image fot the button
    [img,~,alpha]=imread('normalize.png');
    img = im2double(img);
    alpha = im2double(alpha);
    safepict = img.*alpha + permute([0.75 0.75 0.75],[1 3 2]).*(1-alpha);
    PB_normalized_peak.CData=safepict;% assign the button image
    PB_resume_peak=uicontrol('Parent',pl_overlap_EIC, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@change_overlapping_scale,'resume',ax_overlap}, ...
        'Position',[0.84 0.20 0.14 0.19], ...
        'Style','pushbutton',....
        'ToolTip','Show resumed peaks.');
    % prepare the image fot the button
    [img,~,alpha]=imread('resume.png');
    img = im2double(img);
    alpha = im2double(alpha);
    safepict = img.*alpha + permute([0.75 0.75 0.75],[1 3 2]).*(1-alpha);
    PB_resume_peak.CData=safepict; % assign the button image
    pl_indiv_EIC=uipanel('Parent',pl_more_comp, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','none',... 
        'Position',[0.0 0.0 1.0 0.8]);
    for i=2:5
        axes('Parent',pl_indiv_EIC, ...
            'Units','normalized', ...
            'Position',[0.08 0.05+0.19*(i-1) 0.73 0.15], ...
            'XTickLabel','',...
            'Tag',['ax_sub',num2str(6-i)]);
    end
    axes('Parent',pl_indiv_EIC, ...
            'Units','normalized', ...
            'Position',[0.08 0.05 0.73 0.15], ...
            'Tag','ax_sub5');
    uicontrol('Parent',pl_indiv_EIC, ...
        'Units','normalized', ...
        'Enable','off',...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@show_compound_in_nearby_files,0,0,hdlrec,hdlmeth,fig,false}, ...
        'Position',[0.85 0.05 0.1 0.95], ...
        'Style','slider',...        
        'Tag','SL_comp');
    ax=axes('Parent',pl_cur_comp, ...
        'Units','normalized', ...
        'FontSize',12,...
        'NextPlot','add', ...
        'Position',[0.11 0.4 0.88 0.52], ...
        'XColor',[0 0 0], ...
        'XGrid','off', ...
        'YColor',[0 0 0], ...
        'YGrid','on', ...
        'Tag','AX_EIC');
    ax.XLabel.String='Retention Time';
    ax.XLabel.FontSize=14;
    ax.YLabel.String='Intensity';
    ax.YLabel.FontSize=14;
    ax.Toolbar.Visible = 'on';
    ax.YAxis.Exponent = 0;
    % modify the position of identified compound 
    pl_chg_EIC=uipanel('Parent',pl_cur_comp, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','none',... 
        'Position',[0.03 0.03 0.25 0.25]);
    % a miniature of the TIC or the heatmap
    axm=axes('Parent',pl_chg_EIC, ...
        'Units','normalized', ...
        'NextPlot','add', ...
        'Position',[0.2 0.2 0.6 0.6], ...
        'XColor',[0 0 0], ...
        'XTick','',...
        'YColor',[0 0 0], ...
        'YTick','',...
        'Tag','AX_miniature');
    axm.Toolbar.Visible = 'off';
    uicontrol('Parent',pl_chg_EIC, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@change_EIC,'left',hdlmeth,hdlastc,hdlmtx,hdlimg}, ...
        'Position',[0 0.4 0.2 0.2], ...
        'String','<', ...
        'Style','pushbutton',....
        'Tag','PB_prev_comp',...
        'ToolTip','Inspect the EIC of the previous compound.');
    uicontrol('Parent',pl_chg_EIC, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@change_EIC,'right',hdlmeth,hdlastc,hdlmtx,hdlimg}, ...
        'Position',[0.8 0.4 0.2 0.2], ...
        'String','>', ...
        'Style','pushbutton',...
        'Tag','PB_next_comp',...
        'ToolTip','Inspect the EIC of the next compound.');
    uicontrol('Parent',pl_chg_EIC, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@change_EIC,'up',hdlmeth,hdlastc,hdlmtx,hdlimg}, ...
        'Position',[0.4 0.8 0.2 0.2], ...
        'String','^', ...
        'Style','pushbutton',...
        'Tag','PB_prev_samp',...
        'ToolTip','Inspect the EIC of the previous sample.');
    uicontrol('Parent',pl_chg_EIC, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@change_EIC,'down',hdlmeth,hdlastc,hdlmtx,hdlimg}, ...
        'Position',[0.4 0.0 0.2 0.2], ...
        'String','v', ...
        'Style','pushbutton',...
        'Tag','PB_next_samp',...
        'ToolTip','Inspect the EIC of the next sample.');
    % standard curve of the compound
    axs=axes('Parent',pl_cur_comp, ...
        'Units','normalized', ...
        'NextPlot','add', ...
        'Position',[0.36 0.07 0.22 0.18], ...
        'XColor',[0 0 0], ...
        'YColor',[0 0 0], ...
        'Tag','AX_std_curve');
    axs.Toolbar.Visible = 'off';
    % checkbox for showing figure legend
    uicontrol('Parent',pl_cur_comp, ...
        'Units','normalized', ...
        'Fontsize',14, ...
        'BackgroundColor',bgcolor, ...
        'CallBack',@change_view, ...
        'Position',[0.05 0.295 0.15 0.03],...
        'String','Show Legend', ...
        'Style','checkbox',...
        'Value',1,...
        'Tag','cb_show_legend');
    uicontrol('Parent',pl_cur_comp, ...
        'Units','normalized', ...
        'Fontsize',14, ...
        'BackgroundColor',bgcolor, ...
        'CallBack',@change_view, ...
        'Position',[0.23 0.295 0.24 0.03],...
        'String','Show Compound Detail', ...
        'Style','checkbox',...
        'Value',0,...
        'Tag','cb_show_detail');
    uicontrol('Parent',pl_cur_comp, ...
        'Units','normalized', ...
        'Fontsize',14, ...
        'FontWeight','bold',...
        'BackgroundColor',bgcolor, ...
        'Position',[0.52 0.295 0.2 0.03],...
        'String','Quantitation Status: ', ...
        'HorizontalAlignment','left',...
        'Style','text');
    uicontrol('Parent',pl_cur_comp, ...
        'Units','normalized', ...
        'Fontsize',14, ...
        'FontWeight','bold',...
        'BackgroundColor',bgcolor, ...
        'Position',[0.72 0.295 0.29 0.03],...
        'String','', ...
        'HorizontalAlignment','left',...
        'Style','text',...
        'Tag','txt_status');
    % display quantitation status 
    pl_correct=uipanel('Parent',pl_cur_comp, ...
        'Title','Correction Methods',...
        'Fontsize',14,...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','line',... 
        'HighLightColor','k',...
        'Position',[0.6 0.04 0.25 0.24]);
    uicontrol('Parent',pl_correct, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@adjust_quantitation_status,hdlrec,hdlmeth,hdlpara,fig,ax}, ...
        'Position',[0.03 0.01 0.94 0.19], ...
        'String','Adjust Quant. Status', ...
        'Style','pushbutton',...
        'Tag','PB_adj_status',...
        'ToolTip','Manually adjust the peak quantitation status. Status will be updated accordingly.');
    uicontrol('Parent',pl_correct, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@adjust_background,hdlrec,hdlmeth,hdlpara,hdlastc,hdlimg,fig,ax}, ...
        'Position',[0.03 0.21 0.94 0.19], ...
        'String','Adjust Background', ...
        'Style','pushbutton',...
        'Tag','PB_adj_bg',...
        'ToolTip','Manually adjust the background intensity. Peak abundance will be updated accordingly.');
    uicontrol('Parent',pl_correct, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@ref_select,hdlrec,hdlmeth,hdlpara,hdlastc,fig}, ...
        'Position',[0.03 0.41 0.94 0.19], ...
        'String','Select a Reference', ...
        'Style','pushbutton',...
        'ToolTip','RTs of compound peaks of the reference sample are used for peaks detection in other samples.');
    uicontrol('Parent',pl_correct, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@reassign,hdlrec,hdlmeth,hdlpara,hdlastc,hdlimg,fig,ax}, ...
        'Position',[0.03 0.61 0.94 0.19], ...
        'String','Select a Peak', ...
        'Style','pushbutton',...
        'Tag','PB_sel_peak',...
        'ToolTip','Signals of the specified peak are integrated. Deconvolution will be performed if the peak is coeluted.');
    uicontrol('Parent',pl_correct, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@rect_selection,hdlrec,hdlmeth,hdlpara,hdlastc,hdlimg,fig,ax}, ...
        'Position',[0.03 0.81 0.94 0.19], ...
        'String','Select a Region', ...
        'Style','pushbutton',...
        'Tag','PB_sel_region',...
        'ToolTip','Signals in the region are integrated. No deconvolution will be performed.');
    uicontrol('Parent',pl_cur_comp, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@show_more_compound,pl_cur_comp,pl_more_comp,hdlrec,hdlmeth,fig}, ...
        'Position',[0.87 0.22 0.12 0.05], ...
        'String','More >', ...
        'Style','pushbutton',...
        'UserData',0,...
        'Tag','PB_show_more',...
        'Tooltip','Show EICs of the current compound in different files');
    uicontrol('Parent',pl_cur_comp, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@export_EIC,ax}, ...
        'Position',[0.87 0.13 0.12 0.05], ...
        'String','Export', ...
        'Style','pushbutton',...
        'Tooltip','Export the current EIC plot to an image file');
    % button to close the inspection
    uicontrol('Parent',pl_cur_comp, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@hide_figure,fig}, ...
        'Position',[0.87 0.04 0.12 0.05], ...
        'String','Close');
    if strcmpi(fromwhere,'TIC') % called by clicking on a TIC plot
        % generate the miniature of the TIC plot
        % load standard compound info
        method=get(findobj('Tag','pl_comp'),'UserData');
        % load quantation results
        rec=get(findobj('Tag','MRM_Quant'),'UserData');
        lhdl=findobj('Tag','list_file');
        idx=lhdl.Value;
        if ~isempty(method) % standard compound info has been provided
            % denote the locations of the targeted compounds
            compnum=length(method.rt);
            peaknum=0;
            for i=1:compnum % compute total peaks in the TIC
                peaknum=peaknum+length(method.rt{i});
            end
            xcord=zeros(peaknum,1);
            ycord=zeros(peaknum,1);
            sidx=1;
            for i=1:compnum % combine spectra of all compounds
                rtnum=length(method.rt{i});
                xcord(sidx:(sidx+rtnum-1))=method.rt{i};
                ycord(sidx:(sidx+rtnum-1))=1.2*max(rec{idx}.tic(:,2))*ones(rtnum,1);
                sidx=sidx+rtnum;
            end
            xcord=xcord(xcord>0);
            ycord=ycord(xcord>0);
            line(axm,[xcord xcord],[zeros(length(ycord),1) ycord],'color',[0.7 0.7 0.7],'linewidth',1);
        end
        % plot original TIC
        stem(axm,rec{idx}.tic(:,1),rec{idx}.tic(:,2),'markersize',1,'color','k');
        set(findobj('Tag','PB_prev_samp'),'Visible','off'); % in the TIC plot mode, it is forbidden to browse the previous file
        set(findobj('Tag','PB_next_samp'),'Visible','off'); % in the TIC plot mode, it is forbidden to browse the next file
        axis(axm,'tight');
    else %called by clicking on a heat map
        % generate the miniature of the heat map
        mtx=hdlimg.CData;
        cmin=min(min(mtx,[],'omitnan')); %NaN is not included
        cmax=max(max(mtx,[],'omitnan')); %NaN is not included
        mtx(isnan(mtx))=cmin;
        mtx(isinf(mtx))=cmax;
        if cmin == cmax
            if cmin == 0
                cmax=1;
            else
                cmax=1.1*cmax;
                cmin=0.9*cmin;
            end
        end
        para=hdlpara.UserData;
        alpha=hdlimg.UserData;
        if para.show_ambiguous_comp
            showalpha=alpha;
        else
            showalpha=ones(size(alpha));
        end
        if para.take_log
            lmtx=log(mtx+4);
            showalpha(isnan(lmtx))=0;
            imagesc(axm,lmtx,'AlphaData',showalpha,'Tag','im_heatmap_mini');
            axm.CLim = [log(cmin+4),log(cmax+4)];
        else
            imagesc(axm,mtx,'AlphaData',showalpha,'Tag','im_heatmap_mini');
            axm.CLim = [cmin,cmax];
        end
        set(axm,'XTick','','XLim',hdlmtx.XLim,'YTick','','YLim',hdlmtx.YLim,...
            'YDir',hdlmtx.YDir,'CLim',hdlmtx.CLim,'Colormap',hdlmtx.Colormap);
        axis(axm,'tight');
    end
    axes(ax);
end
% ---------------------------------------------------
% hide a figure
% ---------------------------------------------------
function hide_figure(~,~,fobj)
    set(fobj,'Visible','off','Hittest','off');
    if get(findobj('Tag','rb_quantifier_sel'),'Value')==1
        set(findobj('Tag','PB_quantifier_ratio'),'Enable','on');
    end
end
% ---------------------------------------------------
% close a figure
% ---------------------------------------------------
function close_figure(~,~,fobj)
    close(fobj);
end
% --------------------------------------------------------------
% Change the scale of the overlapping plot
% --------------------------------------------------------------
function change_overlapping_scale(~,~,method,ax_overlap)
    switch method
        case 'expand' % expand the width of the peak curves
            hdl=findobj(ax_overlap,'type','line');
            xdata=get(hdl,'XData');
            xmin=min(cellfun(@min,xdata));
            xmax=max(cellfun(@max,xdata));
            set(ax_overlap,'XLim',[xmin, xmax]);
        case 'suppress'  % show the original height of the peak curves
            set(ax_overlap,'XLim',get(findobj('Tag','ax_sub1'),'XLim'));
        case 'normalize' % normalize the height of the peak curves
            hdl=findobj(ax_overlap,'type','line');
            ydata=get(hdl,'YData');
            ymax=cellfun(@max,ydata);
            ydata=cellfun(@(x,y)x/y,ydata,num2cell(ymax),'UniformOutput',false);
            set(hdl,{'YData'},ydata); % set YData in cell format
        otherwise % resume original width of the peak curves
            hdl=findobj(ax_overlap,'type','line');
            set(hdl,{'YData'},get(ax_overlap,'UserData'));
    end
end
%--------------------------------------------------------------
% deconvolute the overlapped peaks and recompute their abundances in all files
%--------------------------------------------------------------
function peak_quantitation_all(hobj, ~,target)
    % delete the EIC inspection window if exists
    fig=findobj('Tag','fg_EIC');
    if ~isempty(fig), delete(fig); end
    % load compound info
    hdlrec=findobj('Tag','MRM_Quant');
    hdlmeth=findobj('Tag','pl_comp');
    hdlpara=findobj('Tag','pl_para');
    hdlmtx=findobj('Tag','AX_heat_map');
    hdlastc=findobj('Tag','rb_abs_stc');
    phdl=findobj('Tag','PB_quant');
    fhdl=findobj('Tag','list_file');
    % load parameters
    para=hdlpara.UserData;
    % progress bar handles
    pg_bar=findobj('Tag','pg_bar');
    pg_text=findobj('Tag','pg_text');
    % set the text of the start button from "start" in green to "stop" in red
    start_quant_string='<html><font color="green"><p style="text-align:center;">Start<br>Quantitation</p></html>';
    stop_quant_string='<html><font color="red"><p style="text-align:center;">Stop<br>Quantitation</p></html>';
    stop_quant = contains(hobj.String,'Stop'); % check if the user terminate the program in the middle of the quantitation process
    % check whether the button is pressed to starting a new quantitation
    % or to stop an existing one
    if strcmpi(hobj.String,start_quant_string) % a new quantitation task
        hobj.String=stop_quant_string;
        if strcmpi(target,'standard') && para.abs_stc
            phdl.UserData='Standard+'; % quantitate standard compounds 
        else
            phdl.UserData='Sample+'; % quantitate sample compounds 
        end
        hobj.Value=1;
    elseif stop_quant % the user click the "stop quantitation" button during the quantitation process
        phdl.UserData=[phdl.UserData,'Stop'];
        hobj.Value=0;
        return
    end
    % turn off Inspection Mode
    set(findobj('Tag','PB_inspect_mode'),'String','Activate Inspection Mode','Value',0);
    % load experiment data
    exp=hdlastc.UserData;
    % start to perform quantitation
    if strcmpi(target,'sample') % the data is a testing sample
        pg_text.String='Perform sample quantitation...';
        % load expected compound info
        method=hdlmeth.UserData;
        % load file info
        filelist=fhdl.String;
        fileno=length(filelist);
        set(fhdl,'min',0,'max',fileno,'value',[]);
        save_result=true;
        % perform parameter check
        is_passed=parameter_check;
        if ~is_passed
            return
        end
    else % perform quantitation on the input standards
        set(pg_text,'String','Computing standard curve...');
        hdlmeth=hdlastc;
        method=hdlmeth.UserData;
        filelist=exp.fname;
        fileno=length(filelist);
        fhdl=findobj('Tag','tbl_std_file');
        save_result=false;
        set(findobj('Tag','PB_TIC_Heat'),'Enable','off');
    end
    nos=length(method.rt);
    name=find_representative_name(filelist);
    % initialize heat map
    change_plot('','','HeatMap');
    % disable the functions during computation
    mtx=ones(fileno,method.nocomp,2);
    hdlmtx.UserData=mtx;
    cla(hdlmtx);
    im=imagesc(hdlmtx,'CData',mtx(:,:,1),'AlphaData',mtx(:,:,1),'UserData',mtx(:,:,1),...
        'Tag','im_heatmap','ButtonDownFcn',{@heat_map_selection,hdlmtx});
    pos=hdlmtx.Position;
    % set up x-label
    hdlmtx.XTick=1:method.nocomp;
    xtickangle(hdlmtx,90);
    hdlmtx.XLabel.String = 'Compounds';
    hdlmtx.XLabel.FontSize = 14;
    hdlmtx.XLim=[0.5 max(method.nocomp+0.5,1.5)];
    if para.xlabel==1
        maxlen=max(cell2mat(cellfun(@(x)length(x),method.indiv_name,'UniformOutput',false))); % find the longest compound name
        p2=0.13+(maxlen-2)*0.0086;
        p4=0.95-p2;
        hdlmtx.Position=[pos(1) p2 pos(3) p4];
        hdlmtx.XTickLabel=method.indiv_name;
    else
        hdlmtx.Position=[pos(1) 0.13 pos(3) 0.82];
        hdlmtx.XTickLabel=cellfun(@(x)num2str(x),num2cell(1:method.nocomp),'UniformOutput',false);
    end
    % set up y-label
    hdlmtx.YTick=1:fileno;
    hdlmtx.YLabel.String = 'Samples';
    hdlmtx.YLabel.FontSize = 14;
    hdlmtx.YLim=[0.5 max(fileno+0.5,1.5)];
    if para.ylabel==1
        maxlen=max(cell2mat(cellfun(@(x)length(x),name,'UniformOutput',false))); % find the longest sample name
        p1=0.03+(maxlen-1)*0.004;
        p3=0.93-p1;
        hdlmtx.Position=[p1 pos(2) p3 pos(4)];
        hdlmtx.YTickLabel=name;
    else
        hdlmtx.Position=[0.03 pos(2) 0.90 pos(4)];
        hdlmtx.YTickLabel=cellfun(@(x)num2str(x),num2cell(1:fileno),'UniformOutput',false);
    end
    hdlmtx.Toolbar.Visible = 'on';
    hdlmtx.TickLabelInterpreter='none';
    colorbar(hdlmtx);
    % turn off all controls when the calculation is proceeded
    set(findall(findobj('Tag','pl_data'),'-property','enable'),'enable','off');
    set(findall(hdlmeth,'-property','enable'),'enable','off');
    set(findall(hdlpara,'-property','enable'),'enable','off');
    set(findall(findobj('Tag','pl_plot'),'-property','enable'),'enable','off');
    set(findobj('Tag','PB_save_result'),'enable','off');
    isAbsQuant=para.abs_int | para.abs_stc; 
    % handle of the show message button
    phhdl=findobj('Tag','PB_show_msg');
    phhdl.Enable='on';
    % handles of message list
    meglist=findobj('Tag','quant_msg');
    % For each file, find the known compounds and compute their intensity sum
    for i=1:fileno
        if contains(phdl.UserData,'Stop') % user stop the quantitation process
            answer = questdlg({'\fontsize{12}Do you really want to stop the quantitation process?','All the computed data will be lost.'},'Data Loss Warning','Yes','No',struct('Default','No','WindowStyle','modal','Interpreter','tex')); 
            if strcmpi(answer,'Yes') % terminate the quantitation process
                stop_quantitation('','');
                return
            else % continue the quantitation process
                phdl.UserData=erase(phdl.UserData,'Stop');
            end
        end
        % perform compound detection in a single file
        peak_quantitation_file('','',i,target,hdlrec,hdlmeth,hdlpara,hdlastc,pg_bar,pg_text,phhdl,meglist);
        % load quantitation info
        rec=hdlrec.UserData;
        % convert the abundance to concentration if absolute quantitation is selected
        if isAbsQuant    
            if para.abs_int % absolute quantitation via internal standards
                for j=1:nos
                    ISID=strcmpi(method.orig_name,method.IS{j}); % the internal standard of the j-th compound
                    isproblem=false;
                    QuantMsg=meglist.String;
                    if ~any(ISID)
                        msg=['The ',num2str(j),'-th designated internal standard ',method.IS{j},' is not found in the list'];
                        isproblem=true;
                    elseif sum(ISID)>1
                        msg=['The ',num2str(j),'-th designated internal standard ',method.IS{j},' has multiple matches in the list'];
                        isproblem=true;
                    elseif (rec{i}.abundance{ISID}(1)<1e-8) % if the abundance of the internal standard is close to zero
                        msg=['The designated internal standard ',method.IS{j},' is not found in ',name{i}];
                        isproblem=true;
                    elseif isempty(method.conc(j)) % if the concentration of the internal standard is not provided
                        msg=['The relative concentration multiplier for ',method.IS{j},' is not set'];
                        isproblem=true;
                    end
                    if isproblem
                        if ~any(strcmp(QuantMsg,msg))
                            meglist.String=[QuantMsg;{msg}];
                            if ~phhdl.UserData
                                show_quantitation_message('','',1,hdlpara);
                            end
                        end
                    end
                    peaknum=length(method.rt{j});
                    rec{i}.conc_org{j}=-1*ones(peaknum,1);
                    for k=1:peaknum % the j-th EIC  contains multiple compounds
                        if isproblem % if any of the above problems is presented
                            rec{i}.conc_org{j}(k)=NaN;
                        else
                            rec{i}.conc_org{j}(k)=max(0.0,rec{i}.abundance{j}(k)/rec{i}.abundance{ISID}(1)*method.conc(j));
                        end
                        if isnan(rec{i}.conc_org{j}(k)) && (rec{i}.quant_note{j}(k)<3) && (rec{i}.abundance{ISID}(1) == 0)
                            rec{i}.quant_note{j}(k)=5; % int. std. unquantiable
                        end
                        rec{i}.concentration{j}(k)=rec{i}.conc_org{j}(k);
                    end
                end
            else % absolute quantitation via standard curves
                for j=1:nos
                    if ~isempty(method.IS)
                        ISID=strcmpi(method.orig_name,method.IS{j}); % the internal standard of the j-th compound
                        ref_abund=rec{i}.abundance{ISID}(1);
                    elseif (method.ISidx~=-1)
                        if method.ISidx > 0
                            ref_abund=rec{i}.abundance{exp.EICidx(method.ISidx,2)}(exp.EICidx(method.ISidx,3));
                        else
                            ref_abund=1;
                        end
                    else
                        ref_abund=1;
                    end
                    peaknum=length(method.rt{j});
                    rec{i}.conc_org{j}=-1*ones(peaknum,1);
                    for k=1:peaknum % the j-th EIC  contains multiple compounds
                        if strcmpi(target,'sample') % the data is a testing sample
                            idx=(exp.EICidx(:,2)==j) & (exp.EICidx(:,3)==k);
                            try
                                [rec{i}.conc_org{j}(k),flag]=find_conc_from_standard_curve(exp,idx,rec{i}.abundance{j}(k)/ref_abund);
                            catch
                                rec{i}.conc_org{j}(k) = NaN;
                                flag = true;
                            end
                            if flag || isnan(rec{i}.conc_org{j}(k))
                                QuantMsg=meglist.String;
                                meglist.String=[QuantMsg;{['Quadratic regression failed for ',exp.indiv_name{idx},' in ',filelist{i},' ! Use linear regression instead.']}];
                                if ~phhdl.UserData
                                    show_quantitation_message('','',1,hdlpara);
                                end
                            end
                            if isnan(rec{i}.conc_org{j}(k)) && (rec{i}.quant_note{j}(k)<3) && (ref_abund == 0)
                                rec{i}.quant_note{j}(k)=5; % int. std. unquantiable
                            end
                        else % the data is a standard sample
                            rec{i}.conc_org{j}(k) = method.conc(i); % set the conentration as expected for now, it will be recomputed in compute_standard_curve
                        end
                        rec{i}.concentration{j}(k)=rec{i}.conc_org{j}(k);
                    end % end of for k=1:peaknum
                end % end of for j=1:nos
            end % end of if para.abs_int
            hdlrec.UserData=rec;
        end % end of if isAbsQuant
        % draw heat map sample by sample
        try
            draw_quantitation_heat_map(i,hdlrec,hdlmeth,hdlpara,hdlmtx,im);
        catch
            msg=sprintf('Error displaying quantitation result for %s !',name{i});
            hdl=errordlg(msg,'Quantitation Result Display Error',struct('WindowStyle','modal','Interpreter','tex'));
            waitfor(hdl);
            return;
        end
        if strcmpi(target,'sample') % the data is a testing sample
            set(fhdl,'min',0,'max',fileno,'value',1:i); % show the progress in file list
        end
        pause(0.005);
    end % end of iteratively quantitating MRM files 
    % perform cross-sample check for inconsistence in RT
    %cross_sample_check(target,hdlrec,hdlmeth,hdlpara,hdlastc);
    % adjust peak abundances by performing batch effect correction and update
    % peak concentrations and heatmap
    if strcmpi(target,'sample') && get(findobj('Tag','cb_normal'),'Value') % batch effect correction is checked
        set(pg_text,'String','Performing batch effect correction...');
        batch_effect_correction(hdlrec,hdlmeth,hdlastc,hdlpara,hdlmtx,[1,fileno,1,method.nocomp]);
        set(pg_text,'String','Performing batch effect correction...done!');
        % update the heatmap
        set(pg_text,'String','Updating heatmap...');
        change_heatmap_abundent('','',hdlrec,hdlmeth,hdlpara,hdlmtx);
        set(pg_text,'String','');
    end
    % the quantitation process is finished
    hobj.String=start_quant_string;
    % stop showing the progress in file list
    if strcmpi(target,'sample')% the data is a testing sample
        set(fhdl,'min',0,'max',1,'value',1); % stop showing the progress in file list
    end
    % update the grid lines
    show_grid('','',hdlmtx,hdlpara);
    if strcmpi(target,'sample') % the data is a testing sample
        % change plot view to heat map
        change_plot('','','HeatMap');
        % turn on all controls when the calculation is proceeded
        set(findall(findobj('Tag','pl_data'),'-property','enable'),'enable','on');
        set(findall(findobj('Tag','pl_comp'),'-property','enable'),'enable','on');
        set(findall(hdlpara,'-property','enable'),'enable','on');
        set(findall(findobj('Tag','pl_plot'),'-property','enable'),'enable','on');
        set(findobj('Tag','PB_quantifier_ratio'),'enable','off'); % keep quantifier_ratio off
        set(findobj('Tag','PB_TIC_Heat'),'Enable','on');
        set(findobj('Tag','PB_save_result'),'enable','on');
    end
    % adjust the Visible region
    suc1=false;suc2=false;
    while ~(suc1 && suc2)
        suc1=reset_view_file_num('','',hdlmtx,hdlpara);
        suc2=reset_view_compound_num('','',hdlmtx,hdlpara);
    end
    % show compound info in heatmap
    set(hdlrec,'WindowButtonMotionFcn',@cursorPos,'WindowKeyPressFcn',@KeyDirect);
    % reset progress bar
    set(pg_bar,'Position',[0.0 0.0 0.0 1.0],'FaceColor','b')
    set(pg_text,'String','');
    if para.quantifier_sel==1
        waitfor(compute_ion_ratio(hdlmeth,hdlmtx),'visible','on');
    end
    % write data to a csv file
    if save_result
        save_quantitation_result('','',hdlrec,hdlmeth,hdlastc,hdlpara); % save quantitation result
    else % standard curve data were quantitated. Start to generate standard curve
        compute_standard_curve(hdlrec,hdlmeth,hdlastc,hdlpara);
    end
end
%--------------------------------------------------------------
% stop the quantitation process
%--------------------------------------------------------------
function stop_quantitation(~,~)
    fhdl=findobj('Tag','reg_result');
    if ~isempty(fhdl)
        close(fhdl);
    end
    phdl=findobj('Tag','PB_quant');
    phdl.String='<html><font color="green"><p style="text-align:center;">Start<br>Quantitation</p></html>';
    para=get(findobj('Tag','pl_para'),'UserData');
    if para.abs_stc
        if contains(phdl.UserData,'Standard')
            phdl.UserData='New';
        else
            phdl.UserData='Standard';
        end
    else
        phdl.UserData='New';
    end
    set(findobj('Tag','list_file'),'min',0,'max',1,'value',1); % stop showing the progress in file list
    % turn on all controls when the calculation is proceeded
    hdlpara=findobj('Tag','pl_para');
    set(findall(findobj('Tag','pl_data'), '-property', 'enable'), 'enable', 'on');
    set(findall(findobj('Tag','pl_comp'), '-property', 'enable'), 'enable', 'on');
    set(findall(hdlpara, '-property', 'enable'), 'enable', 'on');
    set(findall(findobj('Tag','pl_plot'), '-property', 'enable'), 'enable', 'on');
    hdlaxhm=findobj('Tag','AX_heat_map');
    reset_view_file_num('','',hdlaxhm,hdlpara);
    reset_view_compound_num('','',hdlaxhm,hdlpara);
    pg_bar=findobj('Tag','pg_bar');
    pg_text=findobj('Tag','pg_text');
    set(pg_bar,'Position',[0.0 0.0 0.0 0.0])
    set(pg_text,'String','');
    set(findobj('Tag','MRM_Quant'),'WindowButtonMotionFcn',@cursorPos,'WindowKeyPressFcn',@KeyDirect);
end
%--------------------------------------------------------------
% deconvolute the overlapped peaks and recompute their abundances
% in a single file
%--------------------------------------------------------------
function peak_quantitation_file(~,~,index,target,hdlrec,hdlmeth,hdlpara,hdlastc,pg_bar,pg_text,msghdl,meglist)
    % set parameters
    para=hdlpara.UserData;
    qhdl=findobj('Tag','PB_quant');
    if strcmpi(target,'sample') % the data is a testing sample
        % load expected compound info
        method=hdlmeth.UserData; % information of the standard compound in the method file
        % extract file info
        fhdl=findobj('Tag','list_file');
        filelist=fhdl.String;
        % extract quantitation parameters
        bi_auto_detect=para.bg_auto; % if the background intensity is determined automatically
        sn_ratio=para.sn_ratio; % signal-to-noise ratio
        sw_auto_detect=para.smooth_auto; % if the smoothing window size is determined automatically
        smooth_win=para.smooth_win;
        min_peak_width=para.min_peak_width;
        min_peak_dist=para.min_peak_dist;
        min_rt_diff=min_peak_width/4; % min. RT difference allowed for deconvoluting coeluted peaks
        bg_int=para.bg_int;
    else % construct standard curves
        method=hdlastc.UserData;
        bi_auto_detect=method.auto_bg; % if the background intensity is determined automatically
        bg_int=method.bg_int;
        sn_ratio=method.sn_ratio;
        sw_auto_detect=method.auto_smooth; % if the background intensity is determined automatically
        smooth_win=method.smooth_win;
        min_peak_width=method.min_peak_width;
        min_peak_dist=method.min_peak_dist;
        min_rt_diff=method.min_peak_width/4;
        filelist=method.fname;
    end
    % find the number of files
    fileno=length(filelist);
    % --------------------------------------------------------------------------------
    %rec.tic: TIC of the record;
    %rec.name: file name of the record;
    %rec.data: RT and abundance of the record;
    %rec.mz: precursor-product m/z values of the record;
    %rec.batch_QC: whether the record is a QC sample;
    %rec.batch_ref: whether the record is a reference when performing batch effect correction;
    %rec.batch_end: whether the record is at the end of a batch
    %rec.batch_no: the batch number of the record;
    %rec.pidx: the detected peak tip candidates
    %rec.is_compound: whether a signal belongs to the detected peak group
    %rec.is_peak: whether a signal belongs to a peak tip of a std comp
    %rec.is_match_std: whether the detected peak tip matches to a std comp
    %rec.is_defined_by_bound: whether the peak is defined by left and right bounds (usually a noisy peak)
    %rec.abundance: abundance of each matched std comp
    %rec.abund_adjust_ratio: the ratio between normalized and the original abundances
    %rec.concentration: abundance of each matched std comp
    %rec.coelute: coeluation situation of each detected peak group
    %rec.decomp: RT and intensity of decomposed signals
    %rec.bdp: indices of the left- and right- boundary of the detected peaks group
    %rec.smoothy: smoothed intensity of the EIC
    %rec.bg_int: intensity of background noise of the 
    % ---------------------------------------------------------------------------------
    nos=length(method.rt); % number of standard compounds in the method file
    rec=hdlrec.UserData; % the data structure to store the quantitation information
    % match the peaks with known metabolites
    rec{index}.pidx=cell(nos,1); % for each peak (from find_peak), record its index in the raw data
    rec{index}.is_compound=cell(nos,1); % mark whether a raw data belong to the detect peaks
    rec{index}.is_peak=cell(nos,1); % whether a signal belongs to a peak tip of a std comp
    rec{index}.quant_note=cell(nos,1); % note of the peak quantitation result (0 successful, 1 not in allowable RT range, ...
    % 2 multiple peaks in allowable RT range, 3 saturated, 4 defects in quantitation)
    rec{index}.is_match_std=cell(nos,1); % whether the detected peak tip matches to a std comp
    rec{index}.is_defined_by_bound=cell(nos,1); %whether the peak is defined by left and right bounds (usually a noisy peak)
    rec{index}.abundance=cell(nos,1); % normalized abundance of each matched std comp
    rec{index}.conc_org=cell(nos,1); % original abundance of each matched std comp
    rec{index}.concentration=cell(nos,1); % abundance of each matched std comp
    rec{index}.abund_adjust_ratio=cell(nos,1); % set the default batch effect correction ratio to 1
    rec{index}.coelute=cell(nos,1); % for each peak, detect coelution at both sides
    rec{index}.decomp=cell(nos,1); %  RT and intensity of decomposed signals
    rec{index}.bdp=cell(nos,1); % for each peak, record the left- and right- boundary points
    rec{index}.smoothy=cell(nos,1); % smoothed intensity of the EIC
    rec{index}.bg_int=cell(nos,1); % background intensity of the EIC
    % -----------------------------------------------------------
    % ### iterate through each EIC to quantify peak abundance ###
    % -----------------------------------------------------------
    compnum_MRM=length(rec{index}.mz);
    MRMmz=zeros(compnum_MRM,2);
    for i=1:compnum_MRM
        MRMmz(i,:)=rec{index}.mz{i};
    end
    useid=false(compnum_MRM,1); % recoed which MRM has found a match to a method compound
    matchid=zeros(nos,1);
    meghdl=findobj('Tag','quant_msg'); % message window handle
    for i=1:nos
        % find the best match the EIC data to the method compound i
        mzdiff=abs(MRMmz(:,1)-repmat(method.mz(i),compnum_MRM,1))+abs(MRMmz(:,2)-repmat(method.dmz(i),compnum_MRM,1));
        mindiff=min(mzdiff); % find the closest match
        minid=find(mzdiff==mindiff); % find the match indices
        if mindiff < 0.2
            candid=setdiff(minid,find(useid)); % find the candidates that have not been used
            if ~isempty(candid) % a match found
                matchid(i)=candid(1); % record the match index
                useid(candid(1))=true; % set the EIC index for been used
            else % no match can be found
                meghdl.String=[meghdl.String;{['No ion chromatogram is found to contain ',method.orig_name{i}]}];
            end
        end
    end
    % reorder the EIC according to the compound order in the method file
    rec{index}.data(matchid~=0)=rec{index}.data(matchid(matchid>0));
    rec{index}.mz(matchid~=0)=rec{index}.mz(matchid(matchid>0));
    rec{index}.data=rec{index}.data(1:nos);
    rec{index}.mz=rec{index}.mz(1:nos);
    remid=find(matchid==0);
    for i=1:length(remid)
        rec{index}.data{remid(i)}=zeros(1,2);
        rec{index}.mz{remid(i)}=zeros(1,2);
    end
    for i=1:nos % iterate through each standard compound in the method file
%         if index==3 && i==153 % debug code
%            disp('here');
%         end
        if contains(qhdl.UserData,'stop') % if the use press the "stop quantitation" button, terminate the quantitation process
            break;
        end
        nop=length(method.rt{i}); % number of compounds in the ith EIC
        dlen=length(rec{index}.data{i}(:,1)); % number of points in the ith EIC
        % initialize
        rec{index}.is_peak{i}=false(dlen,nop);
        rec{index}.is_compound{i}=false(dlen,nop); % mark whether a raw data belong to the detect peaks
        rec{index}.is_defined_by_bound{i}=true(nop,1);
        rec{index}.bdp{i}=zeros(nop,2);
        rec{index}.coelute{i}=false(nop,2);
        rec{index}.decomp{i}=zeros(dlen,nop);
        rec{index}.abundance{i}=-1*ones(nop,1);
        rec{index}.abund_adjust_ratio{i}=ones(nop,1);
        rec{index}.conc_org{i}=-1*ones(nop,1);
        rec{index}.concentration{i}=-1*ones(nop,1);
        rec{index}.quant_note{i}=zeros(nop,1);
        if matchid(i)==0,continue;end % problematic EIC
        % determine the background intensity
        if bi_auto_detect % if the background is set to be determined automatically
            rec{index}.bg_int{i}=repmat(prctile(rec{index}.data{i}(:,2),30),dlen,1);
        else
            rec{index}.bg_int{i}=repmat(bg_int,dlen,1);
        end
        % check for saturated signals
        maxv=max(rec{index}.data{i}(:,2));
        binv=rec{index}.data{i}(:,2)>0.995*maxv; % signals that are higher than 99.5% of the highest signal
        cumv=(cumsum(~binv)+1).*binv;
        repidx=nonzeros(cumv);
        idx=unique(repidx);
        blocklen=nonzeros(accumarray(repidx,1));
        longest=max(blocklen);
        % check for data quality for proper smoothing window
        if sw_auto_detect
            smooth_win=-1;
        end
        if maxv == 0 % no signal in this data
            sdata=rec{index}.data{i}(:,2);
            LOCS=[];
        elseif (longest >= 4) && (maxv > para.max_int)% possible of saturated signals
            % modify the saturated signals to a sharp tip so that the findpeak function 
            % can be performed successfully
            mody=rec{index}.data{i}(:,2);
            for j=1:length(idx)
                gid=find(cumv==idx(j));
                pid=gid(1)+floor(length(gid)/2);
                leftv=linspace(mody(gid(1)-1),mody(pid),pid-gid(1)+2);
                rightv=linspace(mody(pid),mody(gid(end)+1),gid(end)-pid+2);
                tempv=[leftv rightv(2:end)];
                mody(cumv==idx(j))=tempv(2:(end-1));
            end
            LOCS=rec{index}.data{i}(binv,1);
            for j=1:nop % check whether a target is saturated
                diff=abs(LOCS-method.rt{i}(j));
                tempid=diff <= method.rt_diff{i}(j);
                if sum(tempid)>2 % the peak of interesting is saturated
                    rec{index}.quant_note{i}(j)=3;
                end
            end
            % generate a smoothed data 
            [sdata,LOCS]=smoothing_and_find_peaks(rec{index}.data{i}(:,1),mody,rec{index}.bg_int{i},i,method,sn_ratio,min_peak_width,smooth_win,1.12);
        else
            % generate a smoothed data 
            [sdata,LOCS]=smoothing_and_find_peaks(rec{index}.data{i}(:,1),rec{index}.data{i}(:,2),rec{index}.bg_int{i},i,method,sn_ratio,min_peak_width,smooth_win,1.12);
        end
        % perform baseline correction
        sdata=sdata-rec{index}.bg_int{i};
        sdata(sdata<0)=0;
        % record the smoothed signal
        rec{index}.smoothy{i}=sdata;
        if method.rt{i}==-1 % No RT info in the method for this compound
            rec{index}.abundance{i}=0;
            continue;
        end
        if isempty(LOCS) % no peak is found.
            rec{index}.abundance{i}=zeros(nop,1);
            rec{index}.quant_note{i}=ones(nop,1); % no qualified peaks
            rec{index}.is_match_std{i}=false(nop,1);
            for j=1:nop 
                diff=abs(rec{index}.data{i}(:,1)-method.rt{i}(j));
                [~,minidx]=min(diff);
                rec{index}.is_peak{i}(minidx,j)=true; % record the peak tip
                rec{index}.bdp{i}(j,:)=[0 0]; % record the bound indices
            end
            continue;
        end
        % remove peaks detected close to both ends of the chromatogram to
        % avoid tracing out of bounds of the chromatogram
        totrt=rec{index}.data{i}(end,1)-rec{index}.data{i}(1,1);
        llimit=min(min(method.rt{i}(1)-min_peak_dist),rec{index}.data{i}(1,1)+(0.1*totrt));
        rlimit=max(max(method.rt{i}(end)+min_peak_dist),rec{index}.data{i}(end,1)-(0.1*totrt));
        kidx=(LOCS>llimit) & (LOCS<rlimit);
        LOCS=LOCS(kidx);
        % find the matched indices of the detected peaks and the original signal
        [~,tipidx]=ismember(LOCS,rec{index}.data{i}(:,1)); 
        PKS=rec{index}.data{i}(tipidx,2);
        rec{index}.pidx{i}=tipidx; % record the index of detected peaks
        % find the best match between expected compounds (method.rt) and
        % detected peaks (LOCS)
        try
            idx=findpeakmatch(LOCS,PKS,method.rt{i},method.rt_diff{i});
        catch % the peak is problematic
            rec{index}.abundance{i}=zeros(nop,1);
            rec{index}.quant_note{i}=ones(nop,1); % no qualified peaks
            rec{index}.is_match_std{i}=false(nop,1);
            for j=1:nop 
                diff=abs(rec{index}.data{i}(:,1)-method.rt{i}(j));
                [~,minidx]=min(diff);
                rec{index}.is_peak{i}(minidx,j)=true; % record the peak tip
                rec{index}.bdp{i}(j,:)=[0 0]; % record the bound indices
            end
            continue;
        end
        if all(idx==-1) % the peak is problematic
            rec{index}.abundance{i}=zeros(nop,1);
            rec{index}.quant_note{i}=ones(nop,1); % no qualified peaks
            rec{index}.is_match_std{i}=false(nop,1);
            for j=1:nop 
                diff=abs(rec{index}.data{i}(:,1)-method.rt{i}(j));
                [~,minidx]=min(diff);
                rec{index}.is_peak{i}(minidx,j)=true; % record the peak tip
                rec{index}.bdp{i}(j,:)=[0 0]; % record the bound indices
            end
            continue;
        end
        didx=zeros(size(idx));
        didx(idx>0)=tipidx(idx(idx>0));
        didx(idx<=0)=-1;
        % ### determine the peak information for the jth peak in the ith EIC ###
        for j=1:nop 
            msg=[];
            compoundid=(method.EICidx(:,2)==i) & (method.EICidx(:,3)==j);
            % check if the peak is within the allowable RT difference
            diff=abs(LOCS-method.rt{i}(j));
            tempid=find(diff <= method.rt_diff{i}(j));
            if isempty(tempid) || (didx(j)==-1) % no peak is in the allowable RT difference
                rec{index}.abundance{i}(j)=0;
                rec{index}.is_match_std{i}(j)=false;
                diff=abs(rec{index}.data{i}(:,1)-method.rt{i}(j));
                [~,minidx]=min(diff);
                rec{index}.is_peak{i}(minidx,j)=true; % record the peak tip
                rec{index}.bdp{i}(j,:)=[0 0]; % record the bound indices
                rec{index}.quant_note{i}(j)=1; % No qualified peak is found
                continue;
            end
            if length(tempid)>1 % multiple peaks are found in the allowable RT range
                rec{index}.quant_note{i}(j)=2; % multiple_possible-peaks
            end                
            % check whether the peak is obvious enough
            % 1. Whether the peak is lower than the average of the nearby (-5 ~ +5) signals
            c1=rec{index}.data{i}(didx(j),2)<mean(rec{index}.data{i}(max(1,(didx(j)-5)):min((didx(j)+5),dlen),2)); 
            % 2. Whether the peak not higher than half of the peaks in the EIC
            sd=sort(rec{index}.data{i}(:,2));
            c2=rec{index}.data{i}(didx(j),2)<sd(floor(dlen/2));
            if c1 && c2 % the peak is not qualified and thus is to be ignored 
                rec{index}.abundance{i}(j)=0;
                rec{index}.quant_note{i}(j)=1; % no qualified peaks
                rec{index}.is_match_std{i}(j)=false;
                diff=abs(rec{index}.data{i}(:,1)-method.rt{i}(j));
                [~,minidx]=min(diff);
                rec{index}.is_peak{i}(minidx,j)=true; % record the peak tip
                rec{index}.bdp{i}(j,:)=[0 0]; % record the bound indices
                continue;
            end
            % record the peak tip
            rec{index}.is_peak{i}(didx(j),j)=true;
            % the corresponding compound is detected
            rec{index}.is_match_std{i}(j)=true;
            %  trace the two ends of the peak for coelution
            try
                [bd,coelute,halfcount]=peak_tracing(rec{index}.data{i}(:,1),sdata,didx(j),rec{index}.bg_int{i},sn_ratio,min_rt_diff,min_peak_dist);
            catch
                rec{index}.quant_note{i}(j)=4; %defect quantitation
                msg=['The compound ',method.indiv_name{compoundid},' in file ',filelist{index},' cannot be successfully quantitated during peak tracing!'];
                bd=[didx(j) didx(j)];
                coelute=[false false];
                halfcount=[0 0];
            end
            % record the bound indices
            rec{index}.bdp{i}(j,:)=bd;
            % correct the coelution info if the peak is at the either end
            % of the signal
            if (idx(j) == 1) && coelute(1)
                coelute(1) = false;
            end
            if (idx(j) == length(LOCS)) && coelute(2)
                coelute(2) = false;
            end
            rec{index}.coelute{i}(j,:)=coelute;
            % record the signal from left to right bounds
            if ~any(bd<=0)
                rec{index}.is_compound{i}(bd(1):bd(2),j)=true;
            end
            rec{index}.decomp{i}(:,j)=zeros(size(rec{index}.data{i}(:,2)));
            % if the peak is coeluted and the user does not select "no deconvolution" 
            if any(coelute) && ~para.no_deconv && ~(rec{index}.quant_note{i}(j)==3)
                try
                    rec=peak_deconvolution(idx(j),index,i,j,rec,halfcount,rec{index}.bg_int{i},sn_ratio,min_rt_diff,min_peak_dist);
                    rec{index}.is_defined_by_bound{i}(j)=false;
                catch
                    msg=['The compound ',method.indiv_name{compoundid},' in file ',filelist{index},' cannot be successfully quantitated during deconvolution!'];
                    rec{index}.quant_note{i}(j)=4; %defect quantitation
                end
            elseif ~any(coelute) && para.always_deconv && ...
                    any(rec{index}.is_compound{i}(:,j)) % the peak is not coeluted, but the user select 'aways deconvolution"
                options=optimset('LargeScale','off','Display','off');
                curve=[rec{index}.data{i}(bd(1):bd(2),1) sdata(bd(1):bd(2))];
                halfcount=halfcount(halfcount>0);
                halfcount=halfcount(halfcount~=didx(j));
                sigma0=min(abs(rec{index}.data{i}(halfcount,1)-rec{index}.data{i}(didx(j),1)));
                % x: peak height, peak width, peak tip location
                x0=[sdata(didx(j));sigma0;rec{index}.data{i}(didx(j),1)];
                xlo=[0.7*sdata(didx(j));0.8*sigma0;rec{index}.data{i}(didx(j)-1,1)];
                xhi=[1.3*sdata(didx(j));1.2*sigma0;rec{index}.data{i}(didx(j)+1,1)];
                newx = fmincon(@(x) peak_approximation(x,curve),x0,[],[],[],[],xlo,xhi,[],options);
                y=newx(1)*gaussmf(curve(:,1),[newx(2) newx(3)]); % deconvoluted peak signals
                maxy=max(y);
                dlen=length(sdata);
                is_complete=(y(1)<0.05*maxy) && (y(end)<0.05*maxy);
                newbd=bd;
                llim=max(1,didx(j)-ceil(2.5*(didx(j)-halfcount(1))));
                rlim=min(dlen,didx(j)+ceil(2.5*(halfcount(2)-didx(j))));
                while ~is_complete
                    if (y(1)>0.05*maxy) && (newbd(1)>llim)
                        newbd(1)=newbd(1)-1;
                    end
                    if (y(end)>0.05*maxy) && (newbd(2)<rlim)
                        newbd(2)=newbd(2)+1;
                    end
                    y=newx(1)*gaussmf(rec{index}.data{i}(newbd(1):newbd(2),1),[newx(2) newx(3)]);
                    is_complete=((y(1)<0.05*maxy) || (newbd(1)<=llim)) && ((y(end)<0.05*maxy) || (newbd(2)>=rlim));
                end
                rec{index}.decomp{i}(:,j)=zeros(size(sdata));
                rec{index}.decomp{i}(newbd(1):newbd(2),j)=y+rec{index}.bg_int{i}(newbd(1):newbd(2));
                rec{index}.is_defined_by_bound{i}(j)=false;
            end
            % compute the peak aboundance
            tempdata=rec{index}.decomp{i}(:,j)-rec{index}.bg_int{i};
            sumid=tempdata>0;
            % use trapzoidal reule to compute peak area
            decomp_sum=trapz(rec{index}.data{i}(sumid,1),tempdata(sumid));
            if rec{index}.quant_note{i}(j)>=3 % the peak is saturated or falsely quantitated
                rec{index}.abundance{i}(j)=nan;
                rec{index}.decomp{i}(:,j)=zeros(dlen,1);
                QuantMsg=meglist.String;
                if isempty(msg)
                    if rec{index}.quant_note{i}(j)==3 
                        msg=['The compound ',method.indiv_name{compoundid},' in file ',filelist{index},' cannot be successfully quantitated due to saturation!'];
                    elseif rec{index}.quant_note{i}(j)==4 
                        msg=['The compound ',method.indiv_name{compoundid},' in file ',filelist{index},' cannot be successfully quantitated due to irregular shape!'];
                    end
                end
                meglist.String=[QuantMsg;{msg}];
                if ~msghdl.UserData
                    show_quantitation_message('','',1,hdlpara);
                end
            elseif sum(rec{index}.decomp{i}(:,j))>0 % the deconvoluted peak exists
                rec{index}.abundance{i}(j)=max(0,decomp_sum);
            else % sum up the detected peak signals
                tempy=rec{index}.data{i}(rec{index}.is_compound{i}(:,j),2)-rec{index}.bg_int{i}(rec{index}.is_compound{i}(:,j)); % perform baseline correction
                tempx=rec{index}.data{i}(rec{index}.is_compound{i}(:,j),1);
                sumid=tempy>0;
                if length(tempx)<2
                    rec{index}.abundance{i}(j)=0;
                elseif sum(sumid)<2
                    rec{index}.abundance{i}(j)=0;
                else
                    % use trapzoidal reule to compute peak area
                    rec{index}.abundance{i}(j)=trapz(tempx(sumid),tempy(sumid));
                end
            end
            if rec{index}.abundance{i}(j)==0
                rec{index}.quant_note{i}(j)=1; % no qualified peaks
            end
        end
        % update the progress bar
        set(pg_bar,'Position',[0.0 0.0 (1.0*((index-1)*nos+i)/(fileno*nos)) 1.0],'FaceColor','b');
        pg_text.String=['Performing quantitation in an EIC ',num2str(i),'/',num2str(nos),' of file ',num2str(index),'/',num2str(fileno),' (',num2str(100.0*((index-1)*nos+i)/(fileno*nos),'%5.2f'),' %) finished!'];
        ext=pg_text.Extent;
        set(pg_text,'pos',[0.5-ext(3)/2,0.5]);
        pause(0.005);% better than drawnow;
    end
    % store the resultin main window's userdata
    hdlrec.UserData=rec;
end
%--------------------------------------------------------------
% save quamtitation results
%--------------------------------------------------------------
function save_quantitation_result(~,~,hdlrec,hdlmeth,hdlastc,hdlpara)
    hdldirinfo=findobj('tag','txt_dirinfo');
    dirinfo=hdldirinfo.UserData;
    result=hdlrec.UserData; % the data structure to store the quantitation information
    method=hdlmeth.UserData; % get the compound info
    filelist=get(findobj('Tag','list_file'),'String'); % get the file lis
    fileno=length(filelist);
    sampname=cell(fileno,1);
    s=whos('result','method','filelist','para','methoddata','columnname','exp');
    bytesum=sum([s.bytes]);
    if bytesum >= 2e9
        hdl=warndlg({['The size of all variables is ',num2str(bytesum),' bytes.'];'The storage time will take minutes.';'Be sure to save the file to a "local drive (e.g. C:\)" to prevent long saving time';'Please wait patiently!'},...
                    'Long Saving Time Warning','modal');
        waitfor(hdl);
    end
    for i=1:fileno
        [~,sampname{i},~] = fileparts(filelist{i});
    end
    nos=length(method.orig_name);
    cd(dirinfo{2});
    [file,path] = uiputfile('*.xlsx','Save Quantitation Rsults');
    cd(dirinfo{1});
    if file ~= 0 % if the user has specified a legitimate filename
        hdldirinfo.UserData={dirinfo{1};path};
        % generate a table for abundances of the detected compounds
        dvartype=cell(1,method.nocomp);
        for i=1:method.nocomp
            dvartype{i}='double';
        end
        % construct abundance table
        pg_text=findobj('Tag','pg_text');
        pg_text.String='Preparing abundance information ...';
        ext=pg_text.Extent;
        set(pg_text,'pos',[0.5-ext(3)/2,0.5]);
        pause(0.005);% better than drawnow;
        T_Abund = table('Size',[fileno method.nocomp],'VariableTypes',dvartype,'VariableNames',method.indiv_name,'RowNames',sampname);
        for i=1:fileno
            T_Abund{i,:}=cell2mat(result{i}.abundance)';
        end
        % update the progress bar
        pg_text.String='Writing abundances into the file ...';
        ext=pg_text.Extent;
        set(pg_text,'pos',[0.5-ext(3)/2,0.5]);
        pause(0.005);% better than drawnow;
        writetable(T_Abund,[path,file],'Sheet','Abundance','WriteRowNames',true);
        % construct concentration table
        if get(findobj('Tag','rb_abs_int'),'Value') || get(findobj('Tag','rb_abs_stc'),'Value')% absolute quantitation
            pg_text.String='Preparing concentration information ...';
            ext=pg_text.Extent;
            set(pg_text,'pos',[0.5-ext(3)/2,0.5]);
            pause(0.005);% better than drawnow;
            T_Concen = table('Size',[fileno method.nocomp],'VariableTypes',dvartype,'VariableNames',method.indiv_name,'RowNames',sampname);
            for i=1:fileno
                T_Concen{i,:}=cell2mat(result{i}.concentration)';
            end
            pg_text.String='Writing concentrations into the file...';
            ext=pg_text.Extent;
            set(pg_text,'pos',[0.5-ext(3)/2,0.5]);
            pause(0.005);% better than drawnow;
            writetable(T_Concen,[path,file],'Sheet','Concentration','WriteRowNames',true);
        end
        % construct quantitation status table
        vartype=cell(1,method.nocomp);
        for i=1:method.nocomp
            vartype{i}='cellstr';
        end
        pg_text.String='Preparing quantitation status information ...';
        ext=pg_text.Extent;
        set(pg_text,'pos',[0.5-ext(3)/2,0.5]);
        pause(0.005);% better than drawnow;
        T_Status = table('Size',[fileno method.nocomp],'VariableTypes',vartype,'VariableNames',method.indiv_name,'RowNames',sampname);
        for i=1:fileno
            count=1;
            for j=1:nos
                peaknum=length(method.rt{j});
                for k=1:peaknum % the j-th EIC quant_note contains multiple compounds
                    if result{i}.quant_note{j}(k)==1 % No_qualified_peak
                        T_Status{i,count}={'No Qualified Peak'};
                    elseif result{i}.quant_note{j}(k)==2 %Multiple_Possible_Peaks
                        T_Status{i,count}={'Multiple Candidate Peaks'};
                    elseif result{i}.quant_note{j}(k)==3 %saturated
                        T_Status{i,count}={'Saturated Signals'};
                    elseif result{i}.quant_note{j}(k)==4 
                        T_Status{i,count}={'Defect Quantitation'};
                    elseif result{i}.quant_note{j}(k)==5
                        T_Status{i,count}={'Concentration Unconvertable'};
                    else
                        T_Status{i,count}={'Successful Quantitation'};
                    end
                    count=count+1;
                end
            end
        end
        pg_text.String='Writing quantitation status into the file...';
        ext=pg_text.Extent;
        set(pg_text,'pos',[0.5-ext(3)/2,0.5]);
        pause(0.005);% better than drawnow;
        writetable(T_Status,[path,file],'Sheet','Quantitation Status','WriteRowNames',true);
        if get(findobj('Tag','rb_quantifier_sel'),'Value')==1 % perform quantifier ion selection
            % construct ion ratio table
            pg_text.String='Preparing product ion ratio information ...';
            ext=pg_text.Extent;
            set(pg_text,'pos',[0.5-ext(3)/2,0.5]);
            pause(0.005);% better than drawnow;
            T_Ratio = get(findobj('tag','rb_quantifier_sel'),'UserData');
            pg_text.String='Writing product ion ratio into the file...';
            ext=pg_text.Extent;
            set(pg_text,'pos',[0.5-ext(3)/2,0.5]);
            pause(0.005);% better than drawnow;
            writetable(T_Ratio,[path,file],'Sheet','ProductIonRatio','WriteRowNames',true);
        end
        % construct RT table
        pg_text.String='Preparing retention time information ...';
        ext=pg_text.Extent;
        set(pg_text,'pos',[0.5-ext(3)/2,0.5]);
        pause(0.005);% better than drawnow;
        T_RT = table('Size',[fileno method.nocomp],'VariableTypes',vartype,'VariableNames',method.indiv_name,'RowNames',sampname);
        for i=1:fileno
            count=1;
            for j=1:nos
                peaknum=length(method.rt{j});
                for k=1:peaknum % the j-th EIC  contains multiple compounds
                    if result{i}.abundance{j}(k)==0
                        T_RT{i,count}={'nan(nan)'};
                    else
                        RT=result{i}.data{j}(result{i}.is_peak{j}(:,k),1);
                        RT_diff=RT-method.rt{j}(k);
                        if abs(RT_diff) > method.rt_diff{j}(k)
                            T_RT{i,count}={[num2str(RT),'(*',num2str(RT_diff),')']};
                        else
                            T_RT{i,count}={[num2str(RT),'(',num2str(RT_diff),')']};
                        end
                    end
                    count=count+1;
                end
            end
        end
        pg_text.String='Writing retention times into the file...';
        ext=pg_text.Extent;
        set(pg_text,'pos',[0.5-ext(3)/2,0.5]);
        pause(0.005);% better than drawnow;
        writetable(T_RT,[path,file],'Sheet','RetentionTime','WriteRowNames',true);
        % construct abundance table for standards if EICs for standard
        % curves are provided
        exp=hdlastc.UserData;
        if hdlastc.Value % if EICs for standard curves are provided
            pg_text.String='Preparing standard curve information ...';
            ext=pg_text.Extent;
            set(pg_text,'pos',[0.5-ext(3)/2,0.5]);
            pause(0.005);% better than drawnow;
            [stdfileno,stdcompno]=size(exp.abundance);
            T_STD_Abund = table('Size',[stdfileno stdcompno],'VariableTypes',dvartype,'VariableNames',exp.indiv_name,'RowNames',exp.fname);
            T_STD_Abund{:,:}=exp.abundance;
            writetable(T_STD_Abund,[path,file],'Sheet','STD_Abundance','WriteRowNames',true);
            vartype=cell(1,2);
            vartype{1}='cellstr';
            vartype{2}='cellstr';
            T_STD_Reg_Form = table('Size',[stdcompno 2],'VariableTypes',vartype,'VariableNames',{'Formula','Coefficients'},'RowNames',exp.indiv_name);
            for i=1:stdcompno
                T_STD_Reg_Form{i,1}={formula(exp.std_curve{i})};
                T_STD_Reg_Form{i,2}={num2str(coeffvalues(exp.std_curve{i}),'%8.4f')};
            end
            pg_text.String='Writing standard curve information into the file...';
            ext=pg_text.Extent;
            set(pg_text,'pos',[0.5-ext(3)/2,0.5]);
            pause(0.005);% better than drawnow;
            writetable(T_STD_Reg_Form,[path,file],'Sheet','STD_reg_form','WriteRowNames',true);
        end
        error_message=get(findobj('Tag','quant_msg'),'String');
        if ~isempty(error_message)
            T_error_message = table(error_message);
            T_error_message.Properties.VariableNames={'Error_Message'};
            pg_text.String='Writing error messages into the file...';
            ext=pg_text.Extent;
            set(pg_text,'pos',[0.5-ext(3)/2,0.5]);
            pause(0.005);% better than drawnow;
            writetable(T_error_message,[path,file],'Sheet','error_message','WriteRowNames',false);
        end
        para=hdlpara.UserData;
        methoddata=get(findobj('Tag','tbl_comp_list'),'Data');
        columnname=get(findobj('Tag','tbl_comp_list'),'ColumnName');
        [~,name,~] = fileparts(file);
        % save data to an mat file
        pg_text.String='Saving project information to a Matlab *.mat file ...';
        ext=pg_text.Extent;
        set(pg_text,'pos',[0.5-ext(3)/2,0.5]);
        pause(0.005);% better than drawnow;
        if bytesum > 2e9
            save([path,name,'.mat'],'result','method','filelist','para','methoddata','columnname','exp','-v7.3','-nocompression');
        else
            save([path,name,'.mat'],'result','method','filelist','para','methoddata','columnname','exp');
        end
        % denote that the result has been saved
        set(findobj('Tag','PB_save_result'),'UserData',true,'Enable','off');
        pg_text.String='';
        pause(0.005);% better than drawnow;
    else
        % denote that the result has not been saved
        set(findobj('Tag','PB_save_result'),'UserData',false,'Enable','on');
    end
end
%--------------------------------------------------------------
% find the best match between expected compounds (method.rt) and
% detected peaks (LOCS)
%--------------------------------------------------------------
function didx=findpeakmatch(LOCS,PKS,expect_rt,expect_diff)
    compno=length(expect_rt);
    didx=-1*ones(compno,1);
    if compno == 1 % only one compound in this EIC
        qindex=find((LOCS>=(expect_rt-expect_diff)) & (LOCS<=(expect_rt+expect_diff)))';
        if isempty(qindex)
            didx=-1;
        else
            [~,idx]=max(PKS(qindex));
            didx=qindex(idx);
        end
    else % multiple compounds in this EIC
        [expect_rt,sidx]=sort(expect_rt);
        expect_diff=expect_diff(sidx);
        index=cell(1,compno);
        for i=1:compno
            index{i}=find((LOCS>=(expect_rt(i)-expect_diff(i))) & (LOCS<=(expect_rt(i)+expect_diff(i))))';
            if isempty(index{i})
                index{i}=-1;
            else
                [~,idx]=max(PKS(index{i}));
                didx(i)=index{i}(idx);
            end
        end
        sub = cell(1,numel(index));
        [sub{:}] = ndgrid(index{:});
        sub = cellfun(@(x)x(:),sub,'UniformOutput', false);
        combv = cell2mat(sub)';
        keepid=all(combv~=-1,2); % find the expected RTs that match with the found peaks.
        combv=combv(keepid,:);
        isqualify=combv(2:end,:)>combv(1:end-1,:); % make sure the RTs are in ascending order among the multiple peaks
        qidx=all(isqualify,1);
        combv=combv(:,qidx); % filter out the qualified combinations
        maxint=0;
        if ~isempty(combv)
            tempdidx=didx;
            for i=1:size(combv,2) % find the largest sum of intensities of the qualified combinations
                tempsum=sum(PKS(combv(:,i)));
                if tempsum>maxint
                    maxint=tempsum; % keep the largest sum of intensities
                    tempdidx=combv(:,i); % record the combination
                end
            end
            didx(sidx(keepid))=tempdidx; % convert back to the original RT order
            if ~isempty(sidx(~keepid))
                didx(sidx(~keepid))=-1; % convert back to the original RT order
            end
        end
    end
end
%--------------------------------------------------------------
% deconvolute the coeluted peaks
%--------------------------------------------------------------
function [newx,feval]=solve_coelution(x0,mu,curve)
    options=optimset('LargeScale','off','Display','off');
    sigma=x0(1:length(x0)/2);
    mag=x0(length(x0)/2+1:end);
    [newx,feval] = fmincon(@(x) curve_match(x,mu,curve),x0,[],[],[],[],[0.8*sigma;0.2*mag],[1.05*sigma;mag],[],options);
end
%--------------------------------------------------------------
% The objective function for optimization
%--------------------------------------------------------------
function y=curve_match(x,mu,curve)
    curve1=zeros(size(curve(:,1)));
    nod=length(x);
    sigma=x(1:nod/2);
    mag=x((nod/2+1):end);
    % compute the accumulation of length(sigma) Gaussian functions
    for i=1:length(sigma)
        curve1 = curve1 + mag(i)*gaussmf(curve(:,1),[sigma(i) mu(i)]);
    end
    % compute the difference between the original curve and the accumulated Gaussian
    y=sum(abs(curve1-curve(:,2))); 
end
%--------------------------------------------------------------
% check whether the data has been save before program close
%--------------------------------------------------------------
function close_check(~,~)
    if ~get(findobj('Tag','PB_save_result'),'UserData')
        answer = questdlg('\fontsize{12}The computed/modified result has not been saved. Save it before closing the program?','Data Loss Warning',struct('Default','Yes','WindowStyle','modal','Interpreter','tex')); 
        if strcmpi(answer,'Yes')
            hdlrec=findobj('Tag','MRM_Quant');
            hdlmeth=findobj('Tag','pl_comp');
            hdlastc=findobj('Tag','rb_abs_stc');
            hdlpara=findobj('Tag','pl_para');
            save_quantitation_result('','',hdlrec,hdlmeth,hdlastc,hdlpara);
        end
    end
    % check for existing wondows and close them
    fhdl=findobj('Tag','temp_fig');
    if ~isempty(fhdl), delete(fhdl); end
    EICwin=findobj('Tag','fg_EIC');
    if ~isempty(EICwin), delete(EICwin); end
    parawin=findobj('Tag','fg_comp_para');
    if ~isempty(parawin), delete(parawin); end
    plotwin=findobj('Tag','temp_plot');
    if ~isempty(plotwin), delete(plotwin); end
    importwin=findobj('Tag','std_import');
    if ~isempty(importwin), delete(importwin); end
    regwin=findobj('Tag','reg_result');
    if ~isempty(regwin), delete(regwin); end
    optwin=findobj('Tag','fg_heatmapoptwin');
    if ~isempty(optwin), delete(optwin); end
    selwin=findobj('Tag','fg_sel_EIC'); 
    if ~isempty(selwin), delete(selwin); end
    refwin=findobj('Tag','ref_select');
    if ~isempty(refwin), delete(refwin); end
    fig_peak_ratio=findobj('tag','fg_fragment_ratio');
    if ~isempty(fig_peak_ratio), delete(fig_peak_ratio); end
    closereq;
end
%--------------------------------------------------------------
% export the heatmap 
%--------------------------------------------------------------
function export_plot(~,~)
    fhdl=findobj('Tag','temp_plot');
    if ~isempty(fhdl)
        close(fhdl);
    end
    ax = findobj('tag','AX_heat_map'); % Find the axes object in the GUI
    is_export_heatmap=true;
    if strcmpi(ax.Visible,'off')
        is_export_heatmap=false;
        ax = findobj('tag','AX_TIC_plot'); % Find the axes object in the GUI
    end
    fig = figure('Units','normalized', ...
        'Name','Export Figure', ...
        'NumberTitle','off', ...
        'Position',[0.1 0.1 0.6 0.5],...
        'Tag','temp_plot'); % Open a new figure with handle f1
    set(findobj('Tag','MRM_Quant'),'WindowButtonMotionFcn',[],'WindowKeyPressFcn',[]);
    if is_export_heatmap
        % extract colormap info
        para=get(findobj('Tag','pl_para'),'UserData');
        set(fig,'Colormap',colormap(para.colormap));
        if para.show_colorbar 
            hdl=colorbar(ax);
            copyobj([hdl,ax],fig); % Copy axes object h into figure f1
            hdl=get(fig,'Children');
            set(hdl(1),'unit','normalized','position',[0.95 0.12 0.02 0.84]);
            pause(0.005);
            set(hdl(2),'unit','normalized','position',[0.08 0.12 0.86 0.84]);
        else
            s=copyobj(ax,fig); % Copy axes object h into figure f1
            set(s,'unit','normalized','position',[0.05 0.12 0.93 0.84]);
        end
    else
        s=copyobj(ax,fig); % Copy axes object h into figure f1
        set(s,'unit','normalized','position',[0.05 0.12 0.93 0.83]);
    end
    exportsetupdlg(fig);
    set(findobj('Tag','MRM_Quant'),'WindowButtonMotionFcn',@cursorPos,'WindowKeyPressFcn',@KeyDirect);
end
%--------------------------------------------------------------
% export the EIC plot
%--------------------------------------------------------------
function export_EIC(~,~,ax)
    fhdl=findobj('Tag','temp_fig');
    if ~isempty(fhdl)
        close(fhdl);
    end
    cb_show_legend=findobj('Tag','cb_show_legend');
    fig = figure('Units','normalized', ...
        'Name','Export Figure', ...
        'NumberTitle','off', ...
        'Tag','temp_fig',...
        'Visible','off',...
        'Position',[0.3 0.2 0.5 0.5]); % Open a new figure to show the selected EIC
    if (cb_show_legend.Value) && strcmpi(cb_show_legend.Visible,'on')
        hdl=legend(ax);
        copyobj([hdl,ax],fig); % Copy axes object h into figure f1
    else
        copyobj(ax,fig); % Copy axes object h into figure f1
    end
    exportsetupdlg(fig);
end
%--------------------------------------------------------------
% draw quantitation heat map
%--------------------------------------------------------------
function draw_quantitation_heat_map(idx,hdlrec,hdlmeth,hdlpara,axhdl,imhdl)
    % get required info
    rec=hdlrec.UserData;
    method=hdlmeth.UserData;
    cmtx=axhdl.UserData;
    alpha=imhdl.UserData;
    noc=length(method.orig_name);
    para=hdlpara.UserData;
    use_abundance=(para.heatmap_abund) | contains(lower(get(findobj('Tag','PB_quant'),'UserData')),'standard') |...
        para.rel_quant | para.quantifier_sel;
    count=0;
    for i=1:noc
        peaknum=length(method.rt{i});
        for j=1:peaknum
            count=count+1;
            cmtx(idx,count,1)=rec{idx}.abundance{i}(j); % draw the heatmap using abundance
            cmtx(idx,count,2)=rec{idx}.concentration{i}(j); % draw the heatmap using concentration
            if (rec{idx}.quant_note{i}(j)>=3) || isnan(cmtx(idx,count,1)) || isinf(cmtx(idx,count,1))
                alpha(idx,count)=0;
            elseif rec{idx}.quant_note{i}(j)>0 %ambiguous
                alpha(idx,count)=0.2;
            else
                alpha(idx,count)=1.0;
            end
        end
    end
    if use_abundance % heatmap show abundances
        mtx=cmtx(:,:,1);
    else % heatmap show concentration
        mtx=cmtx(:,:,2);
    end
    % remove elements in mtx that are less than 0
    mtx(mtx<0)=0;
    cmin=min(min(mtx,[],'omitnan')); %NaN is not included
    cmax=max(max(mtx,[],'omitnan')); %NaN is not included    
    mtx(isnan(mtx))=cmin;
    mtx(isinf(mtx))=cmax;
    if cmin == cmax
        if cmin == 0
            cmax=1;
        else
            cmax=1.1*cmax;
            cmin=0.9*cmin;
        end
    end
    if para.show_ambiguous_comp
        showalpha=alpha;
    else
        showalpha=ones(size(alpha));
    end
    if para.take_log
        lmtx=log(mtx+4);
        showalpha(isnan(lmtx))=0;
        set(imhdl,'CData',lmtx,'AlphaData',showalpha,'UserData',alpha);
        axhdl.CLim = [log(cmin+4),log(cmax+4)];
    else
        set(imhdl,'CData',mtx,'AlphaData',showalpha,'UserData',alpha);
        axhdl.CLim = [cmin,cmax];
    end
    % save the quantitation result to userdata
    axhdl.UserData=cmtx;
end
%--------------------------------------------------------------
% shift between auto or manual detection for background intensity
%--------------------------------------------------------------
function change_background_detect(hobj,~,hdledit)
    if hobj.Value
        hdledit.Enable='off';
    else
        hdledit.Enable='on';
    end
end
%--------------------------------------------------------------
% shift between auto or manual detection for smoothing window size
%--------------------------------------------------------------
function change_smoothing_window_size(hobj,~,hdledit)
    if hobj.Value
        hdledit.Enable='off';
    else
        hdledit.Enable='on';
    end
end
%--------------------------------------------------------------
% change properities of the EIC plot when a certain option is changed
%--------------------------------------------------------------
function change_view(~,~)
    fhdl=findobj('Tag','temp_fig');
    if ~isempty(fhdl)
        close(fhdl);
    end
    ax=findobj('Tag','AX_EIC');
    cb_show_legend=findobj('Tag','cb_show_legend');
    cb_show_detail=findobj('Tag','cb_show_detail');
    if cb_show_legend.Value
        try
            legend(ax,'show');
        catch
            errordlg('show legend error')
        end
    else
        legend(ax,'hide');
    end
    if cb_show_detail.Value
        lim=cb_show_detail.UserData;
        if lim(4)~=0
            axis(ax,lim);
        else
            warndlg('No effective peak is found for the expected compound!','Warning',struct('WindowStyle','modal','Interpreter','tex'));
            cb_show_detail.Value=0;
        end
    else
        axis(ax,'tight');
    end
end
%--------------------------------------------------------------
% reassign the peak as the compound name provided by the user and 
% recompute the peak abundances thereafter
%--------------------------------------------------------------
function reassign(~,~,hdlrec,hdlmeth,hdlpara,hdlastc,hdlimg,fhdl,ahdl)
    % turn off the toolbar to prevent it from block the title
    ahdl.Toolbar.Visible = 'off';
    % let the user to specify the peal location
    [x,~]=ginput(1);
    rec=hdlrec.UserData; % get the quantitation reuslt of the current file
    method=hdlmeth.UserData; % get the expected compound info
    para=hdlpara.UserData; % load parameters
    exp=hdlastc.UserData; % load standard info
    hdlmtx=findobj('Tag','AX_heat_map');
    vec=fhdl.UserData;
    fileid=vec(1);
    compoundid=vec(2);
    % convert compound id to EIC id and peak id
    EICid=method.EICidx(method.EICidx(:,1)==compoundid,2);
    peakid=method.EICidx(method.EICidx(:,1)==compoundid,3);
    % save the original data before making the change
    old_rec=temparary_save_EIC(rec,fileid,EICid,peakid,ahdl);
    % recover detected peaks
    LOCS=rec{fileid}.data{EICid}(rec{fileid}.pidx{EICid},1); % detected compound peak in this sample
    if isempty(LOCS)
        errordlg('No qualified peak is found in the EIC!','Selection Error',struct('WindowStyle','modal','Interpreter','none'));
        return;
    end
    OrgTip=rec{fileid}.data{EICid}(rec{fileid}.pidx{EICid},2);
    [~,midx]=min(abs(LOCS-x)); % find the index of peak closest to the cursor
    diff=abs(LOCS(midx)-method.rt{EICid}(peakid)); % compute the RT difference with the standard
    if diff > method.rt_diff{EICid}(peakid) % check if the peak is within the allowable RT difference
        answer = questdlg({'\fontsize{12}No qualified peak can be found!';'\fontsize{12}The closest peak is not within allowable RT range! Use it anyway?'},...
            'Peak Selection Question', 'Yes','No',struct('Default','Yes','Interpreter','tex'));
        if strcmp(answer,'No')
            ahdl.Toolbar.Visible = 'on';
            return;
        end
    end
    % check for saturated signals
    maxv=max(rec{fileid}.data{EICid}(:,2)); % max value in the EIC
    binv=rec{fileid}.data{EICid}(:,2)>=(0.995*maxv); % whether the signal is higher than 99.5% of the highest value
    repidx=nonzeros((cumsum(~binv)+1).*binv);
    blocklen=nonzeros(accumarray(repidx,1));
    longest=max(blocklen); % longest consecutive signals that are higher than 99.5% of the highest value
    if (longest >= 4) && (maxv > para.max_int) && (OrgTip(midx) == maxv) % the user selects a saturated peak
        answer = questdlg('\fontsize{12}The selected peak is saturated and its abundance can not be estimated! Use it anyway?',...
            'Peak Selection Question', 'Yes','No',struct('Default','Yes','Interpreter','tex'));
        if strcmp(answer,'No')
            ahdl.Toolbar.Visible = 'on';
            return;
        else
            rec{fileid}.quant_note{EICid}(peakid)=3;
        end
    end
    % find the index of the peak tip
    diff=abs(rec{fileid}.data{EICid}(:,1)-LOCS(midx));
    [~,didx]=min(diff); % find the index of signal to the peak tip
    % reassign the peak tip
    rec=recompute_peak_info(rec,fileid,compoundid,didx,midx,method,para,exp);
    % change the quantitation status
    hdlrec.UserData=rec;
    % update the EIC plot
    update_plots_in_EIC_window(hdlrec,hdlmeth,hdlpara,hdlastc,ahdl,fileid,compoundid);
    % allow to change the compound info
    set(findobj('Tag','PB_sel_peak'),'UserData',true);
    % get the progress bar handle
    pg_text=findobj('Tag','pg_text');
    % collect update parameter
    update_para.fileid = fileid;
    update_para.compid = compoundid;
    update_para.dir = 'file';
    update_para.bound = [];
    update_para.xcord = x;
    update_para.bg_int = -1;
    update_para.start_file = 0;
    update_para.end_file = -1;
    update_para.start_comp = 0;
    update_para.end_comp = -1;
    % display a window for user to select whether to apply the change to multiple compounds
    % and perform correction on selected EICs other than the current EIC
    select_EIC(update_para,2);
    if ~get(findobj('Tag','PB_sel_peak'),'UserData') % User clicks on 'Cancel', restore the original EIC plot    
        % restore all the peak info
        hdlrec.UserData = restore_EIC(rec,old_rec,fileid,EICid,peakid,para,ahdl);
    else % commence the related updates
        % update the concentration and heatmap in the main window
        update_concentration_and_heatmap_matrix(fileid,compoundid,EICid,peakid,hdlrec,hdlmeth,hdlpara,hdlastc,hdlmtx,hdlimg);
        % update the plots of the same compound in other files
        show_compound_in_nearby_files('','',fileid,compoundid,hdlrec,hdlmeth,'',true);
        if isempty(findobj('Tag','reg_result')) && ...% not a standard curve data
            get(findobj('Tag','cb_normal'),'Value') % batch effect correction is checked
            % re-perform batch effect correction
            update_para=get(findobj('Tag','PB_show_norm'),'UserData');
            range=[update_para.start_file, update_para.end_file,...
                update_para.start_comp, update_para.end_comp];
            set(pg_text,'String','Performing batch effect correction...');
            batch_effect_correction(hdlrec,hdlmeth,hdlastc,hdlpara,hdlmtx,range);
        end
        % allow user to save the result
        set(findobj('Tag','PB_save_result'),'UserData',false,'Enable','on');
    end
    set(pg_text,'String','Updating heatmap...');
    change_heatmap_abundent('','',hdlrec,hdlmeth,hdlpara,hdlmtx);
    set(pg_text,'String','');
    % update grid line
    ghdl=findobj('Tag','grid_line'); 
    if para.show_grid && ~isempty(ghdl)
        set(ghdl,'visible','on');
    elseif ~para.show_grid && ~isempty(ghdl)
        set(ghdl,'visible','off');
    end
    ahdl.Toolbar.Visible = 'on';
end
% ------------------------------------
% temparary save EIC data
% ------------------------------------
function old_rec=temparary_save_EIC(rec,fileid,EICid,peakid,ahdl)
    old_rec.concentration=rec{fileid}.concentration{EICid}(peakid);
    old_rec.abundance=rec{fileid}.abundance{EICid}(peakid); 
    old_rec.conc_org=rec{fileid}.conc_org{EICid}(peakid);
    old_rec.quant_note=rec{fileid}.quant_note{EICid}(peakid);
    old_rec.is_compound=rec{fileid}.is_compound{EICid}(:,peakid);
    old_rec.is_peak=rec{fileid}.is_peak{EICid}(:,peakid);
    old_rec.decomp=rec{fileid}.decomp{EICid}(:,peakid);
    old_rec.bdp=rec{fileid}.bdp{EICid}(peakid,:);
    old_rec.coelute=rec{fileid}.coelute{EICid}(peakid,:);
    old_rec.bg_int=rec{fileid}.bg_int{EICid};
    old_rec.is_defined_by_bound=rec{fileid}.is_defined_by_bound{EICid}(peakid);
    % save original standard curve information
    old_rec.ax_stc=findobj('Tag','AX_std_curve');
    chdl=old_rec.ax_stc.Children;
    old_rec.title=ahdl.Title.String;
    old_rec.stcx=cell(length(chdl),1);
    old_rec.stcy=cell(length(chdl),1);
    for i=1:length(chdl)
        if isprop(chdl(i),'XData')
            old_rec.stcx{i}=chdl(i).XData;
            old_rec.stcy{i}=chdl(i).YData;
        end
    end
end 
% ---------------------------------------------
% restore EIC data
% ---------------------------------------------
function rec = restore_EIC(rec,old_rec,fileid,EICid,peakid,para,ahdl)
    rec{fileid}.abundance{EICid}(peakid)=old_rec.abundance; 
    rec{fileid}.conc_org{EICid}(peakid)=old_rec.conc_org;
    rec{fileid}.concentration{EICid}(peakid)=old_rec.concentration;
    rec{fileid}.is_compound{EICid}(:,peakid)=old_rec.is_compound;
    rec{fileid}.quant_note{EICid}(peakid)=old_rec.quant_note;
    rec{fileid}.is_peak{EICid}(:,peakid)=old_rec.is_peak;
    rec{fileid}.decomp{EICid}(:,peakid)=old_rec.decomp;
    rec{fileid}.bdp{EICid}(peakid,:)=old_rec.bdp;
    rec{fileid}.coelute{EICid}(peakid,:)=old_rec.coelute;
    rec{fileid}.bg_int{EICid}=old_rec.bg_int;
    rec{fileid}.is_defined_by_bound{EICid}(peakid)=old_rec.is_defined_by_bound;
    % restore all the detected peaks
    hdl=zeros(7,1);
    hdl(1)=findobj('tag','lc_hdl1'); % location of standard compound(s) in the EIC
    hdl(2)=findobj('tag','lc_hdl2'); % original signal of the EIC 
    hdl(3)=findobj('tag','lc_hdl3'); % smoothed signal of the EIC 
    hdl(4)=findobj('tag','lc_hdl4'); % detected compound(s) in the EIC 
    hdl(5)=findobj('tag','lc_hdl5'); % detected compound tip(s) in the EIC 
    hdl(6)=findobj('tag','lc_hdl6'); % deconvoluted peak
    hdl(7)=findobj('tag','lc_hdl7'); % background intensity
    cid=old_rec.is_compound;
    set(hdl(4),'xdata',rec{fileid}.data{EICid}(cid,1),'ydata',rec{fileid}.data{EICid}(cid,2));
    % restore the compound tips
    tid=old_rec.is_peak;
    set(hdl(5),'xdata',rec{fileid}.data{EICid}(tid,1),'ydata',rec{fileid}.data{EICid}(tid,2));
    % restore the deconvoluted peaks if existed
    keepid=old_rec.decomp>0;
    if sum(keepid)>0
        set(hdl(6),'xdata',rec{fileid}.data{EICid}(keepid,1),'ydata',old_rec.decomp(keepid),'visible','on');
    else
        set(hdl(6),'xdata',rec{fileid}.data{EICid}(:,1),'ydata',zeros(size(rec{fileid}.data{EICid}(:,1))),'visible','off');
    end
    % restore title
    ahdl.Title.String=old_rec.title;
    % restore legend
    if get(findobj('Tag','cb_show_legend'),'Value') % show legend
        if sum(old_rec.decomp)>0
            legend(hdl,{'Expected RT','Original Signal','Smoothed Signal','Detected Compound','Peak Tip Location','Deconvoluated Signal'});
        else
            legend(hdl([1:5,7]),{'Expected RT','Original Signal','Smoothed Signal','Detected Compound','Peak Tip Location'});
        end
    else
        legend('hide');
    end
    % restore the standard curve plot
    chdl=old_rec.ax_stc.Children;
    for i=1:length(chdl)
        if isprop(chdl(i),'XData')
            chdl(i).XData=old_rec.stcx{i};
            chdl(i).YData=old_rec.stcy{i};
        end
    end
    % restore plot title
    if para.abs_stc || para.abs_int
        title(old_rec.ax_stc,['\fontsize{12}Concentration = {\color{red}',num2str(old_rec.concentration,'%.2f'),'}']);
    else
        title(old_rec.ax_stc,['\fontsize{12}Rel. Abundance = {\color{red}',num2str(max(chdl(1).YData),'%.2f'),'%}']);
    end
end
% ---------------------------------------------------------------------------
% Update the abundance/concentration plot in the EIC plot window
% ---------------------------------------------------------------------------
function update_abundance_concentration_plot_in_EIC(hdlrec,hdlmeth,hdlpara,hdlastc,ax_stc,fileid,compoundid)
    chdl=ax_stc.Children;
    rec=hdlrec.UserData;
    method=hdlmeth.UserData;
    para=hdlpara.UserData;
    exp=hdlastc.UserData;
    % convert compound id to EIC id and peak id
    EICid=method.EICidx(method.EICidx(:,1)==compoundid,2);
    peakid=method.EICidx(method.EICidx(:,1)==compoundid,3);
    if para.abs_int % recompute the concentration and update the linear regression curve
        % update the concentration
        ISID=strcmpi(method.orig_name,method.IS{EICid});
        compconc=rec{fileid}.abundance{EICid}(peakid)/rec{fileid}.abundance{ISID}(1)*method.conc(EICid);
        maxx=max([compconc method.conc(EICid)]);
        maxy=max(rec{fileid}.abundance{EICid}(peakid), rec{fileid}.abundance{ISID}(1));
        XLim=[0 maxx];
        if (maxy == 0) || isnan(maxy)
            YLim=[0 1];
        else
            YLim=[0 1.05*maxy];
        end
        for i=1:length(chdl) % update the standatd curve plot
            if contains(class(chdl(i)),'Line')
                if strcmpi(chdl(i).Tag,'LN_reg')
                    chdl(i).XData = [compconc method.conc(EICid)];
                    chdl(i).YData = [rec{fileid}.abundance{EICid}(peakid) rec{fileid}.abundance{ISID}(1)];
                elseif strcmpi(chdl(i).Tag,'LN_comp_conc')
                    chdl(i).XData = [compconc compconc];
                    chdl(i).YData = YLim;
                elseif strcmpi(chdl(i).Tag,'LN_comp_abund')
                    chdl(i).XData = XLim;
                    chdl(i).YData = [rec{fileid}.abundance{EICid}(peakid) rec{fileid}.abundance{EICid}(peakid)];
                end
            elseif contains(class(chdl(i)),'Text') && isequal(chdl(i).Color,[1 0 0])
                chdl(i).Position = [compconc 0 0];
            end
        end
        set(ax_stc,'XLim',XLim,'YLim',YLim);
        title(ax_stc,['\fontsize{12}Concentration = {\color{red}',num2str(compconc,'%.2f'),'}']);
    elseif para.abs_stc % recompute the concentration and update the standard curve
        % determine whether to normalize the abundance
        if method.ISidx > 0 % internal standard is provided
            refEICid=method.EICidx(method.EICidx(:,1)==method.ISidx,2);
            refpeakid=method.EICidx(method.EICidx(:,1)==method.ISidx,3);
            ycoord=rec{fileid}.abundance{EICid}(peakid)/rec{fileid}.abundance{refEICid}(refpeakid);
            ycoord_ref=exp.abundance(:,compoundid)./exp.abundance(:,exp.ISidx);
        else
            ycoord=rec{fileid}.abundance{EICid}(peakid);
            ycoord_ref=exp.abundance(:,compoundid);
        end
        % update the concentration
        [compconc,~]=find_conc_from_standard_curve(exp,compoundid,ycoord);
        maxx=max([compconc;exp.conc]);
        maxy=max([ycoord;ycoord_ref]);
        XLim=[0 maxx];
        if maxy == 0
            YLim=[0 1];
        else
            YLim=[0 1.05*maxy];
        end
        for i=1:length(chdl) % update the standatd curve plot
            xdata=chdl(i).XData;
            ydata=chdl(i).YData;
            if (length(ydata)==2) && (ydata(1)==ydata(2)) % horizontal line
                chdl(i).XData = XLim;
                chdl(i).YData = [ycoord ycoord];
            elseif (length(xdata)==2) && (xdata(1)==xdata(2)) % vertical line
                chdl(i).XData = [compconc compconc];
                chdl(i).YData = YLim;
            end
        end
        set(ax_stc,'XLim',XLim,'YLim',YLim);
        title(ax_stc,['\fontsize{12}Concentration = {\color{red}',num2str(compconc,'%.2f'),'}']);
    else % plot the relative percentage of abundance 
        % find the max peak among samples
        maxv=0;
        for i=1:length(rec)
            maxv=max(maxv,rec{i}.abundance{EICid}(peakid));
        end
        percentage=100.0*rec{fileid}.abundance{EICid}(peakid)/maxv;
        % target compound abundance and concentration
        tempid=findobj('tag','rt_rel_abunt');
        if isempty(tempid)
            fill(ax_stc,[0 1 1 0 0],[0 0 percentage percentage 0],[0,0,1],...
            'LineStyle','none','PickableParts','none','tag','rt_rel_abunt');
        else
            set(tempid,'xdata',[0 1 1 0 0],'ydata',[0 0 percentage percentage 0]);
        end
        set(ax_stc,'XLim',[-0.25 1.25],'YLim',[0 100],'xticklabel',[]);
        xlabel(ax_stc,method.indiv_name{compoundid})
        ylabel(ax_stc,'percentage','fontsize',12);
        title(ax_stc,['\fontsize{12}Rel. Abundance = {\color{red}',num2str(percentage,'%.2f'),'%}']);
    end
end
%-----------------------------------------------------------
% recompute peak inforomation for a given peak tip location
%-----------------------------------------------------------
function rec=recompute_peak_info(rec,fileid,compoundid,didx,midx,method,para,exp)
    if contains(lower(get(findobj('Tag','PB_quant'),'UserData')),'standard') % quantitation on standard compound data
        filelist=get(findobj('Tag','rb_abs_stc'),'UserData').fname;
        sn_ratio=exp.sn_ratio;
        min_rt_diff=exp.min_peak_width/4;
        min_peak_dist=exp.min_peak_dist;
    else % quantitation on testing data
        filelist=get(findobj('Tag','list_file'),'String');
        sn_ratio=para.sn_ratio;
        min_rt_diff=para.min_peak_width/4;
        min_peak_dist=para.min_peak_dist;
    end
    EICid=method.EICidx(method.EICidx(:,1)==compoundid,2);
    peakid=method.EICidx(method.EICidx(:,1)==compoundid,3);
    sdata=rec{fileid}.smoothy{EICid};
    bg_int=rec{fileid}.bg_int{EICid};
    rec{fileid}.quant_note{EICid}(peakid)=0;
    rec{fileid}.is_peak{EICid}(:,peakid)=false;
    rec{fileid}.is_peak{EICid}(didx,peakid)=true;
    % ### trace the two ends of the peak for coelution ###
    [bd,coelute,halfcount]=peak_tracing(rec{fileid}.data{EICid}(:,1),sdata,didx,bg_int,sn_ratio,min_rt_diff,min_peak_dist);
    % record the bound indices
    rec{fileid}.bdp{EICid}(peakid,:)=bd;
    % record the coelution info
    rec{fileid}.coelute{EICid}(peakid,:)=coelute;
    % record the signal from left to right bounds
    rec{fileid}.is_compound{EICid}(:,peakid)=false(length(sdata),1);
    rec{fileid}.is_compound{EICid}(bd(1):bd(2),peakid)=true;
    % remove existing deconvoluted peaks
    if sum(rec{fileid}.decomp{EICid}(:,peakid))>0
        rec{fileid}.decomp{EICid}(:,peakid)=zeros(size(rec{fileid}.decomp{EICid}(:,peakid)));
    end
    if any(coelute) && ~para.no_deconv && ~(rec{fileid}.quant_note{EICid}(peakid)==3)
        try
            rec=peak_deconvolution(midx,fileid,EICid,peakid,rec,halfcount,bg_int,sn_ratio,min_rt_diff,min_peak_dist);
        catch
            msg=['The compound ',method.orig_name{compoundid},' in file ',filelist{fileid},' cannot be successfully quantitated during deconvolution!'];
            rec{fileid}.quant_note{EICid}(peakid)=4; %defect quantitation
        end
    elseif ~any(coelute) && para.always_deconv && ...
                any(rec{fileid}.is_compound{EICid}(:,peakid))% no coelution but user select 'aways deconvolution"
        options=optimset('LargeScale','off','Display','off');
        curve=[rec{fileid}.data{EICid}(bd(1):bd(2),1) sdata(bd(1):bd(2))];
        halfcount=halfcount(halfcount>0);
        halfcount=halfcount(halfcount~=didx);
        sigma0=min(abs(rec{fileid}.data{EICid}(halfcount,1)-rec{fileid}.data{EICid}(didx,1)));
        x0=[sdata(didx);sigma0;rec{fileid}.data{EICid}(didx,1)]; % peak height, peak width std, peak tip location
        xlo=[0.7*sdata(didx);0.8*sigma0;rec{fileid}.data{EICid}(didx-1,1)];
        xhi=[1.3*sdata(didx);1.2*sigma0;rec{fileid}.data{EICid}(didx+1,1)];
        newx = fmincon(@(x) peak_approximation(x,curve),x0,[],[],[],[],xlo,xhi,[],options);
        y=newx(1)*gaussmf(curve(:,1),[newx(2) newx(3)]); % deconvoluted peak signals
        maxy=max(y);
        dlen=length(sdata);
        is_complete=(y(1)<0.05*maxy) && (y(end)<0.05*maxy);
        newbd=bd;
        while ~is_complete
            if (y(1)>0.05*maxy) && (newbd(1)>1)
                newbd(1)=newbd(1)-1;
            end
            if (y(end)>0.05*maxy) && (newbd(2)<dlen)
                newbd(2)=newbd(2)+1;
            end
            y=newx(1)*gaussmf(rec{fileid}.data{EICid}(newbd(1):newbd(2),1),[newx(2) newx(3)]);
            is_complete=(y(1)<0.05*maxy) && (y(end)<0.05*maxy);
        end
        rec{fileid}.decomp{EICid}(:,peakid)=zeros(size(sdata));
        rec{fileid}.decomp{EICid}(newbd(1):newbd(2),peakid)=y+bg_int(newbd(1):newbd(2));
    end
    % update abundance
    % check if the peak is within the allowable RT difference
    % compute peak abundance 
    if rec{fileid}.quant_note{EICid}(peakid)>=3
        if rec{fileid}.quant_note{EICid}(peakid)==4 % Defect_Quantitation
            meglist=findobj('Tag','quant_msg');
            QuantMsg=meglist.String;
            meglist.String=[QuantMsg;{msg}];
            if ~get(findobj('Tag','PB_show_msg'),'UserData')
                show_quantitation_message('','',1,findobj('tag','pl_para'));
            end
        end
        rec{fileid}.abundance{EICid}(peakid)=nan; % the peak is saturated and the abundance cannot be evaluated
        rec{fileid}.decomp{EICid}(:,peakid)=0;
    elseif sum(rec{fileid}.decomp{EICid}(:,peakid)) > 0 % if the peak is coeluted
        tempdata=rec{fileid}.decomp{EICid}(:,peakid)-rec{fileid}.bg_int{EICid};
        sumid=tempdata>0;
        % use trapzoidal rule to compute peak area
        rec{fileid}.abundance{EICid}(peakid)=trapz(rec{fileid}.data{EICid}(sumid,1),tempdata(sumid));
    else % the peak is successfully quantitation
        tempy=rec{fileid}.data{EICid}(rec{fileid}.is_compound{EICid}(:,peakid),2)-rec{fileid}.bg_int{EICid}(rec{fileid}.is_compound{EICid}(:,peakid));
        tempx=rec{fileid}.data{EICid}(rec{fileid}.is_compound{EICid}(:,peakid),1);
        sumid=tempy>0;
        rec{fileid}.abundance{EICid}(peakid)=trapz(tempx(sumid),tempy(sumid));
    end
    if rec{fileid}.abundance{EICid}(peakid)==0
        rec{fileid}.quant_note{EICid}(peakid)=1; % no qualified peaks
    end
    rec{fileid}.is_defined_by_bound{EICid}(peakid)=false;
end
%---------------------------------------------------------------------------------------------
% given the computed abundance, find compound concentration from its associated standard curve
%---------------------------------------------------------------------------------------------
function [concentration,flag]=find_conc_from_standard_curve(exp,compoundid,abundance)
    flag=false;
    polpar=exp.std_curve{compoundid}; % the function of the std curve of the compoundid-th compound
    ycoord=feval(polpar,exp.conc);
    if isinf(abundance) || isnan(abundance) % abundance is infinite or NAN
        concentration=NaN; % concentration is NAN
        flag=true;
        return
    end
    if ismember('p1',coeffnames(polpar)) % p1 is one of the coefficient
        if (abs(polpar.p1)<1e-6) % a flat line && (abs(polpar.p2)<1e-6)
            concentration=NaN; % concentration cannot be inferred
            flag=true;
            return
        end
    end
    if strcmpi(type(polpar),'customnonlinear') % y=a*x^b
        if ismember('a',coeffnames(polpar))
            if abs(polpar.a)<eps % a flat line
                concentration=NaN; % concentration cannot be inferred
            else
                try
                    concentration=(abundance/polpar.a)^(1.0/polpar.b);
                catch
                    concentration=interp1(ycoord,exp.conc,abundance,"spline","extrap");
                end
            end
        end
    else % linear fitting
        concentration=(abundance-polpar.p2)/polpar.p1;
        flag=true;
    end
    if isempty(concentration) %try to find a solution using linear regression
        polpar=exp.std_curve{compoundid};
        ycoord=polyval(polpar,exp.conc);
        keepid=exp.used_for_reg(:,compoundid); %=~isnan(ycoord);
        polpar=polyfit(exp.conc(keepid),ycoord(keepid),1);
        concentration=(abundance-polpar(2))/polpar(1);
        flag=true;
        if isnan(concentration)
            return
        end
    end
    if ~isnan(concentration)
        concentration=max(0,concentration); % make sure the concentration is non-negative
    end
    if ~isreal(concentration)
        concentration=0;
    end
end
%--------------------------------------------------------------
% show the peak area of the selected compound in a EIC 
%--------------------------------------------------------------
function rect_selection(~,~,hdlrec,hdlmeth,hdlpara,hdlastc,hdlimg,fhdl,ahdl)
    global GETRECT_H1
    % turn off the toolbar to prevent it from block the title
    ahdl.Toolbar.Visible = 'off';
    rec=hdlrec.UserData; % get the quantitation reuslt of the current file
    method=hdlmeth.UserData; % get the expected compound info
    para=hdlpara.UserData; % load parameters
    hdlmtx=findobj('Tag','AX_heat_map');
    % find the current file ID　and Compound ID
    vec=fhdl.UserData;
    fileid=vec(1);
    compoundid=vec(2);
    % keep the original heatmap
    EICid=method.EICidx(method.EICidx(:,1)==compoundid,2);
    peakid=method.EICidx(method.EICidx(:,1)==compoundid,3);
    % rubberand selection.
    try
        % using try to catch user clicking something else, and then repeating getrect call
        rect=getrect(ahdl);
    catch
        ise = evalin('base','exist(''GETRECT_H1'',''var'') == 1');
        if ise
            set(GETRECT_H1, 'UserData', 'Completed'); % force getrect to end
        end
        rect=[];
    end
    if isempty(rect) % user did mark a rectangle!
        warndlg('No recognizable region is selected!','Warning',struct('WindowStyle','modal','Interpreter','none'));
    end  
    if (rect(3)<para.min_peak_width)
        errordlg('The selected region is smaller than the specified min. peak width!','Selection Error',struct('WindowStyle','modal','Interpreter','none'));
        ahdl.Toolbar.Visible = 'on';
        return;
    end
    rmhdl=findobj('tag','templine');
    if ~isempty(rmhdl) % remove the mark of the selected region
        delete(rmhdl);
    end
    dlen=length(rec{fileid}.data{EICid}(:,1)); % the data length
    id1=find(rec{fileid}.data{EICid}(:,1)>rect(1),1,'first'); % the index of the left bound
    id2=find(rec{fileid}.data{EICid}(:,1)<(rect(1)+rect(3)),1,'last'); % the index of the right bound
    range1=max(1,id1-5):(id1+2);
    range2=id2:min(dlen,id2+5);
    [~,d1]=min(rec{fileid}.data{EICid}(range1,2)); % local min of the left bound
    id1=range1(1)+d1-1; % index of the left local min
    [~,d2]=min(rec{fileid}.data{EICid}(range2,2)); % local min of the right bound
    id2=range2(1)+d2-1; % index of the right local min
    % Ask the user to comfirm since the selected region is out of the RT tolerence
    midpeak=(rec{fileid}.data{EICid}(id1,1)+rec{fileid}.data{EICid}(id2,1))/2;
    diff=abs(midpeak-method.rt{EICid}(peakid));
    if diff > method.rt_diff{EICid}(peakid) %the selected region is out of the RT tolerence
        answer = questdlg({'\fontsize{12}No qualified peak can be found!';'\fontsize{12}The closest peak is not within allowable RT range! Use it anyway?'},...
            'Peak Selection Question', 'Yes','No',struct('Default','Yes','Interpreter','tex'));
        if strcmp(answer,'No')
            ahdl.Toolbar.Visible = 'on';
            return;
        end
    end
    % mark the user selected region
    temphdl=stem(ahdl,rec{fileid}.data{EICid}(id1:id2,1),rec{fileid}.data{EICid}(id1:id2,2),'markersize',1,'color','m','tag','templine');
    % save the original information
    old_rec=temparary_save_EIC(rec,fileid,EICid,peakid,ahdl);
    % find index of peak tips that fall within the selected region
    [~,maxid]=max(rec{fileid}.data{EICid}(id1:id2,2));
    pidx=id1+maxid(1)-1;
    delete(temphdl); % remove the mark of the user selected region
    rec{fileid}.is_defined_by_bound{EICid}(peakid)=true;
    % update the peak signals
    rec{fileid}.is_compound{EICid}(:,peakid)=false(dlen,1);
    rec{fileid}.is_compound{EICid}(id1:id2,peakid)=true;
    % update the peak tip
    rec{fileid}.is_peak{EICid}(:,peakid)=false;
    rec{fileid}.is_peak{EICid}(pidx,peakid)=true;
    % update the coelute
    rec{fileid}.coelute{EICid}(peakid,:)=[false false];
    % update the decomvoluted peak signal
    rec{fileid}.decomp{EICid}(:,peakid)=zeros(size(rec{fileid}.decomp{EICid},1),1);
    % update the abundance
    tempy=rec{fileid}.data{EICid}(rec{fileid}.is_compound{EICid}(:,peakid),2)-rec{fileid}.bg_int{EICid}(rec{fileid}.is_compound{EICid}(:,peakid));
    tempx=rec{fileid}.data{EICid}(rec{fileid}.is_compound{EICid}(:,peakid),1);
    sumid=tempy>0;
    % use trapzoidal reule to compute peak area
    rec{fileid}.abundance{EICid}(peakid)=trapz(tempx(sumid),tempy(sumid));
    % update the status
    rec{fileid}.quant_note{EICid}(peakid)=0; % assign the status as Successful Quantitation
    % update the quantitation result
    hdlrec.UserData=rec;
    update_plots_in_EIC_window(hdlrec,hdlmeth,hdlpara,hdlastc,ahdl,fileid,compoundid);
    rec{fileid}.is_peak{EICid}(:,peakid)=false;
    rec{fileid}.is_peak{EICid}(pidx,peakid)=true;
    ptid=rec{fileid}.is_peak{EICid}(:,peakid);
    set(findobj('Tag','PB_sel_region'),'UserData',true);
    % obtain the handle of the progress bar
    pg_text=findobj('Tag','pg_text');
    % collect update parameter
    update_para.fileid = fileid;
    update_para.compid = compoundid;
    update_para.dir = 'file';
    update_para.bound = [rec{fileid}.data{EICid}(id1,1) rec{fileid}.data{EICid}(ptid,1) rec{fileid}.data{EICid}(id2,1)];
    update_para.xcord = -1;
    update_para.bg_int = -1;
    update_para.start_file = 0;
    update_para.end_file = -1;
    update_para.start_comp = 0;
    update_para.end_comp = -1;
    % check whether to keep the change
    select_EIC(update_para,1);
    if ~get(findobj('Tag','PB_sel_region'),'UserData') % restore the original EIC plot    
        % restore all the peak info
        hdlrec.UserData = restore_EIC(rec,old_rec,fileid,EICid,peakid,para,ahdl);
    else % commence the related updates
        % update the concentration and heatmap in the main window
        update_concentration_and_heatmap_matrix(fileid,compoundid,EICid,peakid,hdlrec,hdlmeth,hdlpara,hdlastc,hdlmtx,hdlimg);
        % update the plots of the same compound in other files
        show_compound_in_nearby_files('','',fileid,compoundid,hdlrec,hdlmeth,'',true);
        if isempty(findobj('Tag','reg_result')) && ...% not a standard curve data
            get(findobj('Tag','cb_normal'),'Value') % batch effect correction is checked
            % re-perform batch effect correction
            update_para=get(findobj('Tag','PB_show_norm'),'UserData');
            range=[update_para.start_file, update_para.end_file,...
                update_para.start_comp, update_para.end_comp];
            set(pg_text,'String','Performing batch effect correction...');
            batch_effect_correction(hdlrec,hdlmeth,hdlastc,hdlpara,hdlmtx,range);
            set(pg_text,'String','Performing batch effect correction...done!');
        end
        % allow user to save the result
        set(findobj('Tag','PB_save_result'),'UserData',false,'Enable','on');
    end
    set(pg_text,'String','Updating heatmap...');
    change_heatmap_abundent('','',hdlrec,hdlmeth,hdlpara,hdlmtx);  
    set(pg_text,'String','');
    ahdl.Toolbar.Visible = 'on';
end
%--------------------------------------------------------------
% determine the EIC range of a peak 
%--------------------------------------------------------------
function [bd,coelute,halfcount]=peak_tracing(xdata,ydata,didx,bg_int,sn_ratio,min_rt_diff,min_peak_dist)
    dlen=length(ydata);
    bgmin=max(0.001,min(bg_int));
    bg_int(bg_int<bgmin)=bgmin; % to avoid bg_int = 0 when computing the S/N ratio 
    px=xdata(didx);
    py=ydata(didx);
    if py <=0 || (didx < 4) || (didx > (dlen-3))
        bd=[didx didx];
        coelute=[0 0];
        halfcount=[0 0];
        return
    end
    % trace to the left
    lcoelute=false;% flag for coelution
    lcount=min(find((px-xdata)>min_rt_diff,1,'last'),(dlen-6)); % starting point for left search
    if isempty(lcount)
        lcount=1;
    end
    isHalfWidthFound=false; % whether the width at half height is found
    while (ydata(lcount)/py < 0.5) && (lcount < didx-2) % if the left starting point is lower than the halfheight width, gradually move back toward the tip
        lhalfcount=lcount;
        isHalfWidthFound=true;
        lcount = lcount+1;
    end
    valley=ydata(lcount:didx)<ydata(lcount); % whether there exists a local min between the tip and the left starting point
    if any(valley)
        lcount=min(lcount+find(valley,1,"last"),didx-3);
    end
    if ~isHalfWidthFound
        lhalfcount=didx;
    end
    while (ydata(lcount) > 0) && (lcount > 7) && (lcount < (dlen-6))
        lcount=lcount-1;
        if ~isHalfWidthFound && (ydata(lcount)/py<=0.5) % check the height to determine the peak's half-width
            lhalfcount=lcount;
            isHalfWidthFound=true;
        end
        diff1=ydata((lcount-6):(lcount-1))-ydata((lcount-5):lcount); % check the increasing/decreasing behaviors of the previous 5 peaks 
        diff2=ydata((lcount+1):(lcount+6))-ydata(lcount:(lcount+5)); % check the increasing/decreasing behaviors of the next 5 peaks 
        ratio1=max(ydata(lcount-6:lcount-4))/min(ydata(lcount-3:lcount-1));
        ratio2=max(ydata(lcount+4:lcount+6))/min(ydata(lcount+1:lcount+3));
        if ((sum(diff1>0) >= 3) || ((sum(diff1>0) >= 1) && (ratio1 > 1.04))) && ((sum(diff2>0) >= 3) || ((sum(diff2>0) >= 1) && (ratio2 > 1.04))) % there exists a local min.
            [minv,mid]=min(ydata((lcount-3):min(lcount+3,didx))); % find the index of the local min.
            if (lcount-4+mid) > 7 % move lcount to local min
                lcount=lcount-4+mid;
                if ~isHalfWidthFound && (ydata(lcount)/py<=0.5)
                    lcounttemp=lcount;
                    while (ydata(lcounttemp)/py<=0.5) && (lcounttemp<didx) % back trace the half-height width
                        lhalfcount=lcounttemp;
                        lcounttemp=lcounttemp+1;
                    end
                    isHalfWidthFound=true;
                end
            end
            [maxbump,maxid]=max(ydata(max(1,lcount-10):lcount));
            % use 3 criteria to check for coelution
            % 1. the left local min is higher than 30% of the peak tip
            c1=((minv/py)>0.3) && (minv/bg_int(didx)>=sn_ratio);
            % 2. the left local min is lower than 90% of the peak tip
            c2=(minv/py)<0.9 || ((didx-lcount) < 5 && minv<py);
            % 3. the left coeluted bump has sufficient hight
            c3=(py/(maxbump-minv)<20) && ... % the bump is tall enough (at least 1/20 of the peak height)
                (px-xdata(lcount)>min_rt_diff) && ... % the bump is wide enough
                (px-xdata(lcount-11+maxid)>min_peak_dist); % two coeluted peaks are fat enough
            if c1 && c2 && c3 % if the coelution is influential
                lcoelute=true;
            end
            if (c1 && ~c3) % jump from a small bump
                lcount=max(1,lcount-3);
            else
                break;
            end
        end
    end
    if ~lcoelute && (lhalfcount==didx) && (lcount<=7) % if the peak is very close to the left end of the data
        lhalfcount=find((ydata(1:lcount)./py)<=0.5,1,'last');
        if isempty(lhalfcount)
            lhalfcount=1;
        end
        [~,step]=min(ydata(1:lcount));
        lcount=step;
    end
    [lmax,lmaxid]=max(ydata(lcount:didx));
    if (lmax/py>1.05) && (px-xdata(lcount+lmaxid-1)>min_peak_dist) % the peak is left-coeluted but the local min is not obvious, re-locate the left bound
        [~,minid]=min(ydata((lcount+lmaxid-1):didx)); % find the vally between left bound and the peak tip
        if minid < length(ydata((lcount+lmaxid-1):didx))
            lcount=lcount+lmaxid+minid-2;
            lcoelute=true;
        end
    end
    if lhalfcount==didx
        lhalfcount=lcount;
    end
    ltaillen=px-xdata(lcount);
    lhalfwidth=xdata(didx)-xdata(lhalfcount);
    if ~lcoelute && (ltaillen > 2.5*lhalfwidth) && isHalfWidthFound % adjust the left bound if the left tail is longer than 2.5 times half-height width
        xdiff=abs(xdata(lcount:didx)-(px-2.5*lhalfwidth));
        [~,offset]=min(xdiff); % find the closest location at 2.5*halfwidth
        lcount=max(1,lcount+offset-1);
    end
    %trace to the right
    rcoelute=false;% flag for coelution 
    rcount=max(7,find((xdata-px)>min_rt_diff,1,'first')); % starting point for right search
    if isempty(rcount)
        rcount=dlen;
    end
    isHalfWidthFound=false; % whether the width at half height is found
    while (ydata(rcount)/py < 0.5) && (rcount > didx+2) % if the right starting point is lower than the halfheight width, gradually move back toward the tip
        rhalfcount=rcount;
        isHalfWidthFound=true;
        rcount = rcount-1;
    end
    valley=ydata(didx:rcount)<ydata(rcount); % whether there exists a local min between the tip and the left starting point
    if any(valley)
        rcount=max(rcount-find(valley,1,'first'),didx+3);
    end
    if ~isHalfWidthFound
        rhalfcount=didx;
    end
    while (ydata(rcount) > 0) && (rcount < (dlen-7)) && (rcount>6)
        rcount=rcount+1;
        if ~isHalfWidthFound && (ydata(rcount)/py<=0.5) % check the height to determine the peak's half-width
            rhalfcount=rcount;
            isHalfWidthFound=true;
        end
        diff1=ydata((rcount-6):(rcount-1))-ydata((rcount-5):rcount);
        diff2=ydata((rcount+1):(rcount+6))-ydata(rcount:(rcount+5));
        ratio1=max(ydata(rcount-6:rcount-4))/min(ydata(rcount-3:rcount-1));
        ratio2=max(ydata(rcount+4:rcount+6))/min(ydata(rcount+1:rcount+3));
        if ((sum(diff1>0) >= 3) || ((sum(diff1>0) >= 1) && (ratio1 > 1.04))) && ((sum(diff2>0) >= 3) || ((sum(diff2>0) >= 1) && (ratio2 > 1.04))) % there exists a local min.
            [minv,mid]=min(ydata(max(didx,rcount-3):(rcount+3))); % find the index of the local min.
            if (rcount-4+mid) < (dlen-7)
                rcount=rcount-4+mid;
                if ~isHalfWidthFound && (ydata(rcount)/py<=0.5)
                    rcounttemp=rcount;
                    while (ydata(rcounttemp)/py<=0.5) &&  (rcounttemp>didx)% back trace the half-height width
                        rhalfcount=rcounttemp;
                        rcounttemp=rcounttemp-1;
                    end
                    isHalfWidthFound=true;
                end
            end
            [maxbump,maxid]=max(ydata(rcount:min(dlen,rcount+10)));
            % use 3 criteria to check for coelution
            c1=((minv/py)>0.3) && (minv/bg_int(didx)>=sn_ratio); %the right local min is higher than 10% of the peak tip
            c2=(minv/py)<0.9 || ((rcount-didx) < 5 && minv<py); % the local min does not occur at the peak tip
            c3=(py/(maxbump-minv)<20) && ... % the bump is tall enough (at least 1/20 of the peak height)
                (xdata(rcount)-px>min_rt_diff) && ... % the bump is wide enough
                (xdata(rcount+maxid-1)-px>min_peak_dist); % two coeluted peaks are fat enough
            if c1 && c2 && c3 % if the coelution is influential
                rcoelute=true;
            end
            if c1 && ~c3 % jump from a small bump
                rcount=min(dlen,rcount+3);
            else
                break;
            end
        end
    end
    if ~rcoelute && (rhalfcount==didx) && (rcount>=(dlen-7)) % if the peak is very close to the right end of the data
        step=find((ydata(rcount:dlen)./py)<=0.5,1,'first');
        if isempty(step)
            rhalfcount=dlen;
        else
            rhalfcount=rcount+step-1;
        end
        [~,step]=min(ydata(rcount:dlen));
        rcount=rcount+step-1;
    end
    [rmax,rmaxid]=max(ydata(didx:rcount));
    if (rmax/py>1.05) && (xdata(didx+rmaxid-1)-px>min_peak_dist) % the peak is right-coeluted but the local min is not obvious, redefine the right bound
        [~,minid]=min(ydata(didx:(didx+rmaxid-1))); % find the vally
        if minid > 1
            rcount=didx+minid-1;
            rcoelute=true;
        end
    end
    if rhalfcount==didx
        rhalfcount=rcount;
    end
    rtaillen=xdata(rcount)-px;
    rhalfwidth=xdata(rhalfcount)-px;
    if ~rcoelute && (rtaillen > 2.5*rhalfwidth) && isHalfWidthFound% adjust the right bound if the right tail is longer than 2.5 times half-height width
        xdiff=abs(xdata(didx:rcount)-(px+2.5*rhalfwidth));
        [~,offset]=min(xdiff); % find the closest location at 2.5*halfwidth
        rcount=max(1,didx+offset-1);
    end
    bd=[lcount rcount];
    coelute=[lcoelute rcoelute];
    halfcount=[lhalfcount rhalfcount];
end            
% ------------------------------------------------------------------
% given a peak location ID(centid), boundary IDs(bdid), matched compound(compid),
% compound data(data), standard compound name and location(std), and
% quantitation parameters(para), this function compute compound data(data)
% for the peak
% ------------------------------------------------------------------
function rec=peak_deconvolution(centid,fileid,compoundid,peakid,rec,halfcount,bg_int,sn_ratio,min_rt_diff,min_peak_dist)
    hdlpara=findobj('tag','pl_para');
    xdata=rec{fileid}.data{compoundid}(:,1);
    sdata=rec{fileid}.smoothy{compoundid};
    maxv=sdata(rec{fileid}.pidx{compoundid}(centid)); % height of the peak of interest
    cpbd=rec{fileid}.bdp{compoundid}(peakid,:);
    tipidx=rec{fileid}.pidx{compoundid};
    LOCS=xdata(tipidx); % EIC time of peak tips in the EIC
    bound=[0 0];
    lhalfwidth=LOCS(centid)-xdata(halfcount(1));
    rhalfwidth=xdata(halfcount(2))-LOCS(centid);
    halfwidth=[lhalfwidth,rhalfwidth];
    halfwidth=halfwidth(halfwidth>0);
    csigma0=max(mean(halfwidth),0.5*min_rt_diff); %sigma of the peak of interest
    % look for the width at half-height for the estimation of sigma for the
    % peak that coeluted on the left
    lsigma0=[];
    if (rec{fileid}.coelute{compoundid}(peakid,1)) && (centid > 1) % the peak is left-coeluted
        try 
            [lpbd,~,lphalfcount]=peak_tracing(xdata,sdata,tipidx(centid-1),bg_int,sn_ratio,min_rt_diff,min_peak_dist); % trace the bounds and halfwidthheight of the left peak
        catch 
            msg=['The ',num2str(compoundid),'-th compound in ',num2str(fileid),'-th file cannot be successfully peak-traced (left) during deconvolution!'];
            meglist=findobj('Tag','quant_msg');
            QuantMsg=meglist.String;
            meglist.String=[QuantMsg;{msg}];
            if ~get(findobj('Tag','PB_show_msg'),'UserData')
                show_quantitation_message('','',1,hdlpara);
            end
            return;
        end
        lhalfwidth=LOCS(centid-1)-xdata(lphalfcount(1));
        rhalfwidth=xdata(lphalfcount(2))-LOCS(centid-1);
        halfwidth=[lhalfwidth,rhalfwidth];
        halfwidth=halfwidth(halfwidth>0);
        lsigma0=min(halfwidth); %sigma of the left peak
        if isempty(lsigma0)
            lhalfwidth=LOCS(centid-1)-xdata(lpbd(1));
            rhalfwidth=xdata(lpbd(2))-LOCS(centid-1);
            halfwidth=[lhalfwidth,rhalfwidth];
            halfwidth=halfwidth(halfwidth>0);
            lsigma0=max(halfwidth);
        end
        bound(1)=lpbd(1);
    end
    if bound(1) == 0
        bound(1) = cpbd(1);
    end
    bound(2) = cpbd(2);
    % look for the width at half-height for the estimation of sigma for the
    % peak that coeluted on the left
    rsigma0=[];
    if (rec{fileid}.coelute{compoundid}(peakid,2) && (centid < length(LOCS))) % the peak is right-coeluted
        try
            [rpbd,~,rphalfcount]=peak_tracing(xdata,sdata,tipidx(centid+1),bg_int,sn_ratio,min_rt_diff,min_peak_dist);
        catch
            msg=['The ',num2str(compoundid),'-th compound in ',num2str(fileid),'-th file cannot be successfully peak-traced (right) during deconvolution!'];
            meglist=findobj('Tag','quant_msg');
            QuantMsg=meglist.String;
            meglist.String=[QuantMsg;{msg}];
            if ~get(findobj('Tag','PB_show_msg'),'UserData')
                show_quantitation_message('','',1,hdlpara);
            end
            return;
        end
        lhalfwidth=LOCS(centid+1)-xdata(rphalfcount(1));
        rhalfwidth=xdata(rphalfcount(2))-LOCS(centid+1);
        halfwidth=[lhalfwidth,rhalfwidth];
        halfwidth=halfwidth(halfwidth>0);
        rsigma0=min(halfwidth); %sigma of the right peak
        if isempty(rsigma0)
            lhalfwidth=LOCS(centid+1)-xdata(rpbd(1));
            rhalfwidth=xdata(rpbd(2))-LOCS(centid+1);
            halfwidth=[lhalfwidth,rhalfwidth];
            halfwidth=halfwidth(halfwidth>0);
            rsigma0=max(halfwidth);
        end
        bound(2)=rpbd(2);
    end
    sigma0=[lsigma0;csigma0;rsigma0]; % sigma of the coeluted peaks
    leftid=centid-rec{fileid}.coelute{compoundid}(peakid,1);
    rightid=centid+rec{fileid}.coelute{compoundid}(peakid,2);
    pids=leftid:rightid; % coeluted peak IDs
    % solve the deviation (sigma) of each gaussian wave
    localid=find(pids==centid); % ID of the current peak
    centers=LOCS(pids); % ceter of the coeluted peaks
    mag0=sdata(rec{fileid}.pidx{compoundid}(pids)); % height of the coeluted peaks
    try
        newx=solve_coelution([sigma0;mag0],centers,[xdata(bound(1):bound(2)) sdata(bound(1):bound(2))]);
    catch
        msg=['The ',num2str(compoundid),'-th compound in ',num2str(fileid),'-th file cannot be successfully deconvoluted!'];
        meglist=findobj('Tag','quant_msg');
        QuantMsg=meglist.String;
        meglist.String=[QuantMsg;{msg}];
        if ~get(findobj('Tag','PB_show_msg'),'UserData')
            show_quantitation_message('','',1,hdlpara);
        end
        rec{fileid}.quant_note{compoundid}(peakid)=4; % defect in quantitation
        return;
    end
    sigma=newx(1:length(sigma0)); % deconvoluted sigmas
    mag=newx((length(sigma0)+1):end); % deconvoluted peak heights
    startid=find(xdata<=(max(centers(localid)-3*sigma(localid),xdata(1))),1,'last');
    endid=find(xdata>=min((centers(localid)+3*sigma(localid)),xdata(end)),1,'first'); % deconvoluted peak right boundary
    y=mag(localid)*gaussmf(xdata(startid:endid),[sigma(localid) centers(localid)]); % deconvoluted peak signals
    % adjust the magnitude if the computed one is much higher/lower than the original signal
    maxy=max(y);
    if (maxy/maxv > 1.1) %|| (maxy/maxv < 0.9)
        y=y/(maxy/maxv);
    end
    rec{fileid}.decomp{compoundid}(:,peakid)=zeros(size(sdata));
    rec{fileid}.decomp{compoundid}(startid:endid,peakid)=y+bg_int(startid:endid);
end
% ----------------------------------------------------------
% Create a window to modify the standard compound information
% -----------------------------------------------------------
function modify_compound_parameters(~,~)
    global bgcolor
    fhdl=findobj('tag','fg_comp_para');
    if ~isempty(fhdl)
        close(fhdl);
    end
    tblhdl=findobj('Tag','tbl_comp_list');
    fig=figure('Color',bgcolor,...
        'Menubar','none',...
        'NumberTitle','off', ...
        'Name','Standard Compound Information', ...
        'Units','normalized',...
        'Position',[0.45, 0.1, 0.2, 0.7],...
        'Tag','fg_comp_para'); % Open a new figure for standard compound info
    uicontrol('Parent',fig, ...
        'FontUnits','normalized', ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'Position',[0.05 0.93 0.5 0.04],...
        'String','Fixed difference at',...
        'Style','text');
   % edit box for fixed RT
    uicontrol('Parent',fig, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor','w', ...
        'KeyPressFcn',{@check_RT_tol},...
        'Position',[0.55 0.935 0.3 0.04],...
        'String','0.05', ...
        'Style','edit',...
        'Tag','ed_fix_diff');
    % Diaplay information for standard compound
    uitable('Parent',fig,...
        'Data',tblhdl.Data,...
        'units','normalized',...
        'position',[0.05 0.11 0.9 0.8],...
        'CellEditCallback',@check_modify,...
        'ColumnName',tblhdl.ColumnName,...
        'ColumnWidth',tblhdl.ColumnWidth,...
        'ColumnEditable',true,...
        'FontSize',12,...
        'Tag','tbl_comp_info');
    % button for save the new compound info
    uicontrol('Parent',fig, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',bgcolor, ...
        'Callback',@save_comp_modify, ...
        'Position',[0.05 0.03 0.29 0.05],...
        'String','Save', ...
        'Style','pushbutton',...
        'Tooltip','Save the modifications to a file');
    % button for save the new compound info into a new file
    uicontrol('Parent',fig, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',bgcolor, ...
        'Callback',@update_comp_modify, ...
        'Position',[0.35 0.03 0.29 0.05],...
        'String','Ok', ...
        'Style','pushbutton',...
        'Tag','pb_ok',...
        'Tooltip','Update the modifications and proceed quantitation');
    % button for abamdon all modifications
    uicontrol('Parent',fig, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',bgcolor, ...
        'Callback','close(gcf)', ...
        'Position',[0.65 0.03 0.3 0.05],...
        'String','Cancel', ...
        'Style','pushbutton',...
        'Tag','pb_cancel',...
        'Tooltip','Proceed quantitation disregarding the modifications');
end
% ----------------------------------------------------------
% save the modified compound information to a file
% ----------------------------------------------------------
function save_comp_modify(~,~)
    tblhdl=findobj('tag','tbl_comp_info');
    [file,path,index] = uiputfile('*.csv');
    if all(file ~= 0) && ~isempty(tblhdl) && (index == 1)
        data=tblhdl.Data;
        tbl=cell2table(data);
        tbl.Properties.VariableNames=tblhdl.ColumnName;
        writetable(tbl,fullfile(path,file));
    end
end
% ----------------------------------------------------------
% check and update the max. allowable RT difference
% ----------------------------------------------------------
function check_RT_tol(~, eventdata)
    keystr=eventdata.Key;
    allow_key={'backspace','home','end','leftarrow','rightarrow','uparrow','downarrow','pageup','pagedown','decimal','numlock','period'};
    % chech the validity of the pressed key 
    if length(keystr) == 1
        keynum=str2double(keystr);
        if isnan(keynum) || ~ismember(keystr, '.1234567890')
            hdl=errordlg('Only numerical values are allowed!','Input Error',struct('WindowStyle','modal','Interpreter','tex'));
            waitfor(hdl);
        end
        return
    end
    if contains(keystr,'numpad')
        keynum=str2double(keystr(end));
        if isnan(keynum) || ~ismember(keystr(end), '.1234567890')
            hdl=errordlg('Only numerical values are allowed!','Input Error',struct('WindowStyle','modal','Interpreter','tex'));
            waitfor(hdl);
        end
        return
    end
    if strcmpi(eventdata.Key,'return') % only update the data when 'return' key is pressed
        pause(0.005);
        diffstr=get(findobj('Tag','ed_fix_diff'),'string');
        if ~all(ismember(diffstr, '.1234567890'))
            hdl=errordlg('Only numerical values are allowed!','Input Error',struct('WindowStyle','modal','Interpreter','tex'));
            waitfor(hdl);
            return
        end
        diffnum=str2double(diffstr);
        if isnan(diffnum)
            hdl=errordlg('Only numerical values are allowed!','Input Error',struct('WindowStyle','modal','Interpreter','tex'));
            waitfor(hdl);
            return
        end
        tblhdl=findobj('tag','tbl_comp_info');
        if ~isempty(tblhdl) 
            nos=size(tblhdl.Data,1);
            tblhdl.Data(:,3)=mat2cell(diffnum*ones(nos,1),ones(nos,1));
        end
    else
        if ~ismember(keystr,allow_key)
            hdl=errordlg('Only numerical values are allowed!','Input Error',struct('WindowStyle','modal','Interpreter','tex'));
            waitfor(hdl);
        end
    end
end
% ----------------------------------------------------------
% update the modified compound information
% ----------------------------------------------------------
function update_comp_modify(~,~)
    % load standard compound info
    method=get(findobj('Tag','pl_comp'),'UserData');
    tblhdl1=findobj('Tag','tbl_comp_info');
    tblhdl2=findobj('Tag','tbl_comp_list');
    data=tblhdl1.Data;
    nos=size(data,1);
    % check the validity of the values in the RT column of the table
    for i=1:nos
        % remove space in the string
        sid=isspace(data{i,2});
        data{i,2}(sid)=[];
        % split the remaining string with semi-colons
        locstr=textscan(data{i,2},'%s','delimiter',';');
        temploc=str2double(locstr{1});
        if ~all(ismember(data{i,2}, '.1234567890;')) || any(isnan(temploc))
            hdl=errordlg('Only numerical values separated by semicolon are allowed!','Input Error',struct('WindowStyle','modal','Interpreter','tex'));
            waitfor(hdl);
            % Select cell programmatically
            jUIScrollPane = findjobj(tblhdl1);
            jUITable = jUIScrollPane.getViewport.getView;
            jUITable.changeSelection(i-1,1, false, false);
            return
        end
    end
    % check the validity of the values in the RT_tol column of the table
    for i=1:nos
        if isnan(data{i,3})
            hdl=errordlg('Only numerical values are allowed!','Input Error',struct('WindowStyle','modal','Interpreter','tex'));
            waitfor(hdl);
            % Select cell programmatically
            jUIScrollPane = findjobj(tblhdl1);
            jUITable = jUIScrollPane.getViewport.getView;
            jUITable.changeSelection(i-1,2, false, false);
            return
        end
    end
    if ~isempty(tblhdl1) 
        tblhdl2.Data=tblhdl1.Data;
    end
    for i=1:nos
        method.orig_name{i}=tblhdl2.Data{i,1};
        method.rt{i}=cell2mat(textscan(tblhdl2.Data{i,2},'%f','delimiter',';'));
        method.rt_diff=cell2mat(tblhdl2.Data(:,3));
    end
    set(findobj('Tag','pl_comp'),'UserData',method);
    close(gcf);
end
% ----------------------------------------------------------
% check whether the modification in the table is legitmate
% ----------------------------------------------------------
function check_modify(~,eventdata)
    tempstr = eventdata.EditData;
    c = eventdata.Indices(2);
    % if the modification is not in the first column, check the input string
    if c == 2
        locstr=textscan(tempstr,'%s','delimiter',';');
        temploc=str2double(locstr{1});
        if ~all(ismember(tempstr, '.1234567890;')) || any(isnan(temploc))
            hdl=errordlg('Only numerical values separated by semicolon are allowed!','Input Error',struct('WindowStyle','modal','Interpreter','tex'));
            waitfor(hdl);
            return
        end
    end
    if c == 3
        if ~all(ismember(tempstr, '.1234567890')) || isnan(str2double(tempstr))
            hdl=errordlg('Only numerical values are allowed!','Input Error',struct('WindowStyle','modal','Interpreter','tex'));
            waitfor(hdl);
            return
        end
    end
end
% ----------------------------------------------------------
% adjust the display region of the heatmap if the horizontal slider is moved
% ----------------------------------------------------------
function horizontal_slider_adjust(hobj,~,ax1,ax2,hdlpara)
    value=hobj.Value;
    if strcmpi(ax1.Visible,'on') % the current active axes is AX_heat_map
        noc=1;
        for i=1:length(ax1.Children)
            if strcmpi(class(ax1.Children(i)),'matlab.graphics.primitive.Image')
                noc=size(ax1.Children(i).CData,2);
            end
        end
        para=hdlpara.UserData;
        comp_num=para.comp_num;
        startp=value*(noc-comp_num);
        if (startp+comp_num) >= noc
            xlimnew=[noc-comp_num+0.5 noc+0.5];
        else
            xlimnew=[startp+0.5 startp+comp_num+0.5];
        end
        ax1.XLim=xlimnew;
        pause(0.005);
    else % the current active axes is AX_TIC_plot
        xlim=ax2.XLim;
        xlen=xlim(2)-xlim(1);
        shdl=ax2.Children;
        xdata=shdl(1).XData;
        xrange=xdata(end)-xdata(1);
        startp=value*(xrange-xlen);
        if (startp+xlen) >= xrange
            xlimnew=[xdata(end)-xlen xdata(end)];
        else
            xlimnew=[startp startp+xlen];
        end
        ax2.XLim=xlimnew;
    end
end
% ----------------------------------------------------------
% adjust the display region of the heatmap if the vertical slider is moved
% ----------------------------------------------------------
function vertical_slider_adjust(hobj,~,ax1,ax2,hdlpara)
    value=(1.0-hobj.Value);
    if strcmpi(ax1.Visible,'on') % the current active axes is AX_heat_map
        nof=1;
        for i=1:length(ax1.Children)
            if strcmpi(class(ax1.Children(i)),'matlab.graphics.primitive.Image')
                nof=size(ax1.Children(i).CData,1);
            end
        end
        para=hdlpara.UserData;
        file_num=para.file_num;
        startp=value*(nof-file_num);
        if (startp+file_num) >= nof
            ylimnew=[nof-file_num+0.5 nof+0.5];
        else
            ylimnew=[startp+0.5 startp+file_num+0.5];
        end
        ax1.YLim=ylimnew;
    else % the current active axes is AX_TIC_plot
        ylim=ax2.YLim;
        ylen=ylim(2)-ylim(1);
        shdl=ax2.Children;
        ydata=shdl(1).YData;
        yrange=max(ydata)-min(ydata);
        startp=(1.0-value)*(yrange-ylen);
        if (startp+ylen) >= yrange
            ylimnew=[max(ydata)-ylen max(ydata)];
        else
            ylimnew=[startp startp+ylen];
        end
        ax2.YLim=ylimnew;
    end
end
% ----------------------------------------------------------
% perform check ups for all parameter settings
% ----------------------------------------------------------
function is_passed=parameter_check()
    is_passed=true;
    % check for the background intensity
    if get(findobj('Tag','cb_auto_bg'),'Value')==0
        edhdl=findobj('tag','ed_bg_int');
        bg_int=str2double(get(edhdl,'String'));
        if isnan(bg_int) || (bg_int < 0)
            is_passed=false;
            if bg_int < 0
                hdl=errordlg('The "Background Intensity" given in the Parameters panel can not be less than 0','Input Error',struct('WindowStyle','modal','Interpreter','tex'));
            else
                hdl=errordlg('The "Background Intensity" given in the Parameters panel is not a numerical value','Input Error',struct('WindowStyle','modal','Interpreter','tex'));
            end
            waitfor(hdl);
            uicontrol(edhdl);
            return
        end
    end
    % check for the smoothing window size
    if get(findobj('Tag','cb_auto_smooth'),'Value')==0
        edhdl=findobj('tag','ed_smooth_win');
        winsize=str2double(get(edhdl,'String'));
        if isnan(winsize) || (winsize < 3)
            is_passed=false;
            if winsize < 0
                hdl=errordlg('The "Smoothing Window Size" given in the Parameters panel can not be less than 3','Input Error',struct('WindowStyle','modal','Interpreter','tex'));
            else
                hdl=errordlg('The "Smoothing Window Size" given in the Parameters panel is not a numerical value','Input Error',struct('WindowStyle','modal','Interpreter','tex'));
            end
            waitfor(hdl);
            uicontrol(edhdl);
            return
        end
    end
    % check for the S/N ratio
    edhdl=findobj('tag','ed_sn_ratio');
    if isnan(str2double(get(edhdl,'String')))
        is_passed=false;
        hdl=errordlg('The "Signal-To-Noise(S/N) Ratio" given in the Parameters panel is not a numerical value','Input Error',struct('WindowStyle','modal','Interpreter','tex'));
        waitfor(hdl);
        uicontrol(edhdl);
        return
    end
    % check for the min RT difference for Deconvoluting Coeluted Peaks
    edhdl=findobj('tag','ed_min_peak_width');
    if isnan(str2double(get(edhdl,'String')))
        is_passed=false;
        hdl=errordlg('The "Min. RT difference for Deconvoluting Coeluted Peaks" given in the Parameters panel is not a numerical value','Input Error',struct('WindowStyle','modal','Interpreter','tex'));
        waitfor(hdl);
        uicontrol(edhdl);
        return
    end
end
% ----------------------------------------------------------
% save the system parameters to a default or a specified file
% ----------------------------------------------------------
function save_parameter(~,~,idx,hdldirinfo,hdlpara)
    is_passed=parameter_check;
    if ~is_passed
        return
    end
    % retrive the old parameters
    para=hdlpara.UserData;
    % update the parameters
    para.dir=get(findobj('Tag','edit_dir'),'String'); % default working directory
    % check for the background intensity
    para.bg_auto=get(findobj('Tag','cb_auto_bg'),'Value');
    para.bg_int=str2double(get(findobj('tag','ed_bg_int'),'String'));
    % check for the S/N ratio
    para.sn_ratio=str2double(get(findobj('tag','ed_sn_ratio'),'String'));
    % check for the smoothing window size
    para.smooth_auto=get(findobj('Tag','cb_auto_smooth'),'Value');
    para.smooth_win=str2double(get(findobj('tag','ed_smooth_win'),'String'));
    % check for the min RT difference for Deconvoluting Coeluted Peaks
    para.min_peak_width=str2double(get(findobj('tag','ed_min_peak_width'),'String'));
    para.min_peak_dist=str2double(get(findobj('tag','ed_min_peak_dist'),'String'));
    para.auto_deconv=get(findobj('tag','rb_auto_deconv'),'Value');
    para.always_deconv=get(findobj('tag','rb_always_deconv'),'Value');
    para.no_deconv=get(findobj('tag','rb_no_deconv'),'Value');
    % update the parameters
    hdlpara.UserData=para;
    T=struct2table(para,'AsArray',true);
    if idx==0
        writetable(T,'default_parameter.xlsx');
    else
        dirinfo=hdldirinfo.UserData;
        cd(dirinfo{2}); % change to the most recent accessed folder
        [file,path] = uiputfile('*.xlsx');
        cd(dirinfo{1}); % change back to the program folder
        if file ~= 0
            hdldirinfo.UserData={dirinfo{1};path};
            writetable(T,fullfile(path,file));
        end
    end
end
% ----------------------------------------------------------
% load existing settings to the system
% ----------------------------------------------------------
function load_parameter(~,~,hdldirinfo)
    dirinfo=hdldirinfo.UserData;
    cd(dirinfo{2}); % change to the most recent accessed folder
    [file,path] = uigetfile('*.xlsx');
    cd(dirinfo{1}); % change back to the program folder
    if file~= 0
        hdldirinfo.UserData={dirinfo{1};path};% save the current folder
        T=readtable([path,file]);
        para=table2struct(T);
        set(findobj('Tag','edit_dir'),'String',para.dir); % default working directory
        set(findobj('Tag','cb_auto_bg'),'Value',para.bg_auto);
        set(findobj('tag','ed_bg_int'),'String',num2str(para.bg_int));
        set(findobj('tag','ed_sn_ratio'),'String',num2str(para.sn_ratio));
        set(findobj('Tag','cb_auto_smooth'),'Value',para.smooth_auto);
        set(findobj('tag','ed_smooth_win'),'String',num2str(para.smooth_win));
        set(findobj('tag','ed_min_peak_width'),'String',num2str(para.min_peak_width));
        set(findobj('tag','ed_min_peak_dist'),'String',num2str(para.min_peak_dist));
        set(findobj('tag','rb_auto_deconv'),'String',num2str(para.auto_deconv));
        set(findobj('tag','rb_always_deconv'),'String',num2str(para.always_deconv));
        set(findobj('tag','rb_no_deconv'),'String',num2str(para.no_deconv));
    end
end
% ----------------------------------------------------------
% clear existing quantitation results
% ----------------------------------------------------------
function clear_existing_results()
    mainwin=findobj('Tag','MRM_Quant');
    set(mainwin,'WindowButtonMotionFcn',[],'WindowKeyPressFcn',[]); % disable showing quantitation result when hovering the heatmap
    set(findobj('Tag','PB_quant'),'UserData','New','String','<html><font color="green"><p style="text-align:center;">Start<br>Quantitation</p></html>');
    set(findobj('Tag','PB_save_result'),'UserData',true); % set the save status to true
    set(findobj('Tag','pl_comp'),'UserData',[]); % clear method info
    set(findobj('Tag','list_file'),'String',''); % clear sample list
    set(findobj('Tag','quant_msg'),'String',''); % clear quantitation message
    show_quantitation_message('','',0,findobj('Tag','pl_para'));
    set(findobj('Tag','tbl_comp_list'),'Data',[]); % clear compound list
    set(findobj('Tag','cb_normal'),'UserData',1);% set the batch effect correction to on
    set(findobj('Tag','AX_TIC_plot'),'UserData',0); % clear current file index
    % clear previous quantitation results
    rec=mainwin.UserData;
    if ~isempty(rec)
        for i=1:length(rec)
            rec{i} = structfun(@(x) [], rec{i}, 'UniformOutput', false);
        end
    end
    mainwin.UserData=rec;
    % clear standard curve data
    rhdl=findobj('tag','rb_abs_stc'); % standard curve data 
    exp=rhdl.UserData;
    if ~isempty(exp) % if the standard curve data is non-empty
        exp=structfun(@(x) [], exp, 'UniformOutput', false);
    end
    rhdl.UserData=exp;
    cla(findobj('Tag','AX_heat_map')); % clear heatmap
    cla(findobj('Tag','AX_TIC_plot')); % clear TIC
    % deactive inspection mode
    set(findobj('Tag','PB_inspect_mode'),'Value',0,'String','Activate Inspection Mode');
    % close EIC inspection window
    fig=findobj('Tag','fg_EIC');
    if ~isempty(fig), delete(fig); end
    set(findall(findobj('Tag','pl_comp'),'-property','enable'),'enable','off'); % disable the compound info window
    set(findall(findobj('Tag','pl_para'),'-property','enable'),'enable','off'); % disable the quantitation parameter window
    % clear progress bar
    set(findobj('Tag','pg_bar'),'Position',[0.0 0.0 0.0 1.0],'FaceColor','b')
    set(findobj('Tag','pg_text'),'String','');
end
% ----------------------------------------------------------
% expand the compound information panel for easy inspection
% ----------------------------------------------------------
function expand_compound_information(hobj,~)
    bstr=get(hobj,'String');
    if strcmpi(bstr,'Expand')
        uistack(hobj.Parent,'top');
        set(hobj.Parent,'Position',[0.15 0.1 0.4 0.9]);
        % title of the top-left frame
        set(findobj('Tag','txt_comp'),'Position',[0 0.9 1 0.1]);
        % text showing number of compounds
        set(findobj('Tag','compound_loc'),'Position',[0.83 0.85 0.17 0.08]);
        % table of the detected compounds
        set(findobj('Tag','tbl_comp_list'),'position',[0.02 0.05 0.8 0.9]);
        % button to change the detected compound list
        set(findobj('Tag','PB_new'),'Position',[0.85 0.8 0.13 0.05]);
        % button to change the detected compound list
        set(findobj('Tag','PB_modify'),'Position',[0.85 0.7 0.13 0.05]);
        % button to change the detected compound list
        set(hobj,'String','Shrink','Position',[0.85 0.6 0.13 0.05]);
    else
        set(hobj.Parent,'Position',[0.15 0.8 0.3 0.2]);
        % title of the top-left frame
        set(findobj('Tag','txt_comp'),'Position',[0 0.8 1 0.2]);
        % text showing number of compounds
        set(findobj('Tag','compound_loc'),'Position',[0.75 0.67 0.25 0.13]);
        % table of the detected compounds
        set(findobj('Tag','tbl_comp_list'),'position',[0.02 0.05 0.73 0.75]);
        % button to change the detected compound list
        set(findobj('Tag','PB_new'),'Position',[0.78 0.46 0.2 0.17]);
        % button to change the detected compound list
        set(findobj('Tag','PB_modify'),'Position',[0.78 0.25 0.2 0.17]);
        % button to change the detected compound list
        set(hobj,'String','Expand','Position',[0.78 0.04 0.2 0.17]);
    end
end
% ----------------------------------------------------------
% expand the plot window for easy inspection
% ----------------------------------------------------------
function expand_plot_window(hobj,~)
    bstr=get(hobj,'String');
    if strcmpi(bstr,'Expand')
        uistack(hobj.Parent,'top');
        set(hobj.Parent,'Position',[0.0 0.0 1.0 1.0]);
        % button to change the detected compound list
        set(hobj,'String','Shrink');%,'Position',[0.85 0.6 0.13 0.05]);
    else
        set(hobj.Parent,'Position',[0.15 0.03 0.85 0.77]);
        % button to change the detected compound list
        set(hobj,'String','Expand');%,'Position',[0.78 0.04 0.2 0.17]);
    end
end
% ----------------------------------------------------------
% activate/deactivate the inspection mode (heat map to EIC )
% ----------------------------------------------------------
function inspection_mode(hobj,~,mainwin)
    EICwin=findobj('Tag','fg_EIC');
    if hobj.Value == 1 % the "activate inspection mode" button is pressed
        hobj.String = 'Deactivate Inspection Mode';
        set(mainwin,'WindowButtonMotionFcn',@cursorPos,'WindowKeyPressFcn',@KeyDirect);
        if ~isempty(EICwin)
            set(EICwin,'WindowKeyPressFcn',@KeyDirect);
        end
    else % the "deactivate inspection mode" button is pressed
        hobj.String = 'Activate Inspection Mode';
        set(mainwin,'WindowKeyPressFcn','');
        set(EICwin,'WindowKeyPressFcn','');
        hdl1=findobj('Tag','sel_rect');
        hdl2=findobj('Tag','temp_rect');
        hdl3=findobj('Tag','tip_text');
        if ~isempty(hdl1)
            delete(hdl1);
        end
        if ~isempty(hdl2)
            delete(hdl2);
            delete(hdl3);
        end
        if ~isempty(EICwin) % hide the EIC inspection window
            set(EICwin,'Visible','off','Hittest','off');
        end
    end
end
% ----------------------------------------------------------
% deal with procedures when a pixel in the heat map is selected
% ----------------------------------------------------------
function heat_map_selection(hdlimg,~,phdl)
    % delete previous rectangle
    rhdl=findobj('tag','temp_rect');
    lhdl=findobj('tag','tip_text');
    if ~isempty(rhdl) % check for the exist of the previous notations
        delete(rhdl); % remove the previous notation rectangle
        delete(lhdl); % remove the previous text box
    end
    shdl=findobj('tag','sel_rect');
    if ~isempty(shdl) % check for the exist of the previous selection box
        delete(shdl); % remove the previous selection box
    end
    coord=get(phdl,'CurrentPoint');
    x=coord(1,1);
    y=coord(1,2);
    if (x >= phdl.XLim(1)) && (x <= phdl.XLim(2)) && (y >= phdl.YLim(1)) && (y <= phdl.YLim(2)) && (get(findobj('Tag','PB_inspect_mode'),'Value')==1)
        intx=round(x);
        inty=round(y);
        % get the color of the selected box
        ihdl=findobj(phdl.Children,'type','Image');
        cid=ihdl.CData;
        aid=ihdl.AlphaData;
        cmin = min(cid(:));
        cmax = max(cid(:));
        cmap=colormap;
        m = length(cmap);
        if aid(inty,intx)>0.5
            index = fix((cid(inty,intx)-cmin)/(cmax-cmin)*m)+1; 
            RGB = 1.0-ind2rgb(index,cmap);
        else
            RGB = [0,0,0];
        end
        % update the selected file in the file list
        set(findobj('Tag','list_file'),'Value',inty);
        % update the rectangle in the heatmap
        rectangle(phdl,'Position',[intx-0.5,inty-0.5,1,1],'EdgeColor',RGB,'LineWidth',3,'LineStyle','-','tag','sel_rect');
        % show EIC in a window
        plot_EIC(hdlimg,'',inty,intx);
    end
end
% -----------------------------------------------------------------------------------------------
% Show compound quantitation result when the mouse is over a heatmap cell during activation mode
% -----------------------------------------------------------------------------------------------
function cursorPos(hobj,~)
    % delete previous rectangle
    rhdl=findobj('tag','temp_rect');
    lhdl=findobj('tag','tip_text');
    if contains(lower(get(findobj('Tag','PB_quant'),'UserData')),'standard') % quantitation on standard compound data
        % find number of compounds
        method=get(findobj('Tag','rb_abs_stc'),'UserData');
        compound=method.indiv_name;
        % find number of sample files
        sample=method.fname;
    else % quantitation on standard compound data
        % find number of compounds
        method=get(findobj('Tag','pl_comp'),'UserData');
        compound=method.indiv_name;
        % find number of sample files
        fhdl=findobj('Tag','list_file');
        sample=fhdl.String;
    end
    % load quantation results
    rec=hobj.UserData;
    % get mouse coordinates
    phdl=findobj('Tag','AX_heat_map');
    phdl=phdl(1);
    coord=get(phdl,'CurrentPoint');
    x=coord(1,1);
    y=coord(1,2);
    if (x >= phdl.XLim(1)) && (x <= phdl.XLim(2)) && (y >= phdl.YLim(1)) && (y <= phdl.YLim(2))
        intx=round(x);
        inty=round(y);
        cidx=method.EICidx(find(method.EICidx(:,1)==intx),2);
        pidx=method.EICidx(find(method.EICidx(:,1)==intx),3);
        if ~isfield(rec{inty},'abundance')
            return
        end
        infotext={sample{inty}(1:end-4);compound{intx}};
        abund=['Abund: ',num2str(rec{inty}.abundance{cidx}(pidx),'%.2f')];
        if ~isempty(rec{inty}.conc_org{cidx})
            conc_org=['Conc_org: ',num2str(rec{inty}.conc_org{cidx}(pidx),'%.2f')];
            conc_norm=['Conc_norm: ',num2str(rec{inty}.concentration{cidx}(pidx),'%.2f')];
            infotext=[infotext;abund;conc_org;conc_norm];
        else
            infotext=[infotext;abund];
        end
        if rec{inty}.quant_note{cidx}(pidx)==1 %No qualified peak
            status='Status: No Qualified Peak';
        elseif rec{inty}.quant_note{cidx}(pidx)==2 %Multiple_Possible_Peaks
            status='Status: Multiple Candidate Peaks';
        elseif rec{inty}.quant_note{cidx}(pidx)==3 %saturated
            status='Status: Saturated Signals';
        elseif rec{inty}.quant_note{cidx}(pidx)==4 %Defect_Quantitation
            status='Status: Defect Quantitation';
        elseif rec{inty}.quant_note{cidx}(pidx)==5 %Concentration Unconvertable
            status='Status: Concentration Unconvertable';
        else
            status='Status: Successful Quantitation';
        end
        infotext=[infotext;status];
        if isempty(rhdl)
            rectangle(phdl,'Position',[intx-0.5,inty-0.5,1,1],'EdgeColor','w','LineWidth',2,'LineStyle',':','tag','temp_rect');
            text(phdl,intx+0.5,inty,infotext,'color','k','EdgeColor','k','BackgroundColor','w','tag','tip_text','Interpreter','none');
        else
            rhdl.Position=[intx-0.5,inty-0.5,1,1];
            set(lhdl,'Position',[intx+0.5,inty],'String',infotext);
        end
    end
end
% ----------------------------------------------------------
% deal with procedures when a direction key is pressed during activation mode
% ----------------------------------------------------------
function KeyDirect(~,eventdata)
    % find number of compounds
    method=get(findobj('Tag','pl_comp'),'UserData');
    compnum=method.nocomp;
    % find number of sample files
    fhdl=findobj('Tag','list_file');
    filenum=length(fhdl.String);
    phdl=findobj('Tag','AX_heat_map');
    is_heatmap=strcmpi(phdl.Visible,'on');
    if is_heatmap
        % find boundaries of heat map axes
        xlim=phdl.XLim;
        ylim=phdl.YLim;
        % delete previous rectangles
        hdl1=findobj('Tag','sel_rect');
        hdl2=findobj('Tag','temp_rect');
        hdl3=findobj('Tag','tip_text');
        if ~isempty(hdl1)
            oldpos=hdl1.Position;
            compid=round(oldpos(1)+0.1);
            fileid=round(oldpos(2)+0.1);
            if ~isempty(hdl2)
                delete(hdl2);
                delete(hdl3);
            end
        end
    else
        hdl1=findobj('Tag','sel_line');
        hdl2=findobj('Tag','sel_name');
        % find the selected compound index
        tidx=find(strcmpi(method.orig_name,hdl2.String(1,:)));
        ridx1=find(method.EICidx(:,2)==tidx);
        ridx2=find(cell2mat(method.rt)==hdl1.XData(1));
        compid=intersect(ridx1,ridx2);
        fileid=fhdl.Value;
    end
    switch eventdata.Key
        case 'rightarrow'
            if (compid < compnum) 
                plot_EIC(findobj('Tag','im_heatmap'),'',fileid,compid+1);
                if is_heatmap
                    if (compid+1) > xlim(2) % the pixel is outside the right bound
                        phdl.XLim=xlim+1; % shift the image one unit to the right
                        shdl=findobj('Tag','SL_plot_h');% change the horizontal slider
                        shdl.Value=min(1,shdl.Value+(1/(compnum-(xlim(2)-xlim(1)))));
                    end
                end
            else
                errordlg('You have reached the last compound!','Compound Selection Error');
            end
        case 'leftarrow'
            if compid > 1
                plot_EIC(findobj('Tag','im_heatmap'),'',fileid,compid-1);
                if is_heatmap
                    if (compid-1) < xlim(1) % the pixel is outside the right bound
                        phdl.XLim=xlim-1;
                        shdl=findobj('Tag','SL_plot_h');% change the horizontal slider
                        shdl.Value=max(0,shdl.Value-(1/(compnum-(xlim(2)-xlim(1)))));
                    end
                end
            else
                errordlg('You have reached the first compound!','Compound Selection Error');
            end
        case 'uparrow'
            if fileid > 1
                plot_EIC(findobj('Tag','im_heatmap'),'',fileid-1,compid);
                if is_heatmap
                    if (fileid-1) < ylim(1)
                        phdl.YLim=ylim-1;
                        vhdl=findobj('Tag','SL_plot_v');% change the vertical slider
                        vhdl.Value=max(0,vhdl.Value-(1/(filenum-(ylim(2)-ylim(1)))));
                    end
                end
            else
                errordlg('You have reached the first file!','File Selection Error');
            end
        case 'downarrow'
            if fileid < filenum
                plot_EIC(findobj('Tag','im_heatmap'),'',fileid+1,compid);
                if is_heatmap
                    if (fileid+1) > ylim(2)
                        phdl.YLim=ylim+1;
                        vhdl=findobj('Tag','SL_plot_v');% change the vertical slider
                        vhdl.Value=min(1,vhdl.Value+(1/(filenum-(ylim(2)-ylim(1)))));
                    end
                end
            else
                errordlg('You have reached the last file!','File Selection Error');
            end
        otherwise  
    end
end
% ----------------------------------------------------------
% deal with procedures when a direction button in EIC window is clicked during activation mode
% ----------------------------------------------------------
function change_EIC(hobj,~,direct,hdlmeth,hdlastc,hdlaxhm,hdlimg)
    % find number of compounds
    method=hdlmeth.UserData;
    compnum=method.nocomp;
    exp=hdlastc.UserData;
    % find number of sample files
    fhdl=findobj('Tag','list_file');
    if contains(lower(get(findobj('Tag','PB_quant'),'UserData')),'standard') % quantitation on standard compound data
        filenum=length(exp.fname);
    else % quantitation on testing data
        filenum=length(fhdl.String);
    end
    is_heatmap=strcmpi(get(findobj('Tag','PB_TIC_Heat'),'String'),'Show TIC Plot'); % heat map is shown;
    if is_heatmap % select the EIC from a heat map
        if strcmpi(hdlaxhm.Tag,'AX_TIC_plot')
            hdlaxhm=findobj('Tag','AX_heat_map');
        end
        % find boundaries of plot axes
        cid=hdlimg.CData;
        aid=hdlimg.AlphaData;
        cmin = min(cid(:));
        cmax = max(cid(:));
        cmap=colormap;
        m = length(cmap);
        xlim=hdlaxhm.XLim;
        ylim=hdlaxhm.YLim;
        hdl1=findobj('Tag','sel_rect');
        if ~isempty(hdl1)
            oldpos=hdl1.Position;
            compid=round(oldpos(1)+0.1);
            fileid=round(oldpos(2)+0.1);
        else
            return;
        end
    else % select the EIC from a TIC
        if strcmpi(hdlaxhm.Tag,'AX_heat_map')
            hdlaxhm=findobj('Tag','AX_TIC_plot');
        end
        hdl1=findobj('Tag','sel_line'); % handle of selected compound location lines
        hdl2=findobj('Tag','sel_name'); % handle of selected compound names
        if ~isempty(hdl1) && ~isempty(hdl2)
            % find the selected compound index
            if strcmpi(hdl1.Type,'line') && strcmpi(hdl2.Type,'text')
                compid=find(strcmpi(method.indiv_name,strtrim(hdl2.String(1,:))));
                rtvec=cell2mat(method.rt);
                fileid=fhdl.Value;
            else
                return
            end
        else
            return
        end
    end
    % change the EIC based on the direction button 
    switch direct
        case 'right'
            if compid < compnum % the current compound is less than the total compound number
                set(hobj,'BackgroundColor',[0.7500 0.7500 0.7500]);
                set(findobj('Tag','PB_prev_comp'),'BackgroundColor',[0.7500 0.7500 0.7500]);
                if is_heatmap % the current plot is heatmap
                    index = fix((cid(fileid,compid+1)-cmin)/(cmax-cmin)*m)+1; 
                    % determine the color of the frame that highlight the
                    % current heatmap cell
                    if aid(fileid,compid+1)>0.5 % the currect heatmap cell is in normal color
                        RGB = 1.0-ind2rgb(index,cmap);
                    else % the currect heatmap cell is in half-tone color
                        RGB = [0,0,0];
                    end
                    set(hdl1,'Position',oldpos+[1 0 0 0],'EdgeColor',RGB); % move the select rectangle
                    if (compid+1) > xlim(2) % the pixel is outside the right bound
                        hdlaxhm.XLim=xlim+1; % shift the image one unit to the right
                        shdl=findobj('Tag','SL_plot_h');% change the horizontal slider
                        shdl.Value=min(1,shdl.Value+(1/(compnum-(xlim(2)-xlim(1)))));
                    end
                else % the current plot is TIC
                    set(hdl1,'XData',[rtvec(compid+1) rtvec(compid+1)]); % move the select line
                    set(hdl2,'String',char(strtrim(method.indiv_name{compid+1}),[' @ ',num2str(rtvec(compid+1))])); % restore the color of the previous compound name
                    ext=get(hdl2,'extent');
                    set(hdl2,'position',[rtvec(compid+1),hdl1.YData(2)-ext(4)]);
                end
                % update the EIC plot
                plot_EIC(hdlimg,'',fileid,compid+1);
            else % the current compound is greater than the total compound number
                set(hobj,'BackgroundColor','r'); % change the direct button color to red
            end
        case 'left'
            if compid > 1
                set(hobj,'BackgroundColor',[0.7500 0.7500 0.7500]);
                set(findobj('Tag','PB_next_comp'),'BackgroundColor',[0.7500 0.7500 0.7500]);
                if is_heatmap
                    index = fix((cid(fileid,compid-1)-cmin)/(cmax-cmin)*m)+1; 
                    if aid(fileid,compid-1)>0.5
                        RGB = 1.0-ind2rgb(index,cmap);
                    else
                        RGB = [0,0,0];
                    end                    
                    set(hdl1,'Position',oldpos-[1 0 0 0],'EdgeColor',RGB); % move the select rectangle
                    if (compid-1) < xlim(1) % the pixel is outside the right bound
                        hdlaxhm.XLim=xlim-1;
                        shdl=findobj('Tag','SL_plot_h');% change the horizontal slider
                        shdl.Value=max(0,shdl.Value-(1/(compnum-(xlim(2)-xlim(1)))));
                    end
                else
                    set(hdl1,'XData',[rtvec(compid-1) rtvec(compid-1)]); % move the select line
                    set(hdl2,'String',char(strtrim(method.indiv_name{compid-1}),[' @ ',num2str(rtvec(compid-1))])); % restore the color of the previous compound name
                    ext=get(hdl2,'extent');
                    set(hdl2,'position',[rtvec(compid-1),hdl1.YData(2)-ext(4)]);
                end
                plot_EIC(hdlimg,'',fileid,compid-1);
            else
                set(hobj,'BackgroundColor','r');
            end
        case 'up'
            if fileid > 1
                set(hobj,'BackgroundColor',[0.7500 0.7500 0.7500]);
                set(findobj('Tag','PB_next_samp'),'BackgroundColor',[0.7500 0.7500 0.7500]);
                if is_heatmap
                    index = fix((cid(fileid-1,compid)-cmin)/(cmax-cmin)*m)+1; 
                    if aid(fileid-1,compid)>0.5
                        RGB = 1.0-ind2rgb(index,cmap);
                    else
                        RGB = [0,0,0];
                    end
                    set(hdl1,'Position',oldpos-[0 1 0 0],'EdgeColor',RGB);
                    if (fileid-1) < ylim(1)
                        hdlaxhm.YLim=ylim-1;
                        vhdl=findobj('Tag','SL_plot_v');% change the vertical slider
                        vhdl.Value=max(0,vhdl.Value+(1/(filenum-(ylim(2)-ylim(1)))));
                    end
                end
                set(findobj('Tag','list_file'),'Value',fileid-1);
                plot_EIC(hdlimg,'',fileid-1,compid);
            else
                set(hobj,'BackgroundColor','r');
            end
        case 'down'
            if fileid < filenum
                set(hobj,'BackgroundColor',[0.7500 0.7500 0.7500]);
                set(findobj('Tag','PB_prev_samp'),'BackgroundColor',[0.7500 0.7500 0.7500]);
                if is_heatmap
                    index = fix((cid(fileid+1,compid)-cmin)/(cmax-cmin)*m)+1; 
                    if aid(fileid+1,compid)>0.5
                        RGB = 1.0-ind2rgb(index,cmap);
                    else
                        RGB = [0,0,0];
                    end
                    set(hdl1,'Position',oldpos+[0 1 0 0],'EdgeColor',RGB);
                    if (fileid+1) > ylim(2)
                        hdlaxhm.YLim=ylim+1;
                        vhdl=findobj('Tag','SL_plot_v');% change the vertical slider
                        vhdl.Value=min(1,vhdl.Value-(1/(filenum-(ylim(2)-ylim(1)))));
                    end
                end
                set(findobj('Tag','list_file'),'Value',fileid+1);
                plot_EIC(hdlimg,'',fileid+1,compid);
            else
                set(hobj,'BackgroundColor','r');
            end
    end
end
% ----------------------------------------------------------
% adjust the horizontal and vertical sliders as the TIC plot is zoomed
% ----------------------------------------------------------
function TIC_zoom_change(~,~)
    AX_TIC_plot=findobj('Tag','AX_TIC_plot');
    xlim=AX_TIC_plot.XLim;
    xlen=xlim(2)-xlim(1);
    ylim=AX_TIC_plot.YLim;
    ylen=ylim(2)-ylim(1);
    shdl=findobj('Tag','TIC_signal');
    xdata=shdl(end).XData;
    xrange=xdata(end)-xdata(1);
    ydata=shdl(end).YData;
    yrange=1.2*(max(ydata)-min(ydata));
    SL_h=findobj('Tag','SL_plot_h');
    SL_v=findobj('Tag','SL_plot_v');
    if (abs(xrange-xlen)/xrange) < 1e-3
        set(SL_h,'Enable','off');
    else
        hvalue=min(max((xlim(1)-xdata(1))/(xrange-xlen),0),1);
        set(SL_h,'Value',hvalue,'SliderStep',[min(1,(xlen/5)/(xrange-xlen)) min(1,xlen/(xrange-xlen))],'Enable','on');
    end
    if (abs(yrange-ylen)/yrange) < 1e-3
        set(SL_v,'Enable','off');
    else
        vvalue=min(max(ylim(1)/(yrange-ylen),0),1);
        set(SL_v,'Value',vvalue,'SliderStep',[min(1,(ylen/5)/(yrange-ylen)) min(1,ylen/(yrange-ylen))],'Enable','on');
    end
end
% ----------------------------------------------------------
% indicate which compound in a TIC is selected and display it
% ----------------------------------------------------------
function TIC_select_compound(hobject,~,fileid,compid)
    % extraxt the stdandard compound info
    method=get(findobj('Tag','pl_comp'),'UserData');
    if isempty(hobject)
        str=char(strtrim(method.indiv_name{compid}),...
            [' ',['@ ',num2str(method.rt{method.EICidx(compid,2)}(method.EICidx(compid,3)))]]);
        tempobj=findobj('String',str);
        if strcmpi(tempobj(1).Tag,'sel_name')
            hobject=tempobj(1);
        elseif length(tempobj)==2
            hobject=tempobj(2);
        else % user selects a different file
            return
        end
    elseif length(hobject)>1
        hobject=hobject(1);
    end
    % find the selected compound index
    % draw a red line in the TIC plot to indicate the current selection
    axhdl=findobj('Tag','AX_TIC_plot');
    % find match in the TIC
    str=char(strtrim(hobject.String(1,:)),[' ',strtrim(hobject.String(2,:))]);
    lhdl0=findobj('String',str,'-and','Tag','txt_peak');
    lhdl1=findobj('Tag',str);
    if length(lhdl1) > 1
        lhdl1=lhdl1(1);
    end
    % check if a previous line exists
    lhdl2=findobj('Tag','sel_line');
    lhdl3=findobj('Tag','sel_name');
    if ~isempty(lhdl1) % if the text name has a match
        if isempty(lhdl2) || isempty(lhdl3) % no selected compound is completely highlighted
            if ~isempty(lhdl2), delete(lhdl2);end % remove the line
            if ~isempty(lhdl3), delete(lhdl3);end % remove the text
            % redraw the line
            line(axhdl,lhdl1.XData,axhdl.YLim,'color','r','linewidth',2,'tag','sel_line');
            % rewrite the text
            h=text(axhdl,lhdl1.XData(1),0.9*axhdl.YLim(2),...
                char(method.indiv_name{compid},[' @ ',num2str(method.rt{method.EICidx(compid,2)}(method.EICidx(compid,3)))]),...
                'rotation',90,'fontsize',12,'Interpreter','none','clipping','on');
            ext=get(h,'extent');
            set(h,'position',[lhdl1.XData(1),axhdl.YLim(2)-ext(4)],'color',[1 0 0],'tag','sel_name');
        else % a selected compound is highlighted
            lhdl2.XData=[method.rt{method.EICidx(compid,2)}(method.EICidx(compid,3)) method.rt{method.EICidx(compid,2)}(method.EICidx(compid,3))];
            set(lhdl3,'String',lhdl0.String,'Position',lhdl0.Position);
        end
    end
    % generate another figure with the EIC of the selected compound
    plot_EIC(hobject,'',fileid,compid);
end
% ----------------------------------------------------------
% switch between TIC plot and heat map
% ----------------------------------------------------------
function change_plot(hobj,~,towhich)
    % get the axes handle
    ax1=findobj('Tag','AX_TIC_plot');
    ax2=findobj('Tag','AX_heat_map');
    bhdl=findobj('Tag','PB_TIC_Heat');
    lhdl=findobj('tag','list_file');
    fileid=lhdl.Value;
    toTIC=false;
    if nargin < 3 % if no towhich is specified
        if strcmp(ax1.Visible,'off') % if the TIC plot is currently invisible
            toTIC=true; % set the TIC plot to be visible
        end
    else % if towhich is specified
        if strcmpi(towhich,'TIC') % if the TIC plot is asked to be visible
            toTIC=true; % set the TIC plot to be visible
        end
    end
    if toTIC % set the TIC plot to be visible
        % turn off heatmap controls and turn on TIC controls
        set(findobj('Tag','MRM_Quant'),'WindowButtonMotionFcn',[],'WindowKeyPressFcn',[]);
        set(findall(ax1, '-property', 'visible'), 'visible', 'on'); % set TIC controls to visible
        set(findall(ax2, '-property', 'visible'), 'visible', 'off'); % set heatmap controls to invisible
        set(findobj('Tag', 'PB_heatmap_option'), 'enable', 'off');
        ax1.Toolbar.Visible='on';
        ax2.Toolbar.Visible='off';
        colorbar(ax2,'off');
        bhdl.String='Show Heat Map';
        bhdl.Value=0;
        uistack(ax1,'top');
        plot_TIC('',''); % generate the TIC plot
        if ~isempty(hobj) && ...% call by the "Show TIC plot" button
                (get(findobj('Tag','PB_inspect_mode'),'Value')==1) % the inspect mode is on
            % get the currently selected file and compound IDs
            shdl=findobj('tag','sel_rect');
            if ~isempty(shdl)
                compid=round(shdl.Position(1));
                fileid=round(shdl.Position(2));
                TIC_select_compound('','',fileid,compid); % highlight the selected compound
            end
        end
    else % set the heat map to be visible
        % turn on heatmap controls and turn off TIC controls
        set(findobj('Tag','MRM_Quant'),'WindowButtonMotionFcn',@cursorPos,'WindowKeyPressFcn',@KeyDirect);
        set(findall(ax1, '-property', 'Visible'), 'Visible', 'off'); % set TIC controls to invisible
        set(findall(ax2, '-property', 'Visible'), 'Visible', 'on'); % set heatmap controls to visible
        set(findobj('Tag', 'PB_heatmap_option'), 'Visible', 'on','Enable', 'on');
        shdl_h=findobj('Tag','SL_plot_h');
        shdl_v=findobj('Tag','SL_plot_v');
        set(shdl_h,'Enable', 'on');
        set(shdl_v,'Enable', 'on');
        method=get(findobj('Tag','pl_comp'),'UserData');
        para=get(findobj('Tag','pl_para'),'UserData');
        ax1.Toolbar.Visible='off';
        ax2.Toolbar.Visible='on';
        colorbar(ax2);
        bhdl.String='Show TIC Plot';
        bhdl.Value=1;
        uistack(ax2,'top');
        if ~isempty(hobj) && ...% call by the "Show TIC plot" button
                (get(findobj('Tag','PB_inspect_mode'),'Value')==1) % the inspect mode is on
            % get the currently selected file and compound IDs
            hdl=findobj('Tag','sel_name'); % handle of selected compound names
            if ~isempty(hdl) % if the MRM window exists
                % find the selected compound index
                compid=find(strcmpi(method.indiv_name,strtrim(hdl.String(1,:))));
                filenum=length(lhdl.String);
                ihdl=findobj('Tag','im_heatmap');
                cid=ihdl.CData;
                aid=ihdl.AlphaData;
                cmin = min(cid(:));
                cmax = max(cid(:));
                cmap=colormap;
                m = length(cmap);
                if aid(fileid,compid)>0.5
                    index = fix((cid(fileid,compid)-cmin)/(cmax-cmin)*m)+1; 
                    RGB = 1.0-ind2rgb(index,cmap); % find the complementary color
                else
                    RGB = [0,0,0];
                end
                % mark the selected heatmap cell
                shdl=findobj('tag','sel_rect');
                if isempty(shdl)
                    % draw a rectangle in the heatmap to indicate the selected compound
                    shdl=rectangle(ax2,'Position',[compid-0.5,fileid-0.5,1,1],'EdgeColor',RGB,'LineWidth',3,'LineStyle','-','tag','sel_rect');
                else
                    set(shdl,'Position',[compid-0.5,fileid-0.5,1,1],'EdgeColor',RGB);
                end
                % set the heatmap range
                left=max(1,compid-ceil(0.5*para.comp_num)); % determine the left bound
                top=max(1,fileid-ceil(0.5*para.file_num)); % determine the tio bound
                ax2.XLim=[left-0.5 min(left+para.comp_num,method.nocomp)];
                ax2.YLim=[top-0.5 min(top+para.file_num,filenum)];
                % update the sliders
                if method.nocomp >= para.comp_num % total compound number is greater than the display number
                    vvalue=min(max((left-1)/(method.nocomp-para.comp_num),0),1);
                    svalue=[min(1,5/(method.nocomp-para.comp_num)) min(1,para.comp_num/(method.nocomp-para.comp_num))];
                    set(shdl_h,'value',vvalue,'SliderStep',svalue,'Enable','on');
                else % display all compounds
                    shdl_h.Enable='off';
                end                
                if filenum >= para.file_num % total file number is greater than the display number
                    vvalue=min(max((top-1)/(filenum-para.file_num),0),1); % slide value
                    svalue=[min(1,5/(filenum-para.file_num)) min(1,para.file_num/(filenum-para.file_num))]; % step
                    set(shdl_v,'value',vvalue,'SliderStep',svalue,'Enable','on');
                else % display all files
                    shdl_v.Enable='off';
                end
                % update the miniature in the MRM window
                hdlaxm_mini=findobj('Tag','AX_miniature');
                imhdl_mini=findobj('Tag','im_heatmap_mini');
                if ~isempty(hdlaxm_mini)
                    cla(hdlaxm_mini)
                    if isempty(imhdl_mini)
                        imagesc(hdlaxm_mini,cid,'AlphaData',aid,'Tag','im_heatmap_mini');
                    else
                        set(imhdl_mini,'CData',cid);
                    end
                    set(hdlaxm_mini,'XLim',ax2.XLim,'YLim',ax2.YLim,'YDir',ax2.YDir,...
                        'CLim',ax2.CLim,'Colormap',ax2.Colormap);
                end
                rchdl2=findobj('Tag','sel_rect_mini'); % get the handle of the selected EIC in the heat map
                if isempty(rchdl2)
                    rectangle(hdlaxm_mini,'Position',shdl.Position,'EdgeColor',shdl.EdgeColor,'LineWidth',2,'LineStyle','-','Tag','sel_rect_mini');
                else
                    rchdl2.Position=shdl.Position;
                    rchdl2.EdgeColor=shdl.EdgeColor;
                end
                set(findobj('Tag','PB_prev_samp'),'Visible','on'); % in the heatmap plot mode, it is permitible to browse the previous file
                set(findobj('Tag','PB_next_samp'),'Visible','on'); % in the heatmap plot mode, it is permitible to browse the next file
            end
        end
    end
end
%--------------------------------------------------------------
% Align possible compound peaks with known compound locations
%--------------------------------------------------------------
function prepare_standard_curve_data(~, ~)
    global bgcolor
    stdwin=findobj('Tag','std_import');
    if ~isempty(stdwin), close(stdwin); end
    %------------------------
    % create a window for file input
    %------------------------
    stdwin = figure('Color',bgcolor,...
        'NumberTitle','off', ...
        'Units','normalized', ...
        'Menubar','none',...
        'Name','Import Standard Curve Files', ...
        'Position',[0.2 0.15 0.45 0.7],...
        'Tag','std_import');
    % panel for the display of standard curve files
    pl_std_con=uipanel('Parent',stdwin, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','line',...
        'FontSize',12,...
        'HighlightColor',[0,0,0],...
        'Position',[0.02 0.69 0.96 0.3], ...
        'Title','Standard Compound Files and Their Concentrations',...
        'Tag','pl_std_con');
    % entry for file path 
    uicontrol('Parent',pl_std_con, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'FontUnits','normalized', ...
        'ListboxTop',0, ...
        'Position',[0.01 0.82 0.78 0.14], ...
        'String','',...
        'Style','edit', ...
        'Tag','edit_std_dir');
    % button to change the file path
    uicontrol('Parent',pl_std_con, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',@browse_std_folder, ...
        'Position',[0.80 0.82 0.19 0.14], ...
        'String','Browse...');
    set(pl_std_con,'Units','pixel');
    pos=get(pl_std_con,'position');
    cnames={'File Name','Concentation'};
    hs = '<html><font size=5>'; %html start
    he = '</font></html>'; %html end
    cnames = cellfun(@(x)[hs x he],cnames,'uni',false); %with html
    set(pl_std_con,'Units','normalized');
    uitable('Parent',pl_std_con,... %'Data',T{:,:},...   
            'ColumnName',cnames,...
            'ColumnEditable',[false true],... 
            'ColumnWidth',{0.4*pos(3), 0.4*pos(3)},...
            'Fontsize',12,...
            'RowName','numbered',...
            'Units', 'normalized',...
            'Position',[0.01 0.02 0.98 0.78],...
            'Tag','tbl_std_file');
    % -----------------------------------------------
    % panel for the retention time of the standards
    % -----------------------------------------------
    pl_std_rt=uipanel('Parent',stdwin, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','line',...
        'HighlightColor',[0,0,0],...
        'FontSize',12,...
        'Position',[0.02 0.28 0.96 0.4], ...
        'Title','Standard Compounds and Their Calibration Curves ',...
        'Tag','pl_std_rt',...
        'UserData',get(findobj('tag','pl_comp'),'UserData'));
    % entry for file path 
    uicontrol('Parent',pl_std_rt, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'FontUnits','normalized', ...
        'ListboxTop',0, ...
        'Position',[0.01 0.85 0.78 0.11], ...
        'String','',...
        'Style','edit');
    % button to change the file path
    uicontrol('Parent',pl_std_rt, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@change_method,'stdandard',pl_std_rt,findobj('tag','txt_dirinfo')}, ...
        'Position',[0.8 0.85 0.19 0.11], ...
        'String','Browse...');
    % table for the display of compound info
    thdl=findobj('Tag','tbl_comp_list');
    uicontrol('Parent',pl_std_rt, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'HorizontalAlignment','left',...
        'Position',[0.03 0.74 0.23 0.08],...
        'String','Set General Curve Type', ...
        'Style','text');
    uicontrol('Parent',pl_std_rt, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'Position',[0.27 0.75 0.15 0.08],...
        'Callback',{@change_general_curve_model},...
        'String',{'Quadratic','Linear'},...
        'Style','popupmenu');
    uicontrol('Parent',pl_std_rt, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'HorizontalAlignment','left',...
        'Position',[0.53 0.74 0.23 0.08],...
        'String','Set General Regr. Wt.', ...
        'Style','text');
    uicontrol('Parent',pl_std_rt, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'Position',[0.77 0.75 0.15 0.08],...
        'Callback',{@change_general_regression_weight},...
        'String',{'1','1/x','1/x^2'},...
        'Style','popupmenu');
    cnames=[get(thdl,'ColumnName');'Curve Type';'Regr. Wt.'];
    cnames = cellfun(@(x)[hs x he],cnames,'uni',false); %with html
    tdata=get(thdl,'Data');
    cformat=cell(1,size(tdata,2));
    for i=1:size(tdata,2)
        if ischar(tdata{1,i})
            cformat{i}=class(tdata{1,i});
        else
            cformat{i}='numeric';
        end
    end
    cformat=[cformat,{{'Quadratic','Linear','Constant'}},{{'1','1/x','1/x^2'}}];
    cedit=[false(1,size(tdata,2)),true,true];
    tdata(:,end+1)={'Quadratic'}; % set initial values to the model type of calibration curves 
    tdata(:,end+1)={'1'}; % set initial values to the regression weighting of the model of calibration curves
    uitable('Parent',pl_std_rt,...
        'Data',tdata,... 
        'ColumnName',cnames,... 
        'ColumnFormat',cformat,...
        'ColumnEditable',cedit,...
        'Fontsize',12,...
        'RowName','numbered',...
        'Units', 'normalized',...
        'Position',[0.01 0.02 0.98 0.7],...
        'Tag','tbl_std_RT');
    set(findall(pl_std_rt, '-property', 'enable'), 'enable', 'off');
    % ---------------------------
    % panel for parameter input
    % ---------------------------
    pl_std_para=uipanel('Parent',stdwin, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','line',...
        'FontSize',12,...
        'HighlightColor',[0,0,0],...
        'Position',[0.02 0.08 0.96 0.19], ...
        'Title','Parameters',...
        'Tag','pl_std_para');
    uicontrol('Parent',pl_std_para, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Callback',@same_parameter,...
        'Position',[0.03 0.7 0.9 0.2],...
        'String','Use the same parameters for sample quantitation', ...
        'Style','checkbox',...
        'Value',0,...
        'Tag','cb_same_para');
    % description of the first parameter (background intensity)
    uicontrol('Parent',pl_std_para, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'HorizontalAlignment','left',...
        'Position',[0.03 0.4 0.2 0.2],...
        'String','Background Intensity', ...
        'Style','text');
    % entry for the background intensity
    ed_std_bg_int=uicontrol('Parent',pl_std_para, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'Enable','off',...
        'FontUnits','normalized', ...
        'HorizontalAlignment','left',...
        'Position',[0.24 0.4 0.1 0.2], ...
        'String','',...
        'Style','edit', ...
        'Tag','ed_std_bg_int');
    uicontrol('Parent',pl_std_para, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Callback',{@change_background_detect,ed_std_bg_int},...
        'HorizontalAlignment','left',...
        'Position',[0.35 0.4 0.14 0.2],...
        'String','Auto', ...
        'Style','checkbox',...
        'Value',1,...
        'Tag','cb_std_auto_bg');
    % description of the second parameter (smoothint window size)
    uicontrol('Parent',pl_std_para, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'HorizontalAlignment','left',...
        'Position',[0.03 0.1 0.23 0.2],...
        'String','Smoothing Window Size', ...
        'Style','text');
    % entry for the background intensity
    ed_std_smooth_win=uicontrol('Parent',pl_std_para, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'Enable','off',...
        'FontUnits','normalized', ...
        'HorizontalAlignment','left',...
        'Position',[0.27 0.1 0.1 0.2], ...
        'String','',...
        'Style','edit', ...
        'Tag','ed_std_smooth_win');
    uicontrol('Parent',pl_std_para, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Callback',{@change_smoothing_window_size,ed_std_smooth_win},...
        'HorizontalAlignment','left',...
        'Position',[0.38 0.1 0.14 0.2],...
        'String','Auto', ...
        'Style','checkbox',...
        'Value',1,...
        'Tag','cb_std_auto_smooth');
    % description of the third parameter (Signal To Noise (S/N) Ratio)
    uicontrol('Parent',pl_std_para, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'HorizontalAlignment','left',...
        'Position',[0.6 0.7 0.25 0.2],...
        'String','Signal To Noise (S/N) Ratio', ...
        'Style','text');
    % entry for the Signal To Noise (S/N) Ratio
    uicontrol('Parent',pl_std_para, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'FontUnits','normalized', ...
        'Position',[0.86 0.7 0.1 0.2], ...
        'String','',...
        'Style','edit', ...
        'Tag','ed_std_sn_ratio');
    % description of the fourth parameter (max. RT difference)
    uicontrol('Parent',pl_std_para, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'HorizontalAlignment','left',...
        'Position',[0.6 0.4 0.15 0.2],...
        'String','Min. Peak Width', ...
        'Style','text');
    % entry for the background intensity
    uicontrol('Parent',pl_std_para, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'FontUnits','normalized', ...
        'HorizontalAlignment','left',...
        'Position',[0.76 0.4 0.1 0.2], ...
        'String','',...
        'Style','edit', ...
        'Tag','ed_std_min_peak_width');
    % description of the third parameter (max. RT difference)
    uicontrol('Parent',pl_std_para, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'HorizontalAlignment','left',...
        'Position',[0.6 0.1 0.15 0.2],...
        'String','Min. Peak Dist.', ...
        'Style','text');
    % entry for the background intensity
    uicontrol('Parent',pl_std_para, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'FontUnits','normalized', ...
        'HorizontalAlignment','left',...
        'Position',[0.76 0.1 0.1 0.2], ...
        'String','',...
        'Style','edit', ...
        'Tag','ed_std_min_peak_dist');
    set(findall(pl_std_para, '-property', 'enable'), 'enable', 'off');
    uicontrol('Parent',stdwin, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.06 0.03 0.4 0.03],...
        'String','Show Standard Curve Regression', ...
        'Style','checkbox',...
        'Value',1,...
        'Tag','cb_view_reg');
    % button for standard curve computation
    uicontrol('Parent',stdwin, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',@pre_quantitation_check, ...
        'Enable','off',...
        'Position',[0.6 0.02 0.14 0.04], ...
        'String','Ok', ...
        'Tag','PB_std_ok');
    % button to cancel the input
    uicontrol('Parent',stdwin, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',@resume_input, ...
        'Position',[0.8 0.02 0.14 0.04], ...
        'String','Cancel');
end
%-----------------------------------------------------------------------
% function for changing the general curve model in the standard table
%-----------------------------------------------------------------------
function change_general_curve_model(hobj,~)
    htbl=findobj('tag','tbl_std_RT');
    tdata=get(htbl,'Data');
    weights=hobj.String;
    tdata(:,end-1)=weights(hobj.Value);
    set(htbl,'Data',tdata);
end
%-----------------------------------------------------------------------
% function for changing the general regression weight in the standard table
%-----------------------------------------------------------------------
function change_general_regression_weight(hobj,~)
    htbl=findobj('tag','tbl_std_RT');
    tdata=get(htbl,'Data');
    weights=hobj.String;
    tdata(:,end)=weights(hobj.Value);
    set(htbl,'Data',tdata);
end
%--------------------------------------------------------------
% function for changing the folder that contains standard curve files
%--------------------------------------------------------------
function filelist=browse_std_folder(~, ~)
    hdldirinfo=findobj('tag','txt_dirinfo');
    dirinfo=hdldirinfo.UserData;
    % read files for generating srandard curve
    newpath = uigetdir(dirinfo{2}); % use the path of testing files as a starting path to find the path of standard testing files
    if newpath ~= 0
        hdldirinfo.UserData={dirinfo{1};newpath};% save the current folder
        set(findobj('Tag','edit_std_dir'),'String',newpath);
        cd(newpath); % change to the path of the standard testing files
        txtfileinfo=dir('*.txt');
        mzMLfileinfo=dir('*.mzML');
        if isempty(txtfileinfo)
            fileinfo=mzMLfileinfo;
        elseif isempty(mzMLfileinfo)
            fileinfo=txtfileinfo;
        else
            fileinfo=[txtfileinfo;mzMLfileinfo];
        end
        fileinfostr=struct2cell(fileinfo);
        filelist=fileinfostr(1:6:end);
        cd(dirinfo{1}); % change back to program directory
        nof=length(filelist);
        % attempt to extract concentration info from file names
        if all(cell2mat(strfind(lower(filelist),'x.')))
            [~,fname,~] = fileparts(filelist); % find the file names
            tempname=split(fname,'_'); % split names into part according to '_'
            conc_str=tempname(1,:,end); % extract the concentration string
            con=str2double(erase(conc_str,["X","x"]));
            con(isnan(con))=0;
        else
            con=zeros(1,nof);
        end
        % make a listbox with multiple edit boxes in it
        T=table(filelist',num2cell(con'));
        thdl=findobj('tag','tbl_std_file');
        set(thdl,'Data',T{:,:});
        rec=cell(nof,1);
        pg_bar=findobj('Tag','pg_bar');
        pg_text=findobj('Tag','pg_text');
        % start to read the EIC data from each flie
        keepid=true(nof,1);
        if ~isempty(filelist)
            rec=cell(nof,1);
            for i=1:nof % iteratively read the EIC data
                if contains(filelist{i},'txt')
                    try
                        data=MRM_read_fast([newpath,'\',filelist{i}]); % read MRM data in txt format
                    catch
                        errordlg(['The file named ',filelist{i},' is not a legitimate MRM file!'],'File Format Error','modal');
                        keepid(i)=false;
                    end
                elseif contains(filelist{i},'mzML')
                    try
                        data=mzML_read([newpath,'\',filelist{i}]); % read MRM data in mzml format
                    catch
                        errordlg(['The file named ',filelist{i},' is not a legitimate MRM file!'],'File Format Error','modal');
                        keepid(i)=false;
                    end
                end
                if keepid(i)
                    rec{i}.tic=data.peakdata{1};
                    rec{i}.name=filelist{i};
                    nos=length(data.peakdata)-1;
                    rec{i}.data=cell(nos,1);
                    rec{i}.mz=cell(nos,1);
                    for j=1:nos
                        rec{i}.data{j}=data.peakdata{j+1};
                        rec{i}.mz{j}=data.mzdata{j+1};
                    end
                    rec{i}.batch_QC=false; % set the default QC usage for file i to false
                    rec{i}.batch_ref=false; % set the default reference usage for file i to false
                    rec{i}.batch_no=1; % set the default batch number for file i to 0
                    rec{i}.batch_end=false;
                end
                % show file reading progress
                set(pg_bar,'Position',[0.0 0.0 (1.0*i/nof) 1.0],'FaceColor','b')
                set(pg_text,'String',['Reading ',num2str(nof),' files: ',num2str(i),'/',num2str(nof),' (',num2str(100.0*i/nof,'%5.2f'),' %) finished!']);
                pause(0.005);
            end
            % update the filelist
            filelist=filelist(keepid);
            T=T(keepid,:);
            set(thdl,'Data',T{:,:});
            % update the record info
            rec=rec(keepid);
        else
            warndlg('No MRM data in .txt or .mzML format is found!','Warning',struct('WindowStyle','modal','Interpreter','tex'));
        end
        % clear the progress bar
        set(pg_bar,'Position',[0.0 0.0 0.0 1.0],'FaceColor','b')
        pg_text.String='';
        % store the data
        set(findobj('tag','MRM_Quant'),'UserData',rec); 
        % enable the followup controls
        set(findall(findobj('Tag','pl_std_rt'), '-property', 'enable'), 'enable', 'on');
        set(findall(findobj('Tag','pl_std_para'), '-property', 'enable'), 'enable', 'on');
        if get(findobj('Tag','cb_std_auto_bg'),'Value')
            set(findobj('Tag','ed_std_bg_int'),'Enable','off');
        else
            set(findobj('Tag','ed_std_bg_int'),'String',get(findobj('Tag','ed_bg_int'),'String'),'Enable','on');
        end
        if get(findobj('Tag','cb_std_auto_smooth'),'Value')
            set(findobj('Tag','ed_std_smooth_win'),'Enable','off');
        else
            set(findobj('Tag','ed_std_smooth_win'),'String',get(findobj('Tag','ed_smooth_win'),'String'),'Enable','on');
        end
        set(findobj('Tag','PB_std_ok'),'Enable','on');
    else
        hdl=warndlg('No legitimate folder is selected!','Folder Error',struct('WindowStyle','modal','Interpreter','tex'));
        waitfor(hdl);
    end
end
%--------------------------------------------------------------
% check if information of standard compounds is complete. If the
% information is complete, perform peak quantitation.
%--------------------------------------------------------------
function pre_quantitation_check(~,~)
    hdl1=findobj('Tag','PB_ok');
    hdl2=findobj('Tag','PB_cancel');
    if ~isempty(hdl1)
        hdl1.Enable='off';
        hdl2.Enable='off';
    end
    % check for standard curve files
    std_file_data=get(findobj('tag','tbl_std_file'),'data');
    if isempty(std_file_data) % no standard curve file is provided
        errordlg('You need to provide standard curve files before absolute quantitation can be proceeded!','Lack of Parameters');
        if ~isempty(hdl1)
            hdl1.Enable='on';
            hdl2.Enable='on';
        end
        return;
    end
    % check for concentation inputs
    fileno=size(std_file_data,1);
    for i=1:fileno
        is_wrong_format=~isnumeric(std_file_data{i,2}) | any(isnan(std_file_data{i,2}));
        if ~is_wrong_format
            is_wrong_format=std_file_data{i,2}<=0;
        end
        if is_wrong_format
            errordlg('Some of the concentation readings are not eligible!','Parameter Error');
            if ~isempty(hdl1)
                hdl1.Enable='on';
                hdl2.Enable='on';
            end
            return;
        end
    end
    % check for retention time inputs
    std_RT_data=get(findobj('tag','tbl_std_RT'),'data');
    for i=1:size(std_RT_data,1)
        if isnan(std_RT_data{i,2})
            hdl1.Enable='on';
            hdl2.Enable='on';
            errordlg('Some of the retention time readings are not eligible!','Parameter Error');
            return;
        end
    end
    % check for the parameter inputs
    compdata=get(findobj('tag','pl_std_rt'),'UserData');
    rt_tbl_data=get(findobj('tag','tbl_std_RT'),'Data');
    % store standard compound info
    stddata.abundance=zeros(fileno,compdata.nocomp);
    stddata.auto_bg=get(findobj('Tag','cb_std_auto_bg'),'Value');
    stddata.auto_smooth=get(findobj('Tag','cb_std_auto_smooth'),'Value');
    stddata.bg_int=str2double(get(findobj('Tag','ed_std_bg_int'),'String'));
    stddata.conc=cell2mat(std_file_data(:,2));
    stddata.fname=std_file_data(:,1);
    stddata.indiv_name=compdata.indiv_name;
    stddata.is_show_regression=get(findobj('Tag','cb_view_reg'),'Value');
    stddata.IS=compdata.IS;
    stddata.ISidx=compdata.ISidx;
    stddata.nocomp=compdata.nocomp;
    stddata.orig_name=compdata.orig_name;
    stddata.rt=compdata.rt;
    stddata.rt_diff=compdata.rt_diff;
    stddata.mz=compdata.mz;
    stddata.dmz=compdata.dmz;
    stddata.model=rt_tbl_data(:,end-1);
    stddata.regweight=rt_tbl_data(:,end);
    stddata.smooth_win=str2double(get(findobj('Tag','ed_std_smooth_win'),'String'));
    stddata.sn_ratio=str2double(get(findobj('Tag','ed_std_sn_ratio'),'String'));
    stddata.EICidx=compdata.EICidx;
    stddata.std_curve=cell(stddata.nocomp,1);
    stddata.min_peak_dist=str2double(get(findobj('Tag','ed_std_min_peak_dist'),'String'));
    stddata.min_peak_width=str2double(get(findobj('Tag','ed_std_min_peak_width'),'String'));
    tempv=[stddata.sn_ratio stddata.min_peak_width stddata.min_peak_dist];
    if (~stddata.auto_bg && isnan(stddata.bg_int)) || any(isnan(tempv)) || (~stddata.auto_smooth && isnan(stddata.auto_smooth))
        errordlg('Some of the parameters are not eligible!','Parameter Error');
        if ~isempty(hdl1)
            hdl1.Enable='on';
            hdl2.Enable='on';
        end
        return;
    end
    % update the standard curve data
    set(findobj('tag','rb_abs_stc'),'UserData',stddata);
    % close the standard curve info window
    stdhdl=findobj('Tag','std_import');
    if ~isempty(stdhdl)
        close(stdhdl);
    end
    set(findobj('Tag','PB_quant'),'UserData','Standard'); % set the progress to quantitate standard samples
    % perform quantitation on the standard curve files
    peak_quantitation_all(findobj('tag','PB_quant'),'','standard');
end
%--------------------------------------------------------------
% Create a window to input data for generating a standard curve
%--------------------------------------------------------------
function compute_standard_curve(hdlrec,hdlmeth,hdlastc,hdlpara)
    global bgcolor;
    % load quantation results
    result=hdlrec.UserData; 
    nod=length(result); % number of MRM data
    % obtain the standatd compound info
    exp=hdlastc.UserData;
    nop=exp.nocomp; % number of compounds
    for i=1:nod
        for j=1:nop
            exp.abundance(i,j)=result{i}.abundance{exp.EICidx(j,2)}(exp.EICidx(j,3));
        end
    end
    exp.used_for_reg=~isnan(exp.abundance);
    hdl=findobj('tag','std_import');
    if ~isempty(hdl)
        close(hdl);
    end
    pg_bar=findobj('Tag','pg_bar');
    pg_text=findobj('Tag','pg_text');
    for i=1:nop % compute the standard curve for each compound
        if exp.ISidx > 0 % internal standard is provided
            ycoord=exp.abundance(:,i)./exp.abundance(:,exp.ISidx);
        else
            ycoord=exp.abundance(:,i);
        end
        keepid=exp.used_for_reg(:,i); %=~isnan(ycoord);
        [f,~]=standard_data_regression(exp.conc,ycoord,keepid,exp.model{exp.EICidx(i,2)},exp.regweight{exp.EICidx(i,2)});  
        if isempty(f), return;end
        exp.std_curve{i}=f;
        % recompute the concentration of each compound
        for j=1:nod
            [result{j}.conc_org{exp.EICidx(i,2)}(exp.EICidx(i,3)),~]=find_conc_from_standard_curve(exp,i,ycoord(j));
            result{j}.concentration{exp.EICidx(i,2)}(exp.EICidx(i,3))=result{j}.conc_org{exp.EICidx(i,2)}(exp.EICidx(i,3));
        end
        set(pg_bar,'Position',[0.0 0.0 (1.0*i/nop) 1.0],'FaceColor','b')
        set(pg_text,'String',['Computing ',num2str(nop),' standard curves: ',num2str(i),'/',num2str(nop),' (',num2str(100.0*i/nop,'%5.2f'),' %) finished!']);
    end
    set(pg_bar,'Position',[0.0 0.0 0.0 0.0],'FaceColor','none')
    pg_text.String='';
    % update the heatmap
    ax=findobj('Tag','AX_heat_map');
    im=findobj('Tag','im_heatmap');
    for i=1:nod
        draw_quantitation_heat_map(i,hdlrec,hdlmeth,hdlpara,ax,im);
    end
    % save the updates
    hdlrec.UserData=result; 
    hdlastc.UserData=exp;
    if exp.is_show_regression % if the show regression option is selected
        % generate a window to show regression curves and the corresponding EICs
        regwin=figure('Units','normalized', ...
            'Menubar','none',...
            'Name','Standard Curves', ...
            'NumberTitle','off', ...
            'Color',bgcolor, ...
            'Position',[0.2 0.2 0.63 0.65], ...
            'Tag','reg_result');
        % left panel
        l_panel=uipanel('Parent',regwin, ...
            'Units','normalized', ...
            'BackgroundColor',bgcolor, ...
            'Position',[0.02 0.09 0.63 0.88],...
            'BorderType','line',...
            'HighlightColor',[0,0,0],...
            'Tag','std_curves');
        % title of the left frame
        uicontrol('Parent',regwin, ...
            'Units','normalized', ...
            'Fontsize',12, ...
            'BackgroundColor',bgcolor, ...
            'FontWeight','Bold', ...
            'HorizontalAlignment','center',...
            'Position',[0.0 0.97 0.7 0.03],...
            'String','Standard Curves of Targeted Compounds', ...
            'Style','text');
        % determine the arrangement of the standard curve plots
        % add 4-by-4 axes in the pannel
        tile1=tiledlayout(l_panel,4,4,'TileSpacing','tight','Padding','compact');
        for i=1:min(16,nop) % draw standard curve of the nop compounds
            % determine the arrangement of the standard curve plots
            ax = nexttile(tile1);
            set(ax,'NextPlot','add','ButtonDownFcn',{@show_individual_standard_curve,i},'tag',['ax_stc',num2str(i)]);
            if i==1
                set(ax,'XColor',[1,0,0],'YColor',[1,0,0]);
            end
        end
        if nop >= 16
            SliderStep=[min(1,4/(nop-16)),min(1,16/(nop-16))];
        else
            SliderStep=[0 1];
        end
        uicontrol('Parent',regwin, ...
            'Units','normalized', ...
            'BackgroundColor',[0.75 0.75 0.75], ...
            'Callback',{@show_standard_curve_of_nearby_comps,hdlmeth,hdlastc}, ...
            'Position',[0.655 0.09 0.02 0.88], ...
            'SliderStep',SliderStep,...
            'Style','slider',...        
            'Value',1,...
            'Tag','SL_StandCurve');
        % right panel
        r_panel=uipanel('Parent',regwin, ...
            'Units','normalized', ...
            'BackgroundColor',bgcolor, ...
            'Position',[0.69 0.09 0.26 0.88],...
            'BorderType','line',...
            'HighlightColor',[0,0,0]);
        % title of the right frame
        uicontrol('Parent',regwin, ...
            'Units','normalized', ...
            'Fontsize',12, ...
            'BackgroundColor',bgcolor, ...
            'FontWeight','Bold', ...
            'HorizontalAlignment','center',...
            'Position',[0.7 0.97 0.25 0.03],...
            'String','Detected Peak Area', ...
            'Style','text');
        % panel for the EICs that involve in the selected standard curve
        EIC_panel=uipanel('Parent',r_panel, ...
            'Units','normalized', ...
            'BackgroundColor',bgcolor, ...
            'Position',[0 0 0.94 1],...
            'BorderType','none');
        tile2=tiledlayout(EIC_panel,min(5,nod),1,'TileSpacing','tight','Padding','compact');
        for i=1:min(5,nod) % draw the i-th EICs of the first standard compound
            hdl = nexttile(tile2);
            set(hdl,'NextPlot','add','YGrid','on','ButtonDownFcn',{@show_individual_peak_area,i,nod,hdlastc},'Tag',['ax_comp',num2str(i)]);
            uicontrol('Parent',r_panel, ...
                'Units','normalized', ...
                'BackgroundColor',[0.75 0.75 0.75], ...
                'Callback',{@remove_point_from_standard_curve,hdlrec,hdlmeth,hdlastc}, ...
                'Position',[0.94 1.0-(0.68/min(5,nod))-(i-1)*(0.95/min(5,nod)) 0.06 0.04], ...
                'Style','checkbox',...  
                'Value',exp.used_for_reg(1,i),...
                'Tag',['cb_for_reg',num2str(i)]);
        end
        if nod>=5
            SliderStep=[min(1,1/(nod-5)),min(1,min((nod-5),5)/(nod-5))];
        else
            SliderStep=[0 1];
        end
        uicontrol('Parent',regwin, ...
            'Units','normalized', ...
            'BackgroundColor',[0.75 0.75 0.75], ...
            'Callback',{@show_standard_curve_related_comps,hdlrec,hdlmeth,hdlastc}, ...
            'Position',[0.96 0.09 0.02 0.88], ...
            'SliderStep',SliderStep,...
            'Style','slider',...  
            'Value',1,...
            'Tag','SL_StandComp');
        uicontrol('Parent',regwin, ...
            'Units','normalized', ...
            'BackgroundColor',[0.75 0.75 0.75], ...
            'Callback',{@change_standard_curve_display_range}, ...
            'FontSize',14,...
            'Position',[0.03 0.03 0.25 0.04], ...
            'String','Show log-scaled standard curves',...
            'Style','checkbox',...  
            'Value',0,...
            'Tooltip','Show log-scaled standard curves');
        uicontrol('Parent',regwin, ...
            'Units','normalized', ...
            'BackgroundColor',[0.75 0.75 0.75], ...
            'Callback',{@change_vertical_display_range,hdlrec,hdlmeth,hdlastc}, ...
            'FontSize',14,...
            'Position',[0.3 0.03 0.35 0.04], ...
            'String','Show absolute height for the detected peaks',...
            'Style','checkbox',...  
            'Value',0,...
            'Tag','cb_change_v_disp',...
            'Tooltip','Show absolute peak height in the detected peak area');
        show_standard_curve_of_nearby_comps('','',hdlmeth,hdlastc);
        set(findall(findobj('Tag','pl_plot'), '-property', 'enable'), 'enable', 'on');
        hdlaxhm=findobj('Tag','AX_heat_map');
        reset_view_file_num('','',hdlaxhm,hdlpara);
        reset_view_compound_num('','',hdlaxhm,hdlpara);
        % button for standard curve computation
        uicontrol('Parent',regwin, ...
            'Units','normalized', ...
            'FontUnits','normalized', ...
            'BackgroundColor',[0.75 0.75 0.75], ...
            'Callback',@reset_for_align, ...
            'Position',[0.66 0.02 0.18 0.05], ...
            'String','Continue Quantitation');
        % button to cancel the input
        uicontrol('Parent',regwin, ...
            'Units','normalized', ...
            'FontUnits','normalized', ...
            'BackgroundColor',[0.75 0.75 0.75], ...
            'Callback',@stop_quantitation, ...
            'Position',[0.88 0.02 0.09 0.05], ...
            'String','Cancel');
    else % compute the standard curve without showing individual quantitation
        set(hdlrec,'WindowButtonMotionFcn',[],'WindowKeyPressFcn',[]);
        para=hdlpara.UserData;
        % load sample data into correct storage for followup processes
        set(hdlrec,'UserData',get(findobj('tag','pl_file'),'UserData'));
        set(findobj('Tag','cb_normal'),'UserData',1);
        % batch effect correction settings
        if para.normal % perform batch effect correction
            batch_effect_correction_para(hdlrec,hdlpara,0);
            waitfor(findobj('tag','fg_norm'));           
        end
        % if get(findobj('Tag','cb_normal'),'UserData') == -1, means
        % the user pressed "Cancel" to terminate the entire quantitation
        if get(findobj('Tag','cb_normal'),'UserData')~=-1
            peak_quantitation_all(findobj('tag','PB_quant'),'','sample');
            set(findobj('Tag','cb_normal'),'UserData',1);
        end
    end
end
%--------------------------------------------------------------
% show individual standard curve and allow users to modify the comptuted peak areas
%--------------------------------------------------------------
function show_individual_standard_curve(~,~,comp_id)
    % load quantation results
    hdlrec=findobj('Tag','MRM_Quant');
    result=hdlrec.UserData;
    nod=length(result); % number of files (with various concentrations)
    hdlmeth=findobj('Tag','pl_comp');
    % load standard compound info
    hdlastc=findobj('Tag','rb_abs_stc');
    exp=hdlastc.UserData;
    nop=exp.nocomp; % number of compounds
    % find the handle of the regression window
    hdl=findobj('Tag','std_curves');
    % reset the previous selected axes
    hdl1=findobj(hdl.Children,'XColor',[1 0 0]);
    set(hdl1,'LineWidth',0.5,'Box','off','XColor',[0 0 0],'YColor',[0 0 0]);
    % find the handle of slider
    shdl=findobj('Tag','SL_StandCurve');
    % find the related position in the 4x4 plots
    plot_id=comp_id-round((1.0-shdl.Value)*(nop-16));
    % hightlight the currently selected axes
    hdl2=findobj('Tag',['ax_stc',num2str(plot_id)]);
    set(hdl2,'LineWidth',2,'Box','on','XColor',[1 0 0],'YColor',[1 0 0]);
    % reset the slider position of the peak area plots
    set(findobj('Tag','SL_StandComp'),'Value',1);
    % determine the x-axis range of the peak area plots
    xrange=[exp.rt{exp.EICidx(comp_id,2)}(exp.EICidx(comp_id,3))-exp.rt_diff{exp.EICidx(comp_id,2)}(exp.EICidx(comp_id,3)) ...
        exp.rt{exp.EICidx(comp_id,2)}(exp.EICidx(comp_id,3))+exp.rt_diff{exp.EICidx(comp_id,2)}(exp.EICidx(comp_id,3))];
    EICid=exp.EICidx(comp_id,2);
    peakid=exp.EICidx(comp_id,3);
    orgx=result{1}.data{EICid}(:,1);
    id1=find(orgx>xrange(1),1,'first');
    id2=find(orgx<xrange(2),1,'last');
    maxy=0;
    for j=1:nod
        orgy=result{j}.data{EICid}(:,2);
        maxy=max(maxy,1.05*max(orgy(id1:id2)));
    end   
    if isempty(findobj('tag','conc_hdl11'))
        for j=1:min(5,nod) % draw the peak areas of the highlighted compound in the j-th file
            hdl=findobj('Tag',['ax_comp',num2str(j)]);
            if j == min(5,nod)
                set(hdl,'LineWidth',0.5,'Box','off','XColor',[0 0 0],'YColor',[0 0 0]);
            else
                set(hdl,'LineWidth',0.5,'Box','off','XColor',[0 0 0],'YColor',[0 0 0],'xTickLabel',{});
            end
            axes(hdl); %#ok<LAXES>
            % draw all the recorded abundances
            orgx=result{j}.data{EICid}(:,1);
            orgy=result{j}.data{EICid}(:,2);
            stem(orgx,orgy,'markersize',1,'color','k','PickableParts','none','tag',['conc_hdl1',num2str(j)]);
            % draw all the detected peaks
            if ~isempty(result{j}.is_compound{EICid}(:,peakid))
                stem(orgx(result{j}.is_compound{EICid}(:,peakid)),orgy(result{j}.is_compound{EICid}(:,peakid)),'markersize',3,...
                    'color','g','PickableParts','none','tag',['conc_hdl2',num2str(j)]);
            else
                stem(orgx(result{j}.is_peak{EICid}(:,peakid)),0,'markersize',3,...
                    'color','g','PickableParts','none','tag',['conc_hdl2',num2str(j)]);
            end
            % draw the compound tips
            stem(orgx(result{j}.is_peak{EICid}(:,peakid)),orgy(result{j}.is_peak{EICid}(:,peakid)),'markersize',1,...
                'color','r','PickableParts','none','tag',['conc_hdl3',num2str(j)]);
            % draw the background intensity
            stem(orgx,result{j}.bg_int{EICid},'color',[0.5 0.5 0.5],'markersize',1,...
                'linewidth',1,'PickableParts','none','tag',['conc_hdl4',num2str(j)]);
            % show adjusted peaks
            if any(result{j}.decomp{EICid}(:,peakid))
                stem(orgx,result{j}.decomp{EICid}(:,peakid),'markersize',1,'color','b','PickableParts','none',...
                    'Visible','on','tag',['conc_hdl5',num2str(j)]);
            else
                stem(orgx,zeros(size(orgx)),'markersize',1,'color','b','PickableParts','none',...
                    'Visible','off','tag',['conc_hdl5',num2str(j)]);
            end
            % generate RT difference window
            fill([xrange(1) xrange(1) xrange(2) xrange(2) xrange(1)],[0 maxy maxy 0 0],[0.8 0.8 0.8],...
                'FaceAlpha',0.3,'LineStyle','none','PickableParts','none','tag',['conc_hdl6',num2str(j)]);
            line([exp.rt{exp.EICidx(comp_id,2)}(exp.EICidx(comp_id,3)),exp.rt{exp.EICidx(comp_id,2)}(exp.EICidx(comp_id,3))],...
                [0 maxy],'color',[0.7,0.7,0.7],'tag',['conc_hdl7',num2str(j)]);
            [~,fname,~] = fileparts(exp.fname{j});
            title(hdl,['Concentration: ',num2str(exp.conc(j)),' (',fname,')'],'Interpreter','none');
            hdl.TitleHorizontalAlignment = 'right';
            set(hdl,'XLim',[xrange(1)-0.1 xrange(2)+0.1],'YLim',[0 maxy]);
            hdl.YRuler.SecondaryLabel.HorizontalAlignment='center';
            ytickformat('%d');
        end
    else
        show_standard_curve_related_comps('','',hdlrec,hdlmeth,hdlastc);
    end
end
%--------------------------------------------------------------
% show the peak area of the selected standard compound in a LC for inspection
%--------------------------------------------------------------
function show_individual_peak_area(~,~,pkarea_plotid,filenum,hdlastc)
    % extract the standard compound info
    exp=hdlastc.UserData;
    for i=1:filenum
        set(findobj('tag',['ax_comp',num2str(i)]),'LineWidth',0.5,'Box','off','XColor',[0 0 0],'YColor',[0 0 0]);
    end
    % hightlight the current file by setting its plot borders to red
    slhdl2=findobj('Tag','SL_StandComp'); % slider handle of standard Compound plots
    axid=pkarea_plotid-round((1.0-slhdl2.Value)*(filenum-5));
    axhdl=findobj('tag',['ax_comp',num2str(axid)]);
    set(axhdl,'LineWidth',2,'Box','on','XColor',[1 0 0],'YColor',[1 0 0]);
    % Find out what is the current compound by checking whose x-axis is red
    stdcur_plotid=1;
    for i=1:16 %exp.nocomp
        axhdl=findobj('Tag',['ax_stc',num2str(i)]);
        if isequal(axhdl.XColor,[1 0 0])
            stdcur_plotid=i;
            break;
        end
    end
    % compute the absolute compound id through slider position
    slhdl1=findobj('Tag','SL_StandCurve'); % slider handle of standard curves
    compid=round((1.0-slhdl1.Value)*(exp.nocomp-16))+stdcur_plotid;
    % compute the absolute file id through slider position
    fileid=pkarea_plotid;
    phdl=findobj('Tag','AX_heat_map');
    imhdl=findobj('Tag','im_heatmap');
    % get the color of the selected box
    ihdl=findobj(phdl.Children,'type','Image');
    cid=ihdl.CData;
    aid=ihdl.AlphaData;
    cmin = min(cid(:));
    cmax = max(cid(:));
    cmap=colormap;
    m = length(cmap);
    if aid(fileid,compid)>0.5
        index = fix((cid(fileid,compid)-cmin)/(cmax-cmin)*m)+1; 
        RGB = 1.0-ind2rgb(index,cmap); % find the complementary color
    else
        RGB = [0,0,0];
    end
    % draw a rectangle in the heatmap to indicate the selected compound
    rthdl=findobj('tag','sel_rect');
    if isempty(rthdl)
        rectangle(phdl,'Position',[compid-0.5,fileid-0.5,1,1],'EdgeColor',RGB,'LineWidth',3,'LineStyle','-','tag','sel_rect');
    else
        set(rthdl,'Position',[compid-0.5,fileid-0.5,1,1],'EdgeColor',RGB);
    end
    plot_EIC(imhdl,'',fileid,compid);
end 
%--------------------------------------------------------------
% update the standard curve after a peak area is recomputed
%--------------------------------------------------------------
function update_std_result(update_para,hdlrec,hdlmeth,hdlastc)
    % load quantation results
    result=hdlrec.UserData;
    exp=hdlastc.UserData;
    [fileno,compno]=size(exp.abundance);
    method=hdlmeth.UserData;
    yorg=[];
    % update standard curves in the window of regression curves
    slhdl1=findobj('Tag','SL_StandCurve');
    for i=update_para.start_comp:update_para.end_comp
        EICid=exp.EICidx(i,2);
        peakid=exp.EICidx(i,3);
        for j=update_para.start_file:update_para.end_file
            exp.abundance(j,i)=result{j}.abundance{EICid}(peakid);
            exp.used_for_reg(j,i)=~isnan(exp.abundance(j,i));
        end
        if method.ISidx > 0 % internal standard is provided
            ycoord=exp.abundance(:,i)./exp.abundance(:,method.ISidx);
        else
            ycoord=exp.abundance(:,i);
        end
        keepid=exp.used_for_reg(:,i);
        [f,yreg]=standard_data_regression(exp.conc,ycoord,keepid,exp.model{EICid},exp.regweight{EICid});
        if isempty(f), return;end
        maxy=max(yreg);
        if isnan(maxy)
            maxy=Inf;
        end
        miny=min(yreg);
        if i == update_para.compid
            yorg=ycoord;
        end
        exp.std_curve{i}=f;
        if isempty(slhdl1), return;end
        plotid=i-round((1.0-slhdl1.Value)*(compno-16));
        if (plotid >= 1) && (plotid <= 16)
            axhdl=findobj('tag',['ax_stc',num2str(plotid)]);
            lhdl=axhdl.Children;
            for j=1:length(lhdl)
                if lhdl(j).Marker=='+'
                    lhdl(j).YData=ycoord(keepid);
                    lhdl(j).XData=exp.conc(keepid);
                else
                    lhdl(j).YData=yreg;
                end
            end
            if (maxy-miny) < 1e-6 % to avoid small concentration variation
                YLim=[mean([yorg(keepid);yreg],"omitnan")-0.5 mean([yorg(keepid);yreg],"omitnan")+0.5];
            else
                YLim=[miny maxy];
            end
            set(axhdl,'YLim',YLim);
        end
    end
    % update standard curves in the EIC window
    keepid=exp.used_for_reg(:,update_para.compid); %=~isnan(yorg);
    yreg=feval(exp.std_curve{update_para.compid},exp.conc);
    miny=min([yorg(keepid);yreg]);
    maxy=max([yorg(keepid);yreg]);
    if (max(yreg)-min(yreg)) < 1e-6 % to avoid small concentration variation
        YLim=[mean([yorg(keepid);yreg])-0.5 mean([yorg(keepid);yreg])+0.5];
    else
        YLim=[miny maxy];
    end
    XLim=[min(exp.conc) max(exp.conc)];
    %exp.std_curve{update_para.compid}=f;
    ax_stc=findobj('Tag','AX_std_curve');
    for j=1:length(ax_stc.Children)
        switch ax_stc.Children(j).Tag
            case 'LN_conc_ind'
                set(ax_stc.Children(j),'XData',[exp.conc(update_para.fileid) exp.conc(update_para.fileid)],'YData',YLim);
            case 'LN_abund_ind'
                set(ax_stc.Children(j),'XData',XLim,'YData',[yorg(update_para.fileid) yorg(update_para.fileid)]);
            case 'LN_std_cv'
                set(ax_stc.Children(j),'XData',exp.conc,'YData',yreg);
            case 'LN_std_pt'
                set(ax_stc.Children(j),'XData',exp.conc(keepid),'YData',yorg(keepid));
        end
    end
    set(ax_stc,'XLim',XLim,'YLim',YLim);
    title(ax_stc,['\fontsize{12}Concentration = {\color{red}',num2str(exp.conc(update_para.fileid),'%.2f'),'}']);
    % find out which regression curve plot is highlighted
    selid=0;
    for i=1:min(compno,16)
        hdl=findobj('Tag',['ax_stc',num2str(i)]);
        if all(hdl.XColor==[1,0,0])
            selid=i;
            break;
        end
    end
    if update_para.compid == (selid+round((1.0-slhdl1.Value)*(compno-16)))
        % update individual standard compound EIC
        slhdl2=findobj('Tag','SL_StandComp');
        EICid=exp.EICidx(update_para.compid,2);
        peakid=exp.EICidx(update_para.compid,3);
        for j=update_para.start_file:update_para.end_file % draw the peak areas of the highlighted compound in the j-th file
            exp.abundance(j,update_para.compid)=result{j}.abundance{EICid}(peakid);
            exp.used_for_reg(j,update_para.compid)=~isnan(exp.abundance(j,update_para.compid));
            axid=j-round((1.0-slhdl2.Value)*(fileno-5));
            if (axid >= 1) && (axid <= 5)
                hdl=findobj('Tag',['ax_comp',num2str(axid)]);
                %  the original signal
                orgx=result{j}.data{EICid}(:,1);
                orgy=result{j}.data{EICid}(:,2);
                % draw the detected compound signal
                objhdl=findobj('Tag',['conc_hdl2',num2str(axid)]);
                set(objhdl,'XData',orgx(result{j}.is_compound{EICid}(:,peakid)),'YData',orgy(result{j}.is_compound{EICid}(:,peakid)));
                % draw the compound tips
                objhdl=findobj('Tag',['conc_hdl3',num2str(axid)]);
                set(objhdl,'XData',orgx(result{j}.is_peak{EICid}(:,peakid)),'YData',orgy(result{j}.is_peak{EICid}(:,peakid)));
                % draw the background intensity
                objhdl=findobj('Tag',['conc_hdl4',num2str(axid)]);
                set(objhdl,'YData',result{j}.bg_int{EICid});
                % draw the deconvoluated peak if exists
                objhdl=findobj('Tag',['conc_hdl5',num2str(axid)]);
                if any(result{j}.decomp{EICid}(:,peakid)>0)
                    if isempty(objhdl)
                        stem(hdl,orgx,result{j}.decomp{EICid}(:,peakid),'markersize',1,'color','b','PickableParts','none','tag',['conc_hdl5',num2str(j)]);
                    else
                        tempy=result{j}.decomp{EICid}(:,peakid);
                        keepid=tempy>0;
                        set(objhdl,'XData',orgx(keepid),'YData',tempy(keepid),'Visible','on');
                    end
                else
                    if isempty(objhdl)
                        stem(hdl,orgx,zeros(size(orgx)),'markersize',1,'color','b','PickableParts','none','Visible','off','tag',['conc_hdl5',num2str(j)]);
                    else
           
                        set(objhdl,'XData',orgx,'YData',zeros(size(orgx)),'Visible','off');
                    end
                end
                % update the checkbox for regression
                set(findobj('tag',['cb_for_reg',num2str(axid)]),'Value',exp.used_for_reg(j,update_para.compid));
            end
        end
    end
    % update the standard curve data
    hdlastc.UserData=exp;
end
%--------------------------------------------------------------
% display the same parameter setting when user click the checkbox
%--------------------------------------------------------------
function same_parameter(~,~)
    if get(findobj('Tag','cb_same_para'),'value')
        set(findobj('Tag','cb_std_auto_bg'),'Value',get(findobj('Tag','cb_auto_bg'),'Value'));
        if get(findobj('Tag','cb_std_auto_bg'),'Value')
            set(findobj('Tag','ed_std_bg_int'),'Enable','off','String','');
        else
            set(findobj('Tag','ed_std_bg_int'),'String',get(findobj('Tag','ed_bg_int'),'String'),'Enable','on');
        end
        set(findobj('Tag','ed_std_sn_ratio'),'String',get(findobj('Tag','ed_sn_ratio'),'String'));
        set(findobj('Tag','cb_std_auto_smooth'),'Value',get(findobj('Tag','cb_auto_smooth'),'Value'));
        if get(findobj('Tag','cb_std_auto_smooth'),'Value')
            set(findobj('Tag','ed_std_smooth_win'),'Enable','off');
        else
            set(findobj('Tag','ed_std_smooth_win'),'String',get(findobj('Tag','ed_smooth_win'),'String'));
        end
        set(findobj('Tag','ed_std_min_peak_width'),'String',get(findobj('Tag','ed_min_peak_width'),'String'));
        set(findobj('Tag','ed_std_min_peak_dist'),'String',get(findobj('Tag','ed_min_peak_dist'),'String'));
    else
        set(findobj('Tag','cb_std_auto_bg'),'Value',1);
        set(findobj('Tag','ed_std_bg_int'),'String','');
        set(findobj('Tag','ed_std_sn_ratio'),'String','');
        set(findobj('Tag','cb_std_auto_smooth'),'Value',1);
        set(findobj('Tag','ed_std_smooth_win'),'String','');
        set(findobj('Tag','ed_std_min_peak_width'),'String','');
        set(findobj('Tag','ed_std_min_peak_dist'),'String','');
    end
end
% ----------------------------------------------------------
% determine quantitation type for the subsequent process
% ----------------------------------------------------------
function quantitation_type(hobject,~,hdlrec,hdlpara)

    save_status=get(findobj('Tag','PB_save_result'),'UserData');
    if isempty(save_status)
        is_saved=true;
    else
        is_saved=save_status;
    end
    if ~is_saved
        opts = struct('Default','Save and proceed','WindowStyle','modal','Interpreter','tex');
        answer = questdlg('\fontsize{12}The computed/modified result has not been saved. Save it before starting a new quantitation?',...
            'Data Loss Warning','Save and proceed','Proceed without saving','Cancel',opts); 
        if strcmpi(answer,'Save and proceed')
            hdlmeth=findobj('Tag','pl_comp');
            hdlastc=findobj('Tag','rb_abs_stc');
            save_quantitation_result('','',hdlrec,hdlmeth,hdlastc,hdlpara);
            clear_existing_results;
        elseif strcmpi(answer,'Proceed without saving')
            clear_existing_results;
        else
            return;
        end
    end
    % reset the userdata for sample quantitation
    set(hdlrec,'WindowButtonMotionFcn',[],'WindowKeyPressFcn',[]);
    state=hobject.UserData; % find the current state stored in the "start quantitation" button
    if contains(state,'+') % user clicks on the "start quantitation button" after quantitation is done. Reset the state
        hobject.UserData='New';
    end
    stop_quant = contains(hobject.String,'Stop');%any(matches(["New","Standard","Sample"],state)); % check if the user terminate the program in the middle of the quantitation process
    para=hdlpara.UserData;
    if ~stop_quant % the program is in a starting stage of a quantitation process
        % update parameters
        para.bg_auto=get(findobj('tag','cb_auto_bg'),'Value');
        para.bg_int=str2double(get(findobj('tag','ed_bg_int'),'String'));
        para.sn_ratio=str2double(get(findobj('tag','ed_sn_ratio'),'String'));
        para.smooth_auto=get(findobj('tag','cb_auto_smooth'),'Value');
        para.smooth_win=str2double(get(findobj('tag','ed_smooth_win'),'String'));
        para.min_peak_width=str2double(get(findobj('tag','ed_min_peak_width'),'String'));
        para.min_peak_dist=str2double(get(findobj('tag','ed_min_peak_dist'),'String'));
        para.auto_deconv=get(findobj('tag','rb_auto_deconv'),'Value');
        para.always_deconv=get(findobj('tag','rb_always_deconv'),'Value');
        para.no_deconv=get(findobj('tag','rb_no_deconv'),'Value');
        if para.rel_quant || para.quantifier_sel
            para.heatmap_abund = 1;
        else
            para.heatmap_abund = 0;
        end
        hdlpara.UserData=para;
        % clear message window
        set(findobj('Tag','quant_msg'),'String','');
        % perform different procedure for different experiment types
        if para.abs_stc % quantitation on the standard curve data
            % turn off all controls when the calculation is proceeded
            set(findall(findobj('Tag','pl_data'), '-property', 'enable'), 'enable', 'off');
            set(findall(findobj('Tag','pl_comp'), '-property', 'enable'), 'enable', 'off');
            set(findall(findobj('Tag','pl_para'), '-property', 'enable'), 'enable', 'off');
            set(findall(findobj('Tag','pl_plot'), '-property', 'enable'), 'enable', 'off');
            set(findobj('Tag','PB_save_result'),'enable', 'off');
            set(findobj('Tag','PB_show_msg'),'Enable','on');
            prepare_standard_curve_data(hobject,'');
        else % quantitation on the testing data
            % batch effect correction settings
            if para.normal % perform batch effect correction
                batch_effect_correction_para(hdlrec,hdlpara,0);
                waitfor(findobj('tag','fg_norm'));
            end
            % if get(findobj('Tag','cb_normal'),'UserData') == -1, means
            % the user pressed "Cancel" to terminate the entire quantitation
            if get(findobj('Tag','cb_normal'),'UserData')~=-1 
                peak_quantitation_all(hobject,'','sample');
                set(findobj('Tag','cb_normal'),'UserData',1);
            else 
                set(findobj('Tag','cb_normal'),'UserData',0);
            end
        end
    else % the user click the "stop quantitation" button during the quantitation process
        hobject.UserData=[hobject.UserData,'Stop'];
    end
end
% ----------------------------------------------------------
% show heat map options for user to change the appearance of the heat map
% ----------------------------------------------------------
function show_heatmap_options(~,~,hdlrec,hdlmeth,hdlpara,hdlaxhm)
    global bgcolor
    % close the existing option window
    heatmapoptwin=findobj('Tag','fg_heatmapoptwin');
    if ~isempty(heatmapoptwin), close(heatmapoptwin); end
    % read saved parameters
    para=hdlpara.UserData;
    dirinfo=get(findobj('tag','txt_dirinfo'),'UserData');
    cd(get(findobj('Tag','edit_dir'),'UserData'));
    % prepare the list of colormap options
    cmapList = {'Jet', 'HSV', 'Hot', 'Cool', 'Spring', 'Summer', 'Autumn', ...
                 'Winter', 'Gray', 'Bone', 'Copper', 'Pink', 'Lines'}'; % color schemes 
    allLength = cellfun(@numel,cmapList);
    maxLength = max(allLength);
    cmapHTML = cell(numel(cmapList),1);%[];
    for i = 1:numel(cmapList)
        arrow = [repmat('-',1,maxLength-allLength(i)+1) '>']; % size of the arrow
        cmapFun = str2func(['@(x) ' lower(cmapList{i}) '(x)']);
        cData = cmapFun(16);
        curHTML = ['<HTML>' cmapList{i} '<FONT color="#FFFFFF">' arrow '<>'];
        for j = 1:16
            HEX = rgbconv2(cData(j,1),cData(j,2),cData(j,3));
            curHTML = strcat(curHTML,[ '<FONT face="Arial Narrow" size="3" bgcolor="#' HEX '" color="#' HEX '">__']);
        end
        curHTML = curHTML(1:end-2);
        curHTML = strcat(curHTML, '</FONT></HTML>');
        cmapHTML{i} = curHTML;
    end
    cd(dirinfo{1});
    % construct ui components
    heatmapoptwin = figure('Units','normalized', ...
        'Color',bgcolor, ...
        'Menubar','none',...
        'Name','Heat Map Options', ...
        'NumberTitle','off', ...
        'Position',[0.375 0.3 0.25 0.4], ...
        'Tag','fg_heatmapoptwin');
    % checkbox for taking log on the heatmap values
    uicontrol('Parent',heatmapoptwin, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'CallBack',{@take_log,hdlaxhm,hdlpara}, ...
        'Position',[0.05 0.87 0.5 0.1],...
        'String','Log Transform', ...
        'Style','checkbox',...
        'Value',para.take_log,...
        'Tag','cb_log_trans',...
        'ToolTip','Take logarithm on values in the heatmap');
    % checkbox for showing grid in the heatmap 
    uicontrol('Parent',heatmapoptwin, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'CallBack',{@show_grid,hdlaxhm,hdlpara}, ...
        'Position',[0.05 0.79 0.4 0.07],...
        'String','Show Grid', ...
        'Style','checkbox',...
        'Value',para.show_grid,...
        'ToolTip','Show grid lines in the heatmap');
    % checkbox for showing figure colorbar
    uicontrol('Parent',heatmapoptwin, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'CallBack',{@show_colorbar,hdlaxhm,hdlpara}, ...
        'Position',[0.05 0.71 0.5 0.07],...
        'String','Show ColorBar', ...
        'Style','checkbox',...
        'Value',para.show_colorbar,...
        'ToolTip','Show colorbar in the heatmap');
    % checkbox for showing figure colorbar
    uicontrol('Parent',heatmapoptwin, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'CallBack',{@show_ambiguous_comp,hdlpara}, ...
        'Position',[0.05 0.63 0.7 0.07],...
        'String','Show Ambiguous Compounds', ...
        'Style','checkbox',...
        'Value',para.show_ambiguous_comp,...
        'Tag','cb_show_ambiguous',...
        'ToolTip','Show question mark for ambiguous compounds in the heatmap');
    % radiobuttons for heat map content
    bg_content = uibuttongroup('Parent',heatmapoptwin, ...
        'BackgroundColor',bgcolor, ...
        'BorderType','line',...
        'Fontsize',12,...
        'Position',[0.5 0.73 0.45 0.22],...
        'SelectionChangedFcn',{@change_heatmap_abundent,hdlrec,hdlmeth,hdlpara,hdlaxhm}, ...
        'Title','Heat Map Content',...
        'Visible','on');
    % draw heat map with peak abundances
    if para.rel_quant || para.quantifier_sel || (strcmpi(get(findobj('tag','PB_quant'),'UserData'),'standard+') && para.abs_stc) 
        show_abundance=1;
    else
        show_abundance=para.heatmap_abund;
    end
    rb_abundance=uicontrol('Parent',bg_content, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.58 0.9 0.25],...
        'String','Abundances',...
        'Style','radiobutton',...
        'Tag','rb_abundance',...
        'Tooltip','Use peak abundances to draw the heat map.',...
        'Value',show_abundance);
    % draw heat map with peak concentrations
    uicontrol('Parent',bg_content, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.15 0.9 0.25],...
        'String','Concentrations',...
        'Style','radiobutton',...
        'Tooltip','Use peak concentrations to draw the heat map.',...
        'Value',1-show_abundance);
    if para.rel_quant || para.quantifier_sel
        bg_content.Visible = 'off';
        rb_abundance.Value = 1;
    end
    uicontrol('Parent',heatmapoptwin, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'HorizontalAlignment','left',...
        'Position',[0.05 0.52 0.27 0.08],...
        'String','Color Scheme', ...
        'Style','text');
    % select colormap from a menu
    uicontrol('Parent',heatmapoptwin,...
        'Units','normalized', ...
        'Fontsize',12, ...
        'Position',[0.33 0.52 0.62 0.08],...
        'CallBack',{@change_colormap,hdlaxhm,hdlpara}, ...
        'FontName','Courier',...
        'Value',find(strcmpi(cmapList,para.colormap)),...
        'String',cmapHTML,...
        'Style','popup',...
        'Tag','pp_color_map',...
        'ToolTip','Color scheme used for the heatmap',...
        'UserData',cmapList);
    pl_range=uipanel('Parent',heatmapoptwin, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.03 0.39 0.94 0.12],...
        'BorderType','line',...
        'HighlightColor',[0,0,0],...
        'Title','Display Range',...
        'Tag','pl_data');
    % entry for number of files in the heatmap
    uicontrol('Parent',pl_range, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'CallBack',{@reset_view_file_num,hdlaxhm,hdlpara},...
        'FontUnits','normalized', ...
        'Position',[0.03 0.1 0.25 0.8],...
        'String',para.file_num,...
        'Style','edit', ...
        'ToolTip','Number of data files shown in the vertical axis of heapmap');
    % files
    uicontrol('Parent',pl_range, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'HorizontalAlignment','left',...
        'Position',[0.29 0.06 0.15 0.8],...
        'String','files', ...
        'Style','text');
    % entry for number of files in the heatmap
    uicontrol('Parent',pl_range, ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'CallBack',{@reset_view_compound_num,hdlaxhm,hdlpara},...
        'FontUnits','normalized', ...
        'Position',[0.48 0.1 0.25 0.8],...
        'String',para.comp_num,...
        'Style','edit', ...
        'ToolTip','Number of compounds shown in the horizontal axis of heapmap');
    % compounds
    uicontrol('Parent',pl_range, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'HorizontalAlignment','left',...
        'Position',[0.74 0.06 0.25 0.8],...
        'String','compounds', ...
        'Style','text');
    % radiobuttons for vertical axis label
    bg_v_label = uibuttongroup('Parent',heatmapoptwin, ...
        'BackgroundColor',bgcolor, ...
        'BorderType','line',...
        'Fontsize',12,...
        'Position',[0.03 0.13 0.43 0.23],...
        'SelectionChangedFcn',{@change_vertical_axis_label,hdlpara,hdlaxhm}, ...
        'Title','Vertical Axis',...
        'Visible','on');
    % show sample names
    uicontrol('Parent',bg_v_label, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.58 0.9 0.35],...
        'String','Show Sample Names',...
        'Style','radiobutton',...
        'Tag','rb_v_text',...
        'Tooltip','Show sample names at the vertical axis.',...
        'Value',para.ylabel);
    % show numbers
    uicontrol('Parent',bg_v_label, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.15 0.9 0.35],...
        'String','Show Index',...
        'Style','radiobutton',...
        'Tooltip','Show numerical indices at the vertical axis.',...
        'Value',1-para.ylabel);
    % radiobuttons for horizontal axis label
    bg_h_label = uibuttongroup('Parent',heatmapoptwin, ...
        'BackgroundColor',bgcolor, ...
        'BorderType','line',...
        'Fontsize',12,...
        'Position',[0.49 0.13 0.48 0.23],...
        'SelectionChangedFcn',{@change_horizontal_axis_label,hdlmeth,hdlpara,hdlaxhm}, ...
        'Title','Horizontal Axis',...
        'Visible','on');
    % show sample names
    uicontrol('Parent',bg_h_label, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.58 0.9 0.35],...
        'String','Show Compound Names',...
        'Style','radiobutton',...
        'Tag','rb_h_text',...
        'Tooltip','Show compound names at the horizontal axis.',...
        'Value',para.xlabel);
    % show numbers
    uicontrol('Parent',bg_h_label, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.15 0.9 0.35],...
        'String','Show Index',...
        'Style','radiobutton',...
        'Tooltip','Show numerical indices at the horizontal axis.',...
        'Value',1-para.xlabel);
    % close the option window
    uicontrol('Parent',heatmapoptwin, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback','close(gcf)', ...
        'HorizontalAlignment','center',...
        'Position',[0.4 0.025 0.2 0.07], ...
        'String','Close', ...
        'Style','pushbutton',...
        'ToolTip','Close the option window');
end
%--------------------------------------------------------------
% show/hide colorbar in the heat map
%--------------------------------------------------------------
function show_colorbar(hobj,~,hdlaxhm,hdlpara)
    para=hdlpara.UserData;
    if isempty(hobj)
        tf=para.show_colorbar;
    else
        tf=hobj.Value;
    end
    % update the heat map
    pphdl=findobj('tag','pp_color_map');
    if tf
        colorbar(hdlaxhm);
        pphdl.Enable='on';
    else
        colorbar(hdlaxhm,'off');
        pphdl.Enable='off';
    end
    pause(0.005);
    % update parameter
    para.show_colorbar=tf;
    hdlpara.UserData=para;
end
%--------------------------------------------------------------
% change colormap
%--------------------------------------------------------------
function change_colormap(hobj,~,hdlaxhm,hdlpara)
    %extraction of colormap name from popupmenu
    htmlList = hobj.String;
    listIdx = hobj.Value;
    removedHTML = regexprep(htmlList{listIdx},'<[^>]*>','');
    cmapName = strrep(strrep(strrep(removedHTML,'_',''),'>',''),'-','');
    cmapFun = str2func(['@(x) ' lower(cmapName) '(x)']);
    % update the heat map
    colormap(hdlaxhm,cmapFun(16));
    % update the mini heat map if exists
    imhdl=findobj('Tag','im_heatmap');
    hdlaxm_mini=findobj('Tag','AX_miniature');
    imhdl_mini=findobj('Tag','im_heatmap_mini');
    if ~isempty(hdlaxm_mini)
        set(hdlaxm_mini,'XLim',hdlaxhm.XLim,'YLim',hdlaxhm.YLim,'YDir',hdlaxhm.YDir,...
            'CLim',hdlaxhm.CLim,'Colormap',hdlaxhm.Colormap);
        set(imhdl_mini,'CData',imhdl.CData);
    end
    % update the parameter
    para=hdlpara.UserData;
    para.colormap=cmapFun(16);
    hdlpara.UserData=para;
end
%--------------------------------------------------------------
% perform log transform to the heatmap
%--------------------------------------------------------------
function take_log(hobj,~,hdlaxhm,hdlpara)
    % ger required info
    para=hdlpara.UserData;
    imhdl=findobj('Tag','im_heatmap');
    cmtx=hdlaxhm.UserData;
    if para.heatmap_abund
        mtx=cmtx(:,:,1); % show abundance
    else
        mtx=cmtx(:,:,2); % show concentration
    end
    cmin=min(min(mtx,[],'omitnan'));
    cmax=max(max(mtx,[],'omitnan'));
    mtx(isnan(mtx))=cmin;
    mtx(isinf(mtx))=cmax;
    alpha=imhdl.UserData;
    if para.show_ambiguous_comp
        showalpha=alpha;
    else
        showalpha=ones(size(alpha));
    end
    if sum(sum(abs(mtx-mtx(1,1)))) == 0 % all elements in the matrix are the same
        showalpha(isnan(mtx))=0;
        set(imhdl,'CData',mtx,'AlphaData',showalpha,'UserData',alpha);
        hdlaxhm.CLim = [mtx(1,1)-1,mtx(1,1)+1];
        return;
    end
    % update the heat map
    if hobj.Value
        lmtx=log(mtx+4);
        showalpha(isnan(mtx))=0;
        set(imhdl,'CData',lmtx,'AlphaData',showalpha,'UserData',alpha);
        hdlaxhm.CLim = [min(min(lmtx)),max(max(lmtx))];
    else
        set(imhdl,'CData',mtx,'AlphaData',showalpha,'UserData',alpha);
        hdlaxhm.CLim = [cmin,cmax];
    end
    hdlaxm_mini=findobj('Tag','AX_miniature');
    imhdl_mini=findobj('Tag','im_heatmap_mini');
    if ~isempty(hdlaxm_mini)
        set(hdlaxm_mini,'XLim',hdlaxhm.XLim,'YLim',hdlaxhm.YLim,'YDir',hdlaxhm.YDir,...
            'CLim',hdlaxhm.CLim,'Colormap',hdlaxhm.Colormap);
        set(imhdl_mini,'CData',imhdl.CData);
    end
    % update the parameter
    para.take_log=hobj.Value;
    hdlpara.UserData=para;
end
%--------------------------------------------------------------
% show/hide grid lines in the heatmap
%--------------------------------------------------------------
function show_grid(hobj,~,hdlaxhm,hdlpara)
    para=hdlpara.UserData;
    if isempty(hobj)
        tf=para.show_grid;
    else
        tf=hobj.Value;
    end
    % update the heat map
    [nof,noc]=size(get(findobj('Tag','im_heatmap'),'CData'));
    if tf % show grid lines
        x=1.5:(noc-0.5);
        y=1.5:(nof-0.5);
        xcord=[[x;x],[0.5 noc+0.5]'.*ones(size(y))];
        ycord=[[0.5 nof+0.5]'.*ones(size(x)),[y;y]];
        hdlaxhm.NextPlot='add';
        ghdl=line(hdlaxhm,xcord,ycord,'linestyle','--','color','k');
        set(ghdl,'Tag','grid_line');
        hdlaxhm.NextPlot='replacechildren';
    else % remove all gridlines
        ghdl=findobj('Tag','grid_line');
        delete(ghdl);
    end
    % update the parameter
    para.show_grid=tf;
    hdlpara.UserData=para;
end
%--------------------------------------------------------------
% Show a light gray mask on ambiguous compounds in the heat map
%--------------------------------------------------------------
function show_ambiguous_comp(hobj,~,hdlpara)
    % get the required info
    para=hdlpara.UserData;
    hdlimg=findobj('Tag','im_heatmap');
    alpha=hdlimg.UserData;
    cdata=hdlimg.CData;
    if isempty(hobj)
        tf=para.show_ambiguous_comp;
    else
        tf=hobj.Value;
    end
    % update the heat map
    if tf % show ambiguous notations
        if para.take_log
            lalpha=alpha;
            lalpha(isnan(cdata))=0;
            hdlimg.AlphaData=lalpha;
        else
            hdlimg.AlphaData=alpha;
        end
    else
        talpha=alpha;
        talpha(alpha==0.2)=1;
        hdlimg.AlphaData=talpha;
    end
    hdlaxhm=findobj('Tag','AX_heat_map');
    hdlaxm_mini=findobj('Tag','AX_miniature');
    imhdl_mini=findobj('Tag','im_heatmap_mini');
    if ~isempty(hdlaxm_mini)
        set(hdlaxm_mini,'XLim',hdlaxhm.XLim,'YLim',hdlaxhm.YLim,'YDir',hdlaxhm.YDir,...
            'CLim',hdlaxhm.CLim,'Colormap',hdlaxhm.Colormap);
        set(imhdl_mini,'AlphaData',hdlimg.AlphaData,'CData',hdlimg.CData);
    end
    % update the parameter
    para.show_ambiguous_comp=tf;
    hdlpara.UserData=para;
end
% ----------------------------------------------------------
% Given the new compound number, adjust the region of the heatmap
% ----------------------------------------------------------
function is_successful=reset_view_compound_num(hobj,~,hdlaxhm,hdlpara)
    is_successful=true;
    nocomp=size(hdlaxhm.UserData,2); % number of total compounds in the MRM
    para=hdlpara.UserData;
    if isempty(hobj) % not called by the slider
        comp_num=para.comp_num;
    else % assigned by the user
        comp_num=str2double(get(hobj,'String'));
    end
    msg='';
    if isnan(comp_num)
        msg='The number of compounds given in the Heat Map Options panel is not a numerical value';
    elseif comp_num < 0
        msg={'The number of compounds given in the Heat Map Options panel should be no less than 0!','Use 0 to show compounds all at once.'};
    elseif comp_num == 0
        comp_num=nocomp;
    end
    if ~isempty(msg)
        hdl=errordlg(msg,'Input Error',struct('WindowStyle','modal','Interpreter','tex'));
        waitfor(hdl);
        if ~isempty(hobj)
            uicontrol(hobj);
        end
        is_successful=false;
        return;
    end
    % adjust the Visible region
    true_num=min(nocomp,comp_num);
    hdlaxhm.XLim=[0.5 true_num+0.5];
    % update the sliders
    shdl_h=findobj('Tag','SL_plot_h');
    if nocomp >= comp_num
        set(shdl_h,'value',0,'SliderStep',[min(1,5/(nocomp-comp_num)) min(1,comp_num/(nocomp-comp_num))],'Enable','on');
    else
        shdl_h.Enable='off';
    end
    compv=shdl_h.UserData;
    para.comp_num=comp_num;
    shdl_h.UserData=[compv(1) para.comp_num];
    % update the parameter
    hdlpara.UserData=para;
end
% ----------------------------------------------------------
% Given the new file number, adjust the region of the heatmap
% ----------------------------------------------------------
function is_successful=reset_view_file_num(hobj,~,hdlaxhm,hdlpara)
    is_successful=true;
    fileno=size(hdlaxhm.UserData,1);
    para=hdlpara.UserData;
    if isempty(hobj)
        file_num=para.file_num;
    else
        file_num=str2double(get(hobj,'String'));
    end
    msg='';
    if isnan(file_num)
        msg='The number of files given in the Heat Map Options panel is not a numerical value';
    elseif file_num < 0
        msg='The number of files given in the Heat Map Options panel should be no less than 0!';
    elseif file_num == 0
        file_num=fileno;
    end
    if ~isempty(msg)
        hdl=errordlg(msg,'Input Error',struct('WindowStyle','modal','Interpreter','tex'));
        waitfor(hdl);
        if ~isempty(hobj)
            uicontrol(hobj);
        end
        is_successful=false;
        return;
    end
    % adjust the Visible region
    true_num=min(fileno,file_num);
    hdlaxhm.YLim=[0.5 true_num+0.5];
    % update the sliders
    shdl_v=findobj('Tag','SL_plot_v');
    if fileno >= file_num
        set(shdl_v,'value',1,'SliderStep',[min(1,1/(fileno-file_num)) min(1,file_num/(fileno-file_num))],'Enable','on');
    else
        shdl_v.Enable='off';
    end
    filev=shdl_v.UserData;
    shdl_v.UserData=[filev(1) para.file_num];
    % update the parameter
    para.file_num=file_num;
    hdlpara.UserData=para;
end
% ----------------------------------------------------------
% swtitch between abundance and concentration in the heat map
% ----------------------------------------------------------
function change_heatmap_abundent(~,~,hdlrec,hdlmeth,hdlpara,hdlaxhm)
    heatmapoptwin=findobj('Tag','fg_heatmapoptwin');
    if ~isempty(heatmapoptwin)
        is_show_abund=get(findobj('Tag','rb_abundance'),'Value'); % 0 for concentration
        is_take_log=get(findobj('Tag','cb_log_trans'),'Value');
        is_show_ambiguous=get(findobj('Tag','cb_show_ambiguous'),'Value');
    else
        para=hdlpara.UserData;
        is_show_abund=para.heatmap_abund || para.rel_quant || para.quantifier_sel;
        if strcmpi(get(findobj('tag','PB_quant'),'UserData'),'standard+') && para.abs_stc
            is_show_abund=1;
        end
        is_take_log=para.take_log;
        is_show_ambiguous=para.show_ambiguous_comp;
    end
    rec=hdlrec.UserData;
    method=hdlmeth.UserData;
    imhdl=findobj('Tag','im_heatmap');
    cmtx=hdlaxhm.UserData;
    alpha=imhdl.UserData;
    nof=length(rec);
    % set axes property
    for i=1:nof
        count=0;
        for j=1:length(method.rt)
            peaknum=length(method.rt{j});
            for k=1:peaknum
                count=count+1;
                cmtx(i,count,1)=rec{i}.abundance{j}(k);
                cmtx(i,count,2)=rec{i}.concentration{j}(k);
                if (rec{i}.quant_note{j}(k)>=3) || isnan(cmtx(i,count,1)) || isinf(cmtx(i,count,1))
                    alpha(i,count)=0;
                elseif rec{i}.quant_note{j}(k)>0 % ambiguous
                    alpha(i,count)=0.2;
                else
                    alpha(i,count)=1.0;
                end
            end
        end
    end
    hdlaxhm.UserData=cmtx; % update the matrix
    if is_show_abund
        mtx=cmtx(:,:,1);
    else
        mtx=cmtx(:,:,2);
    end
    cmin=min(min(mtx,[],'omitnan')); %NaN is not included
    cmax=max(max(mtx,[],'omitnan')); %NaN is not included
    mtx(isnan(mtx))=cmin;
    mtx(isinf(mtx))=cmax;
    if cmin == cmax
        if cmin == 0
            cmax=1;
        else
            cmax=1.1*cmax;
            cmin=0.9*cmin;
        end
    end
    if is_show_ambiguous
        showalpha=alpha;
    else
        showalpha=ones(size(alpha));
    end
    if is_take_log % check whether the log transform is needed
        lmtx=log(mtx+4);
        showalpha(isnan(lmtx))=0;
        set(imhdl,'CData',lmtx,'AlphaData',showalpha,'UserData',alpha);
        hdlaxhm.CLim = [log(cmin+4),log(cmax+4)];
    else
        set(imhdl,'CData',mtx,'AlphaData',showalpha,'UserData',alpha);
        hdlaxhm.CLim = [cmin,cmax];
    end
    if strcmpi(get(findobj('Tag','PB_TIC_Heat'),'String'),'Show TIC Plot') % heat map is shown % heat map is shown
        hdlaxm_mini=findobj('Tag','AX_miniature');
        imhdl_mini=findobj('Tag','im_heatmap_mini');
        if ~isempty(hdlaxm_mini)
            set(hdlaxm_mini,'XLim',hdlaxhm.XLim,'YLim',hdlaxhm.YLim,'YDir',hdlaxhm.YDir,...
                'CLim',hdlaxhm.CLim,'Colormap',hdlaxhm.Colormap);
            set(imhdl_mini,'CData',imhdl.CData);
        end
    end
    %update the parameter
    if ~isempty(heatmapoptwin)
        para=hdlpara.UserData;
        para.heatmap_abund=is_show_abund;
        if ~(strcmpi(get(findobj('tag','PB_quant'),'UserData'),'standard+') && para.abs_stc)
            para.show_ambiguous_comp=is_show_ambiguous;
        end
        para.take_log=is_take_log;
        hdlpara.UserData=para;
    end
end
% -------------------------------------------------------------------------
% switch the label of the vertical axis of the heatmap between sample file
% names and indices
%--------------------------------------------------------------------------
function change_vertical_axis_label(hobj,~,hdlpara,hdlaxhm)
    para=hdlpara.UserData;
    filelist=get(findobj('Tag','list_file'),'String');
    fname=find_representative_name(filelist);
    nof=length(filelist); % number of files in the folder
    pos=hdlaxhm.Position;
    if strcmpi(hobj.SelectedObject.String,'show index')
        set(hdlaxhm,'Position',[0.03 pos(2) 0.90 pos(4)],'YTick',1:nof,'YTickLabel',cellfun(@(x)num2str(x),num2cell(1:nof), 'UniformOutput', false));
        para.ylabel=0;
    else
        maxlen=max(cell2mat(cellfun(@(x)length(x),fname,'UniformOutput',false)));
        p1=0.03+(maxlen-1)*0.004;
        p3=0.93-p1;
        set(hdlaxhm,'Position',[p1 pos(2) p3 pos(4)],'YTick',1:nof,'YTickLabel',fname);
        para.ylabel=1;
    end
    hdlpara.UserData=para;
end
% -------------------------------------------------------------------------
% switch the label of the horizontal axis of the heatmap between compound
% names and indices
%--------------------------------------------------------------------------
function change_horizontal_axis_label(hobj,~,hdlmeth,hdlpara,hdlaxhm)
    method=hdlmeth.UserData;
    para=hdlpara.UserData;
    noc=method.nocomp;
    pos=get(hdlaxhm,'Position');
    if strcmpi(hobj.SelectedObject.String,'show index') % show numeric indices on xlabel
        set(hdlaxhm,'Position',[pos(1) 0.13 pos(3) 0.82],'XTick',1:noc,'XTickLabel',cellfun(@(x)num2str(x),num2cell(1:noc), 'UniformOutput', false));
        para.xlabel=0;
    else % show compound name on xlabel
        maxlen=max(cell2mat(cellfun(@(x)length(x),method.indiv_name,'UniformOutput',false)));
        p2=0.13+(maxlen-2)*0.0086;
        p4=0.95-p2;
        set(hdlaxhm,'Position',[pos(1) p2 pos(3) p4],'XTick',1:noc,'XTickLabel',method.indiv_name);
        para.xlabel=1;
    end
    xtickangle(hdlaxhm,90);
    hdlpara.UserData=para;
end
%--------------------------------------------------------------
% the OK button in the standard curve input window is pressed.
% check whether the required information is provided.
%--------------------------------------------------------------
function reset_for_align(~,~)
    % close regression result window if exist
    hdl1=findobj('tag','reg_result');
    if ~isempty(hdl1), close(hdl1); end
    % close standard import window if exist
    hdl2=findobj('tag','std_import');
    if ~isempty(hdl2), close(hdl2); end
    % hide EIC inspection window if exist
    hdl3=findobj('Tag','fg_EIC');
    set(hdl3,'Visible','off','Hittest','off');
    % clear message windoe if exist
    set(findobj('Tag','quant_msg'),'String','');
    % batch effect correction settings
    hdlrec=findobj('tag','MRM_Quant');
    hdlpara=findobj('tag','pl_para');
    para=hdlpara.UserData;
    % reset the userdata for sample quantitation
    set(hdlrec,'WindowButtonMotionFcn',[],'WindowKeyPressFcn',[]);
    % load sample data into correct storage for followup processes
    set(hdlrec,'UserData',get(findobj('tag','pl_file'),'UserData'));
    if para.normal % perform batch effect correction
        batch_effect_correction_para(hdlrec,hdlpara,0);
        waitfor(findobj('tag','fg_norm'));
    end
    set(findall(findobj('Tag','pl_plot'), '-property', 'enable'), 'enable', 'off');
    phdl=findobj('Tag','PB_quant');
    phdl.UserData='Sample';
    % if get(findobj('Tag','cb_normal'),'UserData') == -1, means
    % the user pressed "Cancel" to terminate the entire quantitation
    if get(findobj('Tag','cb_normal'),'UserData')~=-1
        peak_quantitation_all(phdl,'','sample');
        set(findobj('Tag','cb_normal'),'UserData',1);
    end
end
% ----------------------------------------------------------
% Resume and enable all controls
% ----------------------------------------------------------
function resume_input(~,~)
    stdwin=findobj('Tag','std_import');
    if ~isempty(stdwin)
        close(stdwin);
    end
    set(findall(findobj('Tag','pl_comp'), '-property', 'enable'), 'enable', 'on');
    set(findall(findobj('Tag','pl_para'), '-property', 'enable'), 'enable', 'on');
    if get(findobj('Tag','cb_auto_bg'),'Value')
        set(findobj('Tag','ed_bg_int'),'Enable','off');
    else
        set(findobj('Tag','ed_bg_int'),'Enable','on');
    end
    if get(findobj('Tag','cb_auto_smooth'),'Value')
        set(findobj('Tag','ed_smooth_win'),'Enable','off');
    else
        set(findobj('Tag','ed_smooth_win'),'Enable','on');
    end
    set(findall(findobj('Tag','pl_plot'), '-property', 'enable'), 'enable', 'on');
    set(findobj('Tag','PB_quant'),'UserData','New'); % set the progress back to new data
end
% ----------------------------------------------------------
% load the preveiously saved quantitation for inspectrion or further
% modifications
% ----------------------------------------------------------
function load_quantitation_result(~,~,hdlrec,hdlmeth,hdlastc,hdlpara)
    para=hdlpara.UserData;
    hdldirinfo=findobj('tag','txt_dirinfo');
    dirinfo=hdldirinfo.UserData;
    if isempty(dirinfo)
        filepath=para.dir;
        dirinfo={pwd;filepath};
    else
        filepath=dirinfo{2};
    end
    cd(filepath);
    [file,path] = uigetfile({'*.mat'});
    cd(dirinfo{1});
    if file
        hdldirinfo.UserData={dirinfo{1};path};
        % close EIC inspection window
        fig=findobj('Tag','fg_EIC');
        set(fig,'Visible','off','Hittest','off');
        f = waitbar(0,'Please wait for the data to be loaded!');
        var=load([path,file]); 
        waitbar(0.75,f,'Updating controls ...');
        hdlrec.UserData=var.result;
        method=var.method;
        hdlmeth.UserData=method;
        para=var.para;
        hdlpara.UserData=para;
        hdlastc.Value=para.abs_stc;
        hdlastc.UserData=var.exp;
        set(findobj('Tag','list_file'),'String',var.filelist,'UserData',var.filelist,'Value',1);
        set(findobj('Tag','tbl_comp_list'),'Data',var.methoddata,'ColumnName',var.columnname);
        set(findobj('Tag','rb_abs_int'),'Value',para.abs_int);
        set(findobj('Tag','rb_rel_quant'),'Value',para.rel_quant);
        set(findobj('Tag','rb_quantifier_sel'),'Value',para.quantifier_sel);
        set(findobj('Tag','cb_auto_bg'),'Value',para.bg_auto);
        set(findobj('Tag','ed_bg_int'),'String',para.bg_int);
        set(findobj('Tag','ed_sn_ratio'),'String',para.sn_ratio);
        set(findobj('Tag','ed_min_peak_width'),'String',para.min_peak_width);
        set(findobj('Tag','ed_min_peak_dist'),'String',para.min_peak_dist);
        set(findobj('Tag','ed_smooth_win'),'String',para.smooth_win);
        set(findobj('Tag','rb_auto_deconv'),'Value',para.auto_deconv);
        set(findobj('Tag','rb_always_deconv'),'Value',para.always_deconv);
        set(findobj('Tag','rb_no_deconv'),'Value',para.no_deconv);
        set(findobj('Tag','cb_normal'),'Value',para.normal,'UserData',1);
        set(findall(hdlmeth,'-property','enable'),'enable','on');
        set(findall(hdlpara,'-property','enable'),'enable','on');
        set(findall(findobj('Tag','pl_plot'),'-property','enable'),'enable','on');
        set(findobj('Tag','PB_TIC_Heat'),'String','Show TIC Plot','Value',1);
        set(findobj('Tag','PB_inspect_mode'),'String','Activate Inspection Mode','Value',0);
        set(findobj('Tag','PB_heatmap_option'),'Enable','on');
        set(findobj('Tag','PB_quant'),'Enable','on');
        set(findobj('Tag','quant_msg'),'String','');
        show_quantitation_message('','',0,hdlpara);
        fileno=length(var.filelist);
        name=find_representative_name(var.filelist);
        % prepare heat map
        ax=findobj('Tag','AX_heat_map');
        cmtx=ones(fileno,method.nocomp,2);
        alpha=ones(fileno,method.nocomp);
        ax.UserData=cmtx;
        cla(ax);
        waitbar(0.8,f,'Drawing Heatmap...');
        im=imagesc(ax,cmtx(:,:,1),'AlphaData',alpha,'UserData',alpha,...
            'Tag','im_heatmap','ButtonDownFcn',{@heat_map_selection,ax});
        ax.XTick=1:method.nocomp;
        xtickangle(ax,90)
        ax.YTick=1:fileno;
        ax.YTickLabel=name;
        ax.XLabel.String = 'Compounds';
        ax.XLabel.FontSize = 14;
        ax.XLim=[0.5 max(method.nocomp+0.5,1.5)];
        ax.YLabel.String = 'Samples';
        ax.YLabel.FontSize = 14;
        ax.YLim=[0.5 max(fileno+0.5,1.5)];
        ax.Toolbar.Visible = 'on';
        ax.TickLabelInterpreter='none';
        colorbar(ax);
        % plot the TIC plot
        waitbar(0.9,f,'Drawing TIC...');
        change_plot('','','TIC');%plot_TIC();
        % plot heat map
        for i=1:length(var.filelist)
            try
                draw_quantitation_heat_map(i,hdlrec,hdlmeth,hdlpara,ax,im);
            catch
                msg=sprintf('Error displaying quantitation result for %s !',var.filelist{i});
                hdl=errordlg(msg,'Quantitation Result Display Error',struct('WindowStyle','modal','Interpreter','tex'));
                waitfor(hdl);
                return;
            end
        end
        waitbar(0.95,f,'Updating Heatmap...');
        change_plot('','','HeatMap');
        show_grid('','',ax,hdlpara);
        set(findobj('Tag','SL_plot_v'),'UserData',[length(var.result) var.para.file_num]);
        reset_view_file_num('','',ax,hdlpara);
        set(findobj('Tag','SL_plot_h'),'UserData',[var.method.nocomp var.para.file_num]);
        reset_view_compound_num('','',ax,hdlpara);
        % show compound info in heatmap
        set(hdlrec,'WindowButtonMotionFcn',@cursorPos,'WindowKeyPressFcn',@KeyDirect);
        close(f);
    end
end
% ----------------------------------------------------------
% find simple filenames without common letters
% ----------------------------------------------------------
function name=find_representative_name(filelist)
    fileno=length(filelist);
    nameorg=cell(fileno,1);
    namepart=cell(fileno,1);
    maxlen=1;
    for i=1:fileno
        [~,nameorg{i},~] = fileparts(filelist{i}); % extract the true file name
        namepart{i} = strsplit(nameorg{i},'_'); % split the file name by '_'
        maxlen = max(maxlen, length(namepart{i})); % compute the max sections in the names
    end
    namestr=cell(maxlen,1);
    keep=true(maxlen,1);
    % find the common string in the file names
    for i=1:maxlen % check one section by one section
        namestr{i}=cell(fileno,1);
        for j=1:fileno % accumulate all files
            if ~isempty(namepart{j})
                namestr{i}{j}=namepart{j}{1};
                namepart{j}=namepart{j}(2:end);
            end
        end
        if ~any(cellfun(@isempty,namestr{i}))
            if length(unique(namestr{i}))==1 % remove the section that ia common in all names
                keep(i)=false;
            end
        end
    end
    namestr=namestr(keep);
    name=cell(fileno,1);
    for i=1:fileno
        name{i}=namestr{1}{i};
        for j=2:length(namestr)
            if ~isempty(namestr{j}{i})
                name{i}=[name{i},'_',namestr{j}{i}]; % combine the remaining strings 
            else
                break;
            end
        end
    end
end
% ----------------------------------------------------------
% manually adjust the background of a EIC and update the compound abundance
% ----------------------------------------------------------
function adjust_background(~,~,hdlrec,hdlmeth,hdlpara,hdlastc,hdlimg,fhdl,ahdl)
    % find the currect compoind id
    vec=fhdl.UserData;
    fileid=vec(1);
    compoundid=vec(2);
    % disable the toolbar
    ahdl.Toolbar.Visible = 'off';
    % load stored compound data
    rec=hdlrec.UserData;
    method=hdlmeth.UserData;
    % load parameters
    para=hdlpara.UserData;
    % load standard info
    exp=hdlastc.UserData;
    hdlmtx=findobj('Tag','AX_heat_map');
    % convert current compound id to EIC id and peak id 
    EICid=method.EICidx(compoundid,2);
    peakid=method.EICidx(compoundid,3);
    % keep the original info
    old_rec=temparary_save_EIC(rec,fileid,EICid,peakid,ahdl);
    pg_text=findobj('Tag','pg_text');
    % let user to define new background intensities
    stop=false;
    xrec=zeros(1,50);
    yrec=zeros(1,50);
    count=0;
    while ~stop
        [x,y,button]=ginput(1);
        if button~=1
            stop = true;
        else
            count=count+1;
            xrec(count)=x;
            yrec(count)=y;
        end
    end
    xrec=xrec(1:count);
    yrec=yrec(1:count);
    % adjust improper point data
    xmin=rec{fileid}.data{EICid}(1,1);
    xmax=rec{fileid}.data{EICid}(end,1);
    xrec(xrec<xmin)=xmin;
    xrec(xrec>xmax)=xmax;
    yrec(yrec<0)=0;
    % generate the new background intensities
    new_bg_int=rec{fileid}.bg_int{EICid};
    changid=(rec{fileid}.data{EICid}(:,1)>xrec(1) & rec{fileid}.data{EICid}(:,1)<xrec(end));
    new_bg_int(changid) = interp1(xrec,yrec,rec{fileid}.data{EICid}(changid,1),'linear','extrap');
    rec{fileid}.bg_int{EICid}=new_bg_int;
    % re-locate the boundaries on both sides
    didx=find(rec{fileid}.is_peak{EICid}(:,peakid)>0);
    LOCS=rec{fileid}.data{EICid}(rec{fileid}.pidx{EICid},1);
    [~,midx]=min(abs(LOCS-rec{fileid}.data{EICid}(didx,1)));
    rec=recompute_peak_info(rec,fileid,compoundid,didx,midx,method,para,exp);
    % save the update
    hdlrec.UserData=rec;
    % update the EIC plot
    update_plots_in_EIC_window(hdlrec,hdlmeth,hdlpara,hdlastc,ahdl,fileid,compoundid);
    % allow to change the compound info
    set(findobj('Tag','PB_adj_bg'),'UserData',true);
    % display a window for user to select whether to apply the change to multiple compounds
    % collect update parameter
    update_para.fileid = fileid;
    update_para.compid = compoundid;
    update_para.dir = 'comp';
    update_para.bound = [];
    update_para.xcord = -1;
    update_para.bg_int = new_bg_int;
    update_para.start_comp = 0;
    update_para.end_comp = -1;
    update_para.start_file = 0;
    update_para.end_file = -1;
    select_EIC(update_para,3);
    if ~get(findobj('Tag','PB_adj_bg'),'UserData') % restore the original EIC plot
        % restore all the peak info
        hdlrec.UserData = restore_EIC(rec,old_rec,fileid,EICid,peakid,para,ahdl);
    else % commence the related updates
        % update changed background intensity
        hdl7=findobj('tag','lc_hdl7');
        set(hdl7,'XData',rec{fileid}.data{EICid}(:,1),'YData',rec{fileid}.bg_int{EICid});
        % update the concentration and heatmap in the main window
        update_concentration_and_heatmap_matrix(fileid,compoundid,EICid,peakid,hdlrec,hdlmeth,hdlpara,hdlastc,hdlmtx,hdlimg);
        % update the plots of the same compound in other files
        show_compound_in_nearby_files('','',fileid,compoundid,hdlrec,hdlmeth,'',true);
        if isempty(findobj('Tag','reg_result')) && ...% not a standard curve data
            get(findobj('Tag','cb_normal'),'Value') % batch effect correction is checked
            % re-perform batch effect correction
            update_para=get(findobj('Tag','PB_show_norm'),'UserData');
            range=[update_para.start_file, update_para.end_file,...
                update_para.start_comp, update_para.end_comp];
            set(pg_text,'String','Performing batch effect correction...');
            batch_effect_correction(hdlrec,hdlmeth,hdlastc,hdlpara,hdlmtx,range);
            set(pg_text,'String','Performing batch effect correction...done!');
        end
        % allow user to save the result
        set(findobj('Tag','PB_save_result'),'UserData',false,'Enable','on');
    end
    set(pg_text,'String','Updating heatmap...');
    change_heatmap_abundent('','',hdlrec,hdlmeth,hdlpara,hdlmtx);
    set(pg_text,'String','');
    ahdl.Toolbar.Visible = 'on';
end
% ----------------------------------------------------------
% generate a window for user to select EICs to be updated
% ----------------------------------------------------------
function select_EIC(update_para,correct_type)
    global bgcolor
    oldhdl=findobj('Tag','fg_sel_EIC');
    if ~isempty(oldhdl)
        delete(oldhdl);
    end
    fig=figure('Color',bgcolor,...
        'NumberTitle','off', ...
        'Units','normalized', ...
        'Menubar','none',...
        'Position',[0.35 0.3 0.3 0.35],...
        'Tag','fg_sel_EIC'); % Open a new window for user to select EICs to be updated
    pl_adj=uipanel('Parent',fig, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','none',... 
        'Position',[0.0 0.67 1.0 0.33]);
    bg_adj = uibuttongroup('Parent',pl_adj, ...
        'BackgroundColor',bgcolor, ...
        'BorderType','line',...
        'Fontsize',12,...
        'Position',[0.05 0.05 0.65 0.9],...
        'Title','Adjust Selected Region');
    % radiobutton for applying to single EIC
    uicontrol('Parent',bg_adj, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.55 0.9 0.3],...
        'String','Apply the region as selected',...
        'Style','radiobutton',...
        'Tooltip','Apply the region as selected',...
        'Value',1);
    % radiobutton for applying to multiple EICs
    uicontrol('Parent',bg_adj, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.15 0.9 0.3],...
        'String','Adjust the region according to the peak tip',...
        'Style','radiobutton',...
        'Tag','rb_adj_sel',...
        'Tooltip','Adjust the region according to the peak tip',...
        'Value',0);
    if correct_type ~= 1
        set(findall(pl_adj, '-property', 'enable'), 'enable', 'off');
        bg_adj.ForegroundColor = [0.5 0.5 0.5];
    end
    pl_sel=uipanel('Parent',fig, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','none',... 
        'Position',[0.0 0.34 1.0 0.33]);
    bg_sel = uibuttongroup('Parent',pl_sel, ...
        'BackgroundColor',bgcolor, ...
        'BorderType','line',...
        'Fontsize',12,...
        'Position',[0.05 0.05 0.9 0.9],...
        'Title','Applied EICs');
    % radiobutton for applying to single EIC
    uicontrol('Parent',bg_sel, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'Callback',{@sel_multiple_EIC,false,correct_type}, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.55 0.9 0.3],...
        'String','Apply the change to the current EIC',...
        'Style','radiobutton',...
        'Tag','rb_cur_EIC',...
        'Tooltip','Apply the change to the current EIC only',...
        'Value',1);
    % radiobutton for applying to multiple EICs
    uicontrol('Parent',bg_sel, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Callback',{@sel_multiple_EIC,true,correct_type}, ...
        'Position',[0.05 0.15 0.9 0.3],...
        'String','Apply the change to multiple EICs',...
        'Style','radiobutton',...
        'Tooltip','Apply the change to multiple EICs',...
        'Value',0);
    % button for save the new compound info into a new file
    uicontrol('Parent',fig, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',bgcolor, ...
        'Callback',{@update_EICs,update_para}, ...
        'Position',[0.72 0.84 0.25 0.12],...
        'String','Ok', ...
        'Style','pushbutton',...
        'ToolTip','Update the change to specified EIC(s)');
    % button for abamdon all modifications
    uicontrol('Parent',fig, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'BackgroundColor',bgcolor, ...
        'Callback',{@close_select_EIC,correct_type}, ...
        'Position',[0.72 0.69 0.25 0.13],...
        'String','Cancel', ...
        'Style','pushbutton',...
        'ToolTip','Ignore the change and close the window');
    % load file info
    files=yticklabels(findobj('tag','AX_heat_map'));
    fileno=length(files);
    method=get(findobj('Tag','pl_comp'),'UserData');
    nos=length(method.indiv_name);
    % a panel to list compound names
    pl_app_dir=uipanel('Parent',fig, ...
        'Units','normalized', ...
        'BackgroundColor',bgcolor,...
        'BorderType','none',... 
        'Enable','off',...
        'Position',[0.0 0.01 1.0 0.33],...
        'Tag','pl_app_dir');
    % checkbox for applying change across compounds
    uicontrol('Parent',pl_app_dir, ...
        'Units','normalized', ...
        'Enable','off',...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.6 0.45 0.3],...
        'String','across different compounds: from', ...
        'Style','checkbox',...
        'Tag','cb_across_comp',...
        'Value',any(strcmpi(update_para.dir,{'comp','both'})));
    uicontrol('Parent',pl_app_dir, ...
        'Units','normalized', ...
        'Enable','off',...
        'Fontsize',12, ...
        'Position',[0.5 0.6 0.2 0.3],...
        'Style','popup',...
        'String',method.indiv_name,...
        'Value',1,...
        'Tag','pm_comp_from');
    uicontrol('Parent',pl_app_dir, ...
        'Units','normalized', ...
        'Enable','off',...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.7 0.57 0.05 0.3],...
        'String','to', ...
        'Style','text');
    uicontrol('Parent',pl_app_dir, ...
        'Units','normalized', ...
        'Enable','off',...
        'Fontsize',12, ...
        'Position',[0.75 0.6 0.2 0.3],...
        'Style','popup',...
        'String',method.indiv_name,...
        'Value',nos,...
        'Tag','pm_comp_to');
    % checkbox for applying change across files
    uicontrol('Parent',pl_app_dir, ...
        'Units','normalized', ...
        'Enable','off',...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.2 0.35 0.3],...
        'String','across different files: from', ...
        'Style','checkbox',...
        'Value',any(strcmpi(update_para.dir,{'file','both'})));
    uicontrol('Parent',pl_app_dir, ...
        'Units','normalized', ...
        'Enable','off',...
        'Fontsize',12, ...
        'Position',[0.4 0.2 0.25 0.3],...
        'Style','popup',...
        'String',files,...
        'Value',1,...
        'Tag','pm_file_from');
    uicontrol('Parent',pl_app_dir, ...
        'Units','normalized', ...
        'Enable','off',...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.65 0.17 0.05 0.3],...
        'String','to', ...
        'Style','text');
    uicontrol('Parent',pl_app_dir, ...
        'Units','normalized', ...
        'Enable','off',...
        'Fontsize',12, ...
        'Position',[0.7 0.2 0.25 0.3],...
        'Style','popup',...
        'String',files,...
        'Value',fileno,...
        'Tag','pm_file_to');
    uiwait(fig);
end
% ----------------------------------------------------------
% shift between single compound correction or multiple compound corrections
% ----------------------------------------------------------
function sel_multiple_EIC(~,~,is_expand,correct_type)
    if is_expand
        set(findall(findobj('Tag','pl_app_dir'), '-property', 'enable'), 'enable', 'on');
        if correct_type ~= 3
            set(findobj('Tag','cb_across_comp'),'enable', 'off');
            set(findobj('Tag','pm_comp_to'),'enable', 'off');
            set(findobj('Tag','pm_comp_from'),'enable', 'off');
        end
    else
        set(findall(findobj('Tag','pl_app_dir'), '-property', 'enable'), 'enable', 'off');
    end
end
% ----------------------------------------------------------
% close the existing EIC selection window
% ----------------------------------------------------------
function close_select_EIC(~,~,correct_type)
    switch correct_type
        case 1
            set(findobj('Tag','PB_sel_region'),'UserData',false);
        case 2
            set(findobj('Tag','PB_sel_peak'),'UserData',false);
        case 3
            set(findobj('Tag','PB_adj_bg'),'UserData',false);
        case 4
            set(findobj('Tag','PB_adj_status'),'UserData',false);
    end
    fhdl=findobj('Tag','fg_sel_EIC');
    if ~isempty(fhdl)
        delete(fhdl);
    end
end
% ----------------------------------------------------------
% update a single compound without showing the EIC
% used for multiple compound corrections
% ----------------------------------------------------------
function update_EICs(~,~,update_para)
    if get(findobj('Tag','rb_cur_EIC'),'Value') == 0 % if multiple EICs are to be updated
        if any(strcmpi(update_para.dir,{'file','both'})) % applied to multi files
            pmhdl=findobj('Tag','pm_file_from');
            pmhd2=findobj('Tag','pm_file_to');
            update_para.start_file=pmhdl.Value;
            update_para.end_file=pmhd2.Value;
            update_para.start_comp=update_para.compid;
            update_para.end_comp=update_para.compid;
        end
        if any(strcmpi(update_para.dir,{'comp','both'})) % applied to multiple compounds
            pmhdl=findobj('Tag','pm_comp_from');
            pmhd2=findobj('Tag','pm_comp_to');
            update_para.start_comp=pmhdl.Value;
            update_para.end_comp=pmhd2.Value;
            update_para.start_file=update_para.fileid;
            update_para.end_file=update_para.fileid;
        end
    else % only a single EIC is to be updated
        update_para.start_file=update_para.fileid;
        update_para.end_file=update_para.fileid;
        update_para.start_comp=update_para.compid;
        update_para.end_comp=update_para.compid;
    end
    % check if the selected region should be adjusted according to the peak tip
    update_para.is_adjusted = false;
    if get(findobj('Tag','rb_adj_sel'),'Value') == 1
        update_para.is_adjusted = true;
    end
    fhdl=findobj('Tag','fg_sel_EIC'); % close the selection window
    if ~isempty(fhdl)
        delete(fhdl);
    end
    set(findobj('Tag','PB_show_norm'),'UserData',update_para);
    % load stored compound data
    hdlrec=findobj('Tag','MRM_Quant');
    hdlmeth=findobj('Tag','pl_comp');
    hdlpara=findobj('Tag','pl_para');
    hdlmtx=findobj('Tag','AX_heat_map');
    hdlastc=findobj('Tag','rb_abs_stc');
    hdlimg=findobj('Tag','im_heatmap');
    pg_bar=findobj('Tag','pg_bar');
    pg_text=findobj('Tag','pg_text');
    % update the current compound
    method=hdlmeth.UserData;
    para=hdlpara.UserData;
    exp=hdlastc.UserData;
    % update the concentration and the heatmap matrix of the current compound
    if (update_para.end_comp > 0) || (update_para.end_file > 0)
        if contains(lower(get(findobj('Tag','PB_quant'),'UserData')),'standard') % quantitation on standard compound data
            filelist=exp.fname;
            min_rt_diff=exp.min_peak_width/4;
            min_peak_dist=exp.min_peak_dist;
            sn_ratio=exp.sn_ratio;
        else % the progress is to quantitate standard data
            filelist=get(findobj('Tag','list_file'),'String');
            min_rt_diff=para.min_peak_width/4;
            min_peak_dist=para.min_peak_dist;
            sn_ratio=para.sn_ratio;
        end
        nof=update_para.end_comp-update_para.start_comp+1;
        for i=update_para.start_comp:update_para.end_comp % update compound abundances in a file due to background intensity change
            if i ~= update_para.compid
                EICid=method.EICidx(i,2);
                peakid=method.EICidx(i,3);
                filename=filelist{update_para.fileid};
                compoundname=method.orig_name{EICid};
                update_single_EIC(update_para.fileid,filename,i,EICid,peakid,compoundname,sn_ratio,min_rt_diff,min_peak_dist,update_para,hdlrec,hdlmeth,hdlpara,hdlmtx,hdlastc,hdlimg);
                set(pg_bar,'Position',[0.0 0.0 (1.0*i/nof) 1.0],'FaceColor','b')
                set(pg_text,'String',['Reading ',num2str(nof),' files: ',num2str(i),'/',num2str(nof),' (',num2str(100.0*i/nof,'%5.2f'),' %) finished!']);
                pause(0.005);
            end
        end
        nof=update_para.end_file-update_para.start_file+1;
        for i=update_para.start_file:update_para.end_file % update the abundances of a compound in the selected files
            if i ~= update_para.fileid
                EICid=method.EICidx(update_para.compid,2);
                peakid=method.EICidx(update_para.compid,3);
                compoundname=method.orig_name{EICid};
                filename=filelist{i};
                update_single_EIC(i,filename,update_para.compid,EICid,peakid,compoundname,sn_ratio,min_rt_diff,min_peak_dist,update_para,hdlrec,hdlmeth,hdlpara,hdlmtx,hdlastc,hdlimg);
                set(pg_bar,'Position',[0.0 0.0 (1.0*i/nof) 1.0],'FaceColor','b')
                set(pg_text,'String',['Reading ',num2str(nof),' files: ',num2str(i),'/',num2str(nof),' (',num2str(100.0*i/nof,'%5.2f'),' %) finished!']);
                pause(0.005);
            end
        end
    end
    % update the regression curves and compound plots in the regression
    % curves window
    if ~isempty(findobj('Tag','reg_result'))
        update_std_result(update_para,hdlrec,hdlmeth,hdlastc);
    end
    % reset progress bar
    set(pg_bar,'Position',[0.0 0.0 0.0 0.0],'FaceColor','none')
    pg_text.String='';
    % allow users to save the updated result.
    set(findobj('Tag','PB_save_result'),'enable', 'on');
end
% ----------------------------------------------------------
% check if the user specified info contained in the original compound.
% if not, find the compound in the user specified info 
% and remove the original ones
% ----------------------------------------------------------
function update_single_EIC(fileid,filename,compoundid,EICid,peakid,compoundname,sn_ratio,min_rt_diff,min_peak_dist,update_para,hdlrec,hdlmeth,hdlpara,hdlmtx,hdlastc,hdlimg)
    rec=hdlrec.UserData;
    para=hdlpara.UserData;
    method=hdlmeth.UserData;
    % check which type of correction to be made
    if ~isempty(update_para.bound) % the user select a region
        % check if the bound contains the current peak
        is_current=(rec{fileid}.data{EICid}(rec{fileid}.is_peak{EICid}(:,peakid),1)>update_para.bound(1)) & ...
            (rec{fileid}.data{EICid}(rec{fileid}.is_peak{EICid}(:,peakid),1)<update_para.bound(3));
        if ~is_current % the user select another peak, find the new peak tip
            % find index of peak tips that fall within the selected region
            ptid=find((rec{fileid}.data{EICid}(rec{fileid}.pidx{EICid},1)>update_para.bound(1)) & ...
                (rec{fileid}.data{EICid}(rec{fileid}.pidx{EICid},1)<update_para.bound(3)));
            % use the highest one if multiple candidates are found
            [~,maxid]=max(rec{fileid}.smoothy{EICid}(ptid));
            % update the peak tip
            rec{fileid}.is_peak{EICid}(:,peakid)=false(size(rec{fileid}.is_peak{EICid}(:,peakid)));
            rec{fileid}.is_peak{EICid}(rec{fileid}.pidx{EICid}(ptid(maxid)),peakid)=true;
        end
        % find the indices of the bounds
        if update_para.is_adjusted % bounds change with the location of the peak tip
            if ~any(rec{fileid}.is_peak{EICid}(:,peakid)) % no peak tip is detected
                rec{fileid}.is_defined_by_bound{EICid}(peakid)=true;
                % update the peak signals
                rec{fileid}.is_compound{EICid}(:,peakid)=false(length(rec{fileid}.data{EICid}(:,1)),1);
                % update the peak boundaries
                rec{fileid}.bdp{EICid}(peakid,:)=[0 0];
                % update the coelute situation
                rec{fileid}.coelute{EICid}(peakid,:)=[false false];
                % update the decomvoluted peak signal (i.e. remove the peak)
                rec{fileid}.decomp{EICid}(:,peakid)=zeros(size(rec{fileid}.decomp{EICid},1),1);
                % update the abundance
                rec{fileid}.abundance{EICid}(peakid)=0;
                hdlrec.UserData=rec;
                % update the concentration and heatmap in the main window
                update_concentration_and_heatmap_matrix(fileid,compoundid,EICid,peakid,hdlrec,hdlmeth,hdlpara,hdlastc,hdlmtx,hdlimg);
                return;
            else
                tipx=rec{fileid}.data{EICid}(rec{fileid}.is_peak{EICid}(:,peakid),1); %location of the peak tip
                [~,id1] = min(abs(rec{fileid}.data{EICid}(:,1)-(tipx-(update_para.bound(2)-update_para.bound(1)))));
                [~,id2] = min(abs(rec{fileid}.data{EICid}(:,1)-(tipx+(update_para.bound(3)-update_para.bound(2)))));
            end
        else % bound location is fixed across samples
            [~,id1] = min(abs(rec{fileid}.data{EICid}(:,1)-update_para.bound(1)));
            [~,id2] = min(abs(rec{fileid}.data{EICid}(:,1)-update_para.bound(3)));
        end
        rec{fileid}.is_defined_by_bound{EICid}(peakid)=true;
        % update the peak signals
        rec{fileid}.is_compound{EICid}(:,peakid)=false(length(rec{fileid}.data{EICid}(:,1)),1);
        rec{fileid}.is_compound{EICid}(id1:id2,peakid)=true;
        % update the peak boundaries
        rec{fileid}.bdp{EICid}(peakid,:)=[id1 id2];
        % update the coelute situation
        rec{fileid}.coelute{EICid}(peakid,:)=[false false];
        % update the decomvoluted peak signal (i.e. remove the peak)
        rec{fileid}.decomp{EICid}(:,peakid)=zeros(size(rec{fileid}.decomp{EICid},1),1);
        % update the abundance
        tempy=rec{fileid}.data{EICid}(rec{fileid}.is_compound{EICid}(:,peakid),2)-rec{fileid}.bg_int{EICid}(rec{fileid}.is_compound{EICid}(:,peakid));
        tempx=rec{fileid}.data{EICid}(rec{fileid}.is_compound{EICid}(:,peakid),1);
        sumid=tempy>0;
        % use trapzoidal reule to compute peak area
        rec{fileid}.abundance{EICid}(peakid)=trapz(tempx(sumid),tempy(sumid));
    elseif update_para.xcord > 0 % if user select a peak tip
        rec{fileid}.is_defined_by_bound{EICid}(peakid)=false;
        LOCS=rec{fileid}.data{EICid}(rec{fileid}.pidx{EICid},1); % detected peak locations in this sample
        OrgTip=rec{fileid}.data{EICid}(rec{fileid}.pidx{EICid},2);
        % find the index of peak closest to the cursor
        [mindis,midx]=min(abs(LOCS-update_para.xcord));
        if mindis > 5e-2 % no peak was found near the specified RT
            [~,didx]=min(abs(rec{fileid}.data{EICid}(:,1)-update_para.xcord));
            rec{fileid}.is_peak{EICid}(:,peakid)=false(size(rec{fileid}.data{EICid}(:,1)));
            rec{fileid}.is_peak{EICid}(didx,peakid)=true;
            rec{fileid}.quant_note{EICid}(peakid)=1; % no qualified peaks
            % record the bound indices
            rec{fileid}.bdp{EICid}(peakid,:)=[0 0];
            % record the coelution info
            rec{fileid}.coelute{EICid}(peakid,:)=[false false];
            % record the signal from left to right bounds
            rec{fileid}.is_compound{EICid}(:,peakid)=false(size(rec{fileid}.data{EICid}(:,1)));
            rec{fileid}.abundance{EICid}(peakid)=0;
            rec{fileid}.decomp{EICid}(:,peakid)=zeros(size(rec{fileid}.data{EICid}(:,1)));
            hdlrec.UserData=rec;
            % update the concentration and heatmap in the main window
            update_concentration_and_heatmap_matrix(fileid,compoundid,EICid,peakid,hdlrec,hdlmeth,hdlpara,hdlastc,hdlmtx,hdlimg);
            return
        end
        % check for saturated signals
        maxv=max(rec{fileid}.data{EICid}(:,2));
        binv=rec{fileid}.data{EICid}(:,2)>=(0.995*maxv);
        repidx=nonzeros((cumsum(~binv)+1).*binv);
        blocklen=nonzeros(accumarray(repidx,1));
        longest=max(blocklen);
        if (longest >= 4) && (maxv > para.max_int) && (OrgTip(midx) == maxv) % the user selects a saturated peak
            answer = questdlg('\fontsize{12}The selected peak is saturated and its abundance can not be estimated! Use it anyway?',...
                'Peak Selection Question', 'Yes','No',struct('Default','Yes','Interpreter','tex'));
            if strcmp(answer,'No')
                return;
            else
                rec{fileid}.quant_note{EICid}(peakid)=3; % the peak is saturated.
            end
        end
         % find the index of the peak tip
        diff=abs(rec{fileid}.data{EICid}(:,1)-LOCS(midx));
        [~,didx]=min(diff); % find the index of signal to the peak tip
        % reassign the peak tip
        rec{fileid}.is_peak{EICid}(:,peakid)=false(size(rec{fileid}.is_peak{EICid}(:,peakid)));
        rec{fileid}.is_peak{EICid}(didx,peakid)=true;
        % extract required info for peak_tracing
        bg_int=rec{fileid}.bg_int{EICid};
        % ### trace the two ends of the peak for coelution ###
        sdata=rec{fileid}.smoothy{EICid};
        [bd,coelute,halfcount]=peak_tracing(rec{fileid}.data{EICid}(:,1),sdata,didx,bg_int,sn_ratio,min_rt_diff,min_peak_dist);
        % record the bound indices
        rec{fileid}.bdp{EICid}(peakid,:)=bd;
        % record the coelution info
        rec{fileid}.coelute{EICid}(peakid,:)=coelute;
        % record the signal from left to right bounds
        rec{fileid}.is_compound{EICid}(:,peakid)=false(length(sdata),1);
        rec{fileid}.is_compound{EICid}(bd(1):bd(2),peakid)=true;
        % remove existing deconvoluted peaks
        if sum(rec{fileid}.decomp{EICid}(:,peakid))>0
            rec{fileid}.decomp{EICid}(:,peakid)=zeros(size(rec{fileid}.decomp{EICid}(:,peakid)));
        end
        % handles of message list
        meglist=findobj('Tag','quant_msg');
        if any(coelute) && ~para.no_deconv && ~(rec{fileid}.quant_note{EICid}(peakid)==3)
            try
                rec=peak_deconvolution(midx,fileid,EICid,peakid,rec,halfcount,bg_int,sn_ratio,min_rt_diff,min_peak_dist);
            catch
                meglist.String=[meglist.String;{['The compound ',compoundname,' in file ',filename,' cannot be successfully quantitated during deconvolution!']}];
                phhdl=findobj('Tag','PB_show_msg');
                if ~phhdl.UserData
                    show_quantitation_message('','',1,hdlpara);
                end
                rec{fileid}.quant_note{EICid}(peakid)=4; % defect quantitation
            end
        elseif ~any(coelute) && para.always_deconv && ...
                any(rec{fileid}.is_compound{EICid}(:,peakid))% user select 'aways deconvolution"
            options=optimset('LargeScale','off','Display','off');
            curve=[rec{fileid}.data{EICid}(bd(1):bd(2),1) sdata(bd(1):bd(2))];
            halfcount=halfcount(halfcount>0);
            halfcount=halfcount(halfcount~=didx);
            sigma0=min(abs(rec{fileid}.data{EICid}(halfcount,1)-rec{fileid}.data{EICid}(didx,1)));
            x0=[sdata(didx);sigma0;rec{fileid}.data{EICid}(didx,1)];
            xlo=[0.7*sdata(didx);0.8*sigma0;rec{fileid}.data{EICid}(didx-1,1)];
            xhi=[1.3*sdata(didx);1.2*sigma0;rec{fileid}.data{EICid}(didx+1,1)];
            newx = fmincon(@(x) peak_approximation(x,curve),x0,[],[],[],[],xlo,xhi,[],options);
            y=newx(1)*gaussmf(curve(:,1),[newx(2) newx(3)]); % deconvoluted peak signals
            maxy=max(y);
            dlen=length(sdata);
            is_complete=(y(1)<0.05*maxy) && (y(end)<0.05*maxy);
            newbd=bd;
            while ~is_complete
                if (y(1)>0.05*maxy) && (newbd(1)>1)
                    newbd(1)=newbd(1)-1;
                end
                if (y(end)>0.05*maxy) && (newbd(2)<dlen)
                    newbd(2)=newbd(2)+1;
                end
                y=newx(1)*gaussmf(rec{fileid}.data{EICid}(newbd(1):newbd(2),1),[newx(2) newx(3)]);
                is_complete=(y(1)<0.05*maxy) && (y(end)<0.05*maxy);
            end
            rec{fileid}.decomp{EICid}(:,peakid)=zeros(size(sdata));
            rec{fileid}.decomp{EICid}(newbd(1):newbd(2),peakid)=y+bg_int(newbd(1):newbd(2));
        end
        % update abundance
        % check if the peak is within the allowable RT difference
        diff=abs(LOCS-method.rt{EICid}(peakid));
        tempid=find(diff <= method.rt_diff{EICid}(peakid));
        if isempty(tempid) % no peak is in the allowable RT difference
            rec{fileid}.quant_note{EICid}(peakid)=1; % no qualified peaks
        end
        % check if there are multiple peaks in the allowable region
        if length(tempid)>1 
            rec{fileid}.quant_note{EICid}(peakid)=2;
        end
        tempdata=rec{fileid}.decomp{EICid}(:,peakid)-rec{fileid}.bg_int{EICid};
        sumid=tempdata>0;
        % use trapzoidal reule to compute peak area
        decomp_sum=trapz(rec{fileid}.data{EICid}(sumid,1),tempdata(sumid));
        if rec{fileid}.quant_note{EICid}(peakid)>=3 % saturated or defect quantitation
            rec{fileid}.abundance{EICid}(peakid)=nan;
            rec{fileid}.decomp{EICid}(:,peakid)=zeros(size(sdata));
        elseif decomp_sum > 0 % if the peak is coeluted
            rec{fileid}.abundance{EICid}(peakid)=decomp_sum;
        else
            tempy=rec{fileid}.data{EICid}(rec{fileid}.is_compound{EICid}(:,peakid),2)-rec{fileid}.bg_int{EICid}(rec{fileid}.is_compound{EICid}(:,peakid));
            tempx=rec{fileid}.data{EICid}(rec{fileid}.is_compound{EICid}(:,peakid),1);
            sumid=tempy>0;
            rec{fileid}.abundance{EICid}(peakid)=trapz(tempx(sumid),tempy(sumid));
        end
        if rec{fileid}.abundance{EICid}(peakid) <= 0
            rec{fileid}.abundance{EICid}(peakid) = 0;
            rec{fileid}.quant_note{EICid}(peakid) = 1;
        end
    elseif max(update_para.bg_int) >= 0 % user change the background intensities
        % update the abundance
        rec{fileid}.bg_int{EICid}=update_para.bg_int;
        tempy=rec{fileid}.data{EICid}(rec{fileid}.is_compound{EICid}(:,peakid),2)-rec{fileid}.bg_int{EICid}(rec{fileid}.is_compound{EICid}(:,peakid));
        tempx=rec{fileid}.data{EICid}(rec{fileid}.is_compound{EICid}(:,peakid),1);
        sumid=tempy>0;
        rec{fileid}.abundance{EICid}(peakid)=trapz(tempx(sumid),tempy(sumid));
        if rec{fileid}.abundance{EICid}(peakid) == 0
            rec{fileid}.quant_note{EICid}(peakid)=1;
        end
    end
    hdlrec.UserData=rec;
    % update the concentration and heatmap in the main window
    update_concentration_and_heatmap_matrix(fileid,compoundid,EICid,peakid,hdlrec,hdlmeth,hdlpara,hdlastc,hdlmtx,hdlimg);
end
% ----------------------------------------------------------
% update concentration and heatmap matrix of a single compound
% ----------------------------------------------------------
function update_concentration_and_heatmap_matrix(fileid,compoundid,EICid,peakid,hdlrec,hdlmeth,hdlpara,hdlastc,hdlmtx,hdlimg)
    rec=hdlrec.UserData;
    method=hdlmeth.UserData;
    para=hdlpara.UserData;
    exp=hdlastc.UserData; % get the expected compound info
    cmtx=hdlmtx.UserData;
    % load file list
    if contains(lower(get(findobj('Tag','PB_quant'),'UserData')),'standard') % quantitation on standard compound data
        filelist=exp.fname;
        target='standard';    
    else % quantitation on testing data
        filelist=get(findobj('Tag','list_file'),'String');
        target='sample';
    end
    % update the concentration based on different experiment types
    if para.abs_int % absolute quantitation via internal standard 
        ISID=find(strcmpi(method.orig_name,method.IS{EICid}));
        rec{fileid}.conc_org{EICid}(peakid)=max(0,rec{fileid}.abundance{EICid}(peakid)/rec{fileid}.abundance{ISID}*method.conc(EICid));
        rec{fileid}.concentration{EICid}(peakid)=rec{fileid}.conc_org{EICid}(peakid);
        if isnan(rec{fileid}.conc_org{EICid}(peakid))
            rec{fileid}.quant_note{EICid}(peakid)=5; % int. std. unquantiable
        end
        if ISID==EICid % if the modified compound is internal standard, recompute the abundances of the related compounds
            recompid=find(strcmpi(method.IS,method.IS{EICid})); % indices of the compounds using the same internal standard
            recompid=recompid(recompid~=ISID); % exclude the internal standard since it has been recomputed
            for i=1:length(recompid) %recompute the abundances of the related compounds
                tempconc=rec{fileid}.abundance{recompid(i)}/rec{fileid}.abundance{ISID}*method.conc(recompid(i));
                tempconc(tempconc<0)=0;
                rec{fileid}.conc_org{recompid(i)}=tempconc;
                rec{fileid}.concentration{recompid(i)}=rec{fileid}.conc_org{recompid(i)};
            end
        end
    elseif para.abs_stc % absolute quantitation via standard curve
        ref_abund=1; % initialize the abundance of the internal standard
        ISID=-1;% initialize the index of the internal standard in the entire compound list
        ISIDX=-1;% initialize the index of the internal standard in the method file
        if ~isempty(method.IS) % the compound name of the internal standard is provided
            ISID=find(strcmpi(method.orig_name,method.IS{EICid})); % the internal standard of the j-th compound
            ref_abund=rec{fileid}.abundance{ISID}(1);
        elseif (method.ISidx~=-1) % the compound index of the internal standard is provided
            ISIDX=method.ISidx;
            ref_abund=rec{fileid}.abundance{exp.EICidx(method.ISidx,2)}(exp.EICidx(method.ISidx,3));
        end
        if (ISID==EICid) || (ISIDX==compoundid) % if the modified compound is internal standard, recompute the abundances of the related compounds
            startid=1;
            endid=method.nocomp;
        else % recompute the abundances of the modified compound only
            startid=compoundid;
            endid=compoundid;
        end
        for i=startid:endid
            refEICid=method.EICidx(i,2);
            refpeakid=method.EICidx(i,3);
            if strcmpi(target,'sample')
                [rec{fileid}.conc_org{refEICid}(refpeakid),flag]=find_conc_from_standard_curve(exp,i,rec{fileid}.abundance{refEICid}(refpeakid)/ref_abund);
                if flag || isnan(rec{fileid}.conc_org{refEICid}(refpeakid))
                    meglist=findobj('Tag','quant_msg');
                    QuantMsg=meglist.String;
                    meglist.String=[QuantMsg;{['Quadratic regression failed for ',exp.indiv_name{i},' in ',filelist{fileid},' ! Use linear regression instead.']}];
                    if ~get(findobj('Tag','PB_show_msg'),'UserData')
                        show_quantitation_message('','',1,hdlpara);
                    end
                end
                if isnan(rec{fileid}.conc_org{refEICid}(refpeakid))
                    rec{fileid}.quant_note{refEICid}(refpeakid)=5; % int. std. unquantiable
                end
            else
                rec{fileid}.conc_org{refEICid}(refpeakid) = exp.conc(fileid); % set the conentration as expected for now, it will be recomputed in compute_standard_curve
            end 
            rec{fileid}.concentration{refEICid}(refpeakid)=rec{fileid}.conc_org{refEICid}(refpeakid);
        end
    end
    % update the heatmap
    cmtx(fileid,compoundid,1)=rec{fileid}.abundance{EICid}(peakid);
    cmtx(fileid,compoundid,2)=rec{fileid}.concentration{EICid}(peakid);
    % update the opacity of the heatmap cells
    alpha=hdlimg.UserData;
    if (rec{fileid}.quant_note{EICid}(peakid)>=3) || isnan(cmtx(fileid,compoundid,1)) || isinf(cmtx(fileid,compoundid,1))
        alpha(fileid,compoundid)=0; % unquantifiable
    elseif rec{fileid}.quant_note{EICid}(peakid)>0 %ambiguous
        alpha(fileid,compoundid)=0.2;
    else
        alpha(fileid,compoundid)=1.0; % successful quantitation
    end
    % update the heat map miniature if the EIC window exist
    if ~isempty(findobj('tag','AX_EIC'))
        axm=findobj('Tag','AX_miniature'); % get the handle of the miniature
        if strcmpi(get(findobj('Tag','PB_TIC_Heat'),'String'),'Show TIC Plot') % heat map is shown
            rchdl1=findobj('Tag','sel_rect'); % get the handle of the selected EIC in the heat map
            % update heatmap in the the miniature
            set(axm,'XLim',hdlmtx.XLim,'YLim',hdlmtx.YLim,'YDir',hdlmtx.YDir,...
                'CLim',hdlmtx.CLim,'Colormap',hdlmtx.Colormap);
            set(findobj('Tag','im_heatmap_mini'),'CData',hdlimg.CData)
            rchdl2=findobj('Tag','sel_rect_mini'); % get the handle of the selected EIC in the heat map
            if isempty(rchdl2)
                rectangle(axm,'Position',rchdl1.Position,'EdgeColor',rchdl1.EdgeColor,'LineWidth',2,'LineStyle','-','Tag','sel_rect_mini');
            else
                rchdl2.Position=rchdl1.Position;
                rchdl2.EdgeColor=rchdl1.EdgeColor;
            end
        end
    end
    % update the compound info
    hdlrec.UserData=rec;
    hdlmtx.UserData=cmtx;
    hdlimg.UserData=alpha;
    % update the fragment ratio if compound selection experiment is selected
    if para.quantifier_sel && ~isempty(findobj('tag','fg_fragment_ratio'))
        compute_ion_ratio(hdlmeth,hdlmtx);
    end
end
%-------------------------------------------------
% Show the same compound in the neighboring EICs
%-------------------------------------------------
function show_more_compound(hobj,~,pl_cur_comp,pl_more_comp,hdlrec,hdlmeth,fhdl)
    if hobj.UserData == 0
        set(hobj,'String','< Less','UserData',1);
        set(fhdl,'Position',[0.1 0.2 0.6 0.7]);
        % panel displaying the information of the current compound
        set(pl_cur_comp,'Position',[0.0 0.0 0.8 1.0]);
        set(pl_more_comp,'Position',[0.8 0.0 0.2 1.0]);
        currid=fhdl.UserData;
        fileid=currid(1);
        compoundid=currid(2);
        % indices of the current compound
        method=hdlmeth.UserData;
        EICid=method.EICidx(compoundid,2);
        peakid=method.EICidx(compoundid,3);
        if isempty(findobj('Tag','comphdl11')) % no plot was drawn before
            % get the required info
            result=hdlrec.UserData;
            nof=length(result);
            % find the files to be ploted
            if fileid >= nof-2
                startp=max(1,nof-4);
            else
                startp=max(1,(fileid-2));
            end
            endp=min(nof,(startp+5-1));
            % horizontal display range
            xrange=[method.rt{EICid}(peakid)-0.1 method.rt{EICid}(peakid)+0.1];
            % load file list
            if contains(lower(get(findobj('Tag','PB_quant'),'UserData')),'standard') % quantitation on standard compound data
                filelist=get(findobj('Tag','rb_abs_stc'),'UserData').fname;
            else % quantitation on testing data
                filelist=get(findobj('Tag','list_file'),'String');
            end
            overhdl=findobj('tag','ax_overlap');
            set(overhdl,'nextplot','add');
            phdl=findobj('tag','comp_overlap'); % get the IDs of the curves
            for i=1:nof
                orgx=result{i}.data{EICid}(:,1);
                orgy=result{i}.data{EICid}(:,2);
                decy=result{i}.decomp{EICid}(:,peakid);
                if any(decy) % if deconvolution signal exists, show the signal
                    if isempty(phdl)
                       line(overhdl,orgx(decy>0),decy(decy>0),'tag','comp_overlap');
                    else
                        set(phdl(i),'XData',orgx(decy>0),'YData',decy(decy>0));
                    end
                else % no deconvolution signal exists, show the original peak signal
                    if any(result{i}.is_compound{EICid}(:,peakid)) % if a peak is detected
                        if isempty(phdl)
                            line(overhdl,orgx(result{i}.is_compound{EICid}(:,peakid)),...
                                orgy(result{i}.is_compound{EICid}(:,peakid)),'tag','comp_overlap');
                        else
                            set(phdl(i),'XData',orgx(result{i}.is_compound{EICid}(:,peakid)),...
                                'YData',orgy(result{i}.is_compound{EICid}(:,peakid)));
                        end
                    else % no peak is detected
                        if isempty(phdl)
                            line(overhdl,orgx(result{i}.is_peak{EICid}(:,peakid)),...
                                orgy(result{i}.is_peak{EICid}(:,peakid)),'tag','comp_overlap');
                        else
                            set(phdl,'XData',orgx(result{i}.is_peak{EICid}(:,peakid)),...
                                'YData',orgy(result{i}.is_peak{EICid}(:,peakid)));
                        end
                    end
                end
            end
            axis(overhdl,'tight')
            % draw the compound in the current sample with a wider line
            hdlcur=findobj('Tag','cur_curve');
            orgx=result{fileid}.data{EICid}(:,1);
            orgy=result{fileid}.data{EICid}(:,2);
            decy=result{fileid}.decomp{EICid}(:,peakid);
            if any(decy) % if deconvolution signal exists, draw the deconvolution signal
                if isempty(hdlcur)
                    line(overhdl,orgx(decy>0),decy(decy>0),'Color','r',...
                        'LineWidth',2,'Tag','cur_curve');
                else
                    set(hdlcur,'XData',orgx(decy>0),'YData',decy(decy>0));
                end
            else % no deconvolution signal exists, show the original peak signal
                if any(result{fileid}.is_compound{EICid}(:,peakid)) % if a peak is detected
                    if isempty(hdlcur)
                        line(overhdl,orgx(result{fileid}.is_compound{EICid}(:,peakid)),...
                            orgy(result{fileid}.is_compound{EICid}(:,peakid)),...
                            'Color','r','Linewidth',2,'Tag','cur_curve');
                    else
                        set(hdlcur,'XData',orgx(result{fileid}.is_compound{EICid}(:,peakid)),...
                            'YData',orgy(result{fileid}.is_compound{EICid}(:,peakid)));
                    end
                else % no peak is detected
                    if isempty(hdlcur)
                        line(overhdl,orgx(result{fileid}.is_peak{EICid}(:,peakid)),...
                            orgy(result{fileid}.is_peak{EICid}(:,peakid)),...
                            'Color','r','Linewidth',2,'Tag','cur_curve');
                    else
                        set(phdl(i),'XData',orgx(result{fileid}.is_peak{EICid}(:,peakid)),...
                            'YData',orgy(result{fileid}.is_peak{EICid}(:,peakid)));
                    end
                end
            end 
            hdl=findobj(overhdl,'type','line');
            set(overhdl,'UserData',get(hdl,'YData'));
            % plot the compound in the neighboring (+/-2) files
            for i=startp:endp
                axhdl=findobj('Tag',['ax_sub',num2str(i-startp+1)]);
                set(axhdl,'NextPlot','add','buttondownfcn',{@modify_peak_area,i,compoundid});
                % draw the original signals
                orgx=result{i}.data{EICid}(:,1);
                orgy=result{i}.data{EICid}(:,2);
                stem(axhdl,orgx,orgy,'markersize',1,'color','k','PickableParts','none','tag',['comphdl1',num2str(i-startp+1)]);
                % draw all the detected peaks
                if ~isempty(result{i}.is_compound{EICid}(:,peakid))
                    stem(axhdl,orgx(result{i}.is_compound{EICid}(:,peakid)),orgy(result{i}.is_compound{EICid}(:,peakid)),'markersize',3,...
                        'color','g','PickableParts','none','tag',['comphdl2',num2str(i-startp+1)]);
                else
                    stem(axhdl,orgx(result{i}.is_peak{EICid}(:,peakid)),0,'markersize',3,...
                        'color','g','PickableParts','none','tag',['comphdl2',num2str(i-startp+1)]);
                end
                % draw the compound tips
                stem(axhdl,orgx(result{i}.is_peak{EICid}(:,peakid)),orgy(result{i}.is_peak{EICid}(:,peakid)),'markersize',1,...
                    'color','r','PickableParts','none','tag',['comphdl3',num2str(i-startp+1)]);
                % draw the background intensity
                stem(axhdl,orgx,result{i}.bg_int{EICid},'color',[0.5 0.5 0.5],'markersize',1,'linewidth',1,...
                    'PickableParts','none','tag',['comphdl4',num2str(i-startp+1)]);
                % show adjusted peaks
                if any(result{i}.decomp{EICid}(:,peakid)>0)
                    stem(axhdl,orgx,result{i}.decomp{EICid}(:,peakid),'markersize',1,'color','b','PickableParts','none',...
                        'Visible','on','tag',['comphdl5',num2str(i-startp+1)]);
                else
                    stem(axhdl,orgx,zeros(size(orgx)),'markersize',1,'color','none','PickableParts','none',...
                        'Visible','off','tag',['comphdl5',num2str(i-startp+1)]);
                end
                id1=find(orgx>xrange(1),1,'first');
                id2=find(orgx<xrange(2),1,'last');
                maxy=max(1,1.05*max(orgy(id1:id2)));
                if i==fileid
                    set(axhdl,'XColor','r','XLim',[orgx(1) orgx(end)],'YColor','r','YLim',[0 maxy],...
                        'LineWidth',2,'Box','on','Tag',['ax_sub',num2str(i-startp+1)]);
                else
                    set(axhdl,'XColor','k','XLim',[orgx(1) orgx(end)],'YColor','k','YLim',[0 maxy],...
                        'LineWidth',1,'Box','on','Tag',['ax_sub',num2str(i-startp+1)]);
                end
                title(axhdl,filelist{i},'interpreter','none');
                pause(0.005);
            end
            % set the slider position
            if nof >= 5
                set(findobj('Tag','SL_comp'),'Value',1.0-(startp-1)/(nof-5),'Enable','on','SliderStep',[min(1,1/(nof-5)),min(1,min((nof-5),5)/(nof-5))]);
            else
                set(findobj('Tag','SL_comp'),'Enable','off');
            end
        else
            % update the plots of the same compound in other files
            show_compound_in_nearby_files('','',fileid,compoundid,hdlrec,hdlmeth,fhdl,true);
        end
    else
        set(hobj,'String','More >','UserData',0);
        set(fhdl,'Position',[0.1 0.2 0.5 0.7]);
        % panel displaying the information of the current compound
        set(pl_cur_comp,'Position',[0.0 0.0 1.0 1.0]);
        set(pl_more_comp,'Position',[0.0 0.0 0.0 1.0]);
    end
end
%--------------------------------------------------------------------------
% show the same compound EIC in the nearby (+/-2) files when the 'more>'
% button is pressed
%--------------------------------------------------------------------------
function show_compound_in_nearby_files(hobj,~,fileid,compoundid,hdlrec,hdlmeth,fhdl,redraw_overlap_plot)
    pbhdl=findobj('Tag','PB_show_more');
    if pbhdl.UserData == 0, return, end % the 'more>' button is not pressed, no need to show nearby compound info
    % get the required info
    result=hdlrec.UserData;
    nof=length(result);
    method=hdlmeth.UserData;
    hdltxt=findobj('Tag','txt_overlap');
    overhdl=findobj('Tag','ax_overlap');
    compid=hdltxt.UserData;
    slider_update=false; % whether the slider need to be updated
    %redraw_overlap_plot=true; % whether to update the overlapping plot
    if ~isempty(hobj) % the function is called by a slider
        slvalue=1.0-hobj.Value;
        %redraw_overlap_plot=false;
    else % the function is called by other uicontrol
        hobj=findobj('Tag','SL_comp');
        slider_update=true;
    end
    if fileid==0 % called by a slider
        currid=fhdl.UserData;
        fileid=round(slvalue*(nof-5))+3;
        orgfileid=currid(1);
        compoundid=currid(2);
    else
        orgfileid=fileid;
    end
    if (compid==compoundid) % the selected compound is the same as the previous one
        %redraw_overlap_plot=false;
    else
        hdltxt.UserData=compoundid;
    end
    % find the starting file to be ploted
    if fileid >= nof-2 
        startp=max(1,nof-4);
    else
        startp=max(1,(fileid-2));
    end
    endp=min(nof,(startp+4)); % the last file to be ploted
    % indices of the current compound
    EICid=method.EICidx(compoundid,2);
    peakid=method.EICidx(compoundid,3);
    % horizontal display range
    xrange=[method.rt{EICid}(peakid)-method.rt_diff{EICid}(peakid) method.rt{EICid}(peakid)+method.rt_diff{EICid}(peakid)];
    % load file list
    if contains(lower(get(findobj('Tag','PB_quant'),'UserData')),'standard') % quantitation on standard compound data
        filelist=get(findobj('Tag','rb_abs_stc'),'UserData').fname;
    else % quantitation on testing data
        filelist=get(findobj('Tag','list_file'),'String');
    end
    if redraw_overlap_plot
        set(overhdl,'nextplot','add');
        phdl=findobj('tag','comp_overlap'); % get the IDs of the curves
        for i=1:nof
            orgx=result{i}.data{EICid}(:,1);
            orgy=result{i}.data{EICid}(:,2);
            decy=result{i}.decomp{EICid}(:,peakid);
            if any(decy) % if deconvolution signal exists, draw the deconvolution signal
                if isempty(phdl)
                    line(overhdl,orgx(decy>0),decy(decy>0),'tag','comp_overlap');
                else
                    set(phdl(i),'XData',orgx(decy>0),'YData',decy(decy>0));
                end
            else % no deconvolution signal exists, show the original peak signal
                if any(result{i}.is_compound{EICid}(:,peakid)) % if a peak is detected
                    if isempty(phdl)
                        line(overhdl,orgx(result{i}.is_compound{EICid}(:,peakid)),...
                            orgy(result{i}.is_compound{EICid}(:,peakid)),'tag','comp_overlap');
                    else
                        set(phdl(i),'XData',orgx(result{i}.is_compound{EICid}(:,peakid)),...
                        'YData',orgy(result{i}.is_compound{EICid}(:,peakid)));
                    end
                else % no peak is detected
                    if isempty(phdl)
                        line(overhdl,orgx(result{i}.is_peak{EICid}(:,peakid)),...
                            orgy(result{i}.is_peak{EICid}(:,peakid)),'tag','comp_overlap');
                    else
                        set(phdl(i),'XData',orgx(result{i}.is_peak{EICid}(:,peakid)),...
                            'YData',orgy(result{i}.is_peak{EICid}(:,peakid)));
                    end
                end
            end
        end
        axis(overhdl,'tight');
    end
    % draw the compound in the current sample with a wider line
    hdlcur=findobj('Tag','cur_curve');
    orgx=result{orgfileid}.data{EICid}(:,1);
    orgy=result{orgfileid}.data{EICid}(:,2);
    decy=result{orgfileid}.decomp{EICid}(:,peakid);
    if any(decy) % if deconvolution signal exists, draw the deconvolution signal
        if isempty(hdlcur)
            line(overhdl,orgx(decy>0),decy(decy>0),'Color','r','LineWidth',2,'Tag','cur_curve');
        else
            set(hdlcur,'XData',orgx(decy>0),'YData',decy(decy>0));
        end
    else % no deconvolution signal exists, show the original peak signal
        if any(result{orgfileid}.is_compound{EICid}(:,peakid)) % if a peak is detected
            if isempty(hdlcur)
                line(overhdl,orgx(result{orgfileid}.is_compound{EICid}(:,peakid)),...
                    orgy(result{orgfileid}.is_compound{EICid}(:,peakid)),...
                    'Color','r','Linewidth',2,'Tag','cur_curve');
            else
                set(hdlcur,'XData',orgx(result{orgfileid}.is_compound{EICid}(:,peakid)),...
                    'YData',orgy(result{orgfileid}.is_compound{EICid}(:,peakid)));
            end
        else % no peak is detected
            if isempty(hdlcur)
                line(overhdl,orgx(result{orgfileid}.is_peak{EICid}(:,peakid)),...
                    orgy(result{orgfileid}.is_peak{EICid}(:,peakid)),...
                    'Color','r','Linewidth',2,'Tag','cur_curve');
            else
                set(hdlcur,'XData',orgx(result{orgfileid}.is_peak{EICid}(:,peakid)),...
                    'YData',orgy(result{orgfileid}.is_peak{EICid}(:,peakid)));
            end
        end
    end
    hdl=findobj(overhdl,'type','line');
    set(overhdl,'UserData',get(hdl,'YData'));
    % plot the compound in the neighboring (+/-2) files
    for i=startp:endp
        axhdl=findobj('Tag',['ax_sub',num2str(i-startp+1)]);
        % draw all the recorded abundances
        orgx=result{i}.data{EICid}(:,1);
        orgy=result{i}.data{EICid}(:,2);
        ohdl1=findobj('tag',['comphdl1',num2str(i-startp+1)]);
        set(ohdl1,'XData',orgx,'YData',orgy);
        % draw all the detected peaks
        ohdl2=findobj('tag',['comphdl2',num2str(i-startp+1)]);
        set(ohdl2,'XData',orgx(result{i}.is_compound{EICid}(:,peakid)),...
            'YData',orgy(result{i}.is_compound{EICid}(:,peakid)));
        % draw the compound tips
        ohdl3=findobj('tag',['comphdl3',num2str(i-startp+1)]);
        set(ohdl3,'XData',orgx(result{i}.is_peak{EICid}(:,peakid)),...
            'YData',orgy(result{i}.is_peak{EICid}(:,peakid)));
        % show adjusted peaks
        ohdl5=findobj('tag',['comphdl5',num2str(i-startp+1)]);
        if any(result{i}.decomp{EICid}(:,peakid)>0)
            set(ohdl5,'XData',orgx,'YData',result{i}.decomp{EICid}(:,peakid),'Color','b','Visible','on');
        else
            set(ohdl5,'XData',orgx,'YData',result{i}.decomp{EICid}(:,peakid),'Visible','off');
        end
        % draw the background intensity
        ohdl4=findobj('tag',['comphdl4',num2str(i-startp+1)]);
        set(ohdl4,'XData',orgx,'YData',result{i}.bg_int{EICid});
        id1=find(orgx>xrange(1),1,'first');
        id2=find(orgx<xrange(2),1,'last');
        maxy=max(1,1.05*max(orgy(id1:id2)));
        axhdl.YRuler.SecondaryLabel.HorizontalAlignment='center';
        if i==orgfileid
            set(axhdl,'XColor','r','XLim',[orgx(1) orgx(end)],'YColor','r','YLim',[0 maxy],...
                'LineWidth',2,'Box','on','buttondownfcn',{@modify_peak_area,i,compoundid});
        else
            set(axhdl,'XColor','k','XLim',[orgx(1) orgx(end)],'YColor','k','YLim',[0 maxy],...
                'LineWidth',1,'Box','on','buttondownfcn',{@modify_peak_area,i,compoundid});
        end
        title(axhdl,filelist{i},'interpreter','none');
        axhdl.TitleHorizontalAlignment = 'right';
        pause(0.005);
    end
    % set the slider position
    if slider_update && (nof>=5)
        set(hobj,'Value',1.0-(startp-1)/(nof-5),'Enable','on','SliderStep',[min(1,1/(nof-5)),min(1,min((nof-5),5)/(nof-5))]);
    end
end
%-------------------------------------
% adjust compound quantitation status
%-------------------------------------
function adjust_quantitation_status(~,~,hdlrec,hdlmeth,hdlpara,fhdl,ahdl)
    % find the currect compoind id
    vec=fhdl.UserData;
    fileid=vec(1);
    compoundid=vec(2);
    % disable the toolbar
    ahdl.Toolbar.Visible = 'off';
    % load stored compound data
    rec=hdlrec.UserData;
    method=hdlmeth.UserData;
    hdlmtx=findobj('Tag','AX_heat_map');
    % convert current compound id to EIC id and peak id 
    EICid=method.EICidx(compoundid,2);
    peakid=method.EICidx(compoundid,3);
    % keep the original info
    old_quant_note=rec{fileid}.quant_note{EICid}(peakid);
    % update the status
    rec{fileid}.quant_note{EICid}(peakid)=0;
    hdlrec.UserData=rec;
    % allow to change the compound info
    set(findobj('Tag','PB_adj_status'),'UserData',true);
    % display a window for user to select whether to apply the change to multiple compounds
    % collect update parameter
    update_para.fileid = fileid;
    update_para.compid = compoundid;
    update_para.dir = 'file';
    update_para.bound = [];
    update_para.xcord = -1;
    update_para.bg_int = -1;
    update_para.start_comp = 0;
    update_para.end_comp = -1;
    update_para.start_file = 0;
    update_para.end_file = -1;
    select_EIC(update_para,4);
    if ~get(findobj('Tag','PB_adj_status'),'UserData') % restore the original EIC plot
        % restore all the peak info
        rec{fileid}.quant_note{EICid}(peakid)=old_quant_note;
        hdlrec.UserData=rec;
        return
    end
    % update heatmap
    set(pg_text,'String','Updating heatmap...');
    change_heatmap_abundent('','',hdlrec,hdlmeth,hdlpara,hdlmtx);
    set(pg_text,'String','');
    % allow user to save the result
    set(findobj('Tag','PB_save_result'),'UserData',false,'Enable','on');
    % update changed compound status
    set(findobj('tag','txt_status'),'String','Successful Quantitation','FontWeight','bold','ForegroundColor',[0 0.8 0]);
    ahdl.Toolbar.Visible = 'on';
end
%-------------------------------------
% show/hide quantitation message
%-------------------------------------
function show_quantitation_message(hobj,~,is_show,hdlpara)
    if ~isempty(is_show) % if is_show is given
        hobj=findobj(hdlpara,'Tag','PB_show_msg');
        if is_show == 1
            hobj.UserData = 0;
        else
            hobj.UserData = 1;
        end
    end
    pl_qmsg=findobj('Tag','pl_qmsg');
    pl_peakdet=findobj(hdlpara,'Tag','pl_peakdet');
    bg_conv=findobj(hdlpara,'Tag','bg_conv');
    cb_normal=findobj(hdlpara,'Tag','cb_normal');
    pl_parabut=findobj(hdlpara,'Tag','pl_parabut');
    txt_hdl=findobj('Tag','txt_para');
    if hobj.UserData == 0
        hobj.String='Hide Message >';
        hobj.UserData = 1;
        hdlpara.Position=[0.45 0.8 0.1 0.2];
        pl_qmsg.Position=[0.55 0.8 0.35 0.2];
        set(pl_peakdet,'Visible','off','Enable','off');
        set(bg_conv,'Visible','off','Enable','off');
        set(cb_normal,'Visible','off','Enable','off');
        pl_parabut.Position=[0.02 0.0 0.98 0.8];
        set(txt_hdl,'String','Quant. Param.');
    else
        hobj.String='< Show Message';
        hobj.UserData = 0;
        hdlpara.Position=[0.45 0.8 0.45 0.2];
        pl_qmsg.Position=[0.9 0.8 0.0 0.2];
        set(pl_peakdet,'Visible','on','Enable','on');
        set(bg_conv,'Visible','on','Enable','on');
        set(cb_normal,'Visible','on','Enable','on');
        pl_parabut.Position=[0.8 0.0 0.2 0.8];
        set(txt_hdl,'String','Quantitation Parameters');
    end
end
%--------------------------------------------------------------
% show the peak area of the selected standard compound in a LC for inspection
%--------------------------------------------------------------
function modify_peak_area(~,~,fileid,compid)
    % find handle of the heatmap and that of its corresponding axes
    phdl1=findobj('Tag','AX_heat_map');
    phdl2=findobj('Tag','AX_TIC_plot');
    imhdl=findobj('Tag','im_heatmap');
    hdlpara=findobj('Tag','pl_para');
    % update the heat map if the compound is out of display range
    YLim=get(phdl1,'YLim');
    slhdl=findobj('Tag','SL_plot_v'); % handle of the vertical slider
    info=slhdl.UserData;
    nof=info(1);
    dispfnum=info(2);
    dispfnum=min(dispfnum,YLim(2)-0.5); % actual number of files displayed in the heatmap
    if (fileid < YLim(1)) || (fileid > YLim(2)) % need to adjust display range
        % compute the suitable slider value
        slhdl.Value=1.0-max(0,(fileid-dispfnum))/(nof-dispfnum);
        vertical_slider_adjust(slhdl,'',phdl1,phdl2,hdlpara);
    end
    % get the color of the selected box
    ihdl=findobj(phdl1.Children,'type','Image');
    cid=ihdl.CData;
    aid=ihdl.AlphaData;
    cmin = min(cid(:));
    cmax = max(cid(:));
    cmap=colormap;
    m = length(cmap);
    if aid(fileid,compid)==1
        index = fix((cid(fileid,compid)-cmin)/(cmax-cmin)*m)+1; 
        RGB = 1.0-ind2rgb(index,cmap); % find the complementary color
    else
        RGB = [0,0,0];
    end
    % draw a rectangle in the heatmap to indicate the selected compound
    rthdl=findobj('tag','sel_rect');
    if isempty(rthdl)
        rectangle(phdl,'Position',[compid-0.5,fileid-0.5,1,1],'EdgeColor',RGB,'LineWidth',3,'LineStyle','-','tag','sel_rect');
    else
        set(rthdl,'Position',[compid-0.5,fileid-0.5,1,1],'EdgeColor',RGB);
    end
    plot_EIC(imhdl,'',fileid,compid);
end 
%--------------------------------------------------------------------------
% adjust the display of standard curves of different compounds according to
% the slider position
%--------------------------------------------------------------------------
function show_standard_curve_of_nearby_comps(hobj,~,hdlmeth,hdlastc)
    method=hdlmeth.UserData;
    exp=hdlastc.UserData;
    nop=exp.nocomp; % number of compounds
    % Reassign the buttondownfcn of the 16 plots
    if isempty(hobj)
        SliderValue=1.0;
    else
        SliderValue=hobj.Value;
    end
    for i=1:min(16,nop)
        compid=round((1.0-SliderValue)*(nop-16))+i;
        axhdl=findobj('tag',['ax_stc',num2str(i)]);
        set(axhdl,'NextPlot','add','ButtonDownFcn',{@show_individual_standard_curve,compid});
        % compute abundances from known concentrations normalized for internal 
        % standard and the regression line
        if method.ISidx > 0 % internal standard is provided
            ycoord=exp.abundance(:,compid)./exp.abundance(:,method.ISidx);
        else
            ycoord=exp.abundance(:,compid);
        end
        keepid=exp.used_for_reg(:,compid); %=~isnan(ycoord);
        f=exp.std_curve{compid}; % load the fitted curve function for the standard curve
        y=feval(f,exp.conc);
        maxy=max(y);
        miny=min(y);
        %update the standard curve plots
        if isempty(axhdl.Children) % Nothing has been drawn in the axes before
            line(axhdl,exp.conc(keepid),ycoord(keepid),'color','b','marker','+','linewidth',1,'HitTest','off','PickableParts','none','tag',['std_hdl1',num2str(i)]);
            line(axhdl,exp.conc,y,'color','r','linewidth',1,'HitTest','off','PickableParts','none','tag',['std_hdl2',num2str(i)]);
            ytickformat('%,.2f')
            title(axhdl,exp.indiv_name{compid})
        else % Something has been drawn in the axes before
            stdhdl1=findobj('tag',['std_hdl1',num2str(i)]);
            stdhdl2=findobj('tag',['std_hdl2',num2str(i)]);
            if isempty(stdhdl1) % the connection of data points is missing
                line(axhdl,exp.conc(keepid),ycoord(keepid),'color','b','marker','+','linewidth',1,'HitTest','off','PickableParts','none','tag',['std_hdl1',num2str(i)]);
                axhdl.Children=flipud(axhdl.Children);
            elseif isempty(stdhdl2) % the regression curve is missing
                line(axhdl,exp.conc,y,'color','r','linewidth',1,'HitTest','off','PickableParts','none','tag',['std_hdl2',num2str(i)]);
                axhdl.Children=flipud(axhdl.Children);
            else
                set(stdhdl1,'XData',exp.conc(keepid),'YData',ycoord(keepid));
                set(stdhdl2,'XData',exp.conc,'YData',y);
            end
            title(axhdl,exp.indiv_name{compid});
        end
        if (maxy-miny) < 1e-6 % to avoid small concentration variation
            set(axhdl,'XLim',[0 inf],'YLim',[mean(y)-0.5,mean(y)+0.5]);
        else
            set(axhdl,'XLim',[0 inf],'YLim',[-inf inf]);
        end
    end
    show_individual_standard_curve('','',round(1.0-SliderValue)*(nop-16)+1);
end
% ----------------------------------------------------------------------
% adjust the display of compounds related a standard curve according to
% the slider position
% ----------------------------------------------------------------------
function show_standard_curve_related_comps(hobj,~,hdlrec,hdlmeth,hdlastc)
    result=hdlrec.UserData;
    method=hdlmeth.UserData;
    exp=hdlastc.UserData;
    nod=length(result); % number of MRM data
    if isempty(hobj)
        SliderValue=1.0;
    else
        SliderValue=hobj.Value;
    end
     % Find out what is the current compound by checking whose x-axis is red
    stdcur_plotid=1;
    for i=1:min(16,exp.nocomp)
        axhdl=findobj('Tag',['ax_stc',num2str(i)]);
        if isequal(axhdl.XColor,[1 0 0])
            stdcur_plotid=i;
            break;
        end
    end
    % compute the absolute compound id through slider position
    slhdl1=findobj('Tag','SL_StandCurve');
    compid=round((1.0-slhdl1.Value)*(exp.nocomp-16)+stdcur_plotid);
    EICid=method.EICidx(method.EICidx(:,1)==compid,2);
    peakid=method.EICidx(method.EICidx(:,1)==compid,3);
    % determine display range
    xrange=[exp.rt{exp.EICidx(compid,2)}(exp.EICidx(compid,3))-exp.rt_diff{exp.EICidx(compid,2)}(exp.EICidx(compid,3)) ...
        exp.rt{exp.EICidx(compid,2)}(exp.EICidx(compid,3))+exp.rt_diff{exp.EICidx(compid,2)}(exp.EICidx(compid,3))];  
    orgx=result{1}.data{EICid}(:,1);
    id1=find(orgx>xrange(1),1,'first');
    id2=find(orgx<xrange(2),1,'last');
    % check whether to display absolute or relative peak heights
    ckhdl=findobj('tag','cb_change_v_disp');
    tmaxy=0;
    for i=1:nod
        orgy=result{i}.data{EICid}(:,2);
        tmaxy=max(tmaxy,1.05*max(orgy(id1:id2)));
    end
    for i=1:min(5,nod) % draw the i-th EICs of the first standard compound
        fileid=round((1.0-SliderValue)*(nod-5))+i;
        hdl=findobj('Tag',['ax_comp',num2str(i)]);
        set(hdl,'NextPlot','add','YGrid','on','ButtonDownFcn',{@show_individual_peak_area,fileid,nod,hdlastc});
        % draw all the recorded abundances
        orgx=result{fileid}.data{EICid}(:,1);
        orgy=result{fileid}.data{EICid}(:,2);
        if ckhdl.Value
            maxy=max(orgy(id1:id2));
        else
            maxy=tmaxy;
        end
        set(findobj('tag',['conc_hdl1',num2str(i)]),'XData',orgx,'YData',orgy);
        % draw all the detected peaks
        set(findobj('tag',['conc_hdl2',num2str(i)]),'XData',orgx(result{fileid}.is_compound{EICid}(:,peakid)),'YData',orgy(result{fileid}.is_compound{EICid}(:,peakid)));
        % draw the compound tips
        set(findobj('tag',['conc_hdl3',num2str(i)]),'XData',orgx(result{fileid}.is_peak{EICid}(:,peakid)),'YData',orgy(result{fileid}.is_peak{EICid}(:,peakid)));
        % draw background intensity
        set(findobj('tag',['conc_hdl4',num2str(i)]),'XData',orgx,'YData',result{fileid}.bg_int{EICid});
        % show adjusted peaks
        if any(result{fileid}.decomp{EICid}(:,peakid)>0)
            tempy=result{fileid}.decomp{EICid}(:,peakid);
            keepid=tempy>0;
            set(findobj('tag',['conc_hdl5',num2str(i)]),'XData',orgx(keepid),'YData',tempy(keepid),'Visible','on');
        else
            set(findobj('tag',['conc_hdl5',num2str(i)]),'XData',orgx,'YData',zeros(size(orgx)),'Visible','off');
        end
        % generate RT difference window
        set(findobj('tag',['conc_hdl6',num2str(i)]),'XData',[xrange(1) xrange(1) xrange(2) xrange(2) xrange(1)],...
            'YData',[0 maxy maxy 0 0]);
        set(findobj('tag',['conc_hdl7',num2str(i)]),'XData',[exp.rt{exp.EICidx(compid,2)}(exp.EICidx(compid,3)),exp.rt{exp.EICidx(compid,2)}(exp.EICidx(compid,3))],...
            'YData',[0 maxy]);
        [~,fname,~] = fileparts(exp.fname{fileid});
        title(hdl,['Concentration: ',num2str(exp.conc(fileid)),' (',fname,')'],'Interpreter','none');
        hdl.TitleHorizontalAlignment = 'right';
        % adjust display range
        axis(hdl,[xrange(1)-0.1 xrange(2)+0.1 0 maxy]);
        % update the checkbox for regression
        set(findobj('tag',['cb_for_reg',num2str(i)]),'Value',exp.used_for_reg(fileid,compid));
    end
end
%--------------------------------------------------------------
% The objective function for optimization
%--------------------------------------------------------------
function y=peak_approximation(x,curve)
    curve1 = x(1)*gaussmf(curve(:,1),[x(2) x(3)]);
    % compute the difference between the original curve and the accumulated Gaussian
    y=sum(abs(curve1-curve(:,2))); 
end
% -----------------------------------------------------------
% Change the vertical display range in the detected peak area
% -----------------------------------------------------------
function change_vertical_display_range(hobj,~,hdlrec,hdlmeth,hdlastc)
    rec=hdlrec.UserData;
    method=hdlmeth.UserData;
    filenum=length(rec); % number of MRM files to construct the standard curves
    compnum=method.nocomp;
    % find the selected plot ID in the 4x4 standard curve plots
    selid=0;
    for i=1:min(16,compnum)
        axhdl=findobj('tag',['ax_stc',num2str(i)]);
        if all(axhdl.XColor==[1,0,0])
            selid=i;
            break;
        end
    end
    % find the handle of sliders
    shdl1=findobj('Tag','SL_StandCurve');
    shdl2=findobj('Tag','SL_StandComp');
    % find the compound ID
    compid=selid+round((1.0-shdl1.Value)*(compnum-16));
    EICid=method.EICidx(compid,2);
    fileid=round((1.0-shdl2.Value)*(filenum-5));
    exp=hdlastc.UserData;
    xrange=[exp.rt{exp.EICidx(compid,2)}(exp.EICidx(compid,3))-exp.rt_diff{exp.EICidx(compid,2)}(exp.EICidx(compid,3)) ...
        exp.rt{exp.EICidx(compid,2)}(exp.EICidx(compid,3))+exp.rt_diff{exp.EICidx(compid,2)}(exp.EICidx(compid,3))];  
    orgx=rec{1}.data{EICid}(:,1);
    sid=find(orgx>xrange(1),1,'first');
    eid=find(orgx<xrange(2),1,'last');
    if hobj.Value % set the vertical range to the local highest signal
        for i=1:min(5,filenum)
            axhdl=findobj('tag',['ax_comp',num2str(i)]);
            ymax=max(rec{i+fileid}.data{EICid}(sid:eid,2));
            ylim(axhdl,[0 ymax])
        end
    else % set the vertical range to the global highest signal
        ymax=0;
        % find the highest peak height in all files
        for i=1:filenum
            ymax=max(ymax,max(rec{i}.data{EICid}(sid:eid,2)));
        end
        % set all the vertical range to the highest peak height
        for i=1:min(5,filenum)
            axhdl=findobj('tag',['ax_comp',num2str(i)]);
            ylim(axhdl,[0 ymax]);
        end
    end
end
% --------------------------------------------------------------------
% switch the display scale of the standard curves between linear and
% logarithmic
% --------------------------------------------------------------------
function change_standard_curve_display_range(hobj,~)
    plhdl=findobj('Tag','std_curves');
    if hobj.Value==1
        for i=1:length(plhdl.Children.Children)
            set(plhdl.Children.Children(i),'XScale','log','YScale','log');
        end
    else
        for i=1:length(plhdl.Children.Children)
            set(plhdl.Children.Children(i),'XScale','lin','YScale','lin');
        end
    end
end
% ----------------------------------------------------------------------
% update the standard curve when some of its points are removed
% ----------------------------------------------------------------------
function remove_point_from_standard_curve(hobj,~,hdlrec,hdlmeth,hdlastc)
    rec=hdlrec.UserData;
    method=hdlmeth.UserData;
    filenum=length(rec); % number of MRM files to construct the standard curves
    compnum=method.nocomp;
    % find the selected plot ID in the 4x4 standard curve plots
    selid=0;
    for i=1:min(16,compnum)
        axhdl=findobj('tag',['ax_stc',num2str(i)]);
        if all(axhdl.XColor==[1,0,0])
            selid=i;
            break;
        end
    end
    exp=hdlastc.UserData;
    % find the handle of sliders
    shdl1=findobj('Tag','SL_StandCurve');
    shdl2=findobj('Tag','SL_StandComp');
    % compute the file ID
    localID=str2double(hobj.Tag(end)); % which of the five EIC plot is checed/unchecked
    fileid=round((1.0-shdl2.Value)*(filenum-5))+localID;
    % find the compound ID
    compid=selid+round((1.0-shdl1.Value)*(compnum-16));
    EICid=method.EICidx(compid,2);
    % update the used points in the regression 
    exp.used_for_reg(fileid,compid)=(hobj.Value==1);
    % normalize the abundance by internal standard
    ref_abund1=1;
    if ~isempty(method.IS)
        ISID=strcmpi(method.indiv_name,method.IS{EICid}); % the internal standard of the j-th compound
        ref_abund1=exp.abundance(:,ISID);
    elseif (method.ISidx~=-1) % absolute quantitation using standard curve
        if (method.ISidx>0)
            ref_abund1=exp.abundance(:,method.ISidx);
        end
    end
    ycoord=exp.abundance(:,compid)./ref_abund1;
    % find the points involve in the regression
    keepid=exp.used_for_reg(:,compid);
    % determine the regression form
    [f,~]=standard_data_regression(exp.conc,ycoord,keepid,exp.model{EICid},exp.regweight{EICid});  
    if isempty(f), return;end
    exp.std_curve{i}=f;
    y=feval(f,exp.conc);
    yvalue=[ycoord(keepid);y];
    miny=min(yvalue);
    maxy=max(yvalue);
    if (max(y)-min(y)) < 1e-6 % to avoid small concentration variation
        YLim=[mean(y)-0.5 mean(y)+0.5];
    else
        YLim=[miny maxy];
    end
    axhdl=findobj('tag',['ax_stc',num2str(selid)]);
    lhdl=axhdl.Children;
    for j=1:length(lhdl)
        if lhdl(j).Marker=='+'
            lhdl(j).YData=ycoord(keepid);
            lhdl(j).XData=exp.conc(keepid);
        else
            lhdl(j).YData=y;
        end
    end
    set(axhdl,'YLim',YLim);
    % find the current EIC file ID and compound ID in the heatmap
    hdl1=findobj('Tag','sel_rect');
    if ~isempty(hdl1)
        pos=hdl1.Position;
        hm_compid=round(pos(1)+0.1);
        hm_fileid=round(pos(2)+0.1);
        if hm_compid==compid
            axs=findobj('Tag','AX_std_curve');
            % draw the curve links standard sample data
            tempid=findobj('tag','LN_std_pt');
            if isempty(tempid)
                line(axs,exp.conc(keepid),ycoord(keepid),'linewidth',1,'marker','+','color','b','tag','LN_std_pt');
            else
                set(tempid,'xdata',exp.conc(keepid),'ydata',ycoord(keepid))
            end
            % draw the regression line of the previous curve
            tempid=findobj('tag','LN_std_cv');
            if isempty(tempid)
                line(axs,exp.conc,y,'linewidth',1,'color','r','visible','on','tag','LN_std_cv');
            else
                set(tempid,'xdata',exp.conc,'ydata',y);
            end
            [compconc,flag]=find_conc_from_standard_curve(exp,hm_compid,ycoord(hm_fileid));
            tempid=findobj('tag','LN_conc_ind');
            if isempty(tempid)
                line(axs,[compconc compconc],YLim,'linewidth',3,'linestyle',':','color','r','tag','LN_conc_ind');
            else
                set(tempid,'xdata',[compconc compconc],'ydata',YLim);
            end
            if ~flag
                title(axs,['\fontsize{12}Concentration = {\color{red}',num2str(compconc,'%.2f'),'}']);
            else
                title(axs,['\fontsize{12}Concentration = {\color{red}',num2str(compconc,'%.2f'),'(linear)}']);
            end
        end
    end
    % save the modifications
    hdlastc.UserData=exp;
end
% ------------------------------------------------------------------------
% determine the regression line and values from standard data points
% ------------------------------------------------------------------------
function [f,yreg]=standard_data_regression(x,y,keepid,model,regweight)
    % remove nan in y
    useid=~isnan(y) & keepid;
    y=y(useid);
    if sum(useid)<2 % less than two points, no line can be generated
        errordlg('You need at least 2 data points to determine a regression line!','Curve Fitting Error','modal');
        f=[];yreg=[];
        return;
    elseif sum(useid)<3 % only two points are available, a linear line is used as standard curve
        f=fit(x(useid),y,'poly1','Lower',[0,0],'Upper',[Inf,0]); % use a linear function to fit the data points
        yreg=feval(f,x);
    else
        % determine the regression form
        yeq=(y(2:end)-y(1:end-1))==0;
        yincr=(y(2:end)-y(1:end-1))>0;
        incrratio=sum(yincr|yeq)/length(yincr);
        eqratio=sum(yeq)/length(yincr);
        monotonic_increaing=(incrratio>0.7) & (eqratio<0.4); % whether the curve is monotonic increaing
        if (std(y) < 0.05) && ~monotonic_increaing % check if the data is noisy and has small STD
            f=cfit(fittype('a*x+b'),0,mean(y)); % a flat line with the average value
            yreg=repmat(mean(y),size(x));
        else
            if strcmpi(regweight,'1')
                weights=ones(size(x(useid))); % regression weights = 1
            elseif strcmpi(regweight,'1/x')
                weights=1./x(useid); % regression weights = 1/x
            else
                weights=1./(x(useid).^2); % regression weights = 1/x^2
            end
            if strcmpi(model,'quadratic')
                maxpow=2; % power function of order 2
            elseif strcmpi(model,'linear')
                maxpow=1; % power function of order 1
            else
                maxpow=0; % power function of order 0
            end
            try
                f=fit(x(useid),y,'a*x^b','Lower',[0,0],'Upper',[Inf,maxpow],'Weights',weights); % use a power function to fit the data points
            catch
                f=fit(x(useid),y,'poly1','Lower',[0,0],'Upper',[Inf,0],'Weights',weights); % use a linear curve to fit the data points            
            end
            yreg=feval(f,x);
        end 
    end
end
% ------------------------------------------------------------
% set batch effect correction paramaters
% ------------------------------------------------------------
function answer=batch_effect_correction_para(hdlrec,hdlpara,style)
    global bgcolor
    rec=hdlrec.UserData;
    answer='Yes';
    normwin = figure('Units','normalized', ...
        'Color',bgcolor,...
        'Menubar','none',...
        'Name','Batch Effect Correction', ...
        'NumberTitle','off', ...
        'Position',[0.4 0.2 0.3 0.6], ...
        'WindowStyle','normal',...
        'Tag','fg_norm');
    uicontrol('Parent',normwin, ...
        'BackgroundColor',bgcolor, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'Position',[0.02 0.9 0.48 0.09],...
        'HorizontalAlignment','left',...
        'String','Please indicate the QC samples, the reference sample, and the end sample of each batch.', ...
        'Style','text');
    uicontrol('Parent',normwin, ...
        'BackgroundColor',bgcolor, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'Position',[0.54 0.96 0.44 0.03],...
        'HorizontalAlignment','left',...
        'String','The unique term in the QC samples:', ...
        'Style','text');
    edt_term=uicontrol('Parent',normwin, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'Position',[0.56 0.9 0.28 0.05],...
        'Style','edit',...
        'ToolTip','Input the unique term to identify QC samples.');
    tbl_normal=uitable('Parent',normwin,...
        'units','normalized',...
        'position',[0.02 0.16 0.96 0.73],...
        'ColumnName',{'QC Sample','Reference','Batch End','Batch','Sample File Name'},...
        'ColumnFormat',{'logical','logical','logical','numeric','char'},...
        'ColumnEditable',[true true true false false],...
        'ColumnWidth', {80,80,80,50,150},...
        'CellEditCallback',@edit_batch,...
        'FontSize',12,...
        'RowName',[]);
    % button for execute the check
    uicontrol('Parent',normwin, ...
        'Units','normalized', ...
        'FontUnits','normalized', ...
        'Position',[0.85 0.9 0.13 0.05],...
        'String','Check', ...
        'Callback',{@identify_QC_sample_by_unique_term,edt_term,tbl_normal},...
        'Style','pushbutton',...
        'ToolTip','Auto check the QC samples by the unique term.');
    uicontrol('Parent',normwin, ...
        'BackgroundColor',bgcolor, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'Position',[0.02 0.115 0.4 0.03],...
        'HorizontalAlignment','right',...
        'String','Set a regression span', ...
        'Style','text');
    ed_reg_span=uicontrol('Parent',normwin,...
        'units','normalized',...
        'position',[0.43 0.11 0.2 0.04],...
        'FontSize',12,...
        'String','0.1',...
        'Style','edit');
    if style == 0 % the batch effect correction function is call for the first time 
        % button for starting batch effect correction
        uicontrol('Parent',normwin, ...
            'BackgroundColor',bgcolor, ...
            'Units','normalized', ...
            'FontUnits','normalized', ...
            'Callback',{@save_batch_effect_correction_para,1,hdlrec,hdlpara,tbl_normal,ed_reg_span}, ...
            'Position',[0.1 0.02 0.2 0.06],...
            'String','Ok', ...
            'Style','pushbutton',...
            'ToolTip','Start batch effect correction');
        % button for skipping batch effect correction
        uicontrol('Parent',normwin, ...
            'BackgroundColor',bgcolor, ...
            'Units','normalized', ...
            'FontUnits','normalized', ...
            'Callback',{@save_batch_effect_correction_para,0,hdlrec,hdlpara,tbl_normal,ed_reg_span}, ...
            'Position',[0.4 0.02 0.2 0.06],...
            'String','Skip', ...
            'Style','pushbutton',...
            'ToolTip','Skip batch effect correction');
        % button for abamdon all modifications
        uicontrol('Parent',normwin, ...
            'BackgroundColor',bgcolor, ...
            'Units','normalized', ...
            'FontUnits','normalized', ...
            'Callback',{@save_batch_effect_correction_para,-1,hdlrec,hdlpara,tbl_normal,ed_reg_span}, ...
            'Position',[0.7 0.02 0.2 0.06],...
            'String','Cancel', ...
            'Style','pushbutton',...
            'ToolTip','Abort the quantitation process');
    else % the batch effect correction function is called for rerun 
        % button for starting batch effect correction
        uicontrol('Parent',normwin, ...
            'BackgroundColor',bgcolor, ...
            'Units','normalized', ...
            'FontUnits','normalized', ...
            'Callback',{@save_batch_effect_correction_para,1,hdlrec,hdlpara,tbl_normal,ed_reg_span}, ...
            'Position',[0.1 0.02 0.2 0.06],...
            'String','Ok', ...
            'Style','pushbutton',...
            'ToolTip','Start batch effect correction');
        % button for abamdon all modifications
        uicontrol('Parent',normwin, ...
            'BackgroundColor',bgcolor, ...
            'Units','normalized', ...
            'FontUnits','normalized', ...
            'Callback',{@save_batch_effect_correction_para,-1,hdlrec,hdlpara,tbl_normal,ed_reg_span}, ...
            'Position',[0.7 0.02 0.2 0.06],...
            'String','Cancel', ...
            'Style','pushbutton',...
            'ToolTip','Abort the quantitation process');
    end
    filelist=get(findobj('Tag','list_file'),'String'); % get the file lis
    fileno=length(filelist);
    sampname=cell(fileno,1);
    checkbox=cell(fileno,1);
    ratiobox=cell(fileno,1);
    batchend=cell(fileno,1);
    batchvalue=cell(fileno,1);
    for i=1:fileno
        [~,sampname{i},~] = fileparts(filelist{i});
        checkbox{i}=rec{i}.batch_QC;
        ratiobox{i}=rec{i}.batch_ref;
        batchend{i}=rec{i}.batch_end;
        batchvalue{i}=rec{i}.batch_no;
    end
    tbl_normal.Data=[checkbox ratiobox batchend batchvalue sampname];
end
% ------------------------------------------------------------
% save batch effect correction paramaters
% ------------------------------------------------------------
function save_batch_effect_correction_para(~,~,yn,hdlrec,hdlpara,tbl_normal,ed_reg_span)
    rec=hdlrec.UserData;
    para=hdlpara.UserData;
    set(findobj('Tag','cb_normal'),'UserData',1);
    if yn==0 % no batch effect correction will be performed
        answer=questdlg('Do you really want to bypass the batch effect correction process?',...
            'Question','Yes','No','No');
        if strcmpi(answer,'yes') % the user deside to bypass normalization
            set(findobj('Tag','cb_normal'),'Value',0); % uncheck the normalization option
            para.normal=0;
        else
            return;
        end
    elseif yn==-1 % The quantitation process is terminated
        set(findobj('Tag','cb_normal'),'UserData',-1); % notice to abort the quantitation
    else% batch effect correction will be performed
        % check for the selected QC file names
        tbldata=tbl_normal.Data;
        selid=cell2mat(tbldata(:,1)); % extract the QC checkbox data in the table
        batchnum=cell2mat(tbldata(:,4)); % extract the batch number in the table
        QCbatchnum=batchnum(selid);
        numdiff=QCbatchnum(2:end)-QCbatchnum(1:end-1); % number differences of the QC batch number
        % check 
        if ~any(selid) % no sample was selected
            errordlg('No sample file was selected as QC samples.','Selection Error','modal');
            return;
        elseif all(selid) % all samples are selected
            errordlg('All sample files were selected as QC samples. Unselect some of the intermidiant samples','Selection Error','modal');
            return;
        elseif sum(selid)==1 % only one sample was selected
            errordlg('At least two sample files should be selected as QC samples.','Selection Error','modal');
            return;
        elseif ~all(numdiff>=0) % the batch numbers are not in ascending order
            errordlg('The batch numbers should be in ascending order.','Assignment Error','modal');
            return;
        else % compute adjust ratios among sample and the reference
            for i=1:length(rec)
                rec{i}.batch_QC=tbl_normal.Data{i,1};
                rec{i}.batch_ref=tbl_normal.Data{i,2};
                rec{i}.batch_end=tbl_normal.Data{i,3};
                rec{i}.batch_no=tbl_normal.Data{i,4};
            end
            para.lowess_span=max(3,round(str2double(ed_reg_span.String)*sum(selid)));
        end
    end
    % close the window for setting batch effect correction parameters
    close(findobj('Tag','fg_norm'));
    % update parameters
    hdlrec.UserData=rec;
    hdlpara.UserData=para;
end
% ------------------------------------------------------------------------
% Change the batch number of the sameple data
% ------------------------------------------------------------------------
function edit_batch(hobj,event)
    dlen=size(hobj.Data,1);
    jscroll = findjobj(hobj);
    jtable = jscroll.getViewport.getView;%getComponent(0);
    % check batch effect correction parameters
    if event.Indices(2) == 3 % change the batch end of the sample data
        % assign batch numbers according to the indicated batch end samples
        useid=find(cell2mat(hobj.Data(:,3))); % get the batch end indices
        oldbatch=hobj.Data(:,4); % record the original number
        batchnum=ones(dlen,1);
        if ~isempty(useid)
            if useid(1)==1
                hobj.Data{1,3}=false;
                errordlg('The first sample cannot be assigned as batch end','Data Assignment Error','modal');
                return
            else
                count=1;
                batchnum(1:useid(1))=1;
            end
            for i=2:length(useid)
                count=count+1;
                batchnum((useid(i-1)+1):useid(i))=count;
            end
            if useid(end) ~= dlen
                batchnum(useid(end)+1:dlen)=count+1;
            else
                batchnum(dlen)=count+1;
            end
        end
        % update the changed batch numbers
        cid=find((cell2mat(oldbatch)-batchnum)~=0);
        for i=1:length(cid)
            jtable.setValueAt(string(batchnum(cid(i))),cid(i)-1,3); % to update this value in cell (cid(i),4)
        end
    elseif event.Indices(2) == 2 % change the reference 
        if hobj.Data{event.Indices(1),1} % if the sample has been selected as a QC
            oldid=find(cell2mat(hobj.Data(:,2)));
            if length(oldid)>1
                remid=setdiff(oldid,event.Indices(1));
                jtable.setValueAt("false",remid-1,1); % to update this value in cell (remid,2)
            end
        else % the sample has NOT been selected as a QC
            errordlg('The file has to be selected as a QC sample.','Selection Error','modal');
            jtable.setValueAt("false",event.Indices(1)-1,1); % to update this value in cell (remid,2)
        end
    end
end
% ------------------------------------------------------------
% perform batch effect correction on the quantitated data
% ------------------------------------------------------------
function batch_effect_correction(hdlrec,hdlmeth,hdlastc,hdlpara,hdlmtx,range)
    rec=hdlrec.UserData;
    method=hdlmeth.UserData;
    para=hdlpara.UserData;
    exp=hdlastc.UserData;
    cmtx=hdlmtx.UserData;
    filenum=length(rec);
    compnum=method.nocomp;
    filestart=range(1);
    fileend=range(2);
    compstart=range(3);
    compend=range(4);
    QCid=false(filenum,1);
    QC_ref=false(filenum,1);
    batch_no=zeros(filenum,1);
    % collect batch information
    for i=1:filenum
        QCid(i)=rec{i}.batch_QC; % whether this is a QC samples
        QC_ref(i)=rec{i}.batch_ref; % whether this is a reference
        batch_no(i)=rec{i}.batch_no; % The batch number
    end    
    % compute the ratios among the compounds in the QC samples
    qcidx=find(QCid); % indices of the QC samples
    QCAbund=cmtx(qcidx,:,1); % the abundances of the QC samples
    % find consecutive qcidx and compute average abundances among them
    D = diff([0,diff(qcidx')==1,0]);
    startidx=qcidx(D>0);
    endidx=qcidx(D<0);
    if length(startidx)~=length(endidx)
        errordlg('The consecutive QC samples cannot be successfully detected. Please consider reassign the QC samples','Batch Correction Error','modal');
        return
    end
    % iteratively replace the consecutive QCs with their median abundances
    for i=1:length(startidx)
        avgabund=median(cmtx(startidx(i):endidx(i),:,1),1,'omitnan');
        i1=find(qcidx==startidx(i));
        i2=find(qcidx==endidx(i));
        qcidx(i1)=floor(median(startidx(i):endidx(i)));
        qcidx((i1+1):i2)=[];
        QCAbund(i1,:)=avgabund;
        QCAbund((i1+1):i2,:)=[];
    end
    abund_adjust_ratio=zeros(filenum,compnum);
    norm_abund=repmat(median(QCAbund,1,'omitnan'),filenum,1); % initialize as median abundance
    for i=compstart:compend % perform batch effect correction for each IS group
        % extract the abundances of the sample data
        SampAbund=cmtx(:,i,1);
        % extract the abundances of the QC sample data
        QCAbund_comp=QCAbund(:,i);
        % construct the lowess regression curve
        keepid=~(isnan(QCAbund_comp) | isinf(QCAbund_comp));
        span=max(3,min(para.lowess_span,sum(keepid)-2));
        try
            yout=mslowess(qcidx(keepid),QCAbund_comp(keepid),'Order',2,'Kernel','tricubic',...
                'Span',span,'RobustIterations',1);
        catch
            errordlg('Not enough QC samples were selected for the LOWESS regression,','Error Running MSLowess','modal');
        end
        % spline curve
        spl=interp1(qcidx(keepid),yout,1:filenum,'spline','extrap')';
        % compute the normalized abundances
        abund_adjust_ratio(:,i)=norm_abund(:,i)./spl;
        norm_abund(:,i)=SampAbund.*abund_adjust_ratio(:,i);
    end    
    % compute the normalized concentrations
    for i=filestart:fileend
        for j=compstart:compend
            EICid=method.EICidx(j,2);
            peaknum=method.EICidx(j,3);
            if para.abs_stc
                ref_abund=1;
                if ~isempty(method.IS) % the compound name of the internal standard is provided
                    ISID=strcmpi(method.indiv_name,method.IS{EICid}); % the internal standard of the j-th compound
                    ref_abund=cmtx(i,ISID,1)*abund_adjust_ratio(i,ISID);
                elseif (method.ISidx~=-1) % the compound index of the internal standard is provided
                    ISIDX=method.ISidx;
                    ref_abund=cmtx(i,ISIDX,1)*abund_adjust_ratio(i,ISIDX);
                end
                [cmtx(i,j,2),~]=find_conc_from_standard_curve(exp,j,cmtx(i,j,1)*abund_adjust_ratio(i,j)/ref_abund);
            elseif para.abs_int
                ISID=strcmpi(method.indiv_name,method.IS{EICid});
                % compute the normalized concentrations
                cmtx(i,j,2)=norm_abund(i,j)./norm_abund(i,ISID)*method.conc(EICid);
            elseif para.rel_quant || para.quantifier_sel
                cmtx(i,j,2)=norm_abund(i,j);
            end
            cmtx(i,j,2)=max(0,cmtx(i,j,2));
            % update normalized concentrations
            rec{i}.concentration{EICid}(peaknum)=cmtx(i,j,2);
            rec{i}.abund_adjust_ratio{EICid}(peaknum)=abund_adjust_ratio(i,j);
        end
    end
    % update the normalization result
    hdlrec.UserData=rec;
end
% ----------------------------------------------------------
% cross check samples and see if peak's RTs are consistence
% and see if undetected coeluted peaks exist and deconvolute
% them if any
% ----------------------------------------------------------
% function cross_sample_check(state,hdlrec,hdlmeth,hdlpara,hdlastc)
%     rec=hdlrec.UserData;
%     method=hdlmeth.UserData;
%     para=hdlpara.UserData;
%     exp=hdlastc.UserData;
%     hdlmtx=findobj('Tag','AX_heat_map');
%     hdlimg=findobj('Tag','im_heatmap');
%     if contains(lower(state),'sample') % the data is a testing sample
%         min_rt_diff=para.min_peak_width/4;
%         min_peak_dist=para.min_peak_dist;
%     else
%         min_rt_diff=method.min_peak_width/4;
%         min_peak_dist=para.min_peak_dist;
%     end
%     filenum=length(rec);
%     abmtx=zeros(filenum,method.nocomp);
%     rtmtx=zeros(filenum,method.nocomp);
%     qtmtx=zeros(filenum,method.nocomp);
%     % extract peak info
%     for i=1:filenum
%         for j=1:method.nocomp % for each compound, check across samples(files)
%             EICid=method.EICidx(j,2);
%             peakid=method.EICidx(j,3);
%             abmtx(i,j)=rec{i}.abundance{EICid}(peakid); % the abundance matrix
%             qtmtx(i,j)=rec{i}.quant_note{EICid}(peakid); % the quantitation quality matrix
%             if any(rec{i}.is_peak{EICid}(:,peakid))
%                 rtmtx(i,j)=rec{i}.data{EICid}(rec{i}.is_peak{EICid}(:,peakid),1); % the RT matrix
%             end
%         end
%     end
%     % Find compounds that are unidentified in few samples and try to
%     % re-examine the compounds in the samples
%     for i=1:method.nocomp % for each compound, check across samples(files)
%         is_detected=(abmtx(:,i)>0); % no abundance
%         is_saturated=(qtmtx(:,i)==3); % not a saturated peak
%         zeroid=find(~is_detected & ~is_saturated); % indices of zero abundances and saturated
%         rt=rtmtx(is_detected,i); % RTs of the ith compound
%         EICid=method.EICidx(i,2);
%         peakid=method.EICidx(i,3);
%         if (length(rt)>=5) && (std(rt)<3e-2) % the RTs are consistent among the detected compound
%             gaussinfo=zeros(filenum-length(zeroid),2);
%             count=1;
%             % construct a regression line to predict Full width at half maximum
%             for j=1:filenum
%                 if ~ismember(j,zeroid)
%                     gaussinfo(count,1)=rec{j}.data{EICid}(rec{j}.is_peak{EICid}(:,peakid),2);
%                     % collect the intensities if the peak is detected
%                     if any(rec{j}.coelute{EICid}(peakid,:)) % the peak is coeluted
%                         wave=rec{j}.decomp{EICid}(:,peakid);
%                     else
%                         uid=rec{j}.is_compound{EICid}(:,peakid);
%                         wave=zeros(size(rec{j}.data{EICid}(:,1)));
%                         wave(uid)=rec{j}.smoothy{EICid}(uid);
%                     end
%                     qid=find(wave>(max(wave)/2));
%                     gaussinfo(count,2)=(rec{j}.data{EICid}(qid(end),1)-rec{j}.data{EICid}(qid(1),1))/2;
%                     count=count+1;
%                 end
%                 p=polyfit(gaussinfo(:,1),gaussinfo(:,2),1); % compute a regression line
%                 if p(1) < 0 % incorrect slope
%                     p=[0 median(gaussinfo(:,2))]; % use a flat line instead
%                 end
%             end
%             for j=1:length(zeroid) 
%                 xdata=rec{zeroid(j)}.data{EICid}(:,1);
%                 ydata=rec{zeroid(j)}.smoothy{EICid};
%                 medianRT=median(rt); % expected RT of the compound
%                 [~,midx]=min(abs(xdata-medianRT));
%                 ymax=ydata(midx);
%                 % find local max around medianRT
%                 [maxv,maxid]=max(ydata(midx-3:midx+3));
%                 if (maxid~=1) && (maxid~=4) && (maxid~=7) % the local max is not on the boundary and not on the midpoint
%                     midx=midx-4+maxid;
%                     medianRT=xdata(midx);
%                     ymax=maxv;
%                 end
%                 if ymax/rec{zeroid(j)}.bg_int{EICid}(midx)>para.sn_ratio % the signal is high enough
%                     % the signal is high enough, but was not detected as a
%                     % peak. It's likely that the peak is coeluted. Find the
%                     % closest detected peak for deconvolution.
%                     LOCS=xdata(rec{zeroid(j)}.pidx{EICid}); % detected compound locations in this sample
%                     [~,sidx]=sort(abs(LOCS-medianRT));
%                     [bd,coelute,~]=peak_tracing(xdata,rec{zeroid(j)}.smoothy{EICid},midx,...
%                         rec{zeroid(j)}.bg_int{EICid},para.sn_ratio,min_rt_diff,min_peak_dist);
%                     for k=1:min(3,length(sidx)) % find the top-3 closest peak and check for coelution
%                         if ((xdata(bd(1))-medianRT)*(xdata(bd(2))-medianRT)<=0) && ... % coelution exists                            
%                             (any(coelute) || ((xdata(bd(1))-LOCS(sidx(k)))*(xdata(bd(2))-LOCS(sidx(k)))<=0))
%                             startid=find(xdata<=max(medianRT-3*polyval(p,ymax),xdata(1)),1,'last');
%                             endid=find(xdata>=min(medianRT+3*polyval(p,ymax),xdata(end)),1,'first'); % deconvoluted peak right boundary
%                             y=ymax*gaussmf(xdata(startid:endid),[polyval(p,ymax) medianRT]); % deconvoluted peak signals
%                             if LOCS(sidx(k)) < medianRT                               
%                                 rec{zeroid(j)}.coelute{EICid}(peakid,:)=[1 0];
%                             else
%                                 rec{zeroid(j)}.coelute{EICid}(peakid,:)=[0 1];
%                             end
%                             % update the corrected peak info
%                             rec{zeroid(j)}.pidx{EICid}(midx)=true;
%                             rec{zeroid(j)}.is_match_std{EICid}(peakid)=true;
%                             rec{zeroid(j)}.is_peak{EICid}(:,peakid)=false(1,length(xdata));
%                             rec{zeroid(j)}.is_peak{EICid}(midx,peakid)=true;
%                             rec{zeroid(j)}.is_compound{EICid}(:,peakid)=false(1,length(xdata));
%                             rec{zeroid(j)}.is_compound{EICid}(bd(1):bd(2),peakid)=true;
%                             rec{zeroid(j)}.bdp{EICid}(peakid,:)=bd;
%                             rec{zeroid(j)}.decomp{EICid}(:,peakid)=zeros(size(xdata));
%                             rec{zeroid(j)}.decomp{EICid}(startid:endid,peakid)=y+rec{zeroid(j)}.bg_int{EICid}(startid:endid);
%                             rec{zeroid(j)}.quant_note{EICid}(peakid)=0;                            
%                             rec{zeroid(j)}.abundance{EICid}(peakid)=trapz(xdata(startid:endid),ydata(startid:endid)-rec{zeroid(j)}.bg_int{EICid}(startid:endid));
%                             exp.used_for_reg(zeroid(j),i)=true;
%                             % update the quantitation result
%                             hdlrec.UserData=rec;
%                             hdlastc.UserData=exp;
%                             % update concentration and heat map
%                             update_concentration_and_heatmap_matrix(zeroid(j),i,EICid,peakid,hdlrec,hdlmeth,hdlpara,hdlastc,hdlmtx,hdlimg);
%                             break;
%                         end % end of checking the undetected peak is coeluted
%                     end % end of checking the 3 closest peaks
%                 end % end of whether the undetected peak has sufficient S/N ratio
%             end % end of iteratively check the undetected peak
%         end % end of if the RTs of a peak across samples are consistent
%     end % end of iteratively check each peak for undetected coelution
% end
% ----------------------------------------
% change the batch effect correction setting
% ----------------------------------------
function change_normalization(hobj,~,hdlpara)
    para=hdlpara.UserData;
    para.normal=hobj.Value;
    hdlpara.UserData=para;
end
% ----------------------------------------------------------------
% select reference sample for modification of quantitation result
% ----------------------------------------------------------------
function ref_select(~,~,hdlrec,hdlmeth,hdlpara,hdlastc,fhdl)
    refselwin=findobj('Tag','ref_select');
    if ~isempty(refselwin), close(refselwin); end
    global bgcolor
    set(0,'units','pixels');  
    % Obtains this pixel information
    screensize = get(0,'screensize');
    screencenter = [floor(screensize(3)/2), floor(screensize(4)/2)];
    % extract file list
    if contains(lower(get(findobj('Tag','PB_quant'),'UserData')),'standard') % quantitation on standard compound data
        filelist=get(hdlastc,'UserData').fname;
    else % quantitation on testing data
        filelist=get(findobj('Tag','list_file'),'String');
    end
    nof=length(filelist); % number of files in the folder
    % extract quantitation result
    rec=hdlrec.UserData;
    total_batch=rec{nof}.batch_no;
    batch_string=cell(total_batch,1);
    batch_file=cell(total_batch,1);
    batch_num=zeros(nof,1);
    for i=1:nof
        batch_num(i)=rec{i}.batch_no;
    end
    for i=1:total_batch
        batch_string{i}=strcat('Batch #',num2str(i));
        batch_file{i}=[{'Not specified'};filelist(batch_num==i)];
    end
    hdlmtx=findobj('Tag','AX_heat_map');
    %------------------------
    % Display main GUI 
    %------------------------
    colnum=ceil(total_batch/20);
    rownum=ceil(total_batch/colnum);
    step_h=min(500,floor(0.95*screensize(3))/colnum);
    step_v=min(40,floor(0.95*screensize(4))/rownum);
    height=rownum*step_v;
    width=colnum*step_h;
    refselwin = figure('Units','pixels', ...
        'Menubar','none',...
        'Name','Reference Sample Selection', ...
        'Color',bgcolor, ...
        'NumberTitle','off', ...
        'Position',[screencenter(1)-width/2-50,screencenter(2)-height/2-80,width+100,height+160], ...
        'Resize','off',...
        'Tag','ref_select');
    % title of the left frame
    uicontrol('Parent',refselwin, ...
        'Units','pixel', ...
        'Fontsize',16, ...
        'FontWeight','Bold', ...
        'BackgroundColor',bgcolor, ...
        'HorizontalAlignment','left',...
        'Position',[50,height+120,width,25],...
        'String','Select a file as a referece for each batch', ...
        'Style','text');
    % table for showing batches and their corresponding references
    width_1=ceil(0.95*(step_h)/3);
    width_2=ceil(1.9*step_h/3);
    for i=1:colnum
        uicontrol('Parent',refselwin, ...
            'Units','pixel', ...
            'Fontsize',16, ...
            'FontWeight','Bold', ...
            'BackgroundColor',bgcolor, ...
            'HorizontalAlignment','left',...
            'Position',[50+(i-1)*step_h,height+85,width_1,25],...
            'String','Batch No.', ...
            'Style','text');
        uicontrol('Parent',refselwin, ...
            'Units','pixel', ...
            'Fontsize',16, ...
            'FontWeight','Bold', ...
            'BackgroundColor',bgcolor, ...
            'HorizontalAlignment','left',...
            'Position',[50+(i-1)*step_h+width_1,height+85,width_2,25],...
            'String','Reference Sample', ...
            'Style','text',...
            'Tag','txt_dirinfo');
        for j=1:rownum
            if ((i-1)*rownum+j) <= total_batch
                uicontrol('Parent',refselwin, ...
                    'Units','pixel', ...
                    'Fontsize',12, ...
                    'FontWeight','Bold', ...
                    'BackgroundColor',bgcolor, ...
                    'HorizontalAlignment','center',...
                    'Position',[50+(i-1)*step_h,40+height-(j-1)*step_v width_1 35],...
                    'String',batch_string{(i-1)*rownum+j}, ...
                    'Style','text');
                uicontrol('Parent',refselwin,...
                    'units','pixel',...
                    'position',[50+(i-1)*step_h+width_1,40+height-(j-1)*step_v width_2 40],...
                    'FontSize',12,...
                    'CallBack',{@check_ref,hdlrec,hdlmeth,hdlastc}, ...
                    'String',batch_file{(i-1)*rownum+j},...
                    'Value',1,...
                    'Style','popupmenu',...
                    'Tag',['cmb_file',num2str((i-1)*rownum+j)]);
            end
        end
    end
    % button for starting batch effect correction
    uicontrol('Parent',refselwin, ...
        'Units','pixel', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@detect_by_ref,hdlrec,hdlmeth,hdlpara,hdlastc,hdlmtx,fhdl}, ...
        'Position',[width/3-20 30 100 40],...
        'String','Ok', ...
        'Style','pushbutton',...
        'ToolTip','Start quantitation modification by reference');
    % button for abamdon all modifications
    uicontrol('Parent',refselwin, ...
        'Units','pixel', ...
        'FontUnits','normalized', ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback','close(gcf)', ...
        'Position',[2*width/3+20 30 100 40],...
        'String','Cancel', ...
        'Style','pushbutton',...
        'ToolTip','Ignore quantitation modification by reference');
end
% ----------------------------------------------------------------
% modification of quantitation result using selected reference
% ----------------------------------------------------------------
function detect_by_ref(~,~,hdlrec,hdlmeth,hdlpara,hdlastc,hdlmtx,fhdl)
    % extract file list
    quant_state=lower(get(findobj('Tag','PB_quant'),'UserData'));
    if contains(quant_state,'standard') % if the progress is to quantitate new testing data
        filelist=get(hdlastc,'UserData').fname;        
    else % the progress is to quantitate standard data(
        filelist=get(findobj('Tag','list_file'),'String');
    end
    nof=length(filelist); % number of files in the folder
    % extract quantitation result
    rec=hdlrec.UserData;
    % extract method info
    method=hdlmeth.UserData;
    % extract parameters
    para=hdlpara.UserData;
    % extract standard curve info
    exp=hdlastc.UserData;
    % extract batch info
    total_batch=rec{nof}.batch_no;
    batch_num=zeros(nof,1);
    for i=1:nof
        batch_num(i)=rec{i}.batch_no;
    end
    batch_ref_filename=cell(total_batch,1);
    batch_file=cell(total_batch,1);
    batch_ref_fileid=zeros(total_batch,1);
    for i=1:total_batch
        hdltemp=findobj('tag',['cmb_file',num2str(i)]);
        batch_file{i}=hdltemp.String;
        batch_ref_filename{i}=batch_file{i}{hdltemp.Value};
        isused=contains(filelist,batch_ref_filename{i});
        if any(isused)
            batch_ref_fileid(i)=find(isused);
        end
    end
    if sum(batch_ref_fileid)==0
        errordlg('At least one reference sample should be assigned.','Reference Assignment Error','modal');
        return
    end
    % close the reference assignment window
    refselwin=findobj('Tag','ref_select');
    if ~isempty(refselwin), close(refselwin); end
    pg_bar=findobj('Tag','pg_bar');
    pg_text=findobj('Tag','pg_text');
    % start quantitation adjustment using reference
    fileid=zeros(1,nof);
    for i=1:nof % for each file
        if ismember(i,batch_ref_fileid),continue;end % the current file is a reference then skip
        for j=1:method.nocomp % for each compound
            EICid=method.EICidx(j,2);
            peakid=method.EICidx(j,3);
%             if i==2 && j == 150
%                 disp('here')
%             end
            tip=rec{i}.data{EICid}(rec{i}.is_peak{EICid}(:,peakid),1);
            is_defined_by_bound=rec{i}.is_defined_by_bound{EICid}(peakid);
            if batch_ref_fileid(rec{i}.batch_no) > 0 % the reference in the batch is assigned
                fileid(i)=batch_ref_fileid(rec{i}.batch_no);
                tip_ref=rec{batch_ref_fileid(rec{i}.batch_no)}.data{EICid}(rec{batch_ref_fileid(rec{i}.batch_no)}.is_peak{EICid}(:,peakid),1);
                is_defined_by_bound_ref=rec{batch_ref_fileid(rec{i}.batch_no)}.is_defined_by_bound{EICid}(peakid);
                abund_ref=rec{batch_ref_fileid(rec{i}.batch_no)}.abundance{EICid}(peakid);
            else % no ref is assigned for the current batch
                % search forward first for reference sample
                for k=(rec{i}.batch_no-1):-1:1
                    if batch_ref_fileid(k) > 0
                        fileid(i)=batch_ref_fileid(k);
                        break;
                    end
                end
                if fileid(i) ==0
                    % search backward for reference sample
                    for k=(rec{i}.batch_no+1):total_batch
                        if batch_ref_fileid(k) > 0
                            fileid(i)=batch_ref_fileid(k);
                            break;
                        end
                    end
                end
                tip_ref=rec{fileid(i)}.data{EICid}(rec{fileid(i)}.is_peak{EICid}(:,peakid),1);
                is_defined_by_bound_ref=rec{fileid(i)}.is_defined_by_bound{EICid}(peakid);
                abund_ref=rec{fileid(i)}.abundance{EICid}(peakid);
            end % end of if batch_ref_fileid(rec{i}.batch_no) > 0
            if abund_ref<=0,continue;end % the reference compound is not quantifiable
            % the peak is close to the reference peak and does not need to be adjusted
            if ~isempty(tip)
                if (abs(tip-tip_ref)<3e-2) && ~is_defined_by_bound && ~is_defined_by_bound_ref
                    continue;
                end 
            end
            LOCS=rec{i}.data{EICid}(rec{i}.pidx{EICid},1);
            % find the closest peak to the peak in the reference sample
            [minRTdiff,midx]=min(abs(LOCS-tip_ref));
            is_close_peak_exist=false;
            if ~isempty(LOCS) 
                if minRTdiff < 1e-2
                    is_close_peak_exist=true;
                end
            end
            is_peak_qualified=false;
            if is_close_peak_exist && ~is_defined_by_bound_ref % A qualified peak exists
                didx=find(rec{i}.data{EICid}(:,1)==LOCS(midx));
                rec=recompute_peak_info(rec,i,j,didx,midx,method,para,exp);
                peakwidth=rec{i}.data{EICid}(rec{i}.bdp{EICid}(peakid,2),1)-rec{i}.data{EICid}(rec{i}.bdp{EICid}(peakid,1),1);
                peakwidth_ref=rec{fileid(i)}.data{EICid}(rec{fileid(i)}.bdp{EICid}(peakid,2),1)-rec{fileid(i)}.data{EICid}(rec{i}.bdp{EICid}(peakid,1),1);
                peakratio=peakwidth/peakwidth_ref;
                if (peakratio >= 0.8) && (peakratio <= 1.25) % the peak width is much smaller than the reference peak
                    is_peak_qualified=true; % use integrated signals in the same RT range of the reference peak
                end
            end
            if ~ is_peak_qualified % No qualified peak exist. Integrate signals in the same RT range of the reference peak
                bdp=rec{fileid(i)}.bdp{EICid}(peakid,:);
                % check whether the max signal is higher than the specified
                % S/N ratio
                maxv=max(rec{i}.data{EICid}(bdp(1):bdp(2),2));
                mid=find(rec{i}.data{EICid}(bdp(1):bdp(2),2)/maxv>0.995);
                rec{i}.is_defined_by_bound{EICid}(peakid)=true;
                if maxv >= para.sn_ratio*rec{i}.bg_int{EICid} % the signals are suficiently high
                    if (length(mid)>3) && (maxv > para.max_int) && (rec{i}.quant_note{EICid}(peakid)~=5)% the signals are saturated
                        rec{i}.quant_note{EICid}(peakid)=3; % saturated signals
                    end
                    % update the peak signals
                    rec{i}.is_compound{EICid}(:,peakid)=false(length(rec{i}.data{EICid}(:,1)),1);
                    rec{i}.is_compound{EICid}(bdp(1):bdp(2),peakid)=true;
                    % update the peak tip
                    [~,pidx]=min(abs(rec{i}.data{EICid}(:,1)-tip_ref));
                    rec{i}.is_peak{EICid}(:,peakid)=false;
                    rec{i}.is_peak{EICid}(pidx,peakid)=true;
                    % update the peak boundaries
                    rec{i}.bdp{EICid}(peakid,:)=bdp;
                    % update the coelute
                    rec{i}.coelute{EICid}(peakid,:)=[false false];
                    % update the decomvoluted peak signal
                    rec{i}.decomp{EICid}(:,peakid)=zeros(size(rec{i}.decomp{EICid},1),1);
                    % update the abundance
                    tempy=rec{i}.data{EICid}(rec{i}.is_compound{EICid}(:,peakid),2)-rec{i}.bg_int{EICid}(rec{i}.is_compound{EICid}(:,peakid));
                    tempx=rec{i}.data{EICid}(rec{i}.is_compound{EICid}(:,peakid),1);
                    sumid=tempy>0;
                    % use trapzoidal reule to compute peak area
                    if rec{i}.quant_note{EICid}(peakid) == 3
                        rec{i}.abundance{EICid}(peakid)=nan;
                    elseif sum(sumid)<2
                        rec{i}.abundance{EICid}(peakid)=0;
                    else
                        rec{i}.abundance{EICid}(peakid)=trapz(tempx(sumid),tempy(sumid));
                    end
                    rec{i}.is_defined_by_bound{EICid}(peakid,:)=true;
                end
            end
            % convert abundances to concentrations based on different experiment types
            if para.abs_int % absolute quantitation via internal standard 
                ISID=strcmpi(method.orig_name,method.IS{EICid});
                rec{i}.conc_org{EICid}(peakid)=max(0,rec{i}.abundance{EICid}(peakid)/rec{i}.abundance{ISID}(1)*method.conc(EICid));
                if isnan(rec{i}.conc_org{EICid}(peakid))
                    rec{i}.quant_note{EICid}(peakid)=5; % int. std. unquantiable
                end
            elseif para.abs_stc % absolute quantitation via standard curve
                exp=hdlastc.UserData; % get the expected compound info
                ref_abund=1;
                if ~isempty(method.IS) % the compound name of the internal standard is provided
                    ISID=strcmpi(method.orig_name,method.IS{EICid}); % the internal standard of the j-th compound
                    ref_abund=rec{i}.abundance{ISID}(1);
                elseif (method.ISidx~=-1) % the compound index of the internal standard is provided
                    ref_abund=rec{i}.abundance{exp.EICidx(method.ISidx,2)}(exp.EICidx(method.ISidx,3));
                end
                if contains(lower(get(findobj('Tag','PB_quant'),'UserData')),'standard') % quantitation on standard compound data
                    rec{i}.conc_org{EICid}(peakid) = exp.conc(i); % set the conentration as expected for now, it will be recomputed in compute_standard_curve
                else % quantitation on testing data
                    [rec{i}.conc_org{EICid}(peakid),flag]=find_conc_from_standard_curve(exp,j,rec{i}.abundance{EICid}(peakid)/ref_abund);
                    if flag || isnan(rec{i}.conc_org{EICid}(peakid))
                        meglist=findobj('Tag','quant_msg');
                        QuantMsg=meglist.String;
                        meglist.String=[QuantMsg;{['Quadratic regression failed for ',exp.indiv_name{j},' in ',filelist{i},' ! Use linear regression instead.']}];
                        if ~get(findobj('Tag','PB_show_msg'),'UserData')
                            show_quantitation_message('','',1,hdlpara);
                        end
                    end
                    if isnan(rec{i}.conc_org{EICid}(peakid))
                        rec{i}.quant_note{EICid}(peakid)=5; % int. std. unquantiable
                    end
                end 
            end
            rec{i}.concentration{EICid}(peakid)=rec{i}.conc_org{EICid}(peakid);
        end
        im=findobj('Tag','im_heatmap');
        try
            draw_quantitation_heat_map(i,hdlrec,hdlmeth,hdlpara,hdlmtx,im);
        catch
            msg=sprintf('Error displaying quantitation result for %s !',filelist{i});
            hdl=errordlg(msg,'Quantitation Result Display Error',struct('WindowStyle','modal','Interpreter','tex'));
            waitfor(hdl);
            return;
        end
        set(pg_bar,'Position',[0.0 0.0 (1.0*i/nof) 1.0],'FaceColor','b')
        set(pg_text,'String',['Reading ',num2str(nof),' files: ',num2str(i),'/',num2str(nof),' (',num2str(100.0*i/nof,'%5.2f'),' %) finished!']);
        pause(0.005);
    end
    set(pg_bar,'Position',[0.0 0.0 0.0 1.0],'FaceColor','b')
    set(pg_text,'String','');
    % update quantitation result
    hdlrec.UserData=rec;
    % get the file/compound that the user selects from the heatmap
    vec=fhdl.UserData;
    fileid=vec(1);
    compoundid=vec(2);
    if para.normal && ...% batch effect correction 
        isempty(findobj('Tag','reg_result'))% not std samples 
        % re-perform batch effect correction
        set(pg_text,'String','Performing batch effect correction...');
        batch_effect_correction(hdlrec,hdlmeth,hdlastc,hdlpara,hdlmtx,[1,nof,1,method.nocomp]);
        set(pg_text,'String','Performing batch effect correction...done!');
    end
    % update the heatmap
    set(pg_text,'String','Updating heatmap...');
    change_heatmap_abundent('','',hdlrec,hdlmeth,hdlpara,hdlmtx);
    set(pg_text,'String','');
    % find undetected peaks through cross-sample inspections
    %cross_sample_check(quant_state,hdlrec,hdlmeth,hdlpara,hdlastc);
    % update EIC plot
    update_plots_in_EIC_window(hdlrec,hdlmeth,hdlpara,hdlastc,findobj('tag','AX_EIC'),fileid,compoundid);
    % update regression curves if std samples are used
    if ~isempty(findobj('Tag','reg_result')) % if the std curves window exist (std samples used)
        update_para.start_file=1;
        update_para.end_file=nof;
        update_para.start_comp=1;
        update_para.end_comp=method.nocomp;
        update_para.fileid=fileid;
        update_para.compid=compoundid;
        update_std_result(update_para,hdlrec,hdlmeth,hdlastc); 
    end
    % allow user to save the result
    set(findobj('Tag','PB_save_result'),'UserData',false,'Enable','on');
end
% ----------------------------------------------------------------
% Update plots in the EIC window
% ----------------------------------------------------------------
function update_plots_in_EIC_window(hdlrec,hdlmeth,hdlpara,hdlastc,axhdl,fileid,compoundid)
    rec=hdlrec.UserData; % get the quantitation reuslt of the current file
    method=hdlmeth.UserData;
    para=hdlpara.UserData; % load parameters
    % extract file list
    if contains(lower(get(findobj('Tag','PB_quant'),'UserData')),'standard') % quantitation on standard compound data
        filelist=get(hdlastc,'UserData').fname;
    else % quantitation on testing data
        filelist=get(findobj('Tag','list_file'),'String');
    end
    % ********************
    % update the EIC plot
    hdl=zeros(7,1);
    hdl(1)=findobj('tag','lc_hdl1'); % location of standard compound(s) in the EIC
    hdl(2)=findobj('tag','lc_hdl2'); % original signal of the EIC 
    hdl(3)=findobj('tag','lc_hdl3'); % smoothed signal of the EIC 
    hdl(4)=findobj('tag','lc_hdl4'); % detected compound(s) in the EIC 
    hdl(5)=findobj('tag','lc_hdl5'); % detected compound tip(s) in the EIC 
    hdl(6)=findobj('tag','lc_hdl6'); % deconvoluted peak
    hdl(7)=findobj('tag','lc_hdl7'); % background intensity
    % convert compound id to EIC id and peak id
    EICid=method.EICidx(method.EICidx(:,1)==compoundid,2);
    peakid=method.EICidx(method.EICidx(:,1)==compoundid,3);
    % draw all the detected peaks
    cid=rec{fileid}.is_compound{EICid}(:,peakid);
    set(hdl(4),'xdata',rec{fileid}.data{EICid}(cid,1),'ydata',rec{fileid}.data{EICid}(cid,2));
    % indicate the compound tips
    tid=rec{fileid}.is_peak{EICid}(:,peakid);
    set(hdl(5),'xdata',rec{fileid}.data{EICid}(tid,1),'ydata',rec{fileid}.data{EICid}(tid,2));
    % update deconvoluted peaks
    tempv=rec{fileid}.decomp{EICid}(:,peakid);
    keepid=tempv>0;
    if sum(keepid)>0
        set(hdl(6),'xdata',rec{fileid}.data{EICid}(keepid,1),'ydata',tempv(keepid),'visible','on');
    else
        set(hdl(6),'xdata',rec{fileid}.data{EICid}(:,1),'ydata',tempv(keepid),'visible','off');
    end
    % update the background intensities
    set(hdl(7),'xdata',rec{fileid}.data{EICid}(:,1),'ydata',rec{fileid}.bg_int{EICid});
    % show legend
    if get(findobj('Tag','cb_show_legend'),'Value')
        if sum(rec{fileid}.decomp{EICid}(:,peakid))>0
            legend(hdl,{'Expected RT','Original Signal','Smoothed Signal','Detected Compound','Peak Tip Location','Deconvoluated Signal','Background Intensity'});
        else
            legend(hdl([1:5,7]),{'Expected RT','Original Signal','Smoothed Signal','Detected Compound','Peak Tip Location','Background Intensity'});
        end
    else
        legend('hide');
    end
    % update title
    generate_title(fileid,EICid,peakid,filelist{fileid},axhdl,hdlrec,hdlmeth,hdlpara);
    % computed the new boundaries of the peak
    peak_org=rec{fileid}.data{EICid}(cid,1);
    peak_dec=rec{fileid}.data{EICid}(rec{fileid}.decomp{EICid}(:,peakid)>0,1);
    if isempty(peak_org)
        lbound=rec{fileid}.data{EICid}(1,1);
        rbound=rec{fileid}.data{EICid}(end,1);
        difx=0;
    else
        if isempty(peak_dec)
            lbound=min(peak_org);
            rbound=max(peak_org);
        else
            lbound=min(min(peak_org),min(peak_dec));
            rbound=max(max(peak_org),max(peak_dec));
        end
        difx=(rbound-lbound)/2;
    end
    % find the left, right, top, bottom boundaries of the peak
    minx=max(rec{fileid}.data{EICid}(1,1),lbound-difx);
    maxx=min(rec{fileid}.data{EICid}(end,1),rbound+difx);
    if ~isempty(cid)
        maxy=max(rec{fileid}.data{EICid}(cid,2));
    else
        maxy=0;
    end
    miny=0;
    if isempty(maxy)
        maxy=miny+1;
    elseif (maxy <= miny) 
        maxy=miny+1;
    end
    % update the bounds of the EIC plot
    cb_show_detail=findobj('Tag','cb_show_detail');
    if cb_show_detail.Value
        axis(axhdl,[minx maxx miny 1.05*maxy]);
    end
    cb_show_detail.UserData=[minx maxx miny 1.05*maxy];
    % update the title of the abundance-concentration plot
    ax_stc=findobj('Tag','AX_std_curve');
    if para.abs_stc || para.abs_int
        title(ax_stc,['\fontsize{12}Concentration = {\color{red}',num2str(rec{fileid}.conc_org{EICid}(peakid),'%.2f'),'}']);
    else
        title(ax_stc,['\fontsize{12}Rel. Abundance = {\color{red}',num2str(rec{fileid}.abundance{EICid}(peakid),'%.2f'),'%}']);
    end
    % update the standard curve if the current data is a testing sample
    if isempty(findobj('Tag','reg_result'))
        update_abundance_concentration_plot_in_EIC(hdlrec,hdlmeth,hdlpara,hdlastc,findobj('Tag','AX_std_curve'),fileid,compoundid);
    end
    % update the plots of neighboring compounds if the 'more>' is pressed
    show_compound_in_nearby_files('','',fileid,compoundid,hdlrec,hdlmeth,'',true);
end
% --------------------------------------------------------------
% check if the selected reference has all quantifiable compounds
% --------------------------------------------------------------
function check_ref(hobj,~,hdlrec,hdlmeth,hdlastc)
    if hobj.Value==1
        return
    end
    % extract file list
    quant_state=get(findobj('Tag','PB_quant'),'UserData');
    if contains(lower(quant_state),'standard') % if the progress is to quantitate new data
        filelist=get(hdlastc,'UserData').fname;
    else % the progress is to quantitate standard data(
        filelist=get(findobj('Tag','list_file'),'String');
    end
    % compute the file ID
    fileid=contains(filelist,hobj.String(hobj.Value));
    % extract quantitation result
    rec=hdlrec.UserData;
    method=hdlmeth.UserData;
    % check whether all compounds in the reference are quantifiable
    is_problemic=false(1,method.nocomp);
    for i=1:method.nocomp
        EICid=method.EICidx(i,2);
        peakid=method.EICidx(i,3);
        if isnan(rec{fileid}.abundance{EICid}(peakid)) || (rec{fileid}.abundance{EICid}(peakid)<=0)
            is_problemic(i)=true;
        end
    end
    if any(is_problemic)
        probnum=sum(is_problemic);
        msgs=[{['The following ',num2str(probnum),' compounds are unquantifiable in this sample!']};method.indiv_name(is_problemic)];
        hdl=warndlg(msgs,'Selection Warning',struct('WindowStyle','modal','Interpreter','tex'));
        waitfor(hdl);
        return
    end
end
% --------------------------------------------------------
% change of deconvolution strategy
% --------------------------------------------------------
function deconvolution_strategy_change(source,~,hdlpara)
    para=hdlpara.UserData;
    chdhdl=source.Children;
    for i=1:length(chdhdl)
        if strcmp(source.Children(i).String,'Auto. deconvolution')
            para.auto_deconv=source.Children(i).Value;
        end
        if strcmp(source.Children(i).String,'Always deconvolution')
            para.always_deconv=source.Children(i).Value;
        end
        if strcmp(source.Children(i).String,'No deconvolution')
            para.no_deconv=source.Children(i).Value;
        end
    end
    hdlpara.UserData=para;
end
% -------------------------------------------------------------------------
% Use the user specified term to identify and mark QC samples in the table
% -------------------------------------------------------------------------
function identify_QC_sample_by_unique_term(~,~,edthdl,tblhdl)
    term=edthdl.String;
    if isempty(term), return; end
    QC_Names=tblhdl.Data(:,5);
    tf=contains(QC_Names,term);
    jscroll = findjobj(tblhdl);
    jtable = jscroll.getViewport.getView;
    for i=1:length(tf)
        jtable.setValueAt(string(tf(i)),i-1,0);
    end
end
% ---------------------------------------------------------------
% Show batch effect correction result when the "Show Batch Effect 
% Correction" button is pressed.
% ---------------------------------------------------------------
function show_batch_effect_correction_result(~,~,hdlrec,hdlmeth,hdlpara,hdlmtx)
    if ~isempty(findobj('Tag','fig_show_norm')), return;end % the window has existed
    rec=hdlrec.UserData;
    method=hdlmeth.UserData;
    para=hdlpara.UserData;
    cmtx=hdlmtx.UserData;
    filenum=length(rec);
    compnum=length(method.indiv_name);
    if para.normal == 0
        warndlg('The batch effect correction was not selected or was skipped and thus no information is available!','No batch effect correction Information','modal');
        return; 
    end % no batch effect correction was performed
    exp_type=3; % set the default experiment type to rel. quant.
    if para.abs_stc % experiment type is absolute quantitation with standard curves
        exp_type=1;
    elseif para.abs_int % experiment type is absolute quantitation with internal standards
        exp_type=2;
    end
    batchinfo.QCid=false(filenum,1);
    batchinfo.batch_no=zeros(filenum,1);
    batchinfo.comp_orig=zeros(filenum,compnum);
    endidx=zeros(filenum,1);
    % collect batch information
    if exp_type == 3 % if the quantitation is focused on relative abundance 
        batchinfo.comp_orig=cmtx(:,:,1);        
    end
    comp_norm=cmtx(:,1,2);
    for i=1:filenum
        batchinfo.QCid(i)=rec{i}.batch_QC; % whether this is a QC samples
        batchinfo.batch_no(i)=rec{i}.batch_no; % The batch number
        endidx(i)=rec{i}.batch_end;
        batchinfo.comp_orig(i,:)=cell2mat(rec{i}.conc_org)';
    end
    comp_orig=batchinfo.comp_orig(:,1);
    bend=find(endidx);
    bid=find(batchinfo.QCid);
    global bgcolor
    fig_norm=figure('Units','normalized', ...
        'Menubar','none',...
        'Name','Batch Effect Correction', ...
        'Color',bgcolor,...
        'NumberTitle','off', ...
        'Position',[0.2 0.2 0.6 0.6], ...
        'Tag','fig_show_norm');
    pl_compare=uipanel('Parent',fig_norm, ...
        'Units','normalized', ...
        'Position',[0.0 1/3 1.0 2/3],...
        'BackgroundColor',bgcolor,...
        'BorderType','line');
    pl_IS_group=uipanel('Parent',fig_norm, ...
        'Units','normalized', ...
        'Position',[0.0 0.0 1.0 1/3],...
        'BackgroundColor',bgcolor,...
        'BorderType','line');
    % standard curve of the compound
    ax1=axes('Parent',pl_compare, ...
        'Units','normalized', ...
        'Fontsize',10, ...
        'NextPlot','add', ...
        'Position',[0.05 0.51 0.93 0.34], ...
        'XColor',[0 0 0], ...
        'YColor',[0 0 0], ...
        'Tag','AX_before_norm');
    ax2=axes('Parent',pl_compare, ...
        'Units','normalized', ...
        'Fontsize',10, ...
        'NextPlot','add', ...
        'Position',[0.05 0.06 0.93 0.34], ...
        'XColor',[0 0 0], ...
        'YColor',[0 0 0], ...
        'Tag','AX_after_norm');
    uicontrol('Parent',pl_compare, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.91 0.15 0.06],...
        'String','Select a compound', ...
        'Style','text');
    pm_comp_name=uicontrol('Parent',pl_compare,...
        'units','normalized',...
        'position',[0.21 0.92 0.34 0.06],...
        'FontSize',12,...
        'Callback',{@change_batch_effect_correction_compound,hdlmtx}, ...
        'String',method.indiv_name,...
        'Value',1,...
        'Style','popupmenu');
    % Take log/resume the origin of the data
    uicontrol('Parent',pl_compare, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@show_log_signals,[ax1,ax2]}, ...
        'Position',[0.57 0.92 0.13 0.06], ...
        'String','Log Transform', ...
        'Style','togglebutton',...
        'Tooltip','Take log/resume the origin of the data');
    % Rerun batch effect correction
    uicontrol('Parent',pl_compare, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',@rerun_batch_effect_correction, ...
        'Position',[0.72 0.92 0.08 0.06], ...
        'String','Rerun', ...
        'Style','pushbutton',...
        'Tooltip','rerun batch effect correction using different settings');
    % show trend across samples in different IS groups
    uicontrol('Parent',pl_compare, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@show_trends_across_samples,fig_norm,pl_compare,pl_IS_group}, ...
        'Position',[0.82 0.92 0.06 0.06], ...
        'String','^ Less', ...
        'Style','togglebutton',...
        'Tooltip','show/hide trends across samples in different IS groups');
    % close the window
    uicontrol('Parent',pl_compare, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback','close(gcf)', ...
        'Position',[0.9 0.92 0.06 0.06], ...
        'String','Close', ...
        'Style','pushbutton',...
        'Tooltip','Close the batch effect correction result window');
    uicontrol('Parent',pl_IS_group, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',bgcolor, ...
        'Position',[0.05 0.89 0.19 0.08],...
        'String','Select an internal standard', ...
        'Style','text');
    IS_names=unique(method.IS);
    isISTD=ismember(method.indiv_name,IS_names);
    pmlist=["All";IS_names];
    ax3=axes('Parent',pl_IS_group, ...
        'Units','normalized', ...
        'Fontsize',10, ...
        'NextPlot','add', ...
        'Position',[0.05 0.1 0.93 0.63], ...
        'XColor',[0 0 0], ...
        'YColor',[0 0 0],...
        'Tag','ax_INST_Trend');
    pm_IS_name=uicontrol('Parent',pl_IS_group,...
        'units','normalized',...
        'position',[0.25 0.9 0.4 0.08],...
        'FontSize',12,...
        'Callback',{@change_IS_compound,ax3}, ...
        'String',pmlist,...
        'Value',1,...
        'Style','popupmenu');
    % Take log/resume the origin of the data
    uicontrol('Parent',pl_IS_group, ...
        'Units','normalized', ...
        'Fontsize',12, ...
        'BackgroundColor',[0.75 0.75 0.75], ...
        'Callback',{@show_log_signals,ax3}, ...
        'Position',[0.74 0.88 0.15 0.1], ...
        'String','Log Transform', ...
        'Style','togglebutton',...
        'Tooltip','Take log/resume the origin of the data');
    dotsize=9;
    y=comp_orig(batchinfo.QCid);
    scatter(ax1,1:length(comp_orig),comp_orig,dotsize,[0.75,0.75,0.75],'filled','Tag','comp_org_k');
    scatter(ax1,bid,y,dotsize+5,'red','filled','Tag','comp_org_r');
    p=polyfit(bid,y,1);
    yfit = polyval(p,bid);
    SSresid = sum((y - yfit).^2);
    SStotal = (length(y)-1) * var(y);
    rsq_adj = 1 - SSresid/SStotal * (length(y)-1)/(length(y)-length(p));
    line(ax1,bid,yfit,'color','g','linewidth',3,'Tag','reg_org');
    axis(ax1,[0 length(comp_orig)+1 0 inf]);
    line(ax1,[bend bend],[1e-3 max(comp_orig)],'color','k','Tag','batch_div_1');
    title(ax1,['Concentrations across samples before batch effect correction. Regression line: ',...
        sprintf('y = %.4f * x + %.2f', p(1), p(2)),', R^2=',num2str(rsq_adj,'%5.3f')],...
        'VerticalAlignment','baseline','FontSize',14);
    y=comp_norm(batchinfo.QCid);
    scatter(ax2,1:length(comp_norm),comp_norm,dotsize,[0.75,0.75,0.75],'filled','Tag','comp_norm_k');
    scatter(ax2,bid,y,dotsize+5,'red','filled','Tag','comp_norm_r');
    p=polyfit(bid,y,1);
    yfit = polyval(p,bid);
    SSresid = sum((y - yfit).^2);
    SStotal = (length(y)-1) * var(y);
    rsq_adj = 1 - SSresid/SStotal * (length(y)-1)/(length(y)-length(p));
    line(ax2,bid,yfit,'color','g','linewidth',3,'Tag','reg_norm')
    axis(ax2,[0 length(comp_norm)+1 0 inf]);
    line(ax2,[bend bend],[1e-3 max(comp_norm)],'color','k','Tag','batch_div_2');
    title(ax2,['Concentrations across samples after batch effect correction. Regression line: ',...
        sprintf('y = %.4f * x + %.2f', p(1), p(2)),', R^2=',num2str(rsq_adj,'%5.3f')],...
        'VerticalAlignment','baseline','FontSize',15);
    ISTDid=find(isISTD);
    IS.ISdata=zeros(filenum,length(ISTDid));
    IS.name=method.indiv_name(ISTDid);
    for i=1:length(ISTDid)
        tf=ismember(method.IS,IS.name{i});
        IS.ISdata(:,i)=median(cmtx(:,tf,1)./repmat(cmtx(:,ISTDid(i),1),1,sum(tf)),2,"omitnan");
    end
    plot(ax3,IS.ISdata,'Marker','+');
    legend(ax3,IS.name);
    axis(ax3,[0 length(comp_norm)+1 0 inf]);
    title(ax3,'Concentration trend across samples in different IS groups',...
        'VerticalAlignment','baseline','FontSize',15);
    pm_comp_name.UserData=batchinfo;
    pm_IS_name.UserData=IS;
end
% ---------------------------------------------------------------
% Show batch effect correction result when user select a new compound
% ---------------------------------------------------------------
function change_batch_effect_correction_compound(hobj,~,hdlmtx)
    compid=hobj.Value;
    batchinfo=hobj.UserData;
    cmtx=hdlmtx.UserData;
    bid=find(batchinfo.QCid);
    comp_orig=batchinfo.comp_orig(:,compid);
    comp_norm=cmtx(:,compid,2);
    ax1=findobj('Tag','AX_before_norm');
    ax2=findobj('Tag','AX_after_norm');
    set(findobj('Tag','comp_org_k'),'YData',comp_orig);
    set(findobj('Tag','comp_org_r'),'YData',comp_orig(bid));
    set(findobj('Tag','batch_div_1'),'YData',[1e-3 max(comp_orig)]);
    y=comp_orig(bid);
    p=polyfit(bid,y,1);
    yfit = polyval(p,bid);
    SSresid = sum((y - yfit).^2);
    SStotal = (length(y)-1) * var(y);
    rsq = 1 - SSresid/SStotal;
    set(findobj('Tag','reg_org'),'YData',yfit);
    title(ax1,['Concentrations across samples before batch effect correction. Regression line: ',...
        sprintf('y = %.4f * x + %.2f', p(1), p(2)),', R^2=',num2str(rsq,'%5.3e')],'FontSize',15);
    set(findobj('Tag','comp_norm_k'),'YData',comp_norm);
    set(findobj('Tag','comp_norm_r'),'YData',comp_norm(bid));
    set(findobj('Tag','batch_div_2'),'YData',[1e-3 max(comp_norm)]);
    y=comp_norm(bid);
    p=polyfit(bid,y,1);
    yfit = polyval(p,bid);
    SSresid = sum((y - yfit).^2);
    SStotal = (length(y)-1) * var(y);
    rsq = 1 - SSresid/SStotal;
    set(findobj('tag','reg_norm'),'YData',yfit);
    title(ax2,['Concentrations across samples after batch effect correction. Regression line: ',...
        sprintf('y = %.4f * x + %.2f', p(1), p(2)),', R^2=',num2str(rsq,'%5.3e')],'FontSize',15);
end
% -------------------------------------------------------------
% show trend across samples in different IS groups
% -------------------------------------------------------------
function show_trends_across_samples(hobj,~,fig_norm,pl_compare,pl_IS_group)
    if strcmpi(hobj.String,'^ Less')
        hobj.String='v More';
        set(fig_norm,'Position',[0.2 0.4 0.6 0.4]);
        % panel displaying the information of the current compound
        set(pl_compare,'Position',[0.0 0.0 1.0 1.0]);
        set(pl_IS_group,'Position',[0.0 0.0 1.0 0.0]);
    else
        hobj.String='^ Less';
        set(fig_norm,'Position',[0.2 0.2 0.6 0.6]);
        % panel displaying the information of the current compound
        set(pl_compare,'Position',[0.0 1/3 1.0 2/3]);
        set(pl_IS_group,'Position',[0.0 0.0 1.0 1/3]);
    end
end
% ------------------------------------------------
% change IS compound shown in the window
% ------------------------------------------------
function change_IS_compound(hobj,~,hdlax)
    selid=hobj.Value;
    IS=hobj.UserData;
    if selid == 1
        plot(hdlax,IS.ISdata);
        legend(hdlax,IS.name);
    else
        cla(hdlax)
        plot(hdlax,IS.ISdata(:,selid-1));
        legend(hdlax,IS.name{selid-1});
    end
end
% ------------------------------------------------
% take log/resume origin of the data
% ------------------------------------------------
function show_log_signals(hobj,~,hdlax)
    if hobj.Value == 1
        hobj.String = 'Resume';
        set(hdlax,'YScale','log');
    else
        hobj.String = 'Log Transform';
        set(hdlax,'YScale','linear');
    end
end
% ----------------------------------------------
% rerun batch effect correction
% ---------------------------------------------
function rerun_batch_effect_correction(~,~)
    hdlrec=findobj('Tag','MRM_Quant');
    hdlmeth=findobj('Tag','pl_comp');
    hdlpara=findobj('Tag','pl_para');
    hdlastc=findobj('Tag','rb_abs_stc');
    hdlmtx=findobj('Tag','AX_heat_map');
    [filenum,compnum,~]=size(hdlmtx.UserData);
    pg_text=findobj('Tag','pg_text');
    close(findobj('Tag','fig_show_norm'));
    batch_effect_correction_para(hdlrec,hdlpara,1);
    waitfor(findobj('tag','fg_norm'));
    if (get(findobj('Tag','cb_normal'),'UserData')==-1) % the user determine to abandon the correction
        return
    end
    set(pg_text,'String','Performing batch effect correction...');
    batch_effect_correction(hdlrec,hdlmeth,hdlastc,hdlpara,hdlmtx,[1,filenum,1,compnum]);
    set(pg_text,'String','Performing batch effect correction...done!');
    set(pg_text,'String','Updating heatmap...');
    change_heatmap_abundent('','',hdlrec,hdlmeth,hdlpara,hdlmtx);
    set(pg_text,'String','');
    set(findobj('Tag','PB_save_result'),'Enable','on');
    save_quantitation_result('','',hdlrec,hdlmeth,hdlastc,hdlpara);
end
% -------------------------------------------------------------------------
% compute abundance ratio between fragments of a compound
% -------------------------------------------------------------------------
function fig_peak_ratio=compute_ion_ratio(hdlmeth,hdlmtx)
    global bgcolor
    method=hdlmeth.UserData;
    cmtx=hdlmtx.UserData;
    [uniq_mz,iu,imember]=unique(method.mz); % find the unique compounds and their fragments
    noc=length(uniq_mz);
    ratio_info=cell(noc,1);
    maxlen=0;
    rt=cell(noc,1);
    frag=cell(noc,1);
    max_frag=cell(noc,1);
    for i=1:noc
        abund_comp=cmtx(:,imember==i); % extract the abundances of the compound fragments
        fragments=method.dmz(imember==i)';
        tempstr=sprintf('%.4f,',fragments);
        frag{i}=tempstr(1:end-1);
        avg_abund_comp=mean(abund_comp,1,"omitnan"); % compute the average abundance of the compound fragments
        [~,maxid]=max(avg_abund_comp); % find the most abundant peak of the compound
        max_frag{i}=num2str(fragments(maxid));
        ratio=abund_comp./repmat(abund_comp(:,maxid),1,size(abund_comp,2)); % compute the abundance ratios to the most abundant fragment
        ratio_mean=mean(ratio,1,"omitnan");
        ratio_std=std(ratio,0,1,"omitnan");
        ratio_info{i}=cellfun(@(x,y)strcat(x,'+/-',y),cellstr(string(ratio_mean)),cellstr(string(ratio_std)),'UniformOutput',false);
        rt{i}=num2str(method.rt{i}(1));
        maxlen=max(maxlen,length(fragments));
    end
    ratio_table=cell(noc,maxlen);
    rationame=cell(1,maxlen);
    for i=1:maxlen
        rationame{i}=['Abund. Ratio Ion',num2str(i),'/Max. Ion'];
    end
    for i=1:noc
        for j=1:length(ratio_info{i})
            ratio_table(i,j)=ratio_info{i}(j);
        end
    end
    tdata=[method.indiv_name(iu),rt,cellstr(string(method.mz(iu))),frag,max_frag,ratio_table];
    fig_peak_ratio=findobj('tag','fg_fragment_ratio');
    if isempty(fig_peak_ratio)
        cnames=[{'Compound Name'},{'RT'},{'Precursor'},{'Product Ions'},{'Max. Ion'},rationame];
        fig_peak_ratio=figure('Color',bgcolor,...
            'NumberTitle','off', ...
            'Units','normalized', ...
            'Menubar','none',...
            'Position',[0.2 0.25 0.6 0.5],...
            'Tag','fg_fragment_ratio'); % Open a new figure for a EIC plot
        tblhdl=uitable('Parent',fig_peak_ratio,...
            'Units','normalized',...
            'Position',[0.02 0.1 0.96 0.88],...
            'ColumnName',cnames,...
            'Data',tdata,...
            'FontSize',12,...
            'Tag','tbl_comp_ratio');
        % button to close the inspection
        uicontrol('Parent',fig_peak_ratio, ...
            'Units','normalized', ...
            'FontUnits','normalized', ...
            'BackgroundColor',[0.75 0.75 0.75], ...
            'Callback',{@hide_figure,fig_peak_ratio}, ...
            'Position',[0.45 0.02 0.1 0.06], ...
            'String','Close');
    else
        tblhdl=findobj('Tag','tbl_comp_ratio');
        tblhdl.Data=tdata;
        fig_peak_ratio.Visible='on';
    end
    tbl=cell2table(tblhdl.Data);
    tbl.Properties.VariableNames=tblhdl.ColumnName;
    set(findobj('tag','rb_quantifier_sel'),'UserData',tbl);
end
function show_quantifier_ratio(~,~)
    set(findobj('Tag','fg_fragment_ratio'),'visible','on');
end