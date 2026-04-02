

clf

h1=axesm('MapProjection','miller','Grid','on','MapLatLimit',[40,70],'MapLonLimit',[-5 45]);
framem('on'); gridm('on'); mlabel('south'); plabel('west');
%load coast;
%plotm(lat, long,'black');
scatterm(inforcr(:,2),inforcr(:,1),10,'filled')


scatterm(latlon(:,6), latlon(:,5),abs(cor_tem_p1)*80,cor_tem_p1,'filled','MarkerEdgeColor',[0.5 .5 .5]);
colormap(jet(11))
aa=colormap;
aa(6,:)=1;
colormap(aa)
caxis([-1 1])
colorbar