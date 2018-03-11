program bataille_naval_;

uses crt;

CONST
	MAX=10;

Type
    cellule = record 

        ligne,colonne:integer;

end;

Type
	ensemble_cel=array[1..50] of cellule; 

Type
	Tabbat=array[1..5] of cellule;

Type
    bateau = record

        bat:Tabbat;

end;

Type
	Tabflot=array[1..5] of bateau;
Type
    flotte = record //création du type flotte composé d'un Tabflot et d'un numéro de joueur

        numero_joueur:integer; 
		flot:Tabflot;

end;

// FONCTIONS


function creation_cellule(ligne,colonne:integer):cellule;
VAR
	res:cellule; 
BEGIN
	res.ligne:=ligne;
	res.colonne:=colonne;
	creation_cellule:=res;
END;

function comparer_2_cellule(cellule1,cellule2:cellule):boolean;
VAR
	res:boolean;
BEGIN
	res:=FALSE; //initialisation de res
	IF (cellule1.ligne=cellule2.ligne) AND (cellule1.colonne=cellule2.colonne) THEN
		begin
			res:=TRUE;
		end;
	comparer_2_cellule:=res 
END;

function verif_cel_bat(tab:ensemble_cel;cel:cellule):boolean;
VAR
	res:boolean; 
	i:integer;
BEGIN
	res:=FALSE;
	i:=0; //initialisation de i
	REPEAT
		i:=i+1; 
		IF (cel.ligne=tab[i].ligne) AND (cel.colonne=tab[i].colonne) THEN
			begin
				res:=TRUE;
	UNTIL (res=TRUE) OR (i=50);
	IF (cel.ligne<0) OR (cel.colonne<0) OR (cel.ligne>MAX) OR (cel.colonne>MAX)THEN
		begin
			res:=TRUE; 
		end;
	verif_cel_bat:=res; //renvoie vrai ou faux
END;

function creation_de_bateau(cel:cellule;taille,direction:integer;tab:ensemble_cel):bateau;
VAR
	res:bateau;
	test:boolean;
	cel2:cellule;
	i,compteur:integer;
BEGIN
	compteur:=0;
	test:=verif_cel_bat(tab,cel);
	IF test=FALSE THEN 
		begin
			res.bat[1]:=cel; // la première cellule du bateau sera la cellule d'origine
			FOR i:=2 TO taille DO //de la deuxième cellule à la taille du bateau
				begin
					CASE direction of //selon la direction on fait
						1:begin
						   res.bat[i].colonne:=cel.colonne+i-1;
						   res.bat[i].ligne:=cel.ligne;
						   cel2:=res.bat[i];
						   test:=verif_cel_bat(tab,cel2);	 //vérification que la cellule créée est valide
						   IF test=TRUE THEN
							begin
								compteur:=compteur+1;
							end;
						 end;
						2:begin
						    res.bat[i].colonne:=cel.colonne;
							res.bat[i].ligne:=cel.ligne+i-1;
							cel2:=res.bat[i];
							test:=verif_cel_bat(tab,cel2);
							IF test=TRUE THEN
							begin
								compteur:=compteur+1;
							end;
						  end;
						3:begin
						    res.bat[i].colonne:=cel.colonne;
							res.bat[i].ligne:=cel.ligne-i+1;
							cel2:=res.bat[i];
							test:=verif_cel_bat(tab,cel2);
							IF test=TRUE THEN
							begin
								compteur:=compteur+1; 
						  end;
						4:begin
						   res.bat[i].colonne:=cel.colonne-i+1;
						   res.bat[i].ligne:=cel.ligne;
						   cel2:=res.bat[i];
						   test:=verif_cel_bat(tab,cel2);
							begin
								compteur:=compteur+1;
						  end;
					end;
				end;
		end;
	IF compteur>0 THEN
		begin
			test:=TRUE;
		end;
	IF (test=FALSE) AND (taille<>5) THEN //si toute les cellules crée sont valide alors on rempli le reste du bateau avec des 0
		begin
			FOR i:=taille+1 TO 5 DO
				begin
					res.bat[i].colonne:=0;
					res.bat[i].ligne:=0;
				end;
		end
	ELSE
		begin
			IF test=TRUE THEN
				begin
					FOR i:=1 TO 5 DO
						begin
							res.bat[i].colonne:=0;
							res.bat[i].ligne:=0;
						end;
				end;
		end;
	creation_de_bateau:=res;
