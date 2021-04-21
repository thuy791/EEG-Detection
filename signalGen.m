function [Sn] = signalGen(t,fdom,wide,varargin)

%%%%%%%%%%%%%%%%%%
% [Sn] = signalGen(t,fdom,wide,[ph1 ph2...],coh)
% t = time vector
% fdom = dominant frequency of the signal
% width = parameter related with the width of the peak of the dominant frequency in frequency domain
% [ph1 ph2 ..] = phases in case of non independent signals
% coh = coherence value in case of non independent signals
% 
% Gabriel Orellana Lopez
% June 2019
%%%%%%%%%%%%%%%%%%%%%

try
    phs = varargin{1};
    N = length(phs);
catch
    N = 1;
    phs = [0];
end

try
    coh = varargin{2};
catch
    coh=1;
end


Ns = zeros(N,length(t));
step = t(2)-t(1);

w = 2*pi*fdom*step;
w1 = 2*pi*wide*step;

% probs change of state
prob01 = step/6;
prob10 = 0.1/fdom;


state = 0;
rnd3 = 0;
Rnd3 = [rnd3];
flg = 1;
cycleind = [];

for k= 2:length(t)
    if state==0
        rnd1 = rand;
        if rnd1<prob01
            state = 1;
            cycleind = [cycleind k];
            flg=0;
        else
            Ns(1,k) = Ns(1,k-1);
        end
    end
    if state ==1
        Ns(1,k) = Ns(1,k-1)+(w+rnd3);
        if sin(Ns(1,k))*sin(Ns(1,k-1))<0 && sin(Ns(1,k-1))<sin(Ns(1,k)) && flg 
            cycleind = [cycleind k];
            rnd2 = rand;
            if rnd2<prob10
                state = 0;
                Ns(1,k) = round(Ns(1,k)/(2*pi))*2*pi+w*1e-6;
            end
            rnd3 = randraw('semicirc', [0, w1], [1]);
%             rnd3 = randraw('cosine', [], 1)/pi;
            
            Rnd3(end+1) = rnd3;
        end 
    end
    if flg==0
        flg=1;
    end
end

Sn = zeros(size(Ns));
Sn(1,:) = sin(Ns(1,:));

if N>1    
    phs = phs-phs(1);
    for n=2:N
        dephs = round(phs(n)/w);
        aux = Sn(1,:);
%         aux2 = [0 diff(aux)];
        for c = 1:length(cycleind)-1
            rrnd = rand;
            if rrnd<(1-coh)
                aux(cycleind(c):cycleind(c+1))=0;
            end
        end
        Sn(n,dephs:end) = aux(1:end-dephs+1);
    end
end


end





