
/////////////////////////////////////////1ERPUNTO//////////////////////////////////
[x1,Fs]=loadwave("recording2017_05_07_13_55_14.wav")
[h1,Fs,bits]=wavread("York_catedral.wav")
[h2,Fs1,bits]=wavread("estudio_grabacion.wav")
[h3,Fs2,bits]=wavread("UN_Plaza_che.wav")

function A=convolucion(a,b)
    c=fft(a)
    d=fft(b)
//    for i=(1:length(c))
//        B(1,i)=c(1,i)*d(1,i)
//    end

B=c.*d;
    A=fft(B,1)
    
endfunction

function A=cortar(a)
    for i=(1:112001)
        A(1,i)=a(i)
    end
endfunction

function A=alargar(a,b)
    for i=(1:length(a))
        A(1,i)=a(1,i)
    end
    for i=((length(a)+1):b)
        A(1,i)=0
    end
endfunction


hh1=h1(1,1:length(h1)/2)
hh2=h2(1,1:length(h2)/2)
//hh3=h3(1,1:length(h3)/2)

x=cortar(x1)

h1=cortar(hh1)
h2=alargar(hh2,length(x))  //iguala todas las señales a un mismo tamaño 
h3=alargar(h3,length(x))



C1=convolucion(x,h1)
C2=convolucion(x,h2)  
C3=convolucion(x,h3)
CREAL1=real(C1)
CREAL2=real(C2)
CREAL3=real(C3)


xtitle ("York_catedral") 
subplot(3,3,1)
plot2d(x)
subplot(3,3,2)
plot2d(h1)
subplot(3,3,3)
plot2d(C1)
subplot(3,3,4)
plot2d(x)
xtitle ("estudio_grabacion") 
subplot(3,3,5)
plot2d(h2)
subplot(3,3,6)
plot2d(C2)
subplot(3,3,7)
plot2d(x)
title ("plaza che") 
subplot(3,3,8)
plot2d(h3)
subplot(3,3,9)
plot2d(C3)

function sounds(a,b,c)
sound(a,16000)
sleep (5000)
sound(b,16000)
sleep(5000)
sound(c,16000)
sleep(5000)
endfunction

sounds(x,h1,CREAL1)
sounds(x,h2,CREAL2)
sounds(x,h3,CREAL3)

///////////////////SEGUNDO y TERCER PUNTO////////////////////////////////////////////////////

//Ruido blanco contiene todas las frecuencias
close();

// elegir que recirto quiere  procesar? -- C1 C2 C3

y=C1   //este es mi y del sistema salida

y=y(1,:)
relacionS_R=0.01  //Relacion reñal a ruido
noisegen(1,length(y)-1,relacionS_R); //Señal de ruido, se guarda como dua_g
noisefiltering=iir(7,'bp','butt',[3000/Fs,5000/Fs],[]); 
noise= flts(dua_g,noisefiltering); // hago un filtro para el ruido, asi puedo eleguir frecuancias selectivamente de ruido.


s=y+noise;  //suma señal y ruido 

function [F,xt]=dibujo(x)       //Dibujar señales en frecuencia
    xt=fft(x,-1);
    xt=abs(xt);
    N=length(x);
    xt=xt(1:N/2);
    F=0:((N/2)-1);      //Vector frecuencias
    F=F*Fs/N;
endfunction


hz=iir(7,'bp','butt',[100/Fs,2000/Fs],[]);
signal= flts(s,hz);      //SEÑAL PROCESADA CON RUIDO Y DESPUES FILTRADA

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
[F,rt]=dibujo(noise);
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
sleep(2000)

////////////////////////////////////////////PUNTO 4/////////////////////////////////////////////////
close();
function A=RespImpulso(a,b)
    c=fft(a)
    d=fft(b)
//    for i=(1:length(c))
//        B(1,i)=d(1,i)/c(1,i)
//    end
B=d./c;
    A=fft(B,1)
endfunction

//B=cortar(C1)

A=RespImpulso(x,C3) //toma entrada y salida del sistema y encuentra su respuesta al impulso respectiva: varian entre C1,C2,C3

//Se hace promedio entre la respuesta al impulso obtenida y las originales y 
//Se toma el valor absoluto de la diferencia entre el promedio y la respuesta al impulso obtenida. Si este es menor a 0.1 las señales son estadisticamente iguales


r=(A+h1)/2;
r1=abs(A-r);
l=(A+h2)/2;
l1=abs(A-l);
p=(A+h3)/2;
p1=abs(A-p);


if r1<0.1 then
    subplot(4,1,1)
     plot2d(y);
     xtitle ("York_catedral") 
     subplot(4,1,2)
     plot2d(x);
     subplot(4,1,3)
     plot2d(h1);
     subplot(4,1,4)
     plot2d(A);
     sound(h1);
     sound(A);
 elseif l1<0.1 then 
     subplot(4,1,1)
     plot2d(y);
     subplot(4,1,2)
     plot2d(x1);
     subplot(4,1,3)
     plot2d(h2);
     xtitle ("estudio_grabacion") 
     subplot(4,1,4)
     plot2d(A);
     sound(h3);
     sound(A);
 elseif p1<0.1 then 
     subplot(4,1,1)
     plot2d(y);
     subplot(4,1,2)
     plot2d(x1);
     subplot(4,1,3)
     plot2d(h3);
     title ("plaza che") 
     subplot(4,1,4)
     plot2d(A);
     sound(h3);
     sound(A);
     
 else 
      title("no corresponde");
      subplot(4,1,1)
     plot2d(A);
     subplot(4,1,2)
     plot2d(h1);
     subplot(4,1,3)
     plot2d(h2)
     subplot(4,1,4)
     plot2d(h3)
end
