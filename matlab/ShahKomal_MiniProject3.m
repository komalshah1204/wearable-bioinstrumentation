clear 
clc
close all

%% Connect Arduino

a = arduino();

%% Collect and Save Data

% define variables and call pressureSensor function
sampleTime = 10;
thresh = 2.5;
livePlot = false;
pauseTime = 0;
r1 = 100;
Vin = 5;

% calcuate data acqusition rate
%fs = height(data)/sampleTime;

study = struct();

for i = 1:6
    data = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);
    study(i).data = data;
    study(i).r2 = r1*mean(study(i).data.voltage)/(Vin-mean((study(i).data.voltage)));
    pause
end

% save pressureSensor output table to a study array, table, or structure




% save pressureSensor output table to a csv in your data folder



%% Figure 1. Calculate Resistance

figure;
hold on;
for i = 1:6
    plot(study(i).data.time,study(i).data.voltage);
end
xlabel('Time(s)');
ylabel('Voltage(V)');
title('Pressure Sensor Samples');
legend(['No Object: Sample 1', num2str(study(1).r2)], ['No Object: Sample 2', num2str(study(2).r2)], ['Water Bottle: Sample 1', num2str(study(3).r2)], ['Water Bottle: Sample 2', num2str(study(4).r2)], ['Phone: Sample 1', num2str(study(5).r2)], ['Phone: Sample 2', num2str(study(6).r2)]);
hold off;

%% Figure 2. Changing R1

r1_single = r1;
r1_series = r1+r1;
r1_parallel = (r1*r1)/(r1+r1);

r2_untouched = study(1).r2;

Vout_single = Vin*r2_untouched/(r1_single + r2_untouched);
Vout_series = Vin*r2_untouched/(r1_series + r2_untouched);
Vout_parallel = Vin*r2_untouched/(r1_parallel + r2_untouched);

data_single = pressureSensor(a, sampleTime, thresh, livePlot, pauseTime);
pause
data_series = pressureSensor(a, sampleTime, thresh, livePlot, pauseTime);
pause
data_parallel = pressureSensor(a, sampleTime, thresh, livePlot, pauseTime);

avg_single = mean(data_single.voltage);
avg_series = mean(data_series.voltage);
avg_parallel = mean(data_parallel.voltage);

figure;
hold on;
plot(data_single.time,data_single.voltage)
plot(data_series.time, data_series.voltage);
plot(data_parallel.time, data_parallel.voltage);
xlabel('Time(s)');
ylabel('Voltage(V)');
title('Changing R1');
legend(['Single- avg = ' num2str(avg_single)], ['Series- avg = ' num2str(avg_series)], ['Parallel- avg = ' num2str(avg_parallel)]);
hold off;

%% Figure 3. Respiration
sampleTime = 300;
thresh = 2.5;
data = pressureSensor(a, sampleTime, thresh, livePlot, pauseTime);
figure;
plot(data.time,data.voltage);
xlabel('Time(s)');
ylabel('Voltage(V)');
title('Respiration');
writetable(data,'C:\Users\komal\git\wearable-bioinstrumentation\data\pressureSensorData.csv')

