% % config % %

%Komplementarny
a = 0.02;


%Mahony
Ki = 0.8;
Kp = 3;


%Kalman
w = 25;
v = 25;


% GENEROWANIE DO PLIKU(ANIMACJA 3D)

% 1 - komplementarny, 2 - Mahony, 3 - Kalman
typ_filtru = 3;


% % % % % % % 
dt = 0.00408;
pomiar = csvread('pomiary.csv',0,0);
pomiar = pomiar(2500:end,:);
t = (pomiar(:,1)-pomiar(1,1))*dt;
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


% komplementarny
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


% Mahony
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


% Kalman


A = [1 -dt; 0 1];
B = [dt; 0];
C = [1 0];
 

V = [v*v*dt 0; 0 v*v*dt];
R = w*w;
 
x0      = [0; 0];
P0      = [1 0; 0 1];
x_t_t1  = x0;
P_t_t1  = P0;
x_t_t   = x0;
P_t_t   = P0;


kalmany = zeros(1, size(t,2));
kalmanx = zeros(1, size(t,2));
 
for i = 1:size(pomiar, 1);
    %Dane z Å¼yroskopu i akcelerometru
    akcelerometr = atan2(ch1(i),ch3(i))*180/pi;
    zyroskop     = ch5(i);
    
    
    % Inicjalizacja
    if i == 1;
        x_t_t   = [akcelerometr; 0];
    else
        
        
        x_t_t1  = A*x_t_t + B*zyroskop;
        P_t_t1  = A*P_t_t*A' + V;
        
        e_t     = akcelerometr - C*x_t_t1;
        S_t     = C*P_t_t1*C' + R;
        K_t     = P_t_t1*C'*S_t^(-1);
        x_t_t   = x_t_t1 + K_t*e_t;
        P_t_t   = P_t_t1 - K_t*S_t*K_t';
    end
    
    kalmany(i) = x_t_t(1);
end
for i = 1:size(pomiar, 1);
    %Dane z Å¼yroskopu i akcelerometru
    akcelerometr = atan2(ch2(i),ch3(i))*180/pi;
    zyroskop     = ch4(i);
    
    
    % Inicjalizacja
    if i == 1;
        x_t_t   = [akcelerometr; 0];
    else
        
        
        x_t_t1  = A*x_t_t + B*zyroskop;
        P_t_t1  = A*P_t_t*A' + V;
        
        e_t     = akcelerometr - C*x_t_t1;
        S_t     = C*P_t_t1*C' + R;
        K_t     = P_t_t1*C'*S_t^(-1);
        x_t_t   = x_t_t1 + K_t*e_t;
        P_t_t   = P_t_t1 - K_t*S_t*K_t';
    end
    
    kalmanx(i) = x_t_t(1);
end

filtrowany   = zeros(length(t),1);
akcel = atan2(ch1,ch3)*180/pi;

aproks  = polyfit(t,calka2,1);
aproks2 = polyval(aproks, t);


zyro_prosty = (calka2 - aproks2);

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
wlasnyy = filtrowany;


filtrowany   = zeros(length(t),1);
akcel = atan2(ch2,ch3)*180/pi;

aproks  = polyfit(t,calka1,1);
aproks2 = polyval(aproks, t);


zyro_prosty = (calka1 - aproks2);

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
wlasnyx = filtrowany;


figure(1)
plot(t,calka2,t,komy, t,mahy,t,kalmany,t,wlasnyy );
xlabel('Czas [s]')
ylabel(['Wychylenie wokol osi Y [' char(176) ']'])
legend('Proste calkowanie odczytu z zyroskopu', 'Wynik dzialania filtru komplementarnego','Wynik dzialania filtru Mahony`ego', 'Wynik dzialania filtru Kalmana','Wynik dzialania filtru w³anego');
grid on

figure(2)
plot(t,calka1,t,komx,t,mahx,t,kalmanx,t,wlasnyx);
xlabel('Czas [s]')
ylabel(['Wychylenie wokol osi Y [' char(176) ']'])
legend('Proste calkowanie odczytu z zyroskopu', 'Wynik dzialania filtru komplementarnego','Wynik dzialania filtru Mahony`ego', 'Wynik dzialania filtru Kalmana','Wynik dzialania filtru w³anego');
grid on


fileID = fopen('exptable.txt','w');
for i=1:length(komy)
  
        fprintf(fileID,'%f ',komy(i));
        fprintf(fileID,'%f ',komx(i));
 
    
  
        fprintf(fileID,'%f ',mahy(i));
        fprintf(fileID,'%f ',mahx(i));

    
 
        fprintf(fileID,'%f ',kalmany(i));
        fprintf(fileID,'%f',kalmanx(i));
		
		fprintf(fileID,'%f ',wlasnyy(i));
        fprintf(fileID,'%f\n',wlasnyx(i));

end
fclose(fileID);