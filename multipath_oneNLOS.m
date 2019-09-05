function [ran_peak,ran_ep,ran_ephp]=multipath_oneNLOS(l1,l2,m)
%analyze the gait data acquired
fs=500000;Ts=1/fs;tF=7e-3;t=Ts:Ts:tF;N=tF*fs;
% Wnd=hamming(N)';
Wnd=rectwin(N)';
% Wnd=hann(N)';
% r=1.121;%attenuation const m inverse
% r=0;
  eta=0.9; % reflection coefficient
  gamma=0.17;% attenuation coefficient

tx1=chirp(t,39e3,tF,41e3);
tx2=chirp(t,41e3,tF,39e3);


wtx1=Wnd.*tx1;
wtx2=Wnd.*tx2;

% figure; plot(wtx1)
rcv1=zeros(1,2*round((tF*fs)));
rcv2=zeros(1,2*round((tF*fs)));


L=length(wtx1);
Temp=22;

Temp=22;
v=331.5+0.6*Temp;
Range1=[];
Range2=[];
%%%%%%%%%%%set lengths%%%%%%%%%%%%
LOS=floor(l1*fs/v); NLOS1=floor(l2*fs/v);
A1=exp(-gamma*l1);
An1=exp(-gamma*l2);

for k = 1:L   %distances from first transmitter
rcv1(LOS+k) = rcv1(LOS+k)+A1*wtx1(k) ;
% rcv2(NLOS1+k) = rcv2(d12+k) + A*exp(-1*r*d12*v/fs)* wtx1(k);
% rcv3(NLOS2+k) = rcv3(d13+k) + A*exp(-1*r*d13*v/fs)* wtx1(k);
end
% a=rand;
for k = 1:L   %distances from first transmitter
rcv2(NLOS1+k) = rcv2(NLOS1+k)+eta*An1*wtx1(k) ;
% rcv2(NLOS1+k) = rcv2(d12+k) + A*exp(-1*r*d12*v/fs)* wtx1(k);
% rcv3(NLOS2+k) = rcv3(d13+k) + A*exp(-1*r*d13*v/fs)* wtx1(k);
end

rcv=rcv1+rcv2;
nrcv1=awgn(rcv1,10);
nrcv2=awgn(rcv2,10);
nrcv=awgn(rcv,10);
% nrcv1=rcv1;
% nrcv2=rcv2;
% nrcv=rcv;
C=xcorr(nrcv,wtx1);
C1=xcorr(nrcv1,wtx1);
C2=xcorr(nrcv2,wtx1);

% C=C1+C2+C3;
% normal method
[~,p11]=max(abs(C));
TOF_peak=p11-length(rcv1);
ran_peak=TOF_peak*v/fs;
%earliest peak
y=envelope((C));

pk=max(y);
th=0.9*pk;
[pks,locs] = findpeaks(y,'MinPeakHeight',th);

TOF_ep=min(locs)-length(rcv1);
ran_ep=TOF_ep*v/fs;
%earliest peak and half peak
i=min(locs);
while(y(i)>pks(1)/m)
% while(y(i)>1500)
    i=i-1;
end
TOF_ephp=i-length(rcv1);
ran_ephp=TOF_ephp*v/fs;

% figure;
% plot(envelope(C))
% hold on
% % plot(y)
% plot(locs,y(locs),'ko')
% plot(envelope(C1))
% plot(envelope(C2))
% % plot(abs(C3))
% plot(i,y(i),'r*')
% legend('combined cor','peak','LOS','NLOS1','half peak')