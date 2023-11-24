worldmap(13+[-60 60],77.5+[-60 60]);
geoshow('landareas.shp','FaceColor',[1,1,1],'facealpha',1,'LineWidth',1)
geoshow(TxLat,TxLon,prLoc10,'DisplayType','surface','facealpha',0.7)
contourm(TxLat,TxLon,prLoc10,'ShowText','on','LineColor','black','LineStyle','--')
% load coastlines
% plotm(coastlat,coastlon,'Color','k','LineWidth',2)
geoshow(13,77.51,'DisplayType','point','Marker','*','Color','black')
textm(13,77.51+1,'Bangalore')
geoshow(24.431,54.448,'DisplayType','point','Marker','*','Color','black')
textm(24.431,54.448+1,'UAE')
geoshow(1.3771,103.9881,'DisplayType','point','Marker','*','Color','black')
textm(1.3771,103.9881+1,'Singapore')
colormap(cmap)
colorbar