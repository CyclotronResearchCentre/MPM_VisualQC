function [out_png_fold,b1_reslice] = plot_Single_image_b1(plot_info)
  
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
        
        temp_t1 =  spm_file(plot_info.T1,'path',out_png_fold);
        temp_b1 =  spm_file(plot_info.b1,'path',out_png_fold);
        
        
        
        b1_reslice = spm_file(temp_b1,'suffix','_reslice');
        
        if ~exist(b1_reslice,'file')
            
            spm_copy(plot_info.T1,temp_t1)
            spm_copy(plot_info.b1,temp_b1)
        
            spm('defaults','pet');
            global defaults;
            spm_jobman('initcfg');
            
            clear matlabbatch;

            matlabbatch{1}.spm.util.imcalc.input = {temp_t1,temp_b1}';
            matlabbatch{1}.spm.util.imcalc.output = spm_file(b1_reslice,'filename');
            matlabbatch{1}.spm.util.imcalc.outdir = {spm_file(b1_reslice,'path')};
            matlabbatch{1}.spm.util.imcalc.expression = 'i2';
            matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{1}.spm.util.imcalc.options.mask = 0;
            matlabbatch{1}.spm.util.imcalc.options.interp = 1;
            matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

            batch_file = fullfile(out_png_fold,['batch_b1_reslice_job.m']);

            [job_id, mod_job_idlist] = cfg_util('initjob',matlabbatch);
            cfg_util('savejob', job_id, batch_file);

            output_part = spm_jobman('run',matlabbatch);

            clear matlabbatch;
            
            delete(temp_t1)
            delete(temp_b1)
        end

        
        
        %read b1 resliced 
        img_b1_vol = spm_vol(b1_reslice);
        
        close all
        so = slover(img_b1_vol);

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

        close all
        
    else
        temp_b1 =  spm_file(plot_info.b1,'path',out_png_fold);
        b1_reslice = spm_file(temp_b1,'suffix','_reslice');
    end
    
end