function ss_create_html_report(list_qc_json,out_table_csv,out_main_path,BIDS_in)

% define tranformation matrix
transform.axial     = [1 0 0 0 ; 0 1 0 0 ;  0 0 1 0 ; 0 0 0 1 ];
transform.coronal   = [1 0 0 0 ; 0 0 1 0 ;  0 1 0 0 ; 0 0 0 1 ];
transform.sagittal  = [0 -1 0 0 ; 0 0 1 0 ;  1 0 0 0 ; 0 0 0 1 ];

out_main_path = fullfile(out_main_path);
if ~exist(out_main_path,'dir');mkdir(qc_html);end


% out folder images
out_fold_img = fullfile(out_main_path,'out_fold_img');
if ~exist(out_fold_img,'dir'); mkdir(out_fold_img);end

% out folder html
out_fold_html = fullfile(out_main_path,'output_html');
if ~exist(out_fold_html,'dir');mkdir(out_fold_html);end

clear tmp_basename;
% get the MTw name
tmp_basename = spm_file(list_qc_json,'basename');
% remove the extra part
tmp_basename(strfind(tmp_basename,'PDw_echo-'):end)=[];
    

% get subject name COF subj name ; TO DO BIDS naming should take care of
% subj_name_visit = list_qc_json(strfind(list_qc_json,'COF'):strfind(list_qc_json,'COF')+5)  ;
subj_name_visit = tmp_basename;
fprintf('running : %s \n',subj_name_visit); % for qsub
    
% MPMs
% TO DO define Results path and check it validity

img.MTw_OLSfit  = spm_select('FPList',spm_file(list_qc_json,'path'),'.*MTw_OLSfit_TEzero.nii');
img.PDw_OLSfit  = spm_select('FPList',spm_file(list_qc_json,'path'),'.*PDw_OLSfit_TEzero.nii');

img.B1map       =  spm_select('FPList',spm_file(list_qc_json,'path'),'.*B1map.nii');

img.MPM_MTsat   = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'path'),'.*_MTsat.nii');
img.MPM_PD      = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'path'),'.*_PD.nii');
img.MPM_R1      = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'path'),'.*_R1.nii');
img.MPM_R2s_OLS = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'path'),'.*_R2s_OLS.nii');

% c1;c2;c3

c_seg{1} = spm_select('FPList',spm_file(spm_file(spm_file(list_qc_json,'path'),'path'),'filename','segment_TEzero'),'^c1.*.nii');
c_seg{2} = spm_select('FPList',spm_file(spm_file(spm_file(list_qc_json,'path'),'path'),'filename','segment_TEzero'),'^c2.*.nii');
c_seg{3} = spm_select('FPList',spm_file(spm_file(spm_file(list_qc_json,'path'),'path'),'filename','segment_TEzero'),'^c3.*.nii');


% get input images 

reor_in = fullfile(spm_file(spm_file(spm_file(spm_file(list_qc_json,'path'),'path'),'path'),'path'),'Reoriented');

img.in.MTw = spm_select('FPListrec',reor_in,['^' tmp_basename 'MTw.*.nii$']);
img.in.PDw = spm_select('FPListrec',reor_in,['^' tmp_basename 'PDw.*.nii$']);
img.in.T1w = spm_select('FPListrec',reor_in,['^' tmp_basename 'T1w.*.nii$']);

img.MNI.MTw = spm_select('FPList',fullfile(spm_file(spm_file(spm_file(list_qc_json,'path'),'path'),'path'),'Results_USnorm'),'^w.*_MTsat.nii');
img.MNI.PD = spm_select('FPList',fullfile(spm_file(spm_file(spm_file(list_qc_json,'path'),'path'),'path'),'Results_USnorm'),'^w.*RFSC_PD.nii');
img.MNI.R1 = spm_select('FPList',fullfile(spm_file(spm_file(spm_file(list_qc_json,'path'),'path'),'path'),'Results_USnorm'),'^w.*RFSC_R1.nii');
img.MNI.R2s = spm_select('FPList',fullfile(spm_file(spm_file(spm_file(list_qc_json,'path'),'path'),'path'),'Results_USnorm'),'^w.*_RFSC_R2s_OLS.nii');



% =====================================================================
% generating png images startes here  
    
% get the axial range 
[lim.axial,lim.sagittal,lim.coronal] = lim_slices_MPM(c_seg);
% ----------------------------------------------------------------------

% plot MTw_OLSfit_axial axial structural
                           
plot_info.suffix        = 'MTw_OLSfit_axial';
plot_info.sl_def        = [-90 1 89;-127 1 128];
plot_info.transform     = transform.axial;
plot_info.xslices       = 1;
plot_info.slices        = linspace(lim.axial(1)+40,lim.axial(2)-20,40);
%     plot_info.fig_Position  = [172   605   186   263];
plot_info.fig_Position  = [2348 578 202 285];
plot_info.fig_cmap      = 'gray';
plot_info.range         = [0 1000];
plot_info.T1            = img.MTw_OLSfit;
plot_info.out_fold_img  = out_fold_img;
plot_info.subj_name_vst = subj_name_visit;
    
out.MTw_OLSfit_axial_png_folder = plot_Single_image(plot_info);

% ----------------------------------------------------------------------

% plot PDw_OLSfit axial structural
                           
plot_info.suffix        = 'PDw_OLSfit_axial';
plot_info.sl_def        = [-90 1 89;-127 1 128];
plot_info.transform     = transform.axial;
plot_info.xslices       = 1;
plot_info.slices        = linspace(lim.axial(1)+40,lim.axial(2)-20,40);
%     plot_info.fig_Position  = [172   605   186   263];
plot_info.fig_Position  = [2348 578 202 285];
plot_info.fig_cmap      = 'gray';
plot_info.range         = [0 2000];
plot_info.T1            = img.PDw_OLSfit;
plot_info.out_fold_img  = out_fold_img;
plot_info.subj_name_vst = subj_name_visit;
    
out.PDw_OLSfit_axial_png_folder = plot_Single_image(plot_info);
% ----------------------------------------------------------------------


