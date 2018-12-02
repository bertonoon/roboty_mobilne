format compact
format long 

pomiar = csvread('pomiary.csv',0,0);
dt = 0.00816;
t = pomiar(:,1)*dt;
ch1 = pomiar(:,2)*(2/(2^12)); % acc x (g)
ch2 = pomiar(:,3)*(2/(2^12)); % acc y 
ch3 = pomiar(:,4)*(2/(2^12)); % acc z
ch4 = (pomiar(:,5))*(250/(2^12)); % gyro x ( deg/s)
ch5 = (pomiar(:,6))*(250/(2^12)); % gyro y
ch6 = (pomiar(:,7))*(250/(2^12)); % gyro z
calka1 = zeros(length(ch1),1);
calka2 = zeros(length(ch1),1);
calka3 = zeros(length(ch1),1);
for i=2:length(ch1)
    calka1(i) = calka1(i-1) + ch4(i)*dt;
    calka2(i) = calka2(i-1) + ch5(i)*dt;
    calka3(i) = calka3(i-1) + ch6(i)*dt;
end

A = [1 -dt; 0 1];
B = [dt; 0];
C = [1 0];
 
%Szum
v = 0.7;
w = 1;
V = [v*v*dt 0; 0 v*v*dt];
R = w*w;
 
x0      = [0; 0];
P0      = [1 0; 0 1];
x_t_t1  = x0;
P_t_t1  = P0;
x_t_t   = x0;
P_t_t   = P0;
 
Y = zeros(1, size(t,2));
Yf = Y;
 
for i = 1:size(pomiar, 1);
    %Dane z ¿yroskopu i akcelerometru
    akcelerometr = atan2(ch3(i),ch1(i))*180/pi;
    zyroskop     = ch5(i);
    Y(i)         = zyroskop;
    
    % Inicjalizacja
    if i == 1;
        x_t_t   = [zyroskop; 0];
    else
        
        
        x_t_t1  = A*x_t_t + B*akcelerometr;
        P_t_t1  = A*P_t_t*A' + V;
        
        e_t     = Y(i) - C*x_t_t1;
        S_t     = C*P_t_t1*C' + R;
        K_t     = P_t_t1*C'*S_t^(-1);
        x_t_t   = x_t_t1 + K_t*e_t;
        P_t_t   = P_t_t1 - K_t*S_t*K_t';
    end
    
    Yf(i) = x_t_t(1);
end
 
plot(t, Y, 'b', t, Yf, 'r',t,calka2,'g')
title('Filtr Kalmana')
xlabel('Czas')
ylabel('Sygnal mierzony')
legend('Akcelerometr', 'Filtr Kalmana', '¯yroskop')