END;

function creation_flotte(numJoueur:integer;var tab:ensemble_cel):flotte;
VAR
	ligne,colonne,dir:integer;
	res:flotte;
	i,j,x:integer; 
	cel:cellule;
BEGIN

	writeln(UTF8ToAnsi('Création de la flotte du joueur numéro '),numJoueur);
	writeln();
	res.numero_joueur:=numJoueur; //le numéro du joueur prend la valeur 1 ou 2
	REPEAT
		REPEAT
			writeln(UTF8ToAnsi('Veuillez entrer une ligne et un colonne de départ pour votre porte-avion (taille 5) (entre 1 et '),MAX,') :');
			readln(ligne);
			readln(colonne);
		UNTIL (ligne>0) AND (ligne<=MAX) AND (colonne>0) AND (colonne<=MAX);
		cel:=creation_cellule(ligne,colonne);
		REPEAT
			writeln('Veuillez entrer une direction 1:droite 2:bas 3:haut 4:gauche');
			readln(dir); 
		UNTIL (dir>0) AND (dir<5);
		res.flot[1]:=creation_de_bateau(cel,5,dir,tab); 
	UNTIL res.flot[1].bat[1].ligne>0; 
	i:=1; //initialisation de i
	WHILE (tab[i].ligne<>0) AND (tab[i].colonne<>0) DO
		begin
			i:=i+1;
		end;
	x:=1;
	FOR j:=i to i+4 DO 
		begin
			tab[j].ligne:=res.flot[1].bat[x].ligne;
			tab[j].colonne:=res.flot[1].bat[x].colonne;
			x:=x+1;
		end;
	REPEAT
		REPEAT
			writeln();
			writeln(UTF8ToAnsi('Entrez une ligne et un colonne de départ pour votre croiser (taille 4) (entre 1 et '),MAX,') :');
			readln(ligne);
			readln(colonne);
		UNTIL (ligne>0) AND (ligne<=MAX) AND (colonne>0) AND (colonne<=MAX);
		cel:=creation_cellule(ligne,colonne);
		REPEAT
			writeln('Veuillez entrer une direction 1:droite 2:bas 3:haut 4:gauche');
			readln(dir);
		UNTIL (dir>0) AND (dir<5);
		res.flot[2]:=creation_de_bateau(cel,4,dir,tab);
	UNTIL res.flot[2].bat[1].ligne<>0;
	i:=1;
	WHILE (tab[i].ligne<>0) AND (tab[i].colonne<>0) DO
		begin
			i:=i+1;
		end;
	x:=1;
	FOR j:=i to i+4 DO
		begin
			tab[j]:=res.flot[2].bat[x];
			x:=x+1;
		end;
	REPEAT
		REPEAT
			writeln();
			writeln(UTF8ToAnsi('Entrez une ligne et un colonne de départ pour votre contre-torpilleurs (taille 3) (entre 1 et '),MAX,') :');
			readln(ligne);
			readln(colonne);
		UNTIL (ligne>0) AND (ligne<=MAX) AND (colonne>0) AND (colonne<=MAX);
		cel:=creation_cellule(ligne,colonne);
		REPEAT
			writeln('Entrez une direction 1:droite 2:bas 3:haut 4:gauche');
			readln(dir);
		UNTIL (dir>0) AND (dir<5);
		res.flot[3]:=creation_de_bateau(cel,3,dir,tab);
	UNTIL res.flot[3].bat[1].ligne<>0;
	i:=1;
	WHILE (tab[i].ligne<>0) AND (tab[i].colonne<>0) DO
		begin
			i:=i+1;
		end;
	x:=1;
	FOR j:=i to i+4 DO
		begin
			tab[j]:=res.flot[3].bat[x];
			x:=x+1;
		end;
	REPEAT
		REPEAT
			writeln();
			writeln(UTF8ToAnsi('Entrez une ligne et un colonne de départ pour votre sous-marin (taille 3) (entre 1 et '),MAX,') :');
			readln(ligne);
			readln(colonne);
		UNTIL (ligne>0) AND (ligne<=MAX) AND (colonne>0) AND (colonne<=MAX);
		cel:=creation_cellule(ligne,colonne);
		REPEAT
			writeln('Entrez une direction 1:droite 2:bas 3:haut 4:gauche');
			readln(dir);
		UNTIL (dir>0) AND (dir<5);
		res.flot[4]:=creation_de_bateau(cel,3,dir,tab);
	UNTIL res.flot[4].bat[1].ligne<>0;
	i:=1;
	WHILE (tab[i].ligne<>0) AND (tab[i].colonne<>0) DO
		begin
			i:=i+1;
		end;
	x:=1;
	FOR j:=i to i+4 DO
		begin
			tab[j]:=res.flot[4].bat[x];
			x:=x+1;
		end;
	REPEAT
		REPEAT
			writeln();
			writeln(UTF8ToAnsi('Entrez une ligne et un colonne de départ pour votre  torpilleur (taille 2) (entre 1 et '),MAX,') :');
			readln(ligne);
			readln(colonne);
		UNTIL (ligne>0) AND (ligne<=MAX) AND (colonne>0) AND (colonne<=MAX);
		cel:=creation_cellule(ligne,colonne);
		REPEAT
			writeln('Entrez une direction 1:droite 2:bas 3:haut 4:gauche');
			readln(dir);
		UNTIL (dir>0) AND (dir<5);
		res.flot[5]:=creation_de_bateau(cel,2,dir,tab);
	UNTIL res.flot[5].bat[1].ligne<>0;
	i:=1;
	WHILE (tab[i].ligne<>0) AND (tab[i].colonne<>0) DO
		begin
			i:=i+1;
		end;
	x:=1;
	FOR j:=i to i+4 DO
		begin
			tab[j]:=res.flot[5].bat[x];
			x:=x+1;
		end;
	creation_flotte:=res; //on renvoie la flotte
