function [out_c1_cont_png_folder, out_c2_cont_png_folder, out_c3_cont_png_folder] =  create_contour_seg(plot_var)
% author    : Siya Sherif 
% date      : december 2018, 
% v2 ver    : 17 jan 2019 
% to create the segmented c1 c2 c3 overlayed on T1 
    
    % define/create ouput folders for the t1 + c segmentation combos
   
    out_c1_cont_png_folder = fullfile(plot_var.out_fold,plot_var.subj_name_vst,['c1_' plot_var.suffix ]);
    if exist(out_c1_cont_png_folder,'dir') == 0;mkdir(out_c1_cont_png_folder);end
    
    out_c2_cont_png_folder = fullfile(plot_var.out_fold,plot_var.subj_name_vst,['c2_' plot_var.suffix ]);
    if exist(out_c2_cont_png_folder,'dir') == 0;mkdir(out_c2_cont_png_folder);end

    % commented for c3    
    out_c3_cont_png_folder = fullfile(plot_var.out_fold,['c3_' plot_var.suffix]);

% %     % commented for c3    
% %     if exist(out_c3_cont_png_folder) == 0;mkdir(out_c3_cont_png_folder);end
    
    
    
    % ---------------------------------------------------------------------
    % c1 contour for c1
   
    % define the filename to save 
    plot_c1_info_file = fullfile(out_c1_cont_png_folder,'plot_inf.mat');

    if exist(plot_c1_info_file,'file') == 0
        
        if size((dir(out_c1_cont_png_folder)),1)>2
            unix(['rm -rf ' out_c1_cont_png_folder '*.*']);
        end
        save(plot_c1_info_file,'-struct','plot_var')
        run_code = 1;
    
    else
        plot_var_old = load(plot_c1_info_file);
        
        if isequal(plot_var,plot_var_old) == 1 ...
            && size(spm_select('List',out_c1_cont_png_folder,'.*.png'),1) == length(plot_var.slices) 
        
            run_code = 0 ;
            
        else
            
            if size((dir(out_c1_cont_png_folder)),1)>2
                unix(['rm -rf ' out_c1_cont_png_folder '*.*']);
            end
            save(plot_c1_info_file,'-struct','plot_var')
            run_code = 1;
        end
            
    end
    
    if run_code == 1
        
        close all
        
        T1 = spm_vol(plot_var.T1);
        c1 = spm_vol(plot_var.c_seg{1});
        c2 = spm_vol(plot_var.c_seg{2});
        c3 = spm_vol(plot_var.c_seg{3});
    
        % define general features of plot  
        so                  = slover([T1 c1 c2 c3]);
        so.slicedef         = plot_var.sl_def;
        so.xslices          = plot_var.xslices;
        so.transform        = plot_var.transform;
        so.figure.Position  = plot_var.fig_Position ;
        so.img(2).cmap      = plot_var.cmap2;
        so.img(3).cmap      = plot_var.cmap3;
        so.img(4).cmap      = plot_var.cmap4 ;
        so.img(1).range     = plot_var.T1range ;%so.img.range/3;%[0 4087]; % ss edit keeping the same range so.img.range/3;
    
        so.img(1).prop      = plot_var.t_prop;
        so.img(2).prop      = plot_var.c_prop;
        so.img(3).prop      = 0;
        so.img(4).prop      = 0;

        for j=1:length(plot_var.slices)

            so.slices           = plot_var.slices(j);

            so = paint(so);
            set(gca,'units','normalized')
            set(gcf,'Color','k')
            
            img_id =  sprintf('%s%05d','img',j);
            out_png = spm_file(fullfile(out_c1_cont_png_folder,img_id),'ext','png');

            saveas(gcf,out_png)
        end
    end
    % ---------------------------------------------------------------------
    % c2 contour
    
    % define the filename to save 
    plot_c2_info_file = fullfile(out_c2_cont_png_folder,'plot_inf.mat');

    if exist(plot_c2_info_file,'file') == 0
        
        unix(['rm -rf ' out_c2_cont_png_folder '*.*']);
        save(plot_c2_info_file,'-struct','plot_var')
        run_code = 1;
    
    else
        plot_var_old = load(plot_c2_info_file);
        
        if isequal(plot_var,plot_var_old) == 1 ...
            && length(spm_select('List',out_c2_cont_png_folder,'.*.png')) ==length(plot_var.slices)
        
            run_code = 0 ;
        else
            unix(['rm -rf ' out_c2_cont_png_folder '*.*']);
            save(plot_c2_info_file,'-struct','plot_var');
            run_code = 1;
        end
            
    end
    if run_code ==1 
        so.img(1).prop      = plot_var.t_prop;
        so.img(2).prop      = 0;
        so.img(3).prop      = plot_var.c_prop;
        so.img(4).prop      = 0;

        for j=1:length(plot_var.slices)

            so.slices           = plot_var.slices(j);

            so = paint(so);
            set(gca,'units','normalized');
            set(gcf,'Color','k');
            
            img_id =  sprintf('%s%05d','img',j);
            out_png = spm_file(fullfile(out_c2_cont_png_folder,img_id),'ext','png');
            saveas(gcf,out_png)

        end
    end

% % %     % c3 is commented at the moment   
% % %     % c3 contour
% % %     
% % %     so.img(1).prop      = plot_var.t_prop;
% % %     so.img(2).prop      = 0;
% % %     so.img(3).prop      = 0;
% % %     so.img(4).prop      = plot_var.c_prop ;
% % %     
% % %     for j=1:length(plot_var.slices)
% % %         
% % %         so.slices           = plot_var.slices(j);
% % %         
% % %         so = paint(so);
% % %         set(gca,'units','normalized')
% % %         set(gcf,'Color','k')
% % %         
% % %         if j<10
% % %             out_png = [out_c2_cont_png_folder 'img00' num2str(j) '.png'];
% % %         elseif j<100
% % %             out_png = [out_c2_cont_png_folder 'img0' num2str(j) '.png'];
% % %         elseif j<1000
% % %             out_png = [out_c3_cont_png_folder 'img' num2str(j) '.png'];
% % %         end
% % %         saveas(gcf,out_png)
% % %         
% % %     end
    
    close all

end