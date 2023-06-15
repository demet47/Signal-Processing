


%BELOW IS FOR KICK

[y, Fs] = audioread('audio.wav');

% design a lowpass filter with a cutoff frequency of 500 Hz
fc_low = 500; % cutoff frequency
[b_kick, a_kick] = butter(6, fc_low/(Fs/2), 'low'); % design the filter

% apply the filter to the audio data
y_kick_filtered = filter(b_kick, a_kick, y);
y_kick_filtered = filter(b_kick, a_kick, y_kick_filtered);
audiowrite('kick.wav', y_kick_filtered, Fs);


[H, W] = freqz(b_kick, a_kick, 1296, Fs);
figure;
plot(W, abs(H));
title('Magnitude Response of Lowpass Butterworth Filter Used for Kick');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
filename = 'frequency_response_kick.png';
saveas(gcf, filename);
grid off;



%BELOW IS FOR PIANO

f_start = 500;
f_end = 4000;
[b_piano,a_piano] = butter(7,[f_start f_end]/(Fs/2));
y_piano_filtered = filter(b_piano, a_piano, y);
y_piano_filtered = filter(b_piano, a_piano, y_piano_filtered);
audiowrite('piano.wav', y_piano_filtered, Fs);


[H, W] = freqz(b_piano, a_piano, 2401, Fs);
figure;
plot(W, abs(H));
title('Magnitude Response of Bandpass Butterworth Filter Used for Piano');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
filename = 'frequency_response_piano.png';
saveas(gcf, filename);
grid off;




%BELOW IS FOR CYMBAL

fc_high = 4000;
[b_cymbal, a_cymbal] = butter(10,fc_high/(Fs/2),'high');
y_cymbal_filtered = filter(b_cymbal, a_cymbal, y);
y_cymbal_filtered = filter(b_cymbal, a_cymbal, y_cymbal_filtered);
audiowrite('cymbal.wav', y_cymbal_filtered, Fs);


[H, W] = freqz(b_cymbal, a_cymbal, 1000, Fs);
figure;
plot(W, abs(H));
title('Magnitude Response of Highpass Butterworth Filter Used for Cymbal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
filename = 'frequency_response_cymbal.png';
saveas(gcf, filename);
grid off;




filename = 'audio.wav';
[y, Fs] = audioread(filename);
t = (0:length(y)-1)/Fs;

plot(t, y);
xlabel('Time (s)');
ylabel('Amplitude');
title('Waveform of Audio Signal');

saveas(gcf, "audio_waveform.png");


filename = 'kick.wav';
[y, Fs] = audioread(filename);
t = (0:length(y)-1)/Fs;

plot(t, y);
xlabel('Time (s)');
ylabel('Amplitude');
title('Waveform of Kick Signal');

saveas(gcf, "kick_waveform.png");


filename = 'piano.wav';
[y, Fs] = audioread(filename);
t = (0:length(y)-1)/Fs;

plot(t, y);
xlabel('Time (s)');
ylabel('Amplitude');
title('Waveform of Piano Signal');

saveas(gcf, "piano_waveform.png");


filename = 'cymbal.wav';
[y, Fs] = audioread(filename);
t = (0:length(y)-1)/Fs;

plot(t, y);
xlabel('Time (s)');
ylabel('Amplitude');
title('Waveform of Cymbal Signal');

saveas(gcf, "cymbal_waveform.png");



function z = give_b_k(freq)
    z = exp(-1* 1i *freq);
end

function filter = give_H_z_transform(list_of_freqs, from, to)
    filter = sum(arrayfun(@give_b_k, list_of_freqs(from:to)), "all");
end

function index = find_frequency_index(Y_mag, freq)
    for a = 1:length(Y_mag)
        if Y_mag(a) > freq
            index = a - 1;
            return
        end
    end
    index = length(Y_mag)
end


