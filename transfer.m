load('data1.mat')
x=prAcc10_10;
load('data2.mat')
x(101:200)=prAcc10_10(101:200);
load('data3.mat')
x(201:300)=prAcc10_10(201:300);
load('data4.mat')
x(301:end)=prAcc10_10(301:end);%x(end)=0.999;
prAcc10_10=NaN(size(TxLat));
prAcc10_10(within6000km)=x;
mi=min(prAcc10_10(~isnan(prAcc10_10)));
ma=max(prAcc10_10(~isnan(prAcc10_10)));
i1=round(((mi-0.5)/0.5)*255+1);
i2=round(((ma-0.5)/0.5)*255+1);
m=parula;
cmap=m(i1-1:i2,:);
worldmap(13+[-60 60],77.5+[-60 60]);
geoshow('landareas.shp','FaceColor',[1,1,1],'facealpha',0,'LineWidth',1)
geoshow(TxLat,TxLon,prAcc10_10,'DisplayType','surface','facealpha',0.7)
contourm(TxLat,TxLon,prAcc10_10,'ShowText','on','LineColor','black','LineStyle','--')
geoshow(13,77.51,'DisplayType','point','Marker','*','Color','black')
textm(13,77.51+1,'Bangalore','Color','black')
geoshow(24.431,54.448,'DisplayType','point','Marker','*','Color','black')
textm(24.431,54.448+1,'UAE')
geoshow(1.3771,103.9881,'DisplayType','point','Marker','*','Color','black')
textm(1.3771,103.9881+1,'Singapore')
colormap(cmap)
colorbar