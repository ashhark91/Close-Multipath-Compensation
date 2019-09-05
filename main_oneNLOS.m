%main function for multipath simulatiuon
M=[];%To store the value of m, m=2 for half peak detection
MI=[];%To store the value of maximum improvement
MD=[];%To store the value of maximum degradation
AI=[];%To store the value of average improvement
AD=[];%To store the value of average degradation
NI=[];%To store the value of no. of improvements
ND=[];%To store the value of no. of degradation
NC=[];%To store the value of no of no change
 for m=1:0.1:4
% m=sqrt(2);
% m=2;
sim=1001;
Ep=[]; % normal peak detection
Eep=[]; % earliest peak detection
Eephp=[]; % earliest half peak detection
while sim>1
    sim=sim-1;
LOS1=1;
%  NLOS11=1;
NLOS11=1+0.172*rand; % non line of sight within range resolution 1st range value
% NLOS12=1.05;

LOS2=2;
%  NLOS21=2;
NLOS21=2+0.172*rand; % non line of sight within range resolution 2nd range value
% NLOS22=2.10;

[ran_peak1,ran_ep1,ran_ephp1]=multipath_oneNLOS(LOS1,NLOS11,m);
[ran_peak2,ran_ep2,ran_ephp2]=multipath_oneNLOS(LOS2,NLOS21,m);
drange_peak=ran_peak2-ran_peak1;%range fromm peak
drange_ep=ran_ep2-ran_ep1;%range from earliest peak
drange_ephp=ran_ephp2-ran_ephp1;%range from earliest half peak
actualrange=LOS2-LOS1;
e_peak(sim)=drange_peak-actualrange;%range error from peak
e_ep(sim)=drange_ep-actualrange;%range error from earliest peak
e_ephp(sim)=drange_ephp-actualrange;%range error from earliest peak and half peak

% Ep=[Ep e_peak];
% 
% Eep=[Eep e_ep];  
% 
% Eephp=[Eephp e_ephp];
end
%plot ECDF
% [f1,x1]=ecdf(abs(e_peak));
% [f2,x2]=ecdf(abs(e_ephp));
% figure; plot(x1,f1,'b')
% hold on
% plot(x2,f2,'r')
% legend('conventional','proposed')

% figure;
% plot(Ep)
% hold on
% plot(Eep)
% plot(Eephp)
% E(m)=mean(abs(Eep)-abs(Eephp));
% end
% ran_ephp1
% ran_ephp2
% figure;
% stem(abs(e_peak))
% hold on
% stem(abs(e_ephp))
A=[];
B=[];
imp=0;
deg=0;
for i=1:length(e_ephp)
    if abs(e_ephp(i))<abs(e_peak(i))
        imp=imp+1;
        a=abs(e_peak(i))-abs(e_ephp(i));
        A=[A a];
    elseif abs(e_ephp(i))>abs(e_peak(i))
        deg=deg+1;
        b=abs(e_ephp(i))-abs(e_peak(i));
        B=[B b];
    end
end
Average_improvement=mean(A);
Average_degradation=mean(B);
Max_improvement=max(A);
Max_degradation=max(B);
no_change=10000-length(A)-length(B);
% if m==2
%     save('two.mat')
% elseif m==3
%     save('three.mat')
% elseif m==4
%     save('four.mat')
% elseif m==5
%     save('five.mat')
% elseif m==6
%     save('six.mat')
% elseif m==sqrt(2)
%     save('sqrt2.mat')
% end
% 
%  clear all;
M=[M m];
MI=[MI Max_improvement];
MD=[MD Max_degradation];
AI=[AI Average_improvement];
AD=[AD Average_degradation];
NI=[NI numel(A)];
ND=[ND numel(B)];
NC=[NC no_change];
 end
