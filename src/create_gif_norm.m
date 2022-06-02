function out_gif_img = create_gif_norm(plot_gif)
% create the gif files  

    

    % define ouput gif folder
    out_gif_fold = fullfile(plot_gif.out_fold_img,plot_gif.subj_name_vis,plot_gif.suffix);
    if exist(out_gif_fold,'file')==0; mkdir(out_gif_fold);end
    
    % define ouput gif file
    out_gif_img = [out_gif_fold 'out_gif.gif'];
    %----------------------------------------------------------------------
    % define the filename to save plot_info
     
    plot_gif_file = fullfile(out_gif_fold,'plot_inf.mat');

% %     if exist(plot_gif_file,'file') == 0
% %         
% %         % if plot_info_file doesnt exist , save and set run_code =1
% %         if size((dir(out_gif_fold)),1)>2
% %             unix(['rm -rf ' out_gif_fold '*.*']);
% %         end
% %         save(plot_gif_file,'-struct','plot_gif')
% %         run_code = 1;
% %     
% %     else
% %        % else load the saved plot_info
% %         plot_gif_old = load(plot_gif_file);
% %         
% %         % check if its the same as the saved one, if yes set run_code = 0
% %         if isequal(plot_gif,plot_gif_old) == 1 ...
% %                 && exist(out_gif_img,'file') == 2
% %             
% %             run_code = 0 ;
% %         else
% %             % else save the new plot_info and set run_code = 1
% %             if size((dir(out_gif_fold)),1)>2
% %             	unix(['rm -rf ' out_gif_fold '*.*']);
% %             end
% %             save(plot_gif_file,'-struct','plot_gif')
% %             run_code = 1;
% %         end
% %             
% %     end
    %----------------------------------------------------------------------
    run_code =1
    if run_code == 1
        
        img_MTols   = spm_vol(plot_gif.img.MTw_OLSfit);
        img_PDols   = spm_vol(plot_gif.img.PDw_OLSfit);
        
        close all
%         
%         for j=1:length(plot_gif.slices)
        
        % define general features of plot  
        so                  = slover(img_MTols);
        so.xslices          = plot_gif.xslices;
        so.figure.Position  = plot_gif.fig_Position ;
        so.img(1).range     = [0 1000] ;
        
        % sagittal
        so.transform        = plot_gif.transform.sagittal;
        so.slicedef         = [-97.0729    0.6008   95.0483;-140.6411    0.6008  130.7319];%plot_gif.sl_def.Sagit;

        plot_gif.slices           = linspace(plot_gif.lim.sagittal(1),plot_gif.lim.sagittal(2),50);
    
     
        for j=1:length(plot_gif.slices)

            so.slices           = plot_gif.slices(j);

            so = paint(so);
            set(gca,'units','normalized')
            set(gcf,'Color','k')
            
            img_id =  sprintf('%s%05d','img',j);
            out_png = spm_file(fullfile(out_gif_fold,img_id),'ext','png');

            saveas(gcf,out_png)
        end
        
        close all;
        figure();

%         set(gcf,'Position',[97 308 1023 533]);
        set(gcf,'Position',[plot_gif.fig_Position])
        set(gca,'position',[0 0 1 1],'units','normalized');
        
       
        for j=1:length(plot_gif.slices) 
            
            loop_num = sprintf('%s%05d','loop_',j);

            montage(img_names(contains(img_names,loop_num)),'Size',[1 1])
            set(gcf,'Color','k')

            % gif
            f_frm       = getframe(gcf);
            f_img       = frame2im(f_frm);
            [M,c_map]   = rgb2ind(f_img,256);
                        
            if j == 1
                imwrite(M,c_map,out_gif_img,'gif','LoopCount',inf,'DelayTime',plot_gif.delay.begin)
            elseif j == num_frames || j == num_frames +1
                imwrite(M,c_map,out_gif_img,'gif','WriteMode','append','DelayTime',plot_gif.delay.end/2)
            else
                imwrite(M,c_map,out_gif_img,'gif','WriteMode','append','DelayTime',plot_gif.delay.mid) 
            end

        end

        close all

%         % delete temp folder
%         unix(['rm -rf ' temp_fold]);
% %     end
        
        
    end
    % ------------------------------------------------------------------

