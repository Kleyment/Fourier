Participants :
Valentin Thouvenin
Cl�ment Bellanger

Am�lioration de la m�thode :
Pour le contour de l'image, on parcourt les pixels dans la direction de l'angle jusqu'� sortir de l'image.
On retourne en arri�re avec le m�me nombre d'it�rations que pour sortir de l'image, et on s'arr�te lorsqu'on trouve un pixel blanc.
Si on ne trouve pas de pixel blanc, on consid�re alors le bord de l'image.
