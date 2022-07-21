%-----------------------------------------------------------------------
% Job saved on 13-Dec-2021 12:12:56 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.util.imcalc.input = {
                                        '/media/siya/CRC_DATA_ss/MPM_multi/OUT_DATA/MPM-QC/out_fold_img/sub-BAL001_ses-01_acq-rescan/MPM_B1_axial/sub-BAL001_ses-01_acq-rescanPDw_echo-01_mt-off_MPM_MTw_OLSfit_TEzero.nii,1'
                                        '/media/siya/CRC_DATA_ss/MPM_multi/OUT_DATA/MPM-QC/out_fold_img/sub-BAL001_ses-01_acq-rescan/MPM_B1_axial/sub-BAL001_ses-01_acq-rescan_flip-01_echo-01_TB1EPI_B1ref.nii,1'
                                        };
matlabbatch{1}.spm.util.imcalc.output = 'tmpTest.nii';
matlabbatch{1}.spm.util.imcalc.outdir = {'/media/siya/CRC_DATA_ss/MPM_multi/OUT_DATA/MPM-QC/out_fold_img/sub-BAL001_ses-01_acq-rescan/MPM_B1_axial'};
matlabbatch{1}.spm.util.imcalc.expression = 'i2.*1';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