END;

function verif_cel_flotte(var num_bat:integer;var num_cel:integer;cel:cellule;F:flotte):boolean;
VAR
	res:boolean; 
	i,j:integer;
	cel2:cellule; //cel2 permet de comparer les cellules
BEGIN

	num_bat:=0; 
	num_cel:=0;
	res:=FALSE; 
	FOR i:=1 to 5 DO //pour chaque bateaux de la flotte
		begin
			FOR j:=1 to 5 DO //pour chaque cellule du bateau
				begin
					cel2:=F.flot[i].bat[j];
					res:=comparer_2_cellule(cel,cel2); //vérifier que la cellule apparteint à la flotte
					IF (res=TRUE) AND (num_bat=0) THEN
						begin
							num_bat:=i; //si elle y apparteint alors on retient sa position (le numéro du bateau et de la cellule)
							num_cel:=j;
						end;
				end;
		end;
	IF num_bat<>0 THEN //on renvoie vrai si num_bat est différent de 0
		begin
			res:=TRUE;
		end;
	verif_cel_flotte:=res; //renvoie vrai ou faux
END;

function verif_destruction_flotte(F:flotte):boolean;

VAR
	i,j,compteur:integer;
	res:boolean;
BEGIN
	res:=FALSE; 
	compteur:=0; 
	FOR i:=1 TO 5 DO
		begin
			FOR j:=1 TO 5 DO
				begin
					IF (F.flot[i].bat[j].ligne=0) AND (F.flot[i].bat[j].colonne=0) THEN
						begin
							compteur:=compteur+1;
						end;
				end;
		end;
	IF compteur=25 THEN 
		begin
			res:=TRUE;
		end;
	verif_destruction_flotte:=res;