%         close all
% 
%         for i=1:length(k2) 
% 
%             t_prop = k1(i);
%             c_prop = k2(i);
% 
%     %         close all
% 
%             so                  = slover([back_img front_img]);
%             so.xslices          = plot_gif.xslices;
%             so.img(1).range     = so.img(1).range;
%             so.img(2).range     = so.img(2).range;
%             so.img(2).cmap      = plot_gif.cmap2;
%             so.figure.Position  = plot_gif.fig_Position;
%             so.img(1).prop      = t_prop;
%             so.img(2).prop      = c_prop;
%             
%             if i<10
%                 loop_num = ['loop_0' num2str(i)];
%             elseif i<100
%                 loop_num = ['loop_' num2str(i)];
%             end
%             
%             % axial
%             so.transform     = plot_gif.transform.axial;
%             so.slicedef      = plot_gif.sl_def.Axial;
%             slices           = linspace(plot_gif.lim.axial(1),plot_gif.lim.axial(2),num_images_disp);%-47:14:65
% 
%             for j = 1:length(slices)
% 
%                 so.slices   = slices(j);
%                 so = paint(so);
% 
%                 set(gca,'units','normalized')
%                 set(gcf,'Color','k')
% 
%                 if j<10
%                     out_png = [temp_fold loop_num '_axial_img00' num2str(j) '.png'];
%                 elseif j<100
%                     out_png = [temp_fold loop_num '_axial_img0' num2str(j) '.png'];
%                 end
%                 saveas(gcf,out_png)
%                 count = count +1;
%                 img_names{count} = out_png;
%             end
% 
%             % sagittal
%             so.transform        = plot_gif.transform.sagittal;
%             so.slicedef         = plot_gif.sl_def.Sagit;
% 
%             slices           = linspace(plot_gif.lim.sagittal(1),plot_gif.lim.sagittal(2),num_images_disp);
% 
%             for j = 1:length(slices)
%                 so.slices   = slices(j);
%                 so = paint(so);
%     %         print_fig(so)
%                 set(gca,'units','normalized')
%                 set(gcf,'Color','k')
% 
%                 if j<10
%                     out_png = [temp_fold loop_num '_sagittal_img00' num2str(j) '.png'];
%                 elseif j<100
%                     out_png = [temp_fold loop_num '_sagittal_img0' num2str(j) '.png'];
%                 end
%                 saveas(gcf,out_png)
%                 count = count +1;
%                 img_names{count} = out_png;
%             end
%             
%             % coronal
%             so.transform        = plot_gif.transform.coronal;
%             so.slicedef         = plot_gif.sl_def.Coron;
% 
%             slices           = linspace(plot_gif.lim.coronal(1),plot_gif.lim.coronal(2),num_images_disp);%(-55:13:60);
% 
%             for j = 1:length(slices)
%                 so.slices   = slices(j);
%                 so = paint(so);
%     %         print_fig(so)
%                 set(gca,'units','normalized')
%                 set(gcf,'Color','k')
% 
%                 if j<10
%                     out_png = [temp_fold loop_num '_coronal_img00' num2str(j) '.png'];
%                 elseif j<100
%                     out_png = [temp_fold loop_num '_coronal_img0' num2str(j) '.png'];
%                 end
%                 saveas(gcf,out_png)
%                 count = count +1;
%                 img_names{count} = out_png;
%             end
% 
%         end
%         
%         close all
% 
%         % combine images    
% 
%         figure();
% 
%         set(gcf,'Position',[97 308 1023 533]);
%         set(gca,'position',[0 0 1 1],'units','normalized');
%         
%         mm = [(1:num_frames) fliplr(1:num_frames)];
%         
%         for j=1:length(mm)  
% 
%             if j<10
%                 loop_num = ['loop_0' num2str(mm(j))];
%             elseif j<100
%                 loop_num = ['loop_' num2str(mm(j))];
%             end
% 
%             montage(img_names(contains(img_names,loop_num)),'Size',[3 num_images_disp])
%             set(gcf,'Color','k')
% 
%             % gif
%             f_frm       = getframe(gcf);
%             f_img       = frame2im(f_frm);
%             [M,c_map]   = rgb2ind(f_img,256);
%                         
%             if j == 1
%                 imwrite(M,c_map,out_gif_img,'gif','LoopCount',inf,'DelayTime',plot_gif.delay.begin)
%             elseif j == num_frames || j == num_frames +1
%                 imwrite(M,c_map,out_gif_img,'gif','WriteMode','append','DelayTime',plot_gif.delay.end/2)
%             else
%                 imwrite(M,c_map,out_gif_img,'gif','WriteMode','append','DelayTime',plot_gif.delay.mid) 
%             end
% 
%         end
% 
%         close all
% 
%         % delete temp folder
%         unix(['rm -rf ' temp_fold]);
%     end

end