function [JT1]=gabor(M,N,a,count,AD)
gab1=zeros(3,3);
gab=zeros(count,2);
JT1=0;
c=0; 
for k=1:10;
         W=a^2 * 0.05;
         sigmax=((a+1)*sqrt(2 * log(2))) / (2 * pi * a^2 * (a-1) * 0.05);
         sigmay1=((0.4 *0.4) / (2*log(2))) - (( 1 / (2 *pi* sigmax))^2); 
         sigmay=1 / ((2* pi * tan(pi/(2*N)) * sqrt ( sigmay1)));
         theta=30+c ;
         for ij=1:2
            for i=1:3
              for j=1:3
                    xb=a^(-2) * (i*cos(theta) + j*sin(theta));
                    yb=a^(-2) * ((-i)*sin(theta) + j*cos(theta));
                    phi1=(-1/2) * ((xb*xb)/(sigmax*sigmax) + (yb*yb)/(sigmay*sigmay));
                     if ij==1
                        prob=i;
                    else
                        prob=j;
                    end
                    phi=(1/(2*pi*sigmax*sigmay)) * exp(phi1) * exp(2*2*pi*W*prob);
                    gab1(i,j)=phi* a^(-2);
              end
           end
         gab(count,ij)=gab1(i,j);
         end
% Convolve
JT=conv2(AD,gab);
JT1=imadd(JT,JT1);
end
% figure,imshow(JT1);
