format compact
format long 

pomiar = csvread('gyro2(8,16ms).csv',0,0);
dt = 0.00816;
t = pomiar(:,1)*dt;
ch1 = pomiar(:,2)*(2/(2^12)); % acc x (g)
ch2 = pomiar(:,3)*(2/(2^12)); % acc y 
ch3 = pomiar(:,4)*(2/(2^12)); % acc z
ch4 = (pomiar(:,5))*(2500/(2^12)); % gyro x ( deg/s)
ch5 = (pomiar(:,6))*(2500/(2^12)); % gyro y
ch6 = (pomiar(:,7))*(2500/(2^12)); % gyro z


