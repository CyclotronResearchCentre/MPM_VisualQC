function out_png_fold = plot_Single_image(plot_info)
%==========================================================================
%
% PURPOSE: to images
% INPUT  -
%   -plot_info
%       -suffix        - folder name for storing output images
%       -sl_def        - slice defenition
%       -transform     - axial or coronal or sagittal 
%       -xslices       - 1 (slices to display)
%       -slices        - range of slices
%       -fig_Position  - figure position
%       -fig_cmap      - colour map;
%       -range         - range for the intensity
%       -T1            - image inputr file; (T1 for historic reasons, TO DO- replce it by in_img )
%       -out_fold_img  - out_fold_img;
%       -subj_name_vst - prefix for the outfput files
% 
% OUTPUT 
%   out_png_fold        - out folder containing images 
%==========================================================================___________________________________________________________
% Cyclotron Research Centre - University of Liège
% Siya Sherif 
% 09DEC2021 v.01 
% 15AUG2022 edit for the spm batch siya
%==========================================================================

  
    % define out folder , create folder if it doesnt exist
    out_png_fold = fullfile(plot_info.out_fold_img,plot_info.subj_name_vst,plot_info.suffix);
    
    
    if ~exist(out_png_fold,'dir'); mkdir(out_png_fold); end
    
    % define the filename to save plot_info
    plot_info_file = fullfile(out_png_fold,'plot_inf.mat');

    if ~exist(plot_info_file,'file')
        
        % if plot_info_file doesnt exist , save and set run_code =1
        if size((dir(out_png_fold)),1)>2
            unix(['rm -rf ' out_png_fold '*.*']);
        end
        save(plot_info_file,'-struct','plot_info')
        run_code = 1;
    
    else
       % else load the saved plot_info
        plot_info_old = load(plot_info_file);
        
        % check if its the same as the saved one, if yes set run_code = 0
        if isequal(plot_info,plot_info_old) == 1 ...
            && size(spm_select('List',out_png_fold,'.*.png'),1) == length(plot_info.slices)
        
            run_code = 0 ;
        else
            % else save the new plot_info and set run_code = 1
            if size((dir(out_png_fold)),1)>2             
                tmp_list = spm_select('FPList',out_png_fold,'.*');    
                for k=1:size(tmp_list,1)
                    delete(strtrim(tmp_list(k,1:end)));
                end
            end
            save(plot_info_file,'-struct','plot_info')
            run_code = 1;
        end
            
    end
    
    if run_code == 1
        %read T1
        img_T1_vol = spm_vol(plot_info.T1);
        
%         close all
        fg = spm_figure('GetWin','Graphics');
        spm_figure('Clear',fg);
        spm_figure('Close',fg);
        
        ff = figure(45);
        so = slover(img_T1_vol);

        so.xslices          = plot_info.xslices ;
        so.transform        = plot_info.transform;
        so.figure.Position  = plot_info.fig_Position;
        so.img.range        = plot_info.range;%[0 4087]; % ss edit keeping the same range so.img.range/3;
        so.slicedef         = plot_info.sl_def;

        for j=1:length(plot_info.slices)

            so.slices           = plot_info.slices(j);
            so.img(1).cmap      = plot_info.fig_cmap;
            so = paint(so);

            set(gca,'units','normalized')
            set(gca,'Color','k')
            set(gcf,'Color','k')
            
            img_id =  sprintf('%s%05d','img',j);
      
            out_png = spm_file(fullfile(out_png_fold,img_id),'ext','png');

            saveas(gcf,out_png)
        end

        close(ff) 
    end
    
end