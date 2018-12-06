% % config % %

%Mahony
Ki = 0.8;
Kp = 3;

%Komplementarny
a = 0.02;

dt = 0.00408;


% GENEROWANIE DO PLIKU(ANIMACJA 3D)

% 1 - komplementarny, 2 - Mahony
typ_filtru = 1;


% % % % % % % 

pomiar = csvread('pomiary.csv',0,0);
pomiar = pomiar(2500:end,:);
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
komy = zeros(length(t),1);
komx = zeros(length(t),1);

for i=2:length(komy)
    acc = atan2(ch1(i),ch3(i)) * 180 /pi;
    komy(i) = (1-a)*(komy(i-1) + ch5(i)*dt) + a*acc;
end
for i=2:length(komy)
    acc = atan2(ch2(i),ch3(i)) * 180 /pi;
    komx(i) = (1-a)*(komx(i-1) + ch4(i)*dt) + a*acc;
end

mahy = zeros(length(ch1),1);
mahx = zeros(length(ch1),1);
I = zeros(length(ch1),1);
alfa = 1 - Kp*dt;
for i=2:length(komx)
    acc =  atan2(ch1(i),ch3(i)) * 180 /pi ;
    I(i) = I(i-1) + Ki*dt*(acc-mahy(i-1));
    mahy(i) = alfa*mahy(i-1) + (1-alfa)*acc + (ch5(i) + I(i))*dt;
end

for i=2:length(komx)
    acc =  atan2(ch2(i),ch3(i)) * 180 /pi ;
    I(i) = I(i-1) + Ki*dt*(acc-mahx(i-1));
    mahx(i) = alfa*mahx(i-1) + (1-alfa)*acc + (ch4(i) + I(i))*dt;
end


figure(1)
plot(t,calka2,t,komy, t,mahy);
xlabel('Czas [s]')
ylabel(['Wychylenie wokol osi Y [' char(176) ']'])
legend('Proste calkowanie odczytu z zyroskopu', 'Wynik dzialania filtru komplementarnego','Wynik dzialania filtru Mahony`ego');
grid on

figure(2)
plot(t,calka1,t,komx,t,mahx);
xlabel('Czas [s]')
ylabel(['Wychylenie wokol osi Y [' char(176) ']'])
legend('Proste calkowanie odczytu z zyroskopu', 'Wynik dzialania filtru komplementarnego','Wynik dzialania filtru Mahony`ego');
grid on


fileID = fopen('exptable.txt','w');
for i=1:length(komy)
    if typ_filtru == 1
        fprintf(fileID,'%f ',komy(i));
        fprintf(fileID,'%f\n',komx(i));
    end
    if typ_filtru == 2
        fprintf(fileID,'%f ',mahy(i));
        fprintf(fileID,'%f\n',mahx(i));
    end
end
fclose(fileID);