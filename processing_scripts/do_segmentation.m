function do_segmentation(pts,frame_img,frame_ctr,res_folder1)
% generate a mask label for a video frame from the corresponding facial landmarks

% the generate mask is in RGB space, you still need to convert it
% pixel-wisely to the actual class label

% pst: the 68 landmark points which can be loaded from the landmark file of 300VW using 'LoadPts.m'
% frame_img: the video frame image 
% frame_ctr: the video frame index
% res_folder1: the folder to save the generated frame mask

% define a colour set for each facial component
col = {[1 0 0],[0 1 0],[1 1 0],[0 1 1],[0 0 1],[1 0 1],[0 0 0]};

% save name and save path of the generated mask
save_name = [sprintf('%06d', frame_ctr),'.png'];
save_path1 = [res_folder1,save_name];

% the index of eyelids in landmark points
lid1_id_up = [37:40];
lid1_id_down = [40:42,37];
lid2_id_up = [43:46];
lid2_id_down = [46:48,43];

% interpolate eyelid regions
[lid1_xx_up, lid1_yy_up]=interpolate_xx_yy(pts,lid1_id_up);
[lid1_xx_down, lid1_yy_down]=interpolate_xx_yy(pts,lid1_id_down);
lid1_xx = [lid1_xx_up,lid1_xx_down];
lid1_yy = [lid1_yy_up,lid1_yy_down];

[lid2_xx_up, lid2_yy_up]=interpolate_xx_yy(pts,lid2_id_up);
[lid2_xx_down, lid2_yy_down]=interpolate_xx_yy(pts,lid2_id_down);
lid2_xx = [lid2_xx_up,lid2_xx_down];
lid2_yy = [lid2_yy_up,lid2_yy_down];

% the index of out lip in in landmark points
out_lip_id_up1 = [49:52]; 
out_lip_id_up2 = [52:55]; 
out_lip_id_down = [55:60,49]; 

% interpolate out lip regions
[out_lip_xx_up1,out_lip_yy_up1] = interpolate_xx_yy(pts,out_lip_id_up1);
[out_lip_xx_up2,out_lip_yy_up2] = interpolate_xx_yy(pts,out_lip_id_up2);
[out_lip_xx_down,out_lip_yy_down] = interpolate_xx_yy(pts,out_lip_id_down);
out_lip_xx = [out_lip_xx_up1,out_lip_xx_up2,out_lip_xx_down];
out_lip_yy = [out_lip_yy_up1,out_lip_yy_up2,out_lip_yy_down];

% the index of inner lip in landmark points
inner_lip_id_up = [61:65]; 
inner_lip_id_down = [65:68,61]; 

% interpolate inner lip regions
[inner_lip_xx_up,inner_lip_yy_up] = interpolate_xx_yy(pts,inner_lip_id_up);
[inner_lip_xx_down,inner_lip_yy_down] = interpolate_xx_yy(pts,inner_lip_id_down);
inner_lip_xx = [inner_lip_xx_up,inner_lip_xx_down];
inner_lip_yy = [inner_lip_yy_up,inner_lip_yy_down];

% the index of facial edges and eyebows in landmark points
face_edge_id = (1:17);
bow1_id = (18:22);
bow2_id = (23:27);

% connect facial edges and eyebows to interpolate facial region
[face_edge_xx,face_edge_yy] = interpolate_xx_yy(pts,face_edge_id);
[bow1_xx,bow1_yy] = interpolate_xx_yy(pts,bow1_id);
[bow2_xx,bow2_yy] = interpolate_xx_yy(pts,bow2_id);

face_area_xx = [face_edge_xx,fliplr(bow2_xx),fliplr(bow1_xx),face_edge_xx(1)];
face_area_yy = [face_edge_yy,fliplr(bow2_yy),fliplr(bow1_yy),face_edge_yy(1)];

% generate and save the facial mask of the frame size
bg=zeros(size(frame_img));
bg=fill_img(bg,face_area_xx,face_area_yy,col{1});
bg=fill_img(bg,lid1_xx,lid1_yy,col{2});
bg=fill_img(bg,lid2_xx,lid2_yy,col{2});
bg=fill_img(bg,out_lip_xx,out_lip_yy,col{4});
bg=fill_img(bg,inner_lip_xx,inner_lip_yy,col{5});
imwrite(bg,save_path1,'png');

end