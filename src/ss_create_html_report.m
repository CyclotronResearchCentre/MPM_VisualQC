function ss_create_html_report(list_qc_json,subj_info_table,out_main_path)

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
    

% get subject name COF subj name ; TO DO BIDS naming should take care of
subj_name_visit = list_qc_json(strfind(list_qc_json,'COF'):strfind(list_qc_json,'COF')+5)  ;

fprintf('running : %s \n',subj_name_visit); % for qsub
    
% MPMs
% TO DO define Results path and check it validity
img_MPM_MTsat   = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'path'),'.*_MTsat.nii');
img_MPM_PD      = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'path'),'.*_PD.nii');
img_MPM_R1      = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'path'),'.*_R1.nii');
img_MPM_R2s_OLS = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'path'),'.*_R2s_OLS.nii');

% c1;c2;c3

c_seg{1} = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'filename','Segmentation'),'^c1.*.nii');
c_seg{2} = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'filename','Segmentation'),'^c2.*.nii');
c_seg{3} = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'filename','Segmentation'),'^c3.*.nii');

% =====================================================================
% generating png images startes here  
    
% get the axial range 
[lim.axial,lim.sagittal,lim.coronal] = lim_slices_MPM(c_seg);
% ----------------------------------------------------------------------
    

end