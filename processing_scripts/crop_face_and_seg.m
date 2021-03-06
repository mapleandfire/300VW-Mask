function [orig,seg] = crop_face_and_seg(frame_img,seg_img,pts)
% crop the facial image and mask of a video frame using the given landmark points
% frame_img: the frame image to be cropped
% seg_img: the mask label (generated by 'do_segmentation.m') to be cropped 
% pts: the 68 landmark points which can be loaded from the landmark file using 'LoadPts.m'

x = pts(:,1);
y = pts(:,2);
det = [min(x),min(y),max(x),max(y)];

extend = 0.3;  % the extension margin of the cropping area

cropWidth = round(det(3)-det(1));
cropHeight = round(det(4)-det(2));

cropLength = (cropWidth + cropHeight)/2;

% the central point
cenPoint = [round(det(1) + cropWidth/2) round(det(2) + cropHeight/2)];

x1 = cenPoint(1) - round((1+extend)*cropLength/2);
y1 = cenPoint(2) - round((1+extend)*cropLength/2);
x2 = cenPoint(1) + round((1+extend)*cropLength/2);
y2 = cenPoint(2) + round((1+extend)*cropLength/2);

% prevent going out of image
x1 = max(1,x1);
y1 = max(1,y1);
x2 = min(x2,size(frame_img,2));
y2 = min(y2,size(frame_img,1));

orig = frame_img(y1:y2,x1:x2,:); % crop the video frame
seg = seg_img(y1:y2,x1:x2,:); % crop the mask label

end