% plot segmetation c1 c2 c3 on T1

plot_seg.suffix         = 'MTwOLS_overlay';
plot_seg.sl_def        = [-90 1 89;-127 1 128];
plot_seg.subj_name_vis  = subj_name_visit;
plot_seg.transform      = transform.axial;
plot_seg.t_prop         = 0.8;
plot_seg.c_prop         = 0.5;
plot_seg.xslices        = 1;
plot_seg.slices         = linspace(lim.axial(1)+40,lim.axial(2)-20,40);
plot_seg.fig_Position   = [2348 578 202 285];
plot_seg.cmap2          = 'red';
plot_seg.cmap3          = 'blue';
plot_seg.cmap4          = 'green';
plot_seg.T1range        = [0 1000];
plot_seg.T1             = img.MTw_OLSfit;
plot_seg.c_seg          = c_seg;
plot_seg.out_fold       = out_fold_img;
plot_seg.subj_name_vst = subj_name_visit;

%  plot c1 c2 c3
%     [out_t1_c1_folder, out_t1_c2_folder, out_t1_c3_folder] = create_contour_seg_v2(img_T1,c_seg,plot_seg,out_fold_img);
[out.MTwOLS_c1_folder, out.MTwOLS_c2_folder, ~] = create_contour_seg(plot_seg);


%----------------------------------------------------------------------
% plot MPM_MTsat axial structural
                           
plot_info.suffix        = 'MTsat_axial';
plot_info.sl_def        = [-90 1 89;-127 1 128];
plot_info.transform     = transform.axial;
plot_info.xslices       = 1;
plot_info.slices        = linspace(lim.axial(1)+40,lim.axial(2)-20,40);
%     plot_info.fig_Position  = [172   605   186   263];
plot_info.fig_Position  = [2348 578 202 285];
plot_info.fig_cmap      = 'gray';
plot_info.range         = [0 2];
plot_info.T1            = img.MPM_MTsat;
plot_info.out_fold_img  = out_fold_img;
plot_info.subj_name_vst = subj_name_visit;
    
out.MTsat_axial_png_folder = plot_Single_image(plot_info);

% ----------------------------------------------------------------------

% plot MPM_PD axial structural
                           
plot_info.suffix        = 'MPM_PD_axial';
plot_info.sl_def        = [-90 1 89;-127 1 128];
plot_info.transform     = transform.axial;
plot_info.xslices       = 1;
plot_info.slices        = linspace(lim.axial(1)+40,lim.axial(2)-20,40);
%     plot_info.fig_Position  = [172   605   186   263];
plot_info.fig_Position  = [2348 578 202 285];
plot_info.fig_cmap      = 'gray';
plot_info.range         = [30 100];
plot_info.T1            = img.MPM_PD;
plot_info.out_fold_img  = out_fold_img;
plot_info.subj_name_vst = subj_name_visit;
    
out.MPM_PD_axial_png_folder = plot_Single_image(plot_info);

% ----------------------------------------------------------------------

% plot MPM_R1 axial structural
                           
plot_info.suffix        = 'MPM_R1_axial';
plot_info.sl_def        = [-90 1 89;-127 1 128];
plot_info.transform     = transform.axial;
plot_info.xslices       = 1;
plot_info.slices        = linspace(lim.axial(1)+40,lim.axial(2)-20,40);
%     plot_info.fig_Position  = [172   605   186   263];
plot_info.fig_Position  = [2348 578 202 285];
plot_info.fig_cmap      = 'gray';
plot_info.range         = [0.2 1.4];
plot_info.T1            = img.MPM_R1;
plot_info.out_fold_img  = out_fold_img;
plot_info.subj_name_vst = subj_name_visit;
    
out.MPM_R1_axial_png_folder = plot_Single_image(plot_info);

% ----------------------------------------------------------------------

% plot MPM_R2s_OLS axial structural
                           
plot_info.suffix        = 'MPM_R2s_OLS_axial';
plot_info.sl_def        = [-90 1 89;-127 1 128];
plot_info.transform     = transform.axial;
plot_info.xslices       = 1;
plot_info.slices        = linspace(lim.axial(1)+40,lim.axial(2)-20,40);
%     plot_info.fig_Position  = [172   605   186   263];
plot_info.fig_Position  = [2348 578 202 285];
plot_info.fig_cmap      = 'gray';
plot_info.range         = [0 80];
plot_info.T1            = img.MPM_R2s_OLS;
plot_info.out_fold_img  = out_fold_img;
plot_info.subj_name_vst = subj_name_visit;
    
out.MPM_R2s_OLS_axial_png_folder = plot_Single_image(plot_info);

% ----------------------------------------------------------------------

% plot B1 ref special case
                           
plot_info.suffix        = 'MPM_B1_axial';
plot_info.sl_def        = [-90 1 89;-127 1 128];
plot_info.transform     = transform.axial;
plot_info.xslices       = 1;
plot_info.slices        = linspace(lim.axial(1)+40,lim.axial(2)-20,40);
%     plot_info.fig_Position  = [172   605   186   263];
plot_info.fig_Position  = [2348 578 202 285];
plot_info.fig_cmap      = 'gray';
plot_info.range         = [0 80];
plot_info.T1            = img.MTw_OLSfit;
plot_info.b1            = img.B1map;
plot_info.range         = [0 150];
plot_info.out_fold_img  = out_fold_img;
plot_info.subj_name_vst = subj_name_visit;
    
[out.MPM_B1_axial_png_folder,img.MPM_B1_axial_reslice] = plot_Single_image_b1(plot_info);

% ----------------------------------------------------------------------


% GIF 

% plot gif

% set gif delay in sec

plot_gif.transform      = transform;
plot_gif.subj_name_vis  = subj_name_visit;
% plot_gif.sl_def.Axial   = [-90 1 89;-127 1 128];
plot_gif.sl_def.Sagit   = [-127 1 128;-127 1 128];
% plot_gif.sl_def.Coron   = [-90 1 89;-127 1 128];
plot_gif.xslices        = 1;
plot_gif.lim            = lim ;   

