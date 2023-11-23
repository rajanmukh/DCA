 lats=lat0+(-60:5:60);                                                                                                                 
 lons=lon0+(-60:5:60);                                                                                                                                
 [TxLat,TxLon]=meshgrid(lats,lons);                                                                                                                                   
 r=zeros(size(TxLat));                                                                                                                                           
 for i=1:size(TxLat,1)                                                                                                                                             
    for j=1:size(TxLat,2)                                                                                                                                         
          r(i,j)=distance(lat0,lon0,TxLat(i,j),TxLon(i,j),referenceEllipsoid('WGS84'));
    end                                                                                                                                                            
 end                                                                                                                                                                
 within6000km=r<6000;                                                                                                                                               
 TxLat=TxLat(within6000km);                                                                                                                                         
 TxLon=TxLon(within6000km); 
 save('placementGrid','TxLat','TxLon');