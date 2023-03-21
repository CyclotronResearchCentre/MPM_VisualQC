function TT =  other_qcPar(TT,tmp_mpm_info)
%==========================================================================
%
% PURPOSE: to create aother QC parameters 
% INPUT  -
%   TT      - QC table  
%   tmp_job_info - mpm info
% OUTPUT 
%   create html files in the out folder 
%_______________________________________________________________________
% Cyclotron Research Centre - University of Liège
% Siya Sherif 
% 09DEC2021 v.01 
% 29JULY2022 edit for the spm batch 
%==========================================================================

c6_file = spm_select('FPList',tmp_mpm_info.subj.path.segTEzero,'^c6.*.nii');

% create mask 
Y_c6   = spm_vol(c6_file);
V_c6   = double(spm_read_vols(Y_c6));


% binarize
V_c6(V_c6>0)=1;

[~, img_y, ~]  = size(V_c6);

% this part is from the SPM Fieldmap  (cite them)
nerode  = 2;
ndilate = 4;
thresh  = 0.5;  % 0.8 value used in ismrm abstract  
fwhm    = 5;    % 2;

V_c6(:,1:(img_y/2),:) = 0; % top part of the head hask 
% I am using a dirty hack 
% TO DO. 
% 1. create a head mask in MNI template;
% 2. use inverse transform to bring it ot the subject space      

V_c6mask = connect_it(V_c6);


    
%     Y_save = Y_c6;
%     Y_save.fname =  c6_mask;
%     spm_write_vol(Y_save,V_c6mask);
% else
%     Y_c6mask   = spm_vol(c6_mask);
%     V_c6mask   = double(spm_read_vols(Y_c6mask));
% 
% end %end of mask 

c1_main = strrep(c6_file,'c6','c1');
Y_c1   = spm_vol(c1_main);
V_c1   = double(spm_read_vols(Y_c1));
V_c1Mask    = V_c1>0.9;  

c2_main = strrep(c6_file,'c6','c2');
Y_c2   = spm_vol(c2_main);
V_c2   = double(spm_read_vols(Y_c2));
V_c2Mask    = V_c2>0.9;  
 

MTSat   = spm_select('FPList',tmp_mpm_info.subj.path.respath,'_MTsat.nii');
PD      = spm_select('FPList',tmp_mpm_info.subj.path.respath,'_PD.nii');
R1      = spm_select('FPList',tmp_mpm_info.subj.path.respath,'_R1.nii');
R2      = spm_select('FPList',tmp_mpm_info.subj.path.respath,'_R2s_.*.nii');
MTwOLS  = spm_select('FPList',tmp_mpm_info.subj.path.supplpath,'_MTw_.*fit_TEzero.nii');
PDwOLS  = spm_select('FPList',tmp_mpm_info.subj.path.supplpath,'_PDw_.*Sfit_TEzero.nii');

MTsat_mSNR  = spm_select('FPList',tmp_mpm_info.subj.path.supplpath,'_MTsat_mSNR.nii');
PD_mSNR     = spm_select('FPList',tmp_mpm_info.subj.path.supplpath,'_PD_mSNR.nii');
R1_mSNR     = spm_select('FPList',tmp_mpm_info.subj.path.supplpath,'_R1_mSNR.nii');



% SNR 
TT.MTSat_SNR_gm = est_snr(MTSat,V_c1Mask);
TT.MTSat_SNR_wm = est_snr(MTSat,V_c2Mask);

TT.PD_SNR_gm = est_snr(PD,V_c1Mask);
TT.PD_SNR_wm = est_snr(PD,V_c2Mask);  

TT.R1_SNR_gm = est_snr(R1,V_c1Mask);
TT.R1_SNR_wm = est_snr(R1,V_c2Mask); 

TT.R2_SNR_gm = est_snr(R2,V_c1Mask);
TT.R2_SNR_wm = est_snr(R2,V_c2Mask);

%---------------------------------------------------------------
% SNR _dietrich 
TT.MTSat_SNR_dietrich_gm = est_snr_dietrich(MTSat,V_c1Mask,V_c6mask);
TT.MTSat_SNR_dietrich_wm = est_snr_dietrich(MTSat,V_c2Mask,V_c6mask);

TT.PD_SNR_dietrich_gm = est_snr_dietrich(PD,V_c1Mask,V_c6mask);
TT.PD_SNR_dietrich_wm = est_snr_dietrich(PD,V_c2Mask,V_c6mask);

TT.R1_SNR_dietrich_gm = est_snr_dietrich(R1,V_c1Mask,V_c6mask);
TT.R1_SNR_dietrich_wm = est_snr_dietrich(R1,V_c2Mask,V_c6mask);

TT.R2_SNR_dietrich_gm = est_snr_dietrich(R2,V_c1Mask,V_c6mask);
TT.R2_SNR_dietrich_wm = est_snr_dietrich(R2,V_c2Mask,V_c6mask);


%---------------------------------------------------------------
% CNR 
TT.MTSat_CNR = est_cnr(MTSat,V_c1Mask,V_c2Mask,V_c6mask);

