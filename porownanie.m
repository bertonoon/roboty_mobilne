% % config % %

%Mahony
Ki = 0.8;
Kp = 3;

%Komplementarny
a = 0.02;

dt = 0.00816;

% % % % % % % 

pomiar = csvread('pomiary.csv',0,0);

t = pomiar(:,1)*dt;
ch1 = pomiar(:,2)*(2/(2^12)); % acc x (g)
ch2 = pomiar(:,3)*(2/(2^12)); % acc y
ch3 = pomiar(:,4)*(2/(2^12)); % acc z
ch4 = (pomiar(:,5))*(250/(2^12)); % gyro x ( deg/s)
ch5 = -(pomiar(:,6))*(250/(2^12)); % gyro y
ch6 = (pomiar(:,7))*(250/(2^12)); % gyro z

calka1 = zeros(length(ch1),1);
calka2 = zeros(length(ch1),1);
calka3 = zeros(length(ch1),1);
for i=2:length(ch1)
    calka1(i) = calka1(i-1) + ch4(i)*dt;
    calka2(i) = calka2(i-1) + ch5(i)*dt;
    calka3(i) = calka3(i-1) + ch6(i)*dt;
end
kom = zeros(length(t),1);

for i=2:length(kom)
    acc = atan2(ch1(i),ch3(i)) * 180 /pi;
    kom(i) = (1-a)*(kom(i-1) + ch5(i)*dt) + a*acc;
end


mah = zeros(length(ch1),1);
I = zeros(length(ch1),1);
alfa = 1 - Kp*dt;
for i=2:length(kom)
    acc =  atan2(ch1(i),ch3(i)) * 180 /pi ;
    I(i) = I(i-1) + Ki*dt*(acc-mah(i-1));
    mah(i) = alfa*mah(i-1) + (1-alfa)*acc + (ch5(i) + I(i))*dt;
end
plot(t,calka2,t,kom, t,mah,t, wlasny_filtr,t,kalman);
xlabel('Czas [s]')
ylabel(['Wychylenie wokol osi Y [' char(176) ']'])
legend('Proste calkowanie odczytu z zyroskopu', 'Wynik dzialania filtru komplementarnego','Wynik dzialania filtru Mahony`ego');
grid on