%     plot_gif.fig_Position  = [155   503   970   175];
plot_gif.fig_Position   = [2013 464 193 274];
plot_gif.num_frames     = 4;
plot_gif.num_of_image   = 9;
plot_gif.img            = img;
plot_gif.out_fold_img   = out_fold_img;

plot_gif.delay.begin    = 1.50;
plot_gif.delay.mid      = 0.20;
plot_gif.delay.end      = 1.50;


% plot c1 gif
plot_gif.suffix         = 'all_gif';
% plot_gif.cmap2          = 'red';
% plot_gif.img_2          = c_seg{1};

% out_t1_c1_gif = create_gif_norm(plot_gif);

% -------------------------------------------------------------------------
% INPUTS 

% plot MTw_echos axial structural

for k=1:size(img.in.MTw,1)
        
    tmp_img = strtrim(img.in.MTw(k,1:end));
    
    tmp_suff = ['MTw_' sprintf('%s_%02d','echo',k) '_axial'];
    
    plot_info.suffix        = tmp_suff ;
    plot_info.sl_def        = [-90 1 89;-127 1 128];
    plot_info.transform     = transform.axial;
    plot_info.xslices       = 1;
    plot_info.slices        = linspace(lim.axial(1)+40,lim.axial(2)-20,10);
    %     plot_info.fig_Position  = [172   605   186   263];
    plot_info.fig_Position  = [2348 578 202 285];
    plot_info.fig_cmap      = 'gray';
    plot_info.range         = [0 1000];
    plot_info.T1            = tmp_img;
    plot_info.out_fold_img  = out_fold_img;
    plot_info.subj_name_vst = subj_name_visit;

    out.in_MTw.axial{k,1} = plot_Single_image(plot_info);
    out.in_MTw.axial{k,2} = tmp_img;
    
end
                           
% plot PDw_echos axial structural

for k=1:size(img.in.PDw,1)
        
    tmp_img = strtrim(img.in.PDw(k,1:end));
    
    tmp_suff = ['PDw_' sprintf('%s_%02d','echo',k) '_axial'];
    
    plot_info.suffix        = tmp_suff ;
    plot_info.sl_def        = [-90 1 89;-127 1 128];
    plot_info.transform     = transform.axial;
    plot_info.xslices       = 1;
    plot_info.slices        = linspace(lim.axial(1)+40,lim.axial(2)-20,10);
    %     plot_info.fig_Position  = [172   605   186   263];
    plot_info.fig_Position  = [2348 578 202 285];
    plot_info.fig_cmap      = 'gray';
    plot_info.range         = [0 1000];
    plot_info.T1            = tmp_img;
    plot_info.out_fold_img  = out_fold_img;
    plot_info.subj_name_vst = subj_name_visit;

    out.in_PDw.axial{k,1} = plot_Single_image(plot_info);
    out.in_PDw.axial{k,2} = tmp_img;
    
end

% plot T1w_echos axial structural

for k=1:size(img.in.T1w,1)
        
    tmp_img = strtrim(img.in.T1w(k,1:end));
    
    tmp_suff = ['T1w_' sprintf('%s_%02d','echo',k) '_axial'];
    
    plot_info.suffix        = tmp_suff ;
    plot_info.sl_def        = [-90 1 89;-127 1 128];
    plot_info.transform     = transform.axial;
    plot_info.xslices       = 1;
    plot_info.slices        = linspace(lim.axial(1)+40,lim.axial(2)-20,10);
    %     plot_info.fig_Position  = [172   605   186   263];
    plot_info.fig_Position  = [2348 578 202 285];
    plot_info.fig_cmap      = 'gray';
    plot_info.range         = [0 1000];
    plot_info.T1            = tmp_img;
    plot_info.out_fold_img  = out_fold_img;
    plot_info.subj_name_vst = subj_name_visit;

    out.in_T1w.axial{k,1} = plot_Single_image(plot_info);
    out.in_T1w.axial{k,2} = tmp_img;
    
end

%--------------------------------------------------------------------------
% ----------------------------------------------------------------------

% testing 
% GIF Echos 

% plot gif

% set gif delay in sec

plot_info_gif.suffix        = 'MTw_echo_gif_axial';
plot_info_gif.sl_def        = [-90 1 89;-127 1 128];
plot_info_gif.transform     = transform.axial;
plot_info_gif.xslices       = 1;
plot_info_gif.slices        = linspace(lim.axial(1)+40,lim.axial(2)-20,40);
%     plot_info.fig_Position  = [172   605   186   263];
plot_info_gif.fig_Position  = [2348 578 202 285];
plot_info_gif.fig_cmap      = 'gray';
plot_info_gif.range         = [0 1000];
plot_info_gif.img           = img.in.MTw;
plot_info_gif.out_fold_img  = out_fold_img;
plot_info_gif.subj_name_vst = subj_name_visit;

plot_info_gif.delay.begin    = 1.50;
plot_info_gif.delay.mid      = 0.20; %0.90 old
plot_info_gif.delay.end      = 1.50;


out.MTw_gif_axial = create_gif_echos(plot_info_gif);

%--------------------------------------------------------------------------

% set gif delay in sec

plot_info_gif.suffix        = 'PDw_echo_gif_axial';
plot_info_gif.sl_def        = [-90 1 89;-127 1 128];
plot_info_gif.transform     = transform.axial;
plot_info_gif.xslices       = 1;
plot_info_gif.slices        = linspace(lim.axial(1)+40,lim.axial(2)-20,40);
%     plot_info.fig_Position  = [172   605   186   263];
plot_info_gif.fig_Position  = [2348 578 202 285];
plot_info_gif.fig_cmap      = 'gray';
plot_info_gif.range         = [0 1000];
plot_info_gif.img           = img.in.PDw;
plot_info_gif.out_fold_img  = out_fold_img;
plot_info_gif.subj_name_vst = subj_name_visit;

plot_info_gif.delay.begin    = 1.50;
plot_info_gif.delay.mid      = 0.20;
plot_info_gif.delay.end      = 1.50;


