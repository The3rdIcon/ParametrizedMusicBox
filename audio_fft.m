function [ Y, NFFT, f ] = audio_fft( audio_clip, Fs )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

L = length(audio_clip);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(audio_clip,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

end

