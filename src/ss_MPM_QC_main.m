function ss_MPM_QC_main(job_info)
%==========================================================================
%
% PURPOSE: to create html visual report for MPM data
% INPUT  -
%   job_info.json_info   - list of MPM for QC 
%   job_info.outdir      - output folder 
% OUTPUT 
%   create html files in the out folder 
%_______________________________________________________________________
% Cyclotron Research Centre - University of Liège
% Siya Sherif 
% 09DEC2021 v.01 
% 29JULY2022 edit for the spm batch 
%==========================================================================

% % % close all; clear all;clc;


% input Folder
% TO DO :  shoudl be a  SPM batch - input

% % % % % % main_path   = '/media/siya/ss_14T_2022/MPM_TravelHead_Study/OUTDATA/derivative-01_def_val_with_smap_HiRes/';
% % % % % % 
% % % % % % BIDS_in     = '/media/siya/ss_14T_2022/MPM_TravelHead_Study/BIDS-pseudo/';

% list all the qc json (easy way to grep the hMRI output results, 
% WARNING - might grep different runs of hMRI , TO DO , exclude) 
% or ask user to select the list 

% list_qc_json = spm_select('FPListRec',main_path,'^hMRI_map_creation_quality_assessment.*.json$');

% % % list_qc_json =  spm_select('FPListRec',spm_select('FPListRec',main_path,'dir','^acq_lowb1FA'),'^hMRI_map_creation_quality_assessment.*.json$');
% % % list_qc_json = spm_select('FPListRec',spm_select('FPListRec',main_path,'dir','^Results'),'MTw_OLS.*.json$');

% % % SPM segement out of OLFfit  
% % % segmenation could be inculded in the QC 
% % % since i have the segmention, I am directly using it to save time for OHBM
% % % or use mat out of segement 
% % 
% % tiv_table = spm_select('FPListRec',main_path,'.*_T1w_OLSfit_TEzero_TIV_SPM12.txt');

% main out folder
% TO DO spm batch job input 
% out_main_path = '/media/siya/ss_14T_2022/MPM_TravelHead_Study/OUTDATA/QC-test';
out_main_path = fullfile(job_info.outdir{1},'hMRI_vQC-html');
if ~exist(out_main_path);mkdir(out_main_path);end

% create the table csv for plotting the boxplots 
out_table = fullfile(out_main_path,'out_table');
if ~exist(out_table);mkdir(out_table);end

out_table_csv = fullfile(out_table,'subj_data_table.csv');

run_code = 0;

% check if the table exists 
if ~exist(out_table_csv)
    run_code = 1;
else
    % No need to run if table size is same as list of files
    if size(readtable(out_table_csv),1)==size(job_info.json_info,1)
        run_code = 0; % this temp solution. TO DO 1. check the list, 2. compare, 3. run only new files, 4, append to the list 
    else
        run_code = 1;
    end
end

if run_code == 1
    subj_info_table = table; 

    for i = 1: size(job_info.json_info)

        TT = [];
        
        
        % get the BIDS name 
        % this is a dirty way of doing it , should be easy with BIDS naming
        % in future 
        clear tmp_mpm_info tmp_basename tmp_supple_path;
        
        % read the json
        tmp_mpm_info =  spm_jsonread(job_info.json_info{i,:});
       
        % get the MTw OLS/wls fit in the folde rname
        tmp_basename = spm_select('List',tmp_mpm_info.subj.path.supplpath,'_MTw_.*fit_TEzero.nii$');
        
        % remove the extra part (PDw_echo-') all the hMRI toolbox output name are based on the PDw
        tmp_basename(strfind(tmp_basename,'PDw_echo-'):end)=[];
        TT.name  =   sprintf('%35s',tmp_basename);
        
        % read qc matrix
        mpm_qc = spm_jsonread(spm_select('FPList',tmp_mpm_info.subj.path.supplpath,'hMRI_map_creation_quality_assessment.json'));
        
       
        % read the tiv file
        tiv_file = spm_select('FPListRec',tmp_mpm_info.subj.path.segTEzero,'.*_TIV_ICVeTPM.txt$');        
        
        % norm of first three values (euclidian movement)
        % TO DO motion fingerprint
        TT.MT2PD = norm(mpm_qc.ContrastCoreg.MT2PD(1:3));
        TT.T12PD = norm(mpm_qc.ContrastCoreg.T12PD(1:3));
        
        % SDR2s
        TT.SDR2s_MTw = mpm_qc.SDR2s.MTw;
        TT.SDR2s_PDw = mpm_qc.SDR2s.PDw;
        TT.SDR2s_T1w = mpm_qc.SDR2s.T1w;
        
        % PD 
        TT.PD_cov = mpm_qc.PD.SD./mpm_qc.PD.mean;
        
        log_file = tmp_mpm_info.subj.log.logfile;
        % read the log file
        log_read = fileread(log_file);
        % get the line 
        C_line = regexp(log_read,'[^\n\r]+for calculated PD map:','match');
        
        if isempty(C_line)
            fprintf('error in the PD movement line')
        else
            PDline = C_line{1}; 
            % get the value 
            PDchar = (PDline((strfind(PDline,'(')+1) : (strfind(PDline,')')-2)));
            TT.PD_ErrEst = str2double(PDchar);
        end
        
        
        % this is pecific for this 
%         TT.name_R  =  sprintf('%28s',strrep(spm_file(tiv_file,'filename'),'_T1w_OLSfit_TEzero_TIV_SPM12.txt',''));
          % tivFfile 
% %         tiv_file = spm_select('FPListRec',spm_file(spm_file(spm_file(strtrim(list_qc_json(i,:)),'path'),'path'),'path'),'.*TIV.txt$');
         
        T_tiv = readtable(tiv_file);
        % get the tissue volumes, round it to second digit
        TT.c1 = round(T_tiv.Volume1,2);
        TT.c2 = round(T_tiv.Volume2,2);
        TT.c3 = round(T_tiv.Volume3,2);

        TT.tiv = round(T_tiv.Volume1 + T_tiv.Volume2 + T_tiv.Volume3,2);

        TT.c1_tiv = round(T_tiv.Volume1 ./ TT.tiv,2);
        TT.c2_tiv = round(T_tiv.Volume2 ./ TT.tiv,2);
        TT.c3_tiv = round(T_tiv.Volume3 ./ TT.tiv,2);
        
        
        
        TT = other_qcPar(TT,tmp_mpm_info);
        
        
        % add the json file values QC

        subj_info_table = [subj_info_table ; struct2table(TT) ];

    end

    writetable(subj_info_table,out_table_csv,'Delimiter',',')  
end

% parpool('local',5)
% parfor i = 1:size(list_qc_json,1)
for i = 1:size(job_info.json_info,1)
    ss_create_html_report(job_info.json_info{i,:},out_table_csv,out_main_path); % fill array with participants data
end
% delete(gcp('nocreate'));

end