out.PDw_gif_axial = create_gif_echos(plot_info_gif);


%--------------------------------------------------------------------------

% set gif delay in sec

plot_info_gif.suffix        = 'T1w_echo_gif_axial';
plot_info_gif.sl_def        = [-90 1 89;-127 1 128];
plot_info_gif.transform     = transform.axial;
plot_info_gif.xslices       = 1;
plot_info_gif.slices        = linspace(lim.axial(1)+40,lim.axial(2)-20,40);
%     plot_info.fig_Position  = [172   605   186   263];
plot_info_gif.fig_Position  = [2348 578 202 285];
plot_info_gif.fig_cmap      = 'gray';
plot_info_gif.range         = [0 1000];
plot_info_gif.img           = img.in.T1w;
plot_info_gif.out_fold_img  = out_fold_img;
plot_info_gif.subj_name_vst = subj_name_visit;

plot_info_gif.delay.begin    = 1.50;
plot_info_gif.delay.mid      = 0.20;
plot_info_gif.delay.end      = 1.50;


out.T1w_gif_axial = create_gif_echos(plot_info_gif);
%==========================================================================
% MNI 
% set gif delay in sec

plot_info_gif.suffix        = 'MTw_MNI_gif_axial';
plot_info_gif.sl_def        = [-90 1 89;-127 1 128];
plot_info_gif.transform     = transform.axial;
plot_info_gif.xslices       = 1;
% plot_info_gif.slices        = linspace(lim.axial(1),lim.axial(2),40);
plot_info_gif.slices        = linspace(-75,65,50); %MNI axial
%     plot_info.fig_Position  = [172   605   186   263];
plot_info_gif.fig_Position  = [2348 578 202 285];
plot_info_gif.fig_cmap      = 'gray';
plot_info_gif.range         = [0 2];
plot_info_gif.img           = img.MNI.MTw;
plot_info_gif.out_fold_img  = out_fold_img;
plot_info_gif.subj_name_vst = subj_name_visit;

plot_info_gif.delay.begin    = 1.00;
plot_info_gif.delay.mid      = 0.20; %0.90 old
plot_info_gif.delay.end      = 1.00;


out.MTw_MNI_gif_axial = create_MNI_gif(plot_info_gif);

%==========================================================================
% MNI 
% set gif delay in sec

plot_info_gif.suffix        = 'PD_MNI_gif_axial';
plot_info_gif.sl_def        = [-90 1 89;-127 1 128];
plot_info_gif.transform     = transform.axial;
plot_info_gif.xslices       = 1;
% plot_info_gif.slices        = linspace(lim.axial(1),lim.axial(2),40);
plot_info_gif.slices        = linspace(-75,65,50); %MNI axial
%     plot_info.fig_Position  = [172   605   186   263];
plot_info_gif.fig_Position  = [2348 578 202 285];
plot_info_gif.fig_cmap      = 'gray';
plot_info_gif.range         = [30 100];
plot_info_gif.img           = img.MNI.PD;
plot_info_gif.out_fold_img  = out_fold_img;
plot_info_gif.subj_name_vst = subj_name_visit;

plot_info_gif.delay.begin    = 1.00;
plot_info_gif.delay.mid      = 0.20; %0.90 old
plot_info_gif.delay.end      = 1.00;


out.PD_MNI_gif_axial = create_MNI_gif(plot_info_gif);

%==========================================================================
% MNI 
% set gif delay in sec

plot_info_gif.suffix        = 'R1_MNI_gif_axial';
plot_info_gif.sl_def        = [-90 1 89;-127 1 128];
plot_info_gif.transform     = transform.axial;
plot_info_gif.xslices       = 1;
% plot_info_gif.slices        = linspace(lim.axial(1),lim.axial(2),40);
plot_info_gif.slices        = linspace(-75,65,50); %MNI axial
%     plot_info.fig_Position  = [172   605   186   263];
plot_info_gif.fig_Position  = [2348 578 202 285];
plot_info_gif.fig_cmap      = 'gray';
plot_info_gif.range         = [0.2 1.4];
plot_info_gif.img           = img.MNI.R1;
plot_info_gif.out_fold_img  = out_fold_img;
plot_info_gif.subj_name_vst = subj_name_visit;

plot_info_gif.delay.begin    = 1.00;
plot_info_gif.delay.mid      = 0.20; %0.90 old
plot_info_gif.delay.end      = 1.00;


out.R1_MNI_gif_axial = create_MNI_gif(plot_info_gif);

%==========================================================================
% MNI 
% set gif delay in sec

plot_info_gif.suffix        = 'R2s_MNI_gif_axial';
plot_info_gif.sl_def        = [-90 1 89;-127 1 128];
plot_info_gif.transform     = transform.axial;
plot_info_gif.xslices       = 1;
% plot_info_gif.slices        = linspace(lim.axial(1),lim.axial(2),40);
plot_info_gif.slices        = linspace(-75,65,50); %MNI axial
%     plot_info.fig_Position  = [172   605   186   263];
plot_info_gif.fig_Position  = [2348 578 202 285];
plot_info_gif.fig_cmap      = 'gray';
plot_info_gif.range         = [0 80];
plot_info_gif.img           = img.MNI.R2s;
plot_info_gif.out_fold_img  = out_fold_img;
plot_info_gif.subj_name_vst = subj_name_visit;

plot_info_gif.delay.begin    = 1.00;
plot_info_gif.delay.mid      = 0.20; %0.90 old
plot_info_gif.delay.end      = 1.00;


out.R2s_MNI_gif_axial = create_MNI_gif(plot_info_gif);

% 9999999999999999999999999999999999999999999999999999999999999999999999999

% ----------------------------------------------------------------------
% HTML
% ----------------------------------------------------------------------


% set name of html
html_name = spm_file(fullfile(out_fold_html,subj_name_visit),'ext','html');

% rewriting html need admin privilages, 
if exist(html_name,'file')==2
    unix(['rm -rf ' html_name]);
end

fid_html  = fopen(html_name,'w');

fprintf(fid_html,'<h2> %s </h2> \n',subj_name_visit);

