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
v = 1;
w = 1;
V = [v*v*dt 0; 0 v*v*dt];
W = w*w;
 
x0 = [0; 0];
P0 = [1 0; 0 1];
xpri = x0;
Ppri = P0;
xpost = x0;
Ppost = P0;
 
Y = zeros(1, size(t,2));
Yf = Y;
 
for i = 1:size(pomiar, 1);
    %Obliczenie aktualnego kata na podstawie danych z akcelerometru
    akcelerometr = atan2(ch3(i),ch1(i))*180/pi;
    zyroskop = ch5(i);
    Y(i) = zyroskop;
    
    if i == 1;
        xpost = [zyroskop; 0];
    else
        
        xpri = A*xpost + B*akcelerometr;
        Ppri = A*Ppost*A' + V;
        
        % aktualizacja pomiarow
        eps = Y(i) - C*xpri;
        S = C*Ppri*C' + W;
        K = Ppri*C'*S^(-1);
        xpost = xpri + K*eps;
        Ppost = Ppri - K*S*K';
    end
    
    %Zapis estymaty do wektora wynikow
 Yf(i) = xpost(1);
end
 
plot(t, Y, 'b', t, Yf, 'r',t,calka2,'g')
title('Filtr Kalmana')
xlabel('Czas')
ylabel('Sygnal mierzony')
legend('Akcelerometr', 'Filtr Kalmana', '?yroskop')
