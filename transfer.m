% load('data1.mat')
% x=prLoc;
% load('data2.mat')
% x(101:200)=prLoc(101:200);
% load('data3.mat')
% x(201:300)=prLoc(201:300);
% load('data4.mat')
% x(301:end)=prLoc(301:end);%x(end)=0.999;
x=prLoc;
prLoc=NaN(size(TxLat));
prLoc(within6000km)=x;
mi=min(prLoc(~isnan(prLoc)));
ma=max(prLoc(~isnan(prLoc)));
i1=round(((mi-0)/6)*256+1);
i2=round(((ma-0)/6)*256+1);

% i1=round(((mi-0.5)/0.5)*255+1);
% i2=round(((ma-0.5)/0.5)*255+1);
m=parula;
cmap=m(i1-1:i2,:);
worldmap(13+[-60 60],77.5+[-60 60]);
geoshow('landareas.shp','FaceColor',[1,1,1],'facealpha',0,'LineWidth',1)
geoshow(TxLat,TxLon,prLoc,'DisplayType','surface','facealpha',0.7)
contourm(TxLat,TxLon,prLoc,'ShowText','on','LineColor','black','LineStyle','--')
geoshow(13,77.51,'DisplayType','point','Marker','*','Color','black')
textm(13,77.51+1,'Bangalore','Color','black')
geoshow(24.431,54.448,'DisplayType','point','Marker','*','Color','black')
textm(24.431,54.448+1,'UAE')
geoshow(1.3771,103.9881,'DisplayType','point','Marker','*','Color','black')
textm(1.3771,103.9881+1,'Singapore')
colormap(cmap)
colorbar