fprintf(fid_html,'<!DOCTYPE html> \n');
fprintf(fid_html,'<html> \n');

% page title
fprintf(fid_html,'<head> \n');
fprintf(fid_html,'<title> %s </title> \n',subj_name_visit);
fprintf(fid_html,'</head> \n');

%**************************************************************************
% fprintf(fid_html,'<!-- Load d3.js --> \n');
fprintf(fid_html,'<script src="https://d3js.org/d3.v4.js"></script> \n');

% Load the TIV table
subj_info_tab = readtable(out_table_csv);

% tmp table foe the subject
tmp_table   =  subj_info_tab(contains(subj_info_tab{:,1},subj_name_visit),:);

%------------------------------------------------------------------------
% SDR2s_MTw
ss_boxplot_html(fid_html, subj_info_tab.SDR2s_MTw , tmp_table.SDR2s_MTw,'SDR2s_MTw',5,19)
% SDR2s_PDw
ss_boxplot_html(fid_html, subj_info_tab.SDR2s_PDw , tmp_table.SDR2s_PDw,'SDR2s_PDw',5,19)
% SDR2s_T1w
ss_boxplot_html(fid_html, subj_info_tab.SDR2s_T1w , tmp_table.SDR2s_T1w,'SDR2s_T1w',5,19)

% PD_cov
ss_boxplot_html(fid_html, subj_info_tab.PD_cov *100 , tmp_table.PD_cov *100,'PD SD/mean ',0.5,20)



% MT2PD
ss_boxplot_html(fid_html, subj_info_tab.MT2PD , tmp_table.MT2PD,'MT2PD_norm',-0.35,2.2)
% T12PD
ss_boxplot_html(fid_html, subj_info_tab.T12PD , tmp_table.T12PD,'T12PD_norm',0,2.2)




minVal =  min([subj_info_tab.c1 ; subj_info_tab.c2 ; subj_info_tab.c3]);
maxVal =  max([subj_info_tab.c1 ; subj_info_tab.c2 ; subj_info_tab.c3]);

% c1
ss_boxplot_html(fid_html, subj_info_tab.c1 , tmp_table.c1,'c1(Liter)',0.3,0.9)
% c2
ss_boxplot_html(fid_html, subj_info_tab.c2 , tmp_table.c2,'c2(Liter)',0.2,0.7)
% c3
ss_boxplot_html(fid_html, subj_info_tab.c3 , tmp_table.c3,'c3(Liter)',0.2,0.7)
% tiv
ss_boxplot_html(fid_html, subj_info_tab.tiv , tmp_table.tiv,'tiv(Liter)',1.25,1.5)

% c1 ratio
ss_boxplot_html(fid_html, subj_info_tab.c1_tiv*100 , tmp_table.c1_tiv*100,'c1/tiv (%)',10,50)
% c2 ratio
ss_boxplot_html(fid_html, subj_info_tab.c2_tiv*100 , tmp_table.c2_tiv*100,'c2/tiv (%)',10,50)
% c3 ratio
ss_boxplot_html(fid_html, subj_info_tab.c3_tiv*100 , tmp_table.c3_tiv*100,'c3/tiv (%)',10,50)


% CNR
ss_boxplot_html(fid_html, subj_info_tab.MTSat_CNR, tmp_table.MTSat_CNR,'MTSat CNR',0, 3)
ss_boxplot_html(fid_html, subj_info_tab.PD_CNR, tmp_table.PD_CNR,'PD CNR',0, 3)
ss_boxplot_html(fid_html, subj_info_tab.R1_CNR, tmp_table.R1_CNR,'R1 CNR',0, 3)
ss_boxplot_html(fid_html, subj_info_tab.R2_CNR, tmp_table.R2_CNR,'R2s CNR',0, 3)

% SNR
ss_boxplot_html(fid_html, subj_info_tab.MTSat_SNR_gm, tmp_table.MTSat_SNR_gm,'MTSat GM SNR',0, 10)
ss_boxplot_html(fid_html, subj_info_tab.PD_SNR_gm, tmp_table.PD_SNR_gm,'PD GM SNR',0, 15)
ss_boxplot_html(fid_html, subj_info_tab.R1_SNR_gm, tmp_table.R1_SNR_gm,'R1 GM SNR',0, 10)
ss_boxplot_html(fid_html, subj_info_tab.R2_SNR_gm, tmp_table.R2_SNR_gm,'R2s GM SNR',0, 10)

%**************************************************************************
%-------------------------------------------------------------------
% body of html
fprintf(fid_html,'<body> \n');

% fprintf(fid_html,'<h5>structure T1</h5> \n');

% insert image in html

%--------------------------------------------------------------------------


% -------------------------------------------------------------------
% figures

fprintf(fid_html,'\n');   
%----------------------------------------------------------------------

% Style for images

fprintf(fid_html,'<style>\n');
fprintf(fid_html,'* {\n');
fprintf(fid_html,'  box-sizing: border-box;\n');
fprintf(fid_html,'}\n');

fprintf(fid_html,'.column {\n');
fprintf(fid_html,'  float: left;\n');
fprintf(fid_html,'  width: 10%%;\n');%siya
fprintf(fid_html,'  padding: 0px;\n');
fprintf(fid_html,'}\n');

fprintf(fid_html,'/* Clearfix (clear floats) */\n');
fprintf(fid_html,'.row::after {\n');
fprintf(fid_html,'  content: "";\n');fprintf(fid_html,'<body> \n');
fprintf(fid_html,'  clear: both;\n');
fprintf(fid_html,'  display: tabmin(subj_info_tab.MT2PD)le;\n');
fprintf(fid_html,'}\n');

