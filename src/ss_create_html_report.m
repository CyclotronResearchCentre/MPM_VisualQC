function ss_create_html_report(list_qc_json,subj_info_table,out_main_path)

% define tranformation matrix
transform.axial     = [1 0 0 0 ; 0 1 0 0 ;  0 0 1 0 ; 0 0 0 1 ];
transform.coronal   = [1 0 0 0 ; 0 0 1 0 ;  0 1 0 0 ; 0 0 0 1 ];
transform.sagittal  = [0 -1 0 0 ; 0 0 1 0 ;  1 0 0 0 ; 0 0 0 1 ];

out_main_path = fullfile(out_main_path);
if ~exist(out_main_path,'dir');mkdir(qc_html);end


% out folder images
out_fold_img = fullfile(out_main_path,'out_fold_img');
if ~exist(out_fold_img,'dir'); mkdir(out_fold_img);end

% out folder html
out_fold_html = fullfile(out_main_path,'output_html');
if ~exist(out_fold_html,'dir');mkdir(out_fold_html);end
    

% get subject name COF subj name ; TO DO BIDS naming should take care of
subj_name_visit = list_qc_json(strfind(list_qc_json,'COF'):strfind(list_qc_json,'COF')+5)  ;

fprintf('running : %s \n',subj_name_visit); % for qsub
    
% MPMs
% TO DO define Results path and check it validity
img_MPM_MTsat   = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'path'),'.*_MTsat.nii');
img_MPM_PD      = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'path'),'.*_PD.nii');
img_MPM_R1      = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'path'),'.*_R1.nii');
img_MPM_R2s_OLS = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'path'),'.*_R2s_OLS.nii');

% c1;c2;c3

c_seg{1} = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'filename','Segmentation'),'^c1.*.nii');
c_seg{2} = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'filename','Segmentation'),'^c2.*.nii');
c_seg{3} = spm_select('FPList',spm_file(spm_file(list_qc_json,'path'),'filename','Segmentation'),'^c3.*.nii');

% =====================================================================
% generating png images startes here  
    
% get the axial range 
[lim.axial,lim.sagittal,lim.coronal] = lim_slices_MPM(c_seg);
% ----------------------------------------------------------------------

% plot MPM axial structural
                           
plot_info.suffix        = 'MTsat_axial';
plot_info.sl_def        = [-90 1 89;-127 1 128];
plot_info.transform     = transform.axial;
plot_info.xslices       = 1;
plot_info.slices        = linspace(lim.axial(1),lim.axial(2),14);
%     plot_info.fig_Position  = [172   605   186   263];
plot_info.fig_Position  = [172   578   183   290];
plot_info.fig_cmap      = 'gray';
plot_info.range         = [0 2];
plot_info.T1            = img_MPM_MTsat;
plot_info.out_fold_img  = out_fold_img;
plot_info.subj_name_vst = subj_name_visit;
    
out_MTsat_axial_png_folder = plot_Single_image(plot_info);

% ----------------------------------------------------------------------
% ----------------------------------------------------------------------
% HTML
% ----------------------------------------------------------------------


% set name of html
html_name = spm_file(fullfile(out_fold_html,subj_name_visit),'ext','html');

% rewriting html need admin privilages, 
if exist(html_name,'file')==2
    unix(['rm -rf ' html_name]);
end

% fid_html  = fopen(html_name,'w');
% 
% % get the header codes for html
% fidin_html_beginCodes = fopen(html_begin_codes,'r');
% while ~feof(fidin_html_beginCodes)
%     this_line = fgets(fidin_html_beginCodes);
%     fprintf(fid_html,'%s',this_line);
% end
% fclose(fidin_html_beginCodes);

% fprintf(fid_html,'<h2> %s </h2> \n',subj_name_visit);

fprintf(fid_html,'<!DOCTYPE html> \n');
fprintf(fid_html,'<html> \n');

% page title
fprintf(fid_html,'<head> \n');
fprintf(fid_html,'<title> %s </title> \n',subj_name_visit);
fprintf(fid_html,'</head> \n');

% body of html
fprintf(fid_html,'<body> \n');

fprintf(fid_html,'<h3> %s </h3> \n',subj_name_visit);
fprintf(fid_html,'<h5>structure T1</h5> \n');

% insert image in html

%--------------------------------------------------------------------------
 % -------------------------------------------------------------------
% figures

