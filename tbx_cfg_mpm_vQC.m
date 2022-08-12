function MPM_vQC = tbx_cfg_mpm_vQC
% MPM QC matlabbatch configurarion file for all jobs of the vQC branch
% This file is executed by spm job/batch system
%
% See also spm_cfg
% Warning and disclaimer: This software is for research use only.
% Do not use it for clinical or diagnostic purposes.
%
%__________________________________________________________________________
% Cyclotron Research Centre - University of Liège
% Siya Sherif 
% 2022 July 29
%==========================================================================

% Batch configuration

% Add the extension/toolbox in matlab path

MPM_vQC_path = fileparts(mfilename('fullpath'));
addpath(MPM_vQC_path);
addpath(fullfile(MPM_vQC_path,'src'));


% ---------------------------------------------------------------------
% MPM_vQC Tools
% ---------------------------------------------------------------------
MPM_vQC         = cfg_choice;
MPM_vQC.tag     = 'MPM_vQC';
MPM_vQC.name    = 'MPM QC tools ';
MPM_vQC.help    = {
    ['This toolbox MPM_vQC is ... ']
    [' Please report any bugs or problems to siya ']
    }';
MPM_vQC.values  = {tbx_hmri_vQC_config };%tbx_scfg_mp2rage_vQC};

end