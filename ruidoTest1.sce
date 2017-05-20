//Ruido blanco contiene todas las frecuencias
close();
clear;
[y,Fs]=wavread('Hello.wav');
y=y(1,:)
noisegen(1,length(y)-1,0.1); //Señal de ruido, se guarda como dua_g

s=y+dua_g;                  //Suma de la original mas el ruido

m=50;                       //Numero de muestras de entrada
b = ones(m,1)/m;
sf=filter(b,1,s);           //Funcion de filtrado


sound(s,Fs);                //Reproduce señal con ruido

function [F,xt]=dibujo(x)       //Dibujar señales en frecuencia
    xt=fft(x,-1);
    xt=abs(xt);
    N=length(x);
    xt=xt(1:N/2);
    F=0:((N/2)-1);      //Vector frecuencias
    F=F*Fs/N;
endfunction

[F,yt]=dibujo(y);
subplot(4,1,1)
plot2d(F,yt);
title("Original");

[F,rt]=dibujo(dua_g);
subplot(4,1,2)
plot2d(F,rt);
title("Ruido");

[F,st]=dibujo(s);
subplot(4,1,3)
plot2d(F,st);
title("Original+Ruido");

[F,sft]=dibujo(sf);
subplot(4,1,4)
plot2d(F,sft);
title("Filtrado");

sound(sf,Fs);               //Reproduce señal filtrada


//Señal filtrada es similar a la original pero la magnitud 
//(volumen) es menor, parece que
//el parametro (m) afecta esto


