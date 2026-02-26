% analyzeRESP calculates respiration rate using time and frequency domain
% analyses

function [rr,rr_fft] = analyzeRESP(time,resp,plotsOn)
    % INPUTS: 
    % time: elapsed time (seconds)
    % resp: output from pressure sensor (voltage)
    % plotsOn: true for plots, false for no plots
    
    % OUTPUT:
    % rr: respiration rate (brpm) found from time domain data
    % rr_fft: respiration rate (brpm) found from frequency domain data

    % save orgiinal data
    time_raw = time;
    resp_raw = resp;

    % calculate fs
    fs = 1/mean(diff(time));
   

    % remove offset
    resp = resp - mean(resp);

    % bandpass pass filter resp
    w1 = 0.1; % FILL IN CODE HERE
    w2 = 0.5; % FILL IN CODE HERE
    resp = bandpass(resp,[w1 w2],fs);

    % find peaks
    [pks, locs] = findpeaks(resp, time, 'MinPeakDistance', 1); % FILL IN CODE HERE (look at findpeaks documentation)
    
    % calcuate rr
    rr = length(pks)/((time(end)-time(1))*60); % FILL IN CODE HERE

    % fft
    L = length(resp);
    Y = fft(resp);
    P2 = abs(Y/L);
    P1 = P2(1:floor(L/2)+1); % FILL IN CODE HERE (look at fft documentation)
    f = fs*(0:floor(L/2))/L; % FILL IN CODE HERE (look at fft documentation)

    % calcuate rrFft
    valid = f >= w1 & f<=w2; %filtering out the frequencies that are below 0.1 and above 0.5 (breathing range)
    [~, idx] = max(P1(valid)); %returns the index at where the max amplitude/peak is within the breathing range
    f_valid = f(valid); %the frequency of the peak?
    rr_fft = f_valid(idx)*60; %converting to breaths per min

    if plotsOn
        figure % FILL IN CODE HERE to add legends, axes labels, and * for peaks
        subplot(3,1,1) 
        plot(time_raw,resp_raw)
        xlabel('Time(s)');
        ylabel('Voltage(V)');
        
        subplot(3,1,2)
        plot(time,resp)
        hold on
        plot(locs, pks, 'r*');
        hold off
        xlabel('Time(s)');
        ylabel('Voltage(V)');
        
        subplot(3,1,3)
        plot(f,P1);
        hold on
        plot(f_valid(idx), P1(find(f==f_valid(idx))), 'r*');
        hold off
        xlabel('Frequency(Hz)');
        ylabel('|P1(f)|');
    end
end