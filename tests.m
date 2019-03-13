function [recall, precision] = my_tests()
% calcul des descripteurs de Fourier de la base de donnÃƒÂ©es
img_db_path = './db/';
img_db_list = glob([img_db_path, '*.gif']);
img_db = cell(1);
label_db = cell(1);
fd_db = cell(1);
for im = 1:numel(img_db_list);
    img_db{im} = logical(imread(img_db_list{im}));
    label_db{im} = get_label(img_db_list{im});
    disp(label_db{im}); 
    [fd_db{im},~,~,~] = compute_fd(img_db{im});
end

% importation des images de requÃƒÂªte dans une liste
img_path = './dbq/';
img_list = glob([img_path, '*.gif']);
t=tic()

% pour chaque image de la liste...
for im = 1:numel(img_list)
   
    % calcul du descripteur de Fourier de l'image
    img = logical(imread(img_list{im}));
    [fd,r,m,poly] = compute_fd(img)
       
    % calcul et tri des scores de distance aux descripteurs de la base
    for i = 1:length(fd_db)
        scores(i) = norm(fd-fd_db{i});
    end
    [scores, I] = sort(scores);
       
    % affichage des rÃƒÂ©sultats    
    close all;
    figure(1);
    top = 5; % taille du top-rank affichÃƒÂ©
    subplot(2,top,1);
    imshow(img); hold on;
    plot(m(1),m(2),'+b'); % affichage du barycentre
    plot(poly(:,1),poly(:,2),'v-g','MarkerSize',1,'LineWidth',1); % affichage du contour calculÃƒÂ©
    subplot(2,top,2:top);
    plot(r); % affichage du profil de forme
    for i = 1:top
        subplot(2,top,top+i);
        imshow(img_db{I(i)}); % affichage des top plus proches images
    end
    drawnow();
    waitforbuttonpress();
end
end

function [fd,r,m,poly] = compute_fd(img)
% le nombre de points du contour
N = 40;
M = 40;
h = size(img,1);
w = size(img,2);
[x,y]=find(img);
mx=round(mean(y));
my=round(mean(x));
m = [mx my];

% creer des angles N de 0 a 2 Pi avec le meme espace
t = linspace(0,2*pi,N);

poly = zeros(N, 2);
r = zeros(1,N);
for i = 1:N

j=1;
% on cherche le point se situant dans la droite de l'angle au bord de
% l'image
% tant que j n'est pas au bord de l'image
tmpX=mx;
tmpY=my;
while ((tmpX>1 & tmpY>1) & (tmpX<w & tmpY<h))
   tmpX=round(mx+j*cos(t(1,i)));
   tmpY=round(my+j*sin(t(1,i)));
   j=j+1;
end

% le nombre d'iterations que l'on a fait pour sortir du cercle sera le meme
% que le nombre d'iterations pour aller du bord jusqu'au centre
iterations=j;
bordX=tmpX;
bordY=tmpY;
% on part du bord de l'image et on regarde le premier blanc avec lequel on
% va calculer la distance au barycentre
for j = 1:iterations
   tmpX=round(bordX-j*cos(t(1,i)));
   tmpY=round(bordY-j*sin(t(1,i)));
   
   % si le pixel est blanc on s'arrete et on sauvegarde tmpX et tmpY dans les
   % contours de l'image
   if (img(tmpY,tmpX) == 1)
       dx=tmpX-mx;
       dy=tmpY-my;
       r(1,i)=sqrt(dx^2+dy^2);
       poly(i,1)=tmpX;
       poly(i,2)=tmpY;
       break;
   end
end

% si on n'a pas trouve
if (j == iterations)
    dx=bordX-mx;
    dy=bordY-my;
    r(1,i)=sqrt(dx^2+dy^2);
    poly(i,1)=bordX;
    poly(i,2)=bordY;
end

end
fd = zeros(1,N);
% On boucle sur M
for i = 1 : M
    % On a R la transformation de Fourier de r
    R(1,i) = fft(r(1,i));
    % Le vecteur fd form� par les M premiers coefficients de R(f)/R(1)
    fd(1,i) = R(1,i) / R(1,1);
end
end
