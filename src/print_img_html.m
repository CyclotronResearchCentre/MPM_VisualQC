function [img_count] = print_img_html(fid_html,img_count,imgA,out_img_folder,subj_name_visit,folder_PP)    
% to print the images in the html file
% siya sherif
% 20 06 2019

    fprintf(fid_html,'<p>%s</p>\n',imgA);
    
    img_list = dir([out_img_folder '*.png']);

    fprintf(fid_html,'<div class="row">\n');
    
    for i=1:length(img_list)
        
        img_count = img_count +1;

        if img_count < 10
            img_id = ['img_000' num2str(img_count)];
        elseif img_count<100
            img_id = ['img_00' num2str(img_count)];
        elseif img_count<1000
            img_id = ['img_0' num2str(img_count)];
        elseif img_count<10000
            img_id = ['img_' num2str(img_count)];
        end

        fprintf(fid_html,'  <div class="column">\n');
%         fprintf(fid_html,'    <img id="%s" src="%s" alt="Nature" style="width:100%%"> \n',img_id,['../out_fold_img/' subj_name_visit folder_PP img_list(i).name]);
        fprintf(fid_html,'    <img id="%s" src="%s" alt="Nature" style="width:100%%"> \n',img_id,['../out_fold_img/' subj_name_visit '/' folder_PP img_list(i).name]);
        fprintf(fid_html,'  </div>\n');

    end
    fprintf(fid_html,'</div>\n');
    
    % link to list of figures
    fprintf(fid_html,'<a href="#List_full">List of Figures</a>\n');
    
end