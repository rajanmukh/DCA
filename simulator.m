initializeRecord();
if ~exist('initialized','var')
    addpath([pwd,'\sgp4']);
    initialized = true;
end
[SIDs,ToT]=getschedule('meogen_2023-10-03.sch');
readtle(ToT(1));

lat0 = 13.036;
lon0= 77.5124;
h0 = 0;
RxSite=lla2ecef([lat0,lon0,h0])'*1e-3;

load('placementGrid.mat');
noOfPos=length(TxLat);
FoT=406.050e6;

noOfBurst=length(ToT);
error=NaN(noOfBurst,noOfPos);
det = zeros(7,noOfBurst,noOfPos,'logical');
lat=NaN(noOfBurst,noOfPos);
lon=NaN(noOfBurst,noOfPos);
rng default
tic
for j=188
    TxSite=lla2ecef([TxLat(j),TxLon(j),h0])'*1e-3;j
    for i=1:noOfBurst
        [TOA,FOA,chn]=TRxOperation(SIDs(i,:),ToT(i),FoT,TxSite,RxSite);
        CNR=35*ones(size(TOA));
        if length(chn)>=3
            [loc,err,antsV,sInfo]=computeLocation(TOA,FOA,CNR,SIDs(i,chn),RxSite);
            if ~isempty(loc)
                error(i,j)=distance(loc.lat,loc.lon,TxLat(j),TxLon(j),referenceEllipsoid('WGS84'))*1e-3;
                lat(i,j)=loc.lat;
                lon(i,j)=loc.lon;
            end
        end
        det(chn,i,j)= true;
    end
end

%statistics
prDet=zeros(1,noOfPos);
prLoc=zeros(1,noOfPos);
prLoc10=zeros(1,noOfPos);
prAcc5=zeros(1,noOfPos);
prAcc5_10=zeros(1,noOfPos);
prAcc10_10=zeros(1,noOfPos);
for j=188
    %singleburst
    d=det(:,:,j);
    d1=any(d,1);
    noOfDet1=sum(d1);
    prDet1=noOfDet1/noOfBurst;
    d3=sum(d,1)>=3;
    noOfSol=sum(d3);
    prLoc(j)=noOfSol/noOfBurst;
    errorWithin5km = sum(error(:,j)<5);
    prAcc5(j)=errorWithin5km/noOfSol;
    errorWithin10km = sum(error(:,j)<10);
    prAcc10=errorWithin10km/noOfSol;
    %multiburst
    d1_10=any(reshape(d1,12,[]));
    noOf10minWnd=length(d1_10);
    noOfDet = sum(d1_10);
    prDet(j) = noOfDet/noOf10minWnd;
    sol10=any(reshape(d3,12,[]));
    noOfSol10=sum(sol10);
    prLoc10(j)=noOfSol10/noOf10minWnd;
    
    lat_s=reshape(lat(:,j),12,[]);
    lon_s=reshape(lon(:,j),12,[]);
    error10=NaN(1,noOf10minWnd);
    for i=1:noOf10minWnd
        lat1=lat_s(:,i);
        lon1=lon_s(:,i);
        lat10=mean(lat1(~isnan(lat1)));
        lon10=mean(lon1(~isnan(lon1)));
        error10(i)=distance(lat10,lon10,TxLat(j),TxLon(j),referenceEllipsoid('WGS84'))*1e-3;
    end
    errorWithin5km_10 = sum(error10<5);
    prAcc5_10(j)=errorWithin5km_10/noOfSol10;
    errorWithin10km_10 = sum(error10<10);
    prAcc10_10(j)=errorWithin10km_10/noOfSol10;
end
toc
function initializeRecord()
%INITIALIZERECORD Summary of this function goes here
%   Detailed explanation goes here
global LIGHTSPEED;
LIGHTSPEED = physconst('LightSpeed')*1e-3;
global jd2000;
date2000=datetime('1-Jan-2000 12:00:00');
jd2000=juliandate(date2000);
end

