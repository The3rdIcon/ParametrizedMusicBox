function [ FigHandle, peak_freq ] = plot_freq( notes, note_count, Fs, octave )
col=hsv(note_count);
peak_freq = zeros(note_count, 2);
FigHandle = figure('Position', [100, 100, 1049, 895]);
hold on
for i = 1:note_count
    [Y(i,:), NFFT(i), f(i,:)] = audio_fft(notes(i,:), Fs);
end

% Plot single-sided amplitude spectrum.
for i = 1:note_count
    plot(f(i,:),2*abs(Y(i,1:NFFT(i)/2+1)),'color',col(i,:))
end
xVals = cell(note_count, 1);
yVals = cell(note_count, 1);
for i = 1:note_count
    X1 = 2*abs(Y(i,1:NFFT(i)/2+1));
    [Xm, Im] = findpeaks(X1);
    iVals = reshape([ Im - 1 ; Im ; Im + 1],1,[]); 
    xVals{i} = f(i,iVals) ;
    yVals{i} = X1(iVals);
    %scatter(xVals{i}, yVals{i});
    [~, peak_index ] = max(yVals{i});
    xVals{i}(peak_index)
    scatter(xVals{i}(peak_index), yVals{i}(peak_index),'MarkerEdgeColor',col(i,:));
    n = i -10+12*(octave-4);
    x = 440 *(2^(1/12))^n;
    %find closest peak to target frequency
    [distance_from_target, index_of_peak] = min(abs(xVals{i} - x));
   % peak_freq(i,1) = xVals{i};
   % peak_freq(i,2) = distance_from_target;
end

%title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
legend('C3', 'C#3', 'D3', 'D#3', 'E3', 'F3', 'F#3', 'G3', 'G#3', 'A3', 'A#3', 'B3', 'C4');
axis([200 550 0 0.1])

for n = -9+12*(octave-4):-9+12*(octave-4) + note_count - 1
    x = 440 *(2^(1/12))^n;
    plot([x, x], [0, 0.4],'color',col(n + 10-12*(octave-4),:))
end
%for n = -9-12*0:-9-12*0 + note_count - 1
 %   x = 440 *(2^(1/12))^n;
  %  plot([x, x], [0, 0.4],'color',col(n + 10+12*0,:))
%end
hold off
end