TT.PD_CNR = est_cnr(PD,V_c1Mask,V_c2Mask,V_c6mask);

TT.R1_CNR = est_cnr(R1,V_c1Mask,V_c2Mask,V_c6mask);

TT.R2_CNR = est_cnr(R2,V_c1Mask,V_c2Mask,V_c6mask);

%---------------------------------------------------------------

% mSNR for GM and WM

TT.MTSat_mSNR_gm = est_mSNR(MTsat_mSNR,V_c1Mask);
TT.MTSat_mSNR_wm = est_mSNR(MTsat_mSNR,V_c2Mask);

TT.PD_mSNR_gm = est_mSNR(PD_mSNR,V_c1Mask);
TT.PD_mSNR_wm = est_mSNR(PD_mSNR,V_c2Mask);

TT.R1_mSNR_gm = est_mSNR(R1_mSNR,V_c1Mask);
TT.R1_mSNR_wm = est_mSNR(R1_mSNR,V_c2Mask);

end

function mSNR_mean = est_mSNR(img_name,V_Mask)
    % mean mSNR for the mask
    Y_img   = spm_vol(img_name);
    V_img   = double(spm_read_vols(Y_img));
    % apply mask
    V_img   = V_img.*(V_Mask./V_Mask);
    
    % get rid of negative 
    V_img(V_img(:)<0) = NaN;
    
    % mean
    mSNR_mean = mean(V_img(:),'omitnan');

end

function snr = est_snr(img_name,V_Mask)
% estimate snr 

Y_img   = spm_vol(img_name);
V_img   = double(spm_read_vols(Y_img));

V_img = V_img.*(V_Mask./V_Mask);

num_vox = sum(V_Mask(:)==1); 

snr =  mean(V_img(:),'omitnan') ./ (std(V_img(:),'omitnan') .* sqrt(num_vox ./(num_vox -1)) );

end

function snr_dietrich = est_snr_dietrich(image_name,V_Mask,V_Air)

% constant
k = sqrt(2./(4-pi));

Y_img   = spm_vol(image_name);
V_img   = double(spm_read_vols(Y_img));

V_roi   = V_img.*(V_Mask./V_Mask);
V_air   = V_img.*(V_Air./V_Air);

snr_dietrich = mean(V_roi(:),'omitnan') ./ (k .* (std(V_air(:),'omitnan')));

end

function cnr = est_cnr(image_name,V_GM_Mask,V_WM_Mask,V_Air)

Y_img   = spm_vol(image_name);
V_img   = double(spm_read_vols(Y_img));

V_GM   = V_img.*(V_GM_Mask./V_GM_Mask);
V_WM   = V_img.*(V_WM_Mask./V_WM_Mask);
V_air   = V_img.*(V_Air./V_Air);

cnr = abs(mean(V_GM(:),'omitnan')-mean(V_WM(:),'omitnan')) ./ sqrt( (std(V_GM(:),'omitnan').^2) + (std(V_WM(:),'omitnan').^2) +(std(V_air(:),'omitnan').^2)) ;
end
%------------------------------------------------------------------------
function ovol=open_it(vol,ne,nd)
    % Do a morphological opening. This consists of an erosion, followed by 
    % finding the largest connected component, followed by a dilation.

    % Do an erosion then a connected components then a dilation 
    % to get rid of stuff outside brain.
    for i=1:ne
       nvol=spm_erode(double(vol));
       vol=nvol;
    end
    nvol=connect_it(vol);
    vol=nvol;
    for i=1:nd
       nvol=spm_dilate(double(vol));
       vol=nvol;
    end

    ovol=nvol;
end


function ovol=fill_it(vol,k,thresh)
    % Do morpholigical fill. This consists of finding the largest connected 
    % component and assuming that is outside of the head. All the other 
    % components are set to 1 (in the mask). The result is then smoothed by k
    % and thresholded by thresh.
    ovol=vol;

    % Need to find connected components of negative volume
    vol=~vol;
    [vol,NUM]=spm_bwlabel(double(vol),26); 

    % Now get biggest component and assume this is outside head..
    pnc=0;
    maxnc=1;
    for i=1:NUM
       nc=size(find(vol==i),1);
       if nc>pnc
          maxnc=i;
          pnc=nc;
       end
    end

    % We know maxnc is largest cluster outside brain, so lets make all the
    % others = 1.
    for i=1:NUM
        if i~=maxnc
           ovol(vol==i)=1;
        end
    end

    spm_smooth(ovol,ovol,k);
    ovol=ovol>thresh;
end

function ovol=connect_it(vol)
    % Find connected components and return the largest one.

    [vol,NUM]=spm_bwlabel(double(vol),26); 

    % Get biggest component
    pnc=0;
    maxnc=1;
    for i=1:NUM
       nc=size(find(vol==i),1);
       if nc>pnc
          maxnc=i;
          pnc=nc;
       end
    end
    ovol=(vol==maxnc);
end
