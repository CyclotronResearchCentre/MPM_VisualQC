function ss_MPM_QC_main()
% to create html visual report for MPM data
% Siya Sherif 
% 09DEC2021 
% dependencies  SPM12
%--------------------------------------------------------------------------
% fast version for OHBM2021 :)

% input Folder
% TO DO :  shoudl be a  SPM batch - input

main_path = '/media/siya/CRC_DATA_ss/cof_processed/pipeline-03';

% list all the qc json (easy way to grep the hMRI output results, 
% WARNING - might grep different runs of hMRI , TO DO , exclude) 
% or ask user to select the list 
list_qc_json = spm_select('FPListRec',main_path,'^hMRI_map_creation_quality_assessment.*.json$');


% % % SPM segement out of OLFfit  
% % % segmenation could be inculded in the QC 
% % % since i have the segmention, I am directly using it to save time for OHBM
% % % or use mat out of segement 
% % 
% % tiv_table = spm_select('FPListRec',main_path,'.*_T1w_OLSfit_TEzero_TIV_SPM12.txt');

% main out folder
% TO DO spm batch job input 
out_main_path = '/media/siya/CRC_DATA_ss/cof_processed/pipeline-03/MPM-QC';
if ~exist(out_main_path);mkdir(out_main_path);end

% create the table csv for plotting the boxplots 
out_table = fullfile(out_main_path,'out_table');
if ~exist(out_table);mkdir(out_table);end

out_table_csv = fullfile(out_table,'subj_data_table.csv');

run_code = 0;

if ~exist(out_table_csv)
    run_code = 1;
else
    % No need to run if table size is same as list of files
    if size(readtable(out_table_csv),1)==size(list_qc_json,1)
        run_code = 0;
    else
        run_code = 1;
    end
end

if run_code == 1
    subj_info_table = table; 

    for i = 1: size(list_qc_json,1)

        TT = [];
        
        % get the BIDS name 
        % this is a dirty way of doing it , should be easy with BIDS naming 
        % specific problem for this data set 
        TT.name  = list_qc_json(i,strfind(list_qc_json(i,:),'COF'):strfind(list_qc_json(i,:),'COF')+5)  ;
        
        % tivFfile 
        tiv_file = spm_select('FPList',spm_file(spm_file(strtrim(list_qc_json(i,:)),'path'),'filename','Segmentation'),'.*_TIV_SPM12.txt$');
        
        % this is pecific for this 
        TT.name_R  =  sprintf('%28s',strrep(spm_file(tiv_file,'filename'),'_T1w_OLSfit_TEzero_TIV_SPM12.txt',''));
         
        T_tiv = readtable(tiv_file);

        TT.c1 = round(T_tiv.Volume1,2);
        TT.c2 = round(T_tiv.Volume2,2);
        TT.c3 = round(T_tiv.Volume3,2);

        TT.tiv = round(T_tiv.Volume1 + T_tiv.Volume2 + T_tiv.Volume3,2);

        TT.c1_tiv = round(T_tiv.Volume1 ./ TT.tiv,2);
        TT.c2_tiv = round(T_tiv.Volume2 ./ TT.tiv,2);
        TT.c3_tiv = round(T_tiv.Volume3 ./ TT.tiv,2);
        
        % add the json file values QC

        subj_info_table = [subj_info_table ; struct2table(TT) ];

    end

    writetable(subj_info_table,out_table_csv,'Delimiter',',')  
end

% parpool('local',5)
% parfor
for i = 1:size(list_qc_json,1)
    ss_create_html_report(strtrim(list_qc_json(i,:)),out_table_csv,out_main_path); % fill array with participants data
    
end
% delete(gcp('nocreate'));

end