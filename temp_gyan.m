Z=rand(1000,360);
Z(:,50)=1;
r=1:1000;
[R,PHI]=meshgrid(r,(pi/180)*-(0:359)+pi/2);
x=R.*cos(PHI);
y=R.*sin(PHI);

pcolor(x,y,Z')
shading interp; colorbar;

figure
lat0 = 13.036;
lon0= 77.5124; 
lats=lat0+(-10:0.02:10);                                                                                                                 
 lons=lon0+(-10:0.02:10);                                                                                                                                
 [Lat,Lon]=meshgrid(lats,lons);
 Z1=NaN(size(Lat));
 for i=1:length(lons)
     for j=1:length(lats)
        [a,e,r]=geodetic2aer(Lat(i,j),Lon(i,j),0,lat0,lon0,0,referenceEllipsoid('WGS84'));
        r=r*1e-3;
        r1=round(r)+1;
        a1=round(a)+1;
        if r1<=1000 && r1>0 && a1<=360 && a1 >0
            Z1(i,j)=Z(r1,a1);
        end
     end
 end
 worldmap([min(lats),max(lats)],[min(lons),max(lons)]);
 pcolorm(Lat,Lon,Z1);