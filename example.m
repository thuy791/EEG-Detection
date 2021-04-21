

Fs = 512;              
T = 1/Fs;
L = 100*Fs; 
t = 0:1/Fs:L/Fs;
t=t(1:end-1);
f = Fs*(0:(L/2))/L;
frec = 0.1 : 0.005 : 64;
ff = linspace(0.5,20,79);

f3=9;
ampl=60;
alpha = 0.75;

%% example 1

Sg=signalGen(t,f3,3)*ampl*(power(f3,-alpha));
figure; plot(Sg); title('Simulated signal')

Ns = noiseGen(t,frec,alpha);
figure; plot(Ns); title('Simulated background noise')

Mix = Ns+Sg;
oSc = toSpec(Mix,Fs,0.5,20,4);
figure;plot(ff,log(squeeze(mean(abs(oSc),2))),'Linewidth',1)
title('Spec Power')

%% example 2

Sg = signalGen(t,f3,4,[0 pi/2],0.5)*ampl*(power(f3,-alpha));
figure; plot(Sg'); title('Simulated signal')

Ns(1,:) = noiseGen(t,frec,alpha);
Ns(2,:) = noiseGen(t,frec,alpha);
figure; plot(Ns'); title('Simulated background noise')

Mix = Ns+Sg;
oSc = toSpec(Mix,Fs,0.5,20,4);
figure;plot(ff,log(squeeze(mean(abs(oSc),2))),'Linewidth',1)
title('Spec Power')





