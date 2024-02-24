function [sids,TOAs] = getschedule(day1)
global list;

p=zeros(1,300);
j=1;
for i=1:300
    if ~isempty(list{i})
        p(j)=i;
        j=j+1;
    end
end
p(j:end)=[];
satIDs=300+p;

lat0 = 13.036;
lon0= 77.5124;
h0 = 0;
RxSite=lla2ecef([lat0,lon0,h0])'*1e-3;
TOAs= day1+(50:300:86400)/86400;
noOfSats=51;
sids=zeros(length(TOAs),noOfSats);
for i=1:length(TOAs)
    t=split2fields(repmat(TOAs(i),1,noOfSats));
    [posS,velS]=getSatPosVel(t,satIDs);
    els=getAngles(posS,RxSite);
    validChns=(els>20);
    sids(i,validChns)=satIDs(validChns);
end

end

function [a]=getAngles(posS,place)
dxyz=posS-place;
r=sqrt(sum(dxyz.^2));
p=sqrt(sum(place.^2));
cosa=sum(dxyz.*place)./(r*p);
a=90-(acos(cosa)*180/pi);
end

function [pos,vel]=getSatPosVel(toa,satIDs)
global jd2000;
global list;
UT1_UTC=-0.06;
TT_UTC=69.2;
noOfSats = length(satIDs);
pos = zeros(3,noOfSats);
vel = zeros(3,noOfSats);
for i=1:noOfSats
    satrec=list{satIDs(i)-300};
    epochDay=satrec.epochdays;
    ts = toa.s(i);
    d = toa.d(i);
    cdate = toa.date(i);
    tsince=(ts-(epochDay-floor(epochDay))*86400)/60 +(d-floor(epochDay))*1440;
    [~, pos1, vel1] = sgp4 (satrec,  tsince);
    jd=(ts/86400)+juliandate(cdate);
    jd_UT1 = jd + UT1_UTC/86400;
    jd_TT  = jd + TT_UTC/86400;
    ttt = (jd_TT-jd2000)/36525;
    [pos(:,i),vel(:,i),~]=teme2ecef(pos1',vel1',[0,0,0]',ttt,jd_UT1,0,0,0,2);
end
end

function t=split2fields(toa)
t.d=day(toa,'dayofyear');
t.s=3600*toa.Hour+60*toa.Minute+toa.Second;
t.date=datetime(toa.Year,toa.Month,toa.Day);
end

