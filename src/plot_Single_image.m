function out_png_fold = plot_Single_image(plot_info)
  
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
                unix(['rm -rf ' out_png_fold '*.*']);         
            end
            save(plot_info_file,'-struct','plot_info')
            run_code = 1;
        end
            
    end
    
    if run_code == 1
        %read T1
        img_T1_vol = spm_vol(plot_info.T1);
        
        close all
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

            if j<10
                out_png = fullfile(out_png_fold,['img00' num2str(j) '.png']);
            elseif j<100
                out_png = fullfile(out_png_fold,['img0' num2str(j) '.png']); 
            elseif j<1000
                out_png = fullfile(out_png_fold,['img' num2str(j) '.png']);
            end
            saveas(gcf,out_png)
        end

        close all
    end
    
end