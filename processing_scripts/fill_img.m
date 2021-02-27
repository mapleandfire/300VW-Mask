function filled=fill_img(bg,xx,yy,color)

bg_gray=rgb2gray(bg);
BW=roipoly(bg_gray,xx,yy);

rc = bg(:,:,1);
gc = bg(:,:,2);
bc = bg(:,:,3);

rc(BW) = color(1);
gc(BW) = color(2);
bc(BW) = color(3);

filled=cat(3,rc,gc,bc);

end