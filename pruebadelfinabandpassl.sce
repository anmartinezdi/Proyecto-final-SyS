//Ruido blanco contiene todas las frecuencias
close();
clear;
[y,Fs]=wavread('C:\Users\edgar\Desktop\señales\Proyecto-final-SyS-master\Hello.wav');
y=y(1,:)
noisegen(1,length(y)-1,0.01); //Señal de ruido, se guarda como dua_g


s=y+dua_g;


function A=suma(a,b)
    for i=(1:112001)
        A(i)=a(i)+b(i)
    end
endfunction

function [F,xt]=dibujo(x)       //Dibujar señales en frecuencia
    xt=fft(x,-1);
    xt=abs(xt);
    N=length(x);
    xt=xt(1:N/2);
    F=0:((N/2)-1);      //Vector frecuencias
    F=F*Fs/N;
endfunction


hz=iir(5,'bp','butt',[200/Fs,1700/Fs],[]);
signal= flts(s,hz);

subplot(4,2,1)
plot2d(y);
title("Original");
subplot(4,2,2)
plot2d(dua_g);
title("ruido");
subplot(4,2,3)
plot2d(s);
title("Ruido+señal");
subplot(4,2,4)
plot2d(signal)
title("filtrada");


[F,yt]=dibujo(y);
subplot(4,2,5)
plot2d(F,yt);
title("OriginalFRECUECIA");
[F,rt]=dibujo(dua_g);
subplot(4,2,6)
plot2d(F,rt);
title("RuidoFRECUENCIA");
[F,st]=dibujo(s);
subplot(4,2,7)
plot2d(F,st);
title("Original+Ruido FRECUENCIA");
[F,sft]=dibujo(signal);
subplot(4,2,8)
plot2d(F,sft);
title("FiltradoFRECUENCIA");


sound(y,Fs)
sleep(2000)
sound(s,Fs)
sleep(2000)
sound(signal,Fs)