% this is for zoom
fprintf(fid_html,'/* The Modal (background) */\n');
fprintf(fid_html,'.modal {\n');
fprintf(fid_html,'  display: none; /* Hidden by default */\n');
fprintf(fid_html,'  position: fixed; /* Stay in place */\n');
fprintf(fid_html,'  z-index: 1; /* Sit on top */\n');
fprintf(fid_html,'  padding-top: 100px; /* Location of the box */\n');
fprintf(fid_html,'  left: 0;\n');
fprintf(fid_html,'  top: 0;\n');
fprintf(fid_html,'  width: 100%%; /* Full width */\n');
fprintf(fid_html,'  height: 100%%; /* Full height */\n');
fprintf(fid_html,'  overflow: auto; /* Enable scroll if needed */\n');
fprintf(fid_html,'  background-color: rgb(0,0,0); /* Fallback color */\n');
fprintf(fid_html,'  background-color: rgba(0,0,0,0.9); /* Black w/ opacity */\n');
fprintf(fid_html,'}\n');

fprintf(fid_html,'/* Modal Content (image) */\n');
fprintf(fid_html,'.modal-content {\n');
fprintf(fid_html,'  margin: auto;\n');
fprintf(fid_html,'  display: block;\n');
fprintf(fid_html,'  width: 80%%;\n');
fprintf(fid_html,'  max-width: 700px;\n');
fprintf(fid_html,'}\n');

fprintf(fid_html,'/* The Close Button */\n');
fprintf(fid_html,'.close {\n');
fprintf(fid_html,'  position: absolute;\n');
fprintf(fid_html,'  top: 15px;\n');
fprintf(fid_html,'  right: 35px;\n');
fprintf(fid_html,'  color: #f1f1f1;\n');
fprintf(fid_html,'  font-size: 40px;\n');
fprintf(fid_html,'  font-weight: bold;\n');
fprintf(fid_html,'  transition: 0.3s;\n');
fprintf(fid_html,'}\n');

fprintf(fid_html,'</style>\n');
%----------------------------------------------------------------------
% style for table 

fprintf(fid_html,'<style>\n');
fprintf(fid_html,'table {\n');
fprintf(fid_html,'  font-family: arial, sans-serif;\n');
fprintf(fid_html,'  border-collapse: collapse;\n');
fprintf(fid_html,'  width: 100%;\n');
fprintf(fid_html,'}\n');

fprintf(fid_html,'td, th {\n');
fprintf(fid_html,'  border: 1px solid #dddddd;\n');
fprintf(fid_html,'  text-align: left;\n');
fprintf(fid_html,'  padding: 8px;\n');
fprintf(fid_html,'  white-space: nowrap;\n');
fprintf(fid_html,'}\n');

%     fprintf(fid_html,'tr:nth-child(even) {\n');
%     fprintf(fid_html,'  background-color: #dddddd;\n');
fprintf(fid_html,'}\n');
fprintf(fid_html,'</style>\n');
% end of style table 
    
%     ----------------------------------------------------------------------
% for the jump to content 
fprintf(fid_html,'<h3 style="clear:left;">List of Figures</h3>\n');
fprintf(fid_html,'<a id="List_full"</a>\n');

fprintf(fid_html,'<table>\n');

fprintf(fid_html,'  <tr>\n');
fprintf(fid_html,'    <td><a href="#MTw_OLSfit_axial">MTw OLSfit axial</a></td>\n');
fprintf(fid_html,'    <td><a href="#PDw_OLSfit_axial">PDw OLSfit Axial</a></td>\n');
fprintf(fid_html,'    <td><a href="#c1_MTwOLS_overlay">c1 MTwOLS_overlay_axial</a></td>\n');
fprintf(fid_html,'    <td><a href="#c2_MTwOLS_overlay">c2 MTwOLS_overlay_axial</a></td>\n');
fprintf(fid_html,'  </tr>\n'); 


fprintf(fid_html,'  <tr>\n');
fprintf(fid_html,'    <td><a href="#MTsat_axial">MTsat axial</a></td>\n');
fprintf(fid_html,'    <td><a href="#MPM_PD_axial">PD axial</a></td>\n');
fprintf(fid_html,'    <td><a href="#MPM_R1_axial">R1 axial</a></td>\n');
fprintf(fid_html,'    <td><a href="#MPM_R2s_OLS_axial">MPM R2s OLS axial</a></td>\n');
fprintf(fid_html,'  </tr>\n');

fprintf(fid_html,'  <tr>\n');
fprintf(fid_html,'    <td><a href="#MPM_B1_axial">B1 map axial</a></td>\n');
fprintf(fid_html,'  </tr>\n');

fprintf(fid_html,'</table>\n');%end of table 

%----------------------------------------------------------------------
img_count   = 0;

%---------------------------------------------------------------------------
% Insert in MTw echos

% Hyperlink 
% fprintf(fid_html,'<a id="MTw_echos_axial"</a>\n');

fprintf(fid_html,'<h3 style="clear:left;">Structure MTw_echos_axial</h3>\n');

fprintf(fid_html,'<p style="clear:left;">MTw echos images in axial plane:</p>\n');
fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

for k =1:size(out.in_MTw.axial,1)
    [img_count] = print_img_html(fid_html,img_count,out.in_MTw.axial{k,2},...
        out.in_MTw.axial{k,1},subj_name_visit,['MTw_echo_' sprintf('%02d',k) '_axial']);
end


%---------------------------------------------------------------------------
% Insert in MTw echos gif

% Hyperlink 
% fprintf(fid_html,'<a id="MTw_echos_axial"</a>\n');

fprintf(fid_html,'<h3 style="clear:left;">Structure GIF MTw_echos_axial</h3>\n');

fprintf(fid_html,'<p style="clear:left;">MTw echos images in axial plane:</p>\n');
fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

[img_count] = print_img_html(fid_html,img_count,[subj_name_visit ' MTw, Echos ' num2str(size(img.in.MTw,1))],...
        out.MTw_gif_axial,subj_name_visit,'MTw_echo_gif_axial');
    
    

%---------------------------------------------------------------------------
% Insert in PDw echos

% Hyperlink 
% fprintf(fid_html,'<a id="MTw_echos_axial"</a>\n');

fprintf(fid_html,'<h3 style="clear:left;">Structure PDw_echos_axial</h3>\n');

fprintf(fid_html,'<p style="clear:left;">PDw echos images in axial plane:</p>\n');
fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