fprintf(fid_html,'\n');   
%----------------------------------------------------------------------

% Style for images

fprintf(fid_html,'<style>\n');
fprintf(fid_html,'* {\n');
fprintf(fid_html,'  box-sizing: border-box;\n');
fprintf(fid_html,'}\n');

fprintf(fid_html,'.column {\n');
fprintf(fid_html,'  float: left;\n');
fprintf(fid_html,'  width: 12%%;\n');
fprintf(fid_html,'  padding: 0px;\n');
fprintf(fid_html,'}\n');

fprintf(fid_html,'/* Clearfix (clear floats) */\n');
fprintf(fid_html,'.row::after {\n');
fprintf(fid_html,'  content: "";\n');
fprintf(fid_html,'  clear: both;\n');
fprintf(fid_html,'  display: table;\n');
fprintf(fid_html,'}\n');

% this is for zoom
fprintf(fid_html,'/* The Modal (background) */\n');
fprintf(fid_html,'.modal {\n');
fprintf(fid_html,'  display: none; /* Hidden by default */\n');
fprintf(fid_html,'  position: fixed; /* Stay in place */\n');
fprintf(fid_html,'  z-index: 1; /* Sit on top */\n');
fprintf(fid_html,'  padding-top: 100px; /* Location of the box */\n');
fprintf(fid_html,'  left: 0;\n');
fprintf(fid_html,'  top: 0;\n');
fprintf(fid_html,'  width: 100%%; /* Full width */\n');
fprintf(fid_html,'  height: 100%%; /* Full height */\n');
fprintf(fid_html,'  overflow: auto; /* Enable scroll if needed */\n');
fprintf(fid_html,'  background-color: rgb(0,0,0); /* Fallback color */\n');
fprintf(fid_html,'  background-color: rgba(0,0,0,0.9); /* Black w/ opacity */\n');
fprintf(fid_html,'}\n');

fprintf(fid_html,'/* Modal Content (image) */\n');
fprintf(fid_html,'.modal-content {\n');
fprintf(fid_html,'  margin: auto;\n');
fprintf(fid_html,'  display: block;\n');
fprintf(fid_html,'  width: 80%%;\n');
fprintf(fid_html,'  max-width: 700px;\n');
fprintf(fid_html,'}\n');

fprintf(fid_html,'/* The Close Button */\n');
fprintf(fid_html,'.close {\n');
fprintf(fid_html,'  position: absolute;\n');
fprintf(fid_html,'  top: 15px;\n');
fprintf(fid_html,'  right: 35px;\n');
fprintf(fid_html,'  color: #f1f1f1;\n');
fprintf(fid_html,'  font-size: 40px;\n');
fprintf(fid_html,'  font-weight: bold;\n');
fprintf(fid_html,'  transition: 0.3s;\n');
fprintf(fid_html,'}\n');

fprintf(fid_html,'</style>\n');
%----------------------------------------------------------------------
% % % % % % style for table 
% % % % % 
% % % % % fprintf(fid_html,'<style>\n');
% % % % % fprintf(fid_html,'table {\n');
% % % % % fprintf(fid_html,'  font-family: arial, sans-serif;\n');
% % % % % fprintf(fid_html,'  border-collapse: collapse;\n');
% % % % % fprintf(fid_html,'  width: 100%;\n');
% % % % % fprintf(fid_html,'}\n');
% % % % % 
% % % % % fprintf(fid_html,'td, th {\n');
% % % % % fprintf(fid_html,'  border: 1px solid #dddddd;\n');
% % % % % fprintf(fid_html,'  text-align: left;\n');
% % % % % fprintf(fid_html,'  padding: 8px;\n');
% % % % % fprintf(fid_html,'}\n');
% % % % % 
% % % % % %     fprintf(fid_html,'tr:nth-child(even) {\n');
% % % % % %     fprintf(fid_html,'  background-color: #dddddd;\n');
% % % % % fprintf(fid_html,'}\n');
% % % % % fprintf(fid_html,'</style>\n');
% % % % % % end of style table 
    
    %----------------------------------------------------------------------
