function [Noise] = noiseGen(t,frecs,alpha)

%%%%%%%%%%
% t = time vector
% frecs = frequencies used to calculate noise
% alpha = parameter of pink noise
% 
% Gabriel Orellana Lopez
% June 2019
% %%%%%%%%%

Noise = zeros(size(t));
rcoef = 0.01;ncoeff=0.03;bias = 0.2;
stp = t(2)-t(1);
for f=frecs
    P = zeros(size(Noise));
    for k= 2:length(t)
        P(k) = ncoeff*(randn+bias) -rcoef*P(k-1);
    end
    Ns = zeros(size(P));
    Ns(1) = rand*2*pi;
    w = 2*pi*f*stp;
    for i= 2:length(t)
        do = w*(P(i)+1);
        Ns(i) = Ns(i-1)+do;
    end
    A = sin(Ns);
    Noise = Noise+A*(power(f,-alpha));
end


end















