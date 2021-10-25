<?php

#variables test
$NOM_USAGER_MEM = "";
$MOT_DE_PASSE_MEM = "";

$IDUL = "C##CARAY28";
$MDP = "bd111172524";
$SERVEUR = "ift-p-ora12c.fsg.ulaval.ca:1521/ora12c";


#Connexion à la bd avec identifiant
$conn = oci_connect($IDUL, $MDP, $SERVEUR);

