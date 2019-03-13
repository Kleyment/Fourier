Participants :
Valentin Thouvenin
Clément Bellanger

Amélioration de la méthode :
Pour le contour de l'image, on parcourt les pixels dans la direction de l'angle jusqu'à sortir de l'image.
On retourne en arrière avec le même nombre d'itérations que pour sortir de l'image, et on s'arrête lorsqu'on trouve un pixel blanc.
Si on ne trouve pas de pixel blanc, on considère alors le bord de l'image.
