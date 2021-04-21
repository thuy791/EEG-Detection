function [X] = toSpec(origdata,samplfreq,minfreq,maxfreq,windowlength_sec)

% Function based on fourierICA.m
% https://www.cs.helsinki.fi/group/neuroinf/code/fourierica/html/fourierica.html

overlapfactor = 8;
hamm=1;
[channels,T]=size(origdata); 

%Compute number of time points in one window based on other parameters
windowsize=floor(windowlength_sec*samplfreq);
%Compute interval between consecutive windows
windowinterval=ceil(windowsize/overlapfactor);
%Compute number of windows
windows=floor((T-windowsize)/windowinterval+1);

%compute frequency indices (for the STFT)
startfftind=floor(minfreq*windowlength_sec+1); 
if startfftind<1, error('minfreq must be positive'); end
endfftind=floor(maxfreq*windowlength_sec+1); nyquistfreq=floor(windowsize/2);
if endfftind>nyquistfreq, error('maxfreq must be less than the Nyquist frequency'); end
fftsize=endfftind-startfftind+1;

% Initialization of tensor X, which is the main data matrix input to the code which follows.
X=zeros(fftsize,windows,channels);

% Define window initial limits
window=[1,windowsize];

% Construct Hamming window if necessary 
if hamm
    hammingwindow=hamming(windowsize,'periodic');
end
% Short-time Fourier transform (window sampling + fft)
for j=1:windows
    % Extract data window
    datawindow=origdata(:,window(1):window(2));
    % Multiply by a Hamming window if necessary
    if hamm
        datawindow=datawindow*diag(hammingwindow);
    end
    % Do FFT
    datawindow_ft=fft(datawindow');
%     [wt,f] = cwt(datawindow(:,1),samplfreq,'VoicesPerOctave',48,'NumOctaves',5);
    X(:,j,:)=datawindow_ft(startfftind:endfftind,:);
    % New data window interval
    window=window+windowinterval;
end

clear datawindow datawindow_ft window

end