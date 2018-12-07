format compact
format long 
clc
clear

pomiar = csvread('pomiary.csv',0,0);

dt = 0.00816;
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

usredniony   = zeros(length(t),1);
prosta       = zeros(length(t),1);
akcel_m      = zeros(length(t),1);
filtrowany   = zeros(length(t),1);
filtrowany_m = zeros(length(t),1);
akcel = atan2(ch1,ch3)*180/pi;

% y1 = calka2(10);
% y2 = calka2(length(t));
% x1 = 10;
% x2 = length(t);
% 
% A = [x1 1;x2 1];
% B = [y1; y2];
% 
% Z = A\B;
% kat = cot(Z(1));

aproks  = polyfit(t,calka2,1);
aproks2 = polyval(aproks, t);


zyro_prosty = 1.05*(calka2 - aproks2);

for i=1:length(t) 
    if i < 2
        filtrowany(i) = (zyro_prosty(i)+akcel(i))/2;
    elseif i < length(t)     
        temp = sort([akcel(i-1:i+1) zyro_prosty(i-1:i+1)]);
        filtrowany(i) = (temp(3)+temp(4))/2;
    else
        filtrowany(i) = akcel(i);
    end
end

plot( t, zyro_prosty,t,akcel,t,filtrowany)
% plot( t, aproks2,t,aproks_akcel2);

wlasny_filtr = filtrowany;
% title('Filtr Kalmana')
% xlabel('Czas')
% ylabel('Sygnal mierzony')
legend('¯yroskop prosty', 'Akcelerometr', 'Wlasny')
