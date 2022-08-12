function create_hMRI_vQC = tbx_hmri_vQC_config
% tbx_hmri_vQC_config
% 1. for the input files (using json file as ref file )
% 2. for output folder
%__________________________________________________________________________
% Cyclotron Research Centre - University of Liège
% Siya Sherif 
% 2022 July 29
%==========================================================================
% Input Images

% ---------------------------------------------------------------------
% Input - MTsatfile 
% ---------------------------------------------------------------------
in_MTsat           = cfg_files;
in_MTsat.tag       = 'json_info';
in_MTsat.name      = 'hMRI_map_creation_job_create_maps';
in_MTsat.help      = {['Select the hMRI_map_creation_job_create_maps.json files'] ...
                       ['/Results/Supplementary/ Folder of hMRI output'] ...
                       ['Read the sample_dataorg.md '] };
in_MTsat.filter    = 'any';
in_MTsat.ufilter   = '^hMRI_map_creation_job_create_maps.*.json';
in_MTsat.num       = [0 Inf];
in_MTsat.val       = {''};


%---------------------------------------------------------------------
% outdir Output directory
%---------------------------------------------------------------------
outdir         = cfg_files;
outdir.tag     = 'outdir';
outdir.name    = 'Output directory';
outdir.help    = {['An "hMRI_vQC-html" directory will be created within the selected output directory']};
outdir.filter = 'dir';
outdir.ufilter = '.*';
outdir.num     = [1 1];


% ---------------------------------------------------------------------

% 
% ---------------------------------------------------------------------
create_hMRI_vQC         = cfg_exbranch;
create_hMRI_vQC.tag     = 'create_hMRIvQC';
create_hMRI_vQC.name    = 'Create hMRI vQC ';
create_hMRI_vQC.val     = {in_MTsat outdir};
create_hMRI_vQC.help    = {'vQC for hMRI'};
create_hMRI_vQC.prog    = @hmri_vQC_run_create;
% create_hMRI_vQC.vout    = @vout_create;

function out = hmri_vQC_run_create(job)
   fprintf('hola mundo\n') ;
   ss_MPM_QC_main(job);
end

end