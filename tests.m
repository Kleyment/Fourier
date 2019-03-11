function [recall, precision] = my_tests()
% calcul des descripteurs de Fourier de la base de donnÃ©es
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

% importation des images de requÃªte dans une liste
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
       
    % affichage des rÃ©sultats    
    close all;
    figure(1);
    top = 5; % taille du top-rank affichÃ©
    subplot(2,top,1);
    imshow(img); hold on;
    plot(m(1),m(2),'+b'); % affichage du barycentre
    plot(poly(:,1),poly(:,2),'v-g','MarkerSize',1,'LineWidth',1); % affichage du contour calculÃ©
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
N = 512; % Ã  modifier !!!
M = 512; % Ã  modifier !!!
h = size(img,1);
w = size(img,2);
[x,y,v]=find(img);
m = [round(mean(y)) round(mean(x))]
%m = [w/2 h/2]; % Ã  modifier !!!
%m = [ 110 120];

t = linspace(0,2*pi,100);
R = min(h,w)/2;
poly = [m(1)+R*cos(t'), m(2)+R*sin(t')]; % Ã  modifier !!!
r = R*ones(1,N); % Ã  modifier !!!
fd = rand(1,M); % Ã  modifier !!!
end
