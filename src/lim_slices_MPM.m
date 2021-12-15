function [lim_axial,lim_sagittal,lim_coronal] = lim_slices_MPM(c_seg)
    
    % using c1
    Y_img   = spm_vol(c_seg{1});
    V_img   = double(spm_read_vols(Y_img));
    
    % binarize
    V_img(V_img>0)=1;
    
    [img_x, img_y, img_z]  = size(V_img);
    
    
    % Sag 
    f_a = zeros(1,img_z);
    
    for z=1:img_z

        if sum(V_img(:,:,z))== 0 

            f_a(z)= 0; 
        else
            f_x = zeros(1,img_x);
            for x=1:img_x
                if sum(V_img(x,:,z))== 0
                    f_x(x)=0;
                else
                   f_x(x)=1;
                end
            end
            
            f_y = zeros(1,img_y);
            for y=1:img_y
                if sum(V_img(:,y,z))== 0
                    f_y(y)=0;
                else
                   f_y(y)=1;
                end
            end
            % voxel to real 
            A1 = Y_img.mat*[find(f_x, 1 ) find(f_y,1) z 1]';
            f_a(z)= A1(1);  
        end
        

    end
    lim_sagittal = [min(f_a(f_a~=0)) max(f_a(f_a~=0))];

    %----------------------------------------------------------------------
    f_b = zeros(1,img_x);
    
    for x=1:img_x
        if sum(V_img(x,:,:))== 0 
            f_b(x)= 0; 
        else
             f_z = zeros(1,img_z);
            for z=1:img_z
                if sum(V_img(x,:,z))== 0
                    f_z(z)=0;
                else
                   f_z(z)=1;
                end
            end
            
            f_y = zeros(1,img_y);
            for y=1:img_y
                if sum(V_img(x,y,:))== 0
                    f_y(y)=0;
                else
                   f_y(y)=1;
                end
            end
            
            A1 = Y_img.mat*[x find(f_y, 1 ) find(f_z,1) 1]';
            
            f_b(x)= A1(2);  
            
        end
        
    end

    lim_coronal = [min(f_b(f_b~=0)) max(f_b(f_b~=0))];
    %----------------------------------------------------------------------
    % 
    f_c = zeros(1,img_y);
    
    for y=1:img_y
        if sum(V_img(:,y,:))== 0 
            f_c(y)= 0; 
        else
                                                
            f_x = zeros(1,img_x);
            for x=1:img_x
                if sum(V_img(x,y,:))== 0
                    f_x(x)=0;
                else
                   f_x(x)=1;
                end
            end
            
            f_z = zeros(1,img_z);
            for z=1:img_z
                if sum(V_img(:,y,z))== 0
                    f_z(z)=0;
                else
                    f_z(z)=1;
                end
            end
            
            A1 = Y_img.mat*[find(f_x,1)  y find(f_z,1) 1]';
            
            f_c(y)= A1(3);  
            
        end
        
    end
    
    lim_axial = [min(f_c(f_c~=0)) max(f_c(f_c~=0))];
    
end