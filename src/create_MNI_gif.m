function out_gif_fold = create_MNI_gif(plot_gif)
% create the gif files  

    

    % define ouput gif folder
    out_gif_fold = fullfile(plot_gif.out_fold_img,plot_gif.subj_name_vst,plot_gif.suffix);
    if exist(out_gif_fold,'file')==0; mkdir(out_gif_fold);end
    
    
    %----------------------------------------------------------------------
    % define the filename to save plot_info
     
    plot_gif_file = fullfile(out_gif_fold,'plot_inf.mat');

    if ~exist(plot_gif_file,'file') 
        
        % if plot_info_file doesnt exist , save and set run_code =1
        tmp_list = spm_select('FPList',out_gif_fold,'.*');    
        for k=1:size(tmp_list,1)
            delete(strtrim(tmp_list(k,1:end)));
        end
        
        save(plot_gif_file,'-struct','plot_gif')
        run_code = 1;
    
    else
       % else load the saved plot_info
        plot_gif_old = load(plot_gif_file);
        
        % check if its the same as the saved one, if yes set run_code = 0
        if isequal(plot_gif,plot_gif_old) == 1 ...
                && (size(spm_select('FPlist',out_gif_fold,'.*.gif') ,1)==size(plot_gif.img,1)) 
            
            run_code = 0 ;
        else
            % else save the new plot_info and set run_code = 1
            if size((dir(out_gif_fold)),1)>2
            	tmp_list = spm_select('FPList',out_gif_fold,'.*');    
                for k=1:size(tmp_list,1)
                    delete(strtrim(tmp_list(k,1:end)));
                end
            end
            save(plot_gif_file,'-struct','plot_gif')
            run_code = 1;
        end
            
    end
    %----------------------------------------------------------------------
%     run_code =1
    if run_code == 1
        
        for k=1:size(plot_gif.img ,1)
                      
            tmp_img = strtrim(plot_gif.img(k,1:end));
            
% % %             bnam = spm_file(tmp_img,'basename');
% % %             if strcmp(bnam(1:4),'wap1') || strcmp(bnam(1:4),'wap2')
% % %                 plot_gif.range = [0 1];
% % %             end
%             tmp_suff = ['tmp_' sprintf('%s_%02d','echo',k) '_axial'];
%             
            close all
            
            img_img_vol = spm_vol(tmp_img);
        
            so = slover(img_img_vol);

            so.xslices          = plot_gif.xslices ;
            so.transform        = plot_gif.transform;
            so.figure.Position  = plot_gif.fig_Position;
            so.img.range        = plot_gif.range;%[0 4087]; % ss edit keeping the same range so.img.range/3;
            so.slicedef         = plot_gif.sl_def;
            
            for j=1:length(plot_gif.slices)

                so.slices           = plot_gif.slices(j);
                so.img(1).cmap      = plot_gif.fig_cmap;
                so = paint(so);

                set(gca,'units','normalized')
                set(gca,'Color','k')
                set(gcf,'Color','k')
            
                img_id =  sprintf('%s%05d','img_',k);
                
                % define ouput gif file
                out_gif_img = spm_file(fullfile(out_gif_fold,img_id),'ext','gif');
      
%                 out_png = spm_file(fullfile(out_gif_fold,img_id),'ext','png');

%                 saveas(gcf,out_png)
%             end
% 
%             close all
%             
%             % create gif 
%             figure();
% 
%             set(gcf,'Position',[plot_gif.fig_Position])
%             set(gca,'position',[0 0 1 1],'units','normalized');
% 
% 
%             for j=1:length(plot_gif.slices) 
% 
%                 loop_num = sprintf('%s%05d','loop_',j);
% 
%                 montage(img_names(contains(img_names,loop_num)),'Size',[1 1])
%                 set(gcf,'Color','k')

                % gif
                f_frm       = getframe(gcf);
                f_img       = frame2im(f_frm);
                [M,c_map]   = rgb2ind(f_img,256);

                if j == 1
                    imwrite(M,c_map,out_gif_img,'gif','LoopCount',inf,'DelayTime',plot_gif.delay.begin)
                elseif j == length(plot_gif.slices)
                    imwrite(M,c_map,out_gif_img,'gif','WriteMode','append','DelayTime',plot_gif.delay.end/2)
                else
                    imwrite(M,c_map,out_gif_img,'gif','WriteMode','append','DelayTime',plot_gif.delay.mid) 
                end

            end

            close all

        end
            
    end
    % ------------------------------------------------------------------

end