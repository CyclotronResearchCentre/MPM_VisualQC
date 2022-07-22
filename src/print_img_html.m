function [img_count] = print_img_html(fid_html,img_count,imgA,out_img_folder,subj_name_visit,folder_PP)    
% to print the images in the html file
% siya sherif
% 20 06 2019

    fprintf(fid_html,'<p style="clear:left;"> %s</p>\n',imgA);
    
    % list images
%     img_list = dir([out_img_folder '*.png']);
    
    img_list = spm_select('FPList',out_img_folder,'.*.png$');
    if isempty(img_list)
        img_list = spm_select('FPList',out_img_folder,'.*.gif$');
    end
    
    fprintf(fid_html,'<div class="row">\n');
    
    for i=1:size(img_list,1)
        clear path_tmp;
        
        img_count = img_count +1;

        img_id =  sprintf('%s%05d','img',img_count);

        fprintf(fid_html,'  <div class="column">\n');
%         fprintf(fid_html,'    <img id="%s" src="%s" alt="Nature" style="width:100%%"> \n',img_id,['../out_fold_img/' subj_name_visit '/' folder_PP img_list(i).name]);
            
        path_tmp = fullfile('..','out_fold_img',subj_name_visit,folder_PP,spm_file(strtrim(img_list(i,:)),'filename'));
        
        fprintf(fid_html,'    <img id="%s" src="%s" alt="Nature" style="width:100%%"> \n',img_id,path_tmp);
        fprintf(fid_html,'  </div>\n');

    end
    fprintf(fid_html,'</div>\n');
    
    % link to list of figures
%     fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');

end