% % % % %     % for the jump to content 
% % % % %     fprintf(fid_html,'<h3>List of Figures</h3>\n');
% % % % %     fprintf(fid_html,'<a id="List_full"</a>\n');
% % % % %     
% % % % %     fprintf(fid_html,'<table>\n');
% % % % % 
% % % % %     fprintf(fid_html,'  <tr>\n');
% % % % %     fprintf(fid_html,'    <td><a href="#T1_axial">T1 Axial</a></td>\n');
% % % % %     fprintf(fid_html,'    <td><a href="#T1_Coronal">T1 Coronal</a></td>\n');
% % % % %     fprintf(fid_html,'    <td><a href="#T1_Sagittal">T1 Sagittal</a></td>\n');
% % % % %     
% % % % %    
% % % % %     fprintf(fid_html,'  </tr>\n'); 
% % % % %     
% % % % %      if exist(img_hypo,'file')==2
% % % % %          % if fdg is present
% % % % %         fprintf(fid_html,'  <tr>\n');
% % % % %         fprintf(fid_html,'    <td><a href="#hypothalamus_Axi">T1 + hypothalamus Axial</a></td>\n');
% % % % %         fprintf(fid_html,'    <td><a href="#hypothalamus_Cor">T1 + hypothalamus Coronal</a></td>\n');
% % % % %         fprintf(fid_html,'    <td><a href="#hypothalamus_Sag">T1 + hypothalamus Sagittal</a></td>\n');
% % % % %         
% % % % % %         fprintf(fid_html,'    <td><a href="#FDG_T1_gif"> T1 + FDG gif</a></td>\n');
% % % % % 
% % % % %         fprintf(fid_html,'  </tr>\n');
% % % % %         
% % % % %      else
% % % % %          
% % % % %         fprintf(fid_html,'  <tr>\n');
% % % % %         fprintf(fid_html,'    <td><a href="#missing_hypothalamus"> missing hypothalamus</a></td>\n');
% % % % %         fprintf(fid_html,'  </tr>\n');      
% % % % %      end

%----------------------------------------------------------------------
img_count   = 0;

% Insert T1 axial

% Hyperlink 
fprintf(fid_html,'<a id="T1_axial"</a>\n');

fprintf(fid_html,'<h3>Structure T1 Axial</h3>\n');

fprintf(fid_html,'<p>T1 images in axial plane:</p>\n');

[img_count] = print_img_html(fid_html,img_count,img_MPM_MTsat,out_MTsat_axial_png_folder,subj_name_visit,'/MTsat_axial/');



%end of html
fprintf(fid_html,'\n');

% for  zooming in the image 
fprintf(fid_html,'<!-- The Modal -->\n');
fprintf(fid_html,'<div id="myModal" class="modal">\n');
fprintf(fid_html,'  <span class="close">&times;</span>\n');
fprintf(fid_html,'  <img class="modal-content" id="img01">\n');
fprintf(fid_html,'  <div id="caption"></div>\n');
fprintf(fid_html,'</div>\n');

fprintf(fid_html,'<script>\n');

fprintf(fid_html,'// Get the modal\n');
fprintf(fid_html,'var modal = document.getElementById("myModal");\n');
fprintf(fid_html,'var modalImg = document.getElementById("img01");\n');


fprintf(fid_html,'// Get the image and insert it inside the modal - use its "alt" text as a caption\n');

for k = 1:img_count

    if k < 10
        img_num = ['000' num2str(k)];
    elseif k<100
        img_num = ['00' num2str(k)];
    elseif k<1000
        img_num = ['0' num2str(k)];
    elseif k<10000
        img_num = [num2str(k)];
    end

    fprintf(fid_html,'var img%s = document.getElementById("img_%s");\n',img_num,img_num);

    fprintf(fid_html,'img%s.onclick = function(){\n',img_num);
    fprintf(fid_html,'  modal.style.display = "block";\n');
    fprintf(fid_html,'  modalImg.src = this.src;\n');
    fprintf(fid_html,'  captionText.innerHTML = this.alt;\n');
    fprintf(fid_html,'}\n');
end

fprintf(fid_html,'// Get the <span> element that closes the modal\n');
fprintf(fid_html,'var span = document.getElementsByClassName("close")[0];\n');

fprintf(fid_html,'// When the user clicks on <span> (x), close the modal\n');
fprintf(fid_html,'span.onclick = function() { \n');
fprintf(fid_html,'  modal.style.display = "none";\n');
fprintf(fid_html,'}\n');

fprintf(fid_html,'</script>\n');    
    
%----------------------------------------------------------------------
% closing html 
fprintf(fid_html,'</body> \n');
fprintf(fid_html,'</html> \n');

fclose(fid_html);

    

end