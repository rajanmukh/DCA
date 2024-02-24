dop=zeros(1000,30);
for N=4:30
    for i=1:1000
    %     N=randi([12 24],1);
    L=ceil(N/3);
    M=3*L;
    az=zeros(M,1);
    for k=1:3
        az((k-1)*L+1:k*L)=(k-1)*2/3*pi+(2/3*pi)*rand(L,1);        
    end
    el=pi/9+(pi/2-pi/9)*rand(M,1);
    for k=1:M-N
        P=length(el);
        ii=randi([1 P],1);
        az(ii)=[];
        el(ii)=[];
    end
    a=[sin(az).*cos(el) cos(az).*cos(el) sin(el) 1*ones(N,1)];
    p=inv(a'*a);
    dop(i,N)=sqrt(trace(p(1:2,1:2)));
    end
end
for N=4:30
% m(N)=mean(dop(dop(:,N)<20,N));
m(N)=median(dop(:,N));
end
plot(4:30,m(4:30),'r*')
