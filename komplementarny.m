% % config % %

a = 0.002;
dt = 0.00816;

% % % % % % % 

pomiar = csvread('gyro2(8,16ms).csv',0,0);

t = pomiar(:,1)*dt;
ch1 = pomiar(:,2)*(2/(2^12)); % acc x (g)
ch2 = pomiar(:,3)*(2/(2^12)); % acc y
ch3 = pomiar(:,4)*(2/(2^12)); % acc z
ch4 = (pomiar(:,5))*(2500/(2^12)); % gyro x ( deg/s)
ch5 = (pomiar(:,6))*(2500/(2^12)); % gyro y
ch6 = (pomiar(:,7))*(2500/(2^12)); % gyro z

calka1 = zeros(length(ch1),1);
calka2 = zeros(length(ch1),1);
calka3 = zeros(length(ch1),1);
for i=2:length(ch1)
    calka1(i) = calka1(i-1) + ch4(i)*dt;
    calka2(i) = calka2(i-1) + ch5(i)*dt;
    calka3(i) = calka3(i-1) + ch6(i)*dt;
end

kom = zeros(length(ch1),1);

for i=2:length(kom)
    acc = atan2(ch3(i),ch1(i)) * 180 /pi;
    kom(i) = (1-a)*(kom(i-1) + ch5(i)*dt) + a*acc ;
end
plot(t,calka2,t,kom);
xlabel('Czas [s]')
ylabel(['Wychylenie wokol osi Y [' char(176) ']'])
legend('Proste calkowanie odczytu z zyroskopu', 'Wynik dzialania filtru komplementarnego');
grid on