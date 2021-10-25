<?php
include 'init.php';
include 'statut.php';

if (!estConnecte()) {
    $_SESSION['msg'] = "Veuillez vous connecter avant d'atteindre cette page.";
    header("location:connexion.php");
}

?>
<html>
	<head>
    	<style>
    	   #recherche {text-align : center;}
    	           td {border : 1px solid black;
    	               border-collapse : collapse;}
    	    #tableau-recherche {overflow-x:auto; 
    	                        border : 1px solid black;
    	                        border-collapse : collapse;}
	   </style>
	</head>
	<nav>
		<a href="index.php">Accueil</a>
		<a href="aliment.php">Aliment</a>
		<a href="liste_aliment.php">Liste des aliments</a>
	</nav>
    <body>
    	<h1>Page liste aliment</h1>
    	<form name="liste_aliment" action="liste_aliment.php" method="get" id="recherche">
    		<label>Rechercher : </label>
    		<input type="text" name="aliment">
    		<input type="submit" name="rechercher">
    	</form>
    		<div>

<?php 

if (isset($_GET["rechercher"])) {
    $aliment = $_GET["aliment"];
    $stid = oci_parse($conn, "select NOM_ALI, PORTION_ALI, UNITE_ALI, CATEGORIE_ALI, NB_POINTS_ALI, NO_ALIMENT from TP2_ALIMENT where NOM_ALI like '%" . $aliment . "%' or NUMERO_CODE_BARRE_ALI = '" . $aliment . "'");
    $requete = oci_execute($stid);

    

    echo "<table id=\"tableau-recherche\">\n
          <tr>
              <td>Nom</td>
              <td>Nombre de portion</td>
              <td>Unite par portion</td>
              <td>Catégorie</td>
              <td>Nombre de points</td>
              <td>En savoir plus</td>
          </tr>
    ";
$i = 0;

    while (($row = oci_fetch_assoc($stid)) != false) {
        $noAli = oci_result($stid, "NO_ALIMENT");
        
        if (++$i > 5) break; #on s'assure qu'il n'y a pas plus que 5 items dans une recherche.
        
        echo "<tr>";
        echo "<td>";
        echo oci_result($stid, "NOM_ALI");
        echo "</td>";
        echo "<td>";
        echo oci_result($stid, "PORTION_ALI");
        echo "</td>";
        echo "<td>";
        echo oci_result($stid, "UNITE_ALI");
        echo "</td>";
        echo "<td>";
        echo oci_result($stid, "CATEGORIE_ALI");
        echo "</td>";
        echo "<td>";
        echo oci_result($stid, "NB_POINTS_ALI");
        echo "</td>";
        echo "<td>";
        echo "<a href=\"aliment.php?NO=" . $noAli . "\">En savoir plus</a>";
        echo "</td>";
        echo "</tr>";
        
    }
    
} else {
    #Base du tableau qui est généré.
    echo "<table id=\"tableau-recherche\">\n
          <tr>
              <td>Nom</td>
              <td>Nombre de portion</td>
              <td>Unite par portion</td>
              <td>Catégorie</td>
              <td>Nombre de points</td>
              <td>En savoir plus</td>
          </tr>
    ";
    
    $stid = oci_parse($conn, "select NOM_ALI, PORTION_ALI, UNITE_ALI, CATEGORIE_ALI, NB_POINTS_ALI, NO_ALIMENT from TP2_ALIMENT order by NOM_ALI ASC");
    $requete = oci_execute($stid);
    
    while (($row = oci_fetch_assoc($stid)) != false) {
        $noAli = oci_result($stid, "NO_ALIMENT");
        
        echo "<tr>";
        echo "<td>";
            echo oci_result($stid, "NOM_ALI");
        echo "</td>";
        echo "<td>";
            echo oci_result($stid, "PORTION_ALI");
        echo "</td>";
        echo "<td>";
            echo oci_result($stid, "UNITE_ALI");
        echo "</td>";
        echo "<td>";
            echo oci_result($stid, "CATEGORIE_ALI");
        echo "</td>";
        echo "<td>";
            echo oci_result($stid, "NB_POINTS_ALI");
        echo "</td>";
        echo "<td>";
            echo "<a href=\"aliment.php?NO=" . $noAli . "\">En savoir plus</a>";
        echo "</td>";
        echo "</tr>";
        
    }
    echo "</table>";
}


?>
		</div>
    </body>
    <footer>
    <?php include_once "rabais.php"?>
    </footer>
</html>