END;

VAR
	flotJ1,flotJ2:flotte;
	Tabcel:ensemble_cel;
	testVJ1,testVJ2,testtoucher:boolean;
	nbtour,ligne,colonne,num_bat,num_cel,testrejouer,i:integer;
	celtire:cellule;
BEGIN

	REPEAT //relance le programme
		clrscr;
		testVJ1:=FALSE;
		testVJ2:=FALSE;
		nbtour:=0;
		For i:=1 to 50 do
			begin
				Tabcel[i].ligne:=0;
				Tabcel[i].colonne:=0;
			end;
		writeln('Bataille naval');
		writeln();
		writeln(UTF8ToAnsi('Attention, les deux flottes sont sur la même grille et aucun des deux joueurs ne peut toucher sa propre flotte ni poser son bateau sur un autre'));
		writeln();
		flotJ1:=creation_flotte(1,Tabcel); //création de la flotte du joueur 1  
		clrscr;
		flotJ2:=creation_flotte(2,Tabcel); //création de la flotte du joueur 2
		clrscr;
		REPEAT
			nbtour:=nbtour+1; 
			IF nbtour MOD 2<>0 THEN //si le nombre de tours est impaire alors c'est le tour du joueur 1
				begin
					clrscr;
					writeln('Tour du joueur 1');
					REPEAT
						writeln();
						writeln(UTF8ToAnsi('Veuillez entrer les coordonnées d''une case à attaquer :'));
						readln(ligne); //demande d'une case à attaquer
						readln(colonne);
					UNTIL (ligne>0) AND (ligne<=MAX) AND (colonne>0) AND (colonne<=MAX); //vérification que les coordonnées sont valides
					celtire:=creation_cellule(ligne,colonne); //création d'une cellule visée
					testtoucher:=verif_cel_flotte(num_bat,num_cel,celtire,flotJ2); //vérification de si elle appartient à la flotte de J2 
					IF testtoucher=TRUE THEN
						begin
							writeln();
							writeln(UTF8ToAnsi('Touché !')); //SI c'est le cas alors on supprime la cellule en la remplaçant avec des 0
							flotJ2.flot[num_bat].bat[num_cel].ligne:=0;
							flotJ2.flot[num_bat].bat[num_cel].colonne:=0;
						end
					ELSE	
						begin
							writeln();
							writeln(UTF8ToAnsi('Raté'));
						end;
				end
			ELSE
				begin
					clrscr;
					writeln('Tour du joueur 2'); 
					REPEAT
						writeln();
						writeln(UTF8ToAnsi('Veuillez entrer les coordonnées d''une case à attaquer :'));
						readln(ligne); 
						readln(colonne);
					UNTIL (ligne>0) AND (ligne<=MAX) AND (colonne>0) AND (colonne<=MAX);
					celtire:=creation_cellule(ligne,colonne);
					testtoucher:=verif_cel_flotte(num_bat,num_cel,celtire,flotJ1);
					IF testtoucher=TRUE THEN
						begin
							writeln();
							writeln(UTF8ToAnsi('Touché !')); 
							flotJ1.flot[num_bat].bat[num_cel].ligne:=0;
							flotJ1.flot[num_bat].bat[num_cel].colonne:=0;
						end
					ELSE	
						begin
							writeln();
							writeln(UTF8ToAnsi('Raté'));
						end;
				end;
			testVJ1:=verif_destruction_flotte(flotJ2); 
			testVJ2:=verif_destruction_flotte(flotJ1); 
			readln;
		UNTIL (testVJ1=TRUE) OR (testVJ2=TRUE);
		IF testVJ1=TRUE THEN 
			begin
				writeln();
				writeln('Victoire de J1 !');
			end
		ELSE
			begin
				writeln();
				writeln('Victoire de J2 !');
			end;
		writeln();
		writeln('Tapez 0 pour quitter ou n''importe quel autre nombre pour rejouer :');
		readln(testrejouer);
	UNTIL testrejouer=0;

END.