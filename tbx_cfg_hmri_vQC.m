function hMRIvQC = tbx_cfg_hmri_vQC
% hMRI_vQC_cfg_matlabbatch is the configurarion file for all jobs of the mp2rage branch
% This file is executed by spm job/batch system
%
% See also spm_cfg


%% Batch configuration

% Add the extension/toolbox in matlab path
addpath(fileparts(mfilename('fullpath')));


%% Input Images

% ---------------------------------------------------------------------
% Input - in_dir 
% ---------------------------------------------------------------------
in_dir           = cfg_files;
in_dir.tag       = 'select the main derivative/output folder of hMRI or MPM';
in_dir.name      = '';
in_dir.help      = {''};
in_dir.filter    = 'image';
in_dir.ufilter   = '.*';
in_dir.num       = [1 1];
in_dir.val       = {''};

% ---------------------------------------------------------------------
% Input - inv2 
% ---------------------------------------------------------------------

inv2           = cfg_files;
inv2.tag       = 'inv2';
inv2.name      = 'inv2 images';
inv2.help      = {'Input inv2 images.'};
inv2.filter    = 'image';
inv2.ufilter   = '.*';
inv2.num       = [1 1];
inv2.val       = {''};

% ---------------------------------------------------------------------
% Input - UNI 
% ---------------------------------------------------------------------

uni            = cfg_files;
uni.tag        = 'uni';
uni.name       = 'uni images';
uni.help       = {'Input uni images.'};
uni.filter     = 'image';
uni.ufilter    = '.*';
uni.num        = [1 1];
uni.val        = {''};

image_qc      = cfg_exbranch;
image_qc.tag  = 'image_qc';
image_qc.name = 'hMRI-vQC';
image_qc.help = {
    'Based abcd '
    ''
    };
image_qc.val  = {in_dir inv2 uni};
image_qc.prog = @prog_imgQC;
% image_qc.vout = @vout_imgQC;
%% Main

%--------------------------------------------------------------------------
% hMRIvQC : main
%--------------------------------------------------------------------------
% This is the menue on the batch editor : SPM > Tools > MP2RAGEQC
% 
hMRIvQC         = cfg_choice;
hMRIvQC.tag     = 'hMRI-vQC';
hMRIvQC.name    = 'hMRI-vQC';
hMRIvQC.help    = {
    ['This toolbox hMRI_vQC is based in   ']
    [' Please report any bugs or problems to siya ']
    }';
hMRIvQC.values  = {image_qc};

end % end of main function 

function prog_imgQC(job)

    fprintf('Hello1')

end

function vout_imgQC

    fprintf('Hello2')

end