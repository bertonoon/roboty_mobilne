format compact
format long 

pomiar = csvread('pomiary.csv',0,0);
dt = 0.00816;
t = pomiar(:,1)*dt;
ch1 = pomiar(:,2)*(2/(2^12)); % acc x (g)
ch2 = pomiar(:,3)*(2/(2^12)); % acc y
ch3 = pomiar(:,4)*(2/(2^12)); % acc z
ch4 = (pomiar(:,5))*(250/(2^12)); % gyro x ( deg/s)
ch5 = -(pomiar(:,6))*(250/(2^12)); % gyro y
ch6 = (pomiar(:,7))*(250/(2^12)); % gyro zcalka1 = zeros(length(ch1),1);
calka2 = zeros(length(ch1),1);
calka3 = zeros(length(ch1),1);
for i=2:length(ch1)
    calka1(i) = calka1(i-1) + ch4(i)*dt;
    calka2(i) = calka2(i-1) + ch5(i)*dt;
    calka3(i) = calka3(i-1) + ch6(i)*dt;
end

akcel = zeros(length(t),1);
akcel = atan2(ch1,ch3)*180/pi;

plot( t, calka2,t,akcel)
% title('Filtr Kalmana')
% xlabel('Czas')
% ylabel('Sygnal mierzony')
% legend('Akcelerometr', 'Filtr Kalmana', '¯yroskop')