for k =1:size(out.in_PDw.axial,1)
    [img_count] = print_img_html(fid_html,img_count,out.in_PDw.axial{k,2},...
        out.in_PDw.axial{k,1},subj_name_visit,['PDw_echo_' sprintf('%02d',k) '_axial']);
end

%---------------------------------------------------------------------------

% Insert in PDw echos gif

% Hyperlink 
% fprintf(fid_html,'<a id="MTw_echos_axial"</a>\n');

fprintf(fid_html,'<h3 style="clear:left;">Structure GIF PDw_echos_axial</h3>\n');

fprintf(fid_html,'<p style="clear:left;">PDw echos images in axial plane:</p>\n');
fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

[img_count] = print_img_html(fid_html,img_count,[subj_name_visit ' PDw, Echos ' num2str(size(img.in.PDw,1))],...
        out.PDw_gif_axial,subj_name_visit,'PDw_echo_gif_axial');


%---------------------------------------------------------------------------
% Insert in T1w echos

% Hyperlink 
% fprintf(fid_html,'<a id="MTw_echos_axial"</a>\n');

fprintf(fid_html,'<h3 style="clear:left;">Structure T1w_echos_axial</h3>\n');

fprintf(fid_html,'<p style="clear:left;">T1w echos images in axial plane:</p>\n');
fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

for k =1:size(out.in_T1w.axial,1)
    [img_count] = print_img_html(fid_html,img_count,out.in_T1w.axial{k,2},...
        out.in_T1w.axial{k,1},subj_name_visit,['T1w_echo_' sprintf('%02d',k) '_axial']);
end


%---------------------------------------------------------------------------

% Insert in T1w echos gif

% Hyperlink 
% fprintf(fid_html,'<a id="MTw_echos_axial"</a>\n');

fprintf(fid_html,'<h3 style="clear:left;">Structure GIF T1w_echos_axial</h3>\n');

fprintf(fid_html,'<p style="clear:left;">T1w echos images in axial plane:</p>\n');
fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

[img_count] = print_img_html(fid_html,img_count,[subj_name_visit ' T1w, Echos ' num2str(size(img.in.T1w,1))],...
        out.T1w_gif_axial,subj_name_visit,'T1w_echo_gif_axial');







%***************************************************************************
%---------------------------------------------------------------------------
% Insert MPM MT OLS fit

% Hyperlink 
fprintf(fid_html,'<a id="MTw_OLSfit_axial"</a>\n');

fprintf(fid_html,'<h3 style="clear:left;">Structure MTw_OLSfit_axial</h3>\n');

fprintf(fid_html,'<p style="clear:left;">MTw_OLSfit_axial images in axial plane:</p>\n');
fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

[img_count] = print_img_html(fid_html,img_count,img.MTw_OLSfit,out.MTw_OLSfit_axial_png_folder,subj_name_visit,'MTw_OLSfit_axial');

%---------------------------------------------------------------------------
% Insert MPM PD OLS fit

fprintf(fid_html,'<h3 style="clear:left;">Structure PDw OLSfit axial</h3>\n');

fprintf(fid_html,'<p style="clear:left;">PDw_OLSfit_axial images in axial plane:</p>\n');
% Hyperlink 
fprintf(fid_html,'<a id="PDw_OLSfit_axial"</a>\n');
fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

[img_count] = print_img_html(fid_html,img_count,img.PDw_OLSfit,out.PDw_OLSfit_axial_png_folder,subj_name_visit,'PDw_OLSfit_axial');

%---------------------------------------------------------------------------
% Insert MPM MT c1 overlay fit

fprintf(fid_html,'<h3 style="clear:left;">Structure c1_MTwOLS_overlay axial</h3>\n');

fprintf(fid_html,'<p>c1 MTwOLS_overlay images in axial plane:</p>\n');
% Hyperlink 
fprintf(fid_html,'<a id="c1_MTwOLS_overlay"</a>\n');
fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

[img_count] = print_img_html(fid_html,img_count,c_seg{1},out.MTwOLS_c1_folder,subj_name_visit,'c1_MTwOLS_overlay');

%---------------------------------------------------------------------------
% Insert MPM MT c2 overlay fit

fprintf(fid_html,'<h3 style="clear:left;">Structure c2_MTwOLS_overlay axial</h3>\n');

fprintf(fid_html,'<p>c2_MTwOLS_overlayimages in axial plane:</p>\n');
% Hyperlink 
fprintf(fid_html,'<a id="c2_MTwOLS_overlay"</a>\n');
fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

[img_count] = print_img_html(fid_html,img_count,c_seg{2},out.MTwOLS_c2_folder,subj_name_visit,'c2_MTwOLS_overlay');


%---------------------------------------------------------------------------
% Insert MPM MTsat axial

fprintf(fid_html,'<h3 style="clear:left;">Structure MTsat Axial</h3>\n');

fprintf(fid_html,'<p>MPM images in axial plane:</p>\n');

% Hyperlink 
fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');
fprintf(fid_html,'<a id="MTsat_axial"</a>\n');

[img_count] = print_img_html(fid_html,img_count,img.MPM_MTsat,out.MTsat_axial_png_folder,subj_name_visit,'MTsat_axial');

% % % link to list of figures
% fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

%---------------------------------------------------------------------------
% Insert MPM PD axial

% Hyperlink 


fprintf(fid_html,'<h3 style="clear:left;">Structure MPM PD Axial</h3>\n');

fprintf(fid_html,'<p>MPM_PD_axial images in axial plane:</p>\n');

fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');
fprintf(fid_html,'<a id="MPM_PD_axial"</a>\n');

[img_count] = print_img_html(fid_html,img_count,img.MPM_PD,out.MPM_PD_axial_png_folder,subj_name_visit,'MPM_PD_axial');

%---------------------------------------------------------------------------
% Insert MPM R1 axial

fprintf(fid_html,'<h3 style="clear:left;">Structure MPM R1 Axial</h3>\n');

fprintf(fid_html,'<p>MPM R1 images in axial plane:</p>\n');

fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');
fprintf(fid_html,'<a id="MPM_R1_axial"</a>\n');

[img_count] = print_img_html(fid_html,img_count,img.MPM_R1,out.MPM_R1_axial_png_folder,subj_name_visit,'MPM_R1_axial');



%---------------------------------------------------------------------------
% Insert MPM R2s OLS axial

fprintf(fid_html,'<h3 style="clear:left;">Structure MPM R2s OLS Axial</h3>\n');


fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

fprintf(fid_html,'<a id="MPM_R2s_OLS_axial"</a>\n');

fprintf(fid_html,'<p>MPM R2s OLS images in axial plane:</p>\n');

[img_count] = print_img_html(fid_html,img_count,img.MPM_R2s_OLS,out.MPM_R2s_OLS_axial_png_folder,subj_name_visit,'MPM_R2s_OLS_axial');

%---------------------------------------------------------------------------
% Insert MPM R2s OLS axial

fprintf(fid_html,'<h3 style="clear:left;">Structure B1 map Axial</h3>\n');


fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

fprintf(fid_html,'<a id="MPM_B1_axial"</a>\n');

fprintf(fid_html,'<p>MPM B1 map images in axial plane:</p>\n');

[img_count] = print_img_html(fid_html,img_count,img.B1map,out.MPM_B1_axial_png_folder,subj_name_visit,'MPM_B1_axial');
%---------------------------------------------------------------------------

%---------------------------------------------------------------------------

% Insert in MTw MNI gif

% Hyperlink 
% fprintf(fid_html,'<a id="MTw_echos_axial"</a>\n');

%fprintf(fid_html,'<h3 style="clear:left;">Structure GIF T1w_echos_axial</h3>\n');

fprintf(fid_html,'<p style="clear:left;">MTw MNI images in axial plane:</p>\n');
fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

[img_count] = print_img_html(fid_html,img_count,[subj_name_visit ' MNI wap1 wap1 MTw ' num2str(size(img.MNI.MTw,1))],...
        out.MTw_MNI_gif_axial,subj_name_visit,'MTw_MNI_gif_axial');

    
%---------------------------------------------------------------------------

% Insert in PD MNI gif

% Hyperlink 
% fprintf(fid_html,'<a id="MTw_echos_axial"</a>\n');

%fprintf(fid_html,'<h3 style="clear:left;">Structure GIF T1w_echos_axial</h3>\n');

fprintf(fid_html,'<p style="clear:left;">PD MNI images in axial plane:</p>\n');
fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

[img_count] = print_img_html(fid_html,img_count,[subj_name_visit ' MNI wap1 wap1 PD ' num2str(size(img.MNI.PD,1))],...
        out.PD_MNI_gif_axial,subj_name_visit,'PD_MNI_gif_axial');    
    
    
%---------------------------------------------------------------------------

% Insert in PD MNI gif

% Hyperlink 
% fprintf(fid_html,'<a id="MTw_echos_axial"</a>\n');

%fprintf(fid_html,'<h3 style="clear:left;">Structure GIF T1w_echos_axial</h3>\n');

fprintf(fid_html,'<p style="clear:left;">R1 MNI images in axial plane:</p>\n');
fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

[img_count] = print_img_html(fid_html,img_count,[subj_name_visit ' MNI wap1 wap1 R1 ' num2str(size(img.MNI.R1,1))],...
        out.R1_MNI_gif_axial,subj_name_visit,'R1_MNI_gif_axial');  
    
%---------------------------------------------------------------------------

% Insert in PD MNI gif

% Hyperlink 
% fprintf(fid_html,'<a id="MTw_echos_axial"</a>\n');

%fprintf(fid_html,'<h3 style="clear:left;">Structure GIF T1w_echos_axial</h3>\n');

fprintf(fid_html,'<p style="clear:left;">R2s MNI images in axial plane:</p>\n');
fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

[img_count] = print_img_html(fid_html,img_count,[subj_name_visit ' MNI wap1 wap1 R2s ' num2str(size(img.MNI.R2s,1))],...
        out.R2s_MNI_gif_axial,subj_name_visit,'R2s_MNI_gif_axial');
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%---------------------------------------------------------------------------
%end of html
fprintf(fid_html,'\n');

% for  zooming in the image 
fprintf(fid_html,'<!-- The Modal -->\n');
fprintf(fid_html,'<div id="myModal" class="modal">\n');
fprintf(fid_html,'  <span class="close">&times;</span>\n');
fprintf(fid_html,'  <img class="modal-content" id="img01">\n');
fprintf(fid_html,'  <div id="caption"></div>\n');
fprintf(fid_html,'</div>\n');

fprintf(fid_html,'<script>\n');

fprintf(fid_html,'// Get the modal\n');
fprintf(fid_html,'var modal = document.getElementById("myModal");\n');
fprintf(fid_html,'var modalImg = document.getElementById("img01");\n');


fprintf(fid_html,'// Get the image and insert it inside the modal - use its "alt" text as a caption\n');

for k = 1:img_count

    
    img_num =  sprintf('%05d',k);

    fprintf(fid_html,'var img%s = document.getElementById("img%s");\n',img_num,img_num);

    fprintf(fid_html,'img%s.onclick = function(){\n',img_num);
    fprintf(fid_html,'  modal.style.display = "block";\n');
    fprintf(fid_html,'  modalImg.src = this.src;\n');
    fprintf(fid_html,'  captionText.innerHTML = this.alt;\n');
    fprintf(fid_html,'}\n');
end

fprintf(fid_html,'// Get the <span> element that closes the modal\n');
fprintf(fid_html,'var span = document.getElementsByClassName("close")[0];\n');

fprintf(fid_html,'// When the user clicks on <span> (x), close the modal\n');
fprintf(fid_html,'span.onclick = function() { \n');
fprintf(fid_html,'  modal.style.display = "none";\n');
fprintf(fid_html,'}\n');

fprintf(fid_html,'</script>\n');    
    
%----------------------------------------------------------------------
% closing html 
fprintf(fid_html,'</body> \n');
fprintf(fid_html,'</html> \n');

fclose(fid_html);

    

end