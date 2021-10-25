<?php
 include 'statut.php';
 include 'init.php';
 
 if (estConnecte()){
     if ($_SESSION['usager']) {
         header("Location: liste_aliment.php");
     } elseif ($_SESSION['admin']) {
         header("Location: admin.php");
     }
 }
 else {
     $_SESSION['msg'] = "Veuillez vous connecter pour accéder à votre compte.";
     #echo $_SESSION['msg'];
 }
 
 ?>

<html>

	<head>
		<title>Mon poids ca compte</title>
		
	</head>
	<header>
	</header>
	<body>
		
		<?php
		echo '<h4>Inscription</h4>';
    	
    	echo '<form action="index.php" method="post">';
		echo 'Nom usager : <input type="text" name="NOM_USAGER_MEM"><br>';
		echo 'Mot de passe :<input type="password" name="MOT_DE_PASSE_MEM"><br>';
		echo 'Prénom : <input type="text" name="PRENOM_MEM"><br>';
		echo 'Nom : <input type="text" name="NOM_MEM"><br>';
		echo 'Courriel :   <input type="text" name="COURRIEL_MEM"><br>';
		echo 'Sexe :  <input type="radio" id="SEXE_MEM_M" name="sexe" value="M">­­­­<label for="SEXE_MEM">Masculin</label>
		              <input type="radio" id="SEXE_MEM_F" name="sexe" value="F">­­­­<label for="SEXE_MEM">Féminin</label><br>';
		echo 'Taille :    <input type="text" name="TAILLE_MEM"><br>';
		echo 'Date de naissance : <input type="text" name="DATE_NAISSANCE_MEM"><br>';
		echo 'Poids initial : <input type="text" name="POIDS_INITIAL_MEM"><br>';
		echo 'Poids désiré : <input type="text" name="POIDS_DESIRE_MEM"><br>';
		echo 'Unité de poids : <input type="radio" name="UNITE_POIDS_MEM" value= "Lb""><label>Livres</label>
                               <input type="radio" name="UNITE_POIDS_MEM" value= "Kg""><label>Kilogrammes</label><br>';

		echo '<input type="submit" name="ajout" value="Inscription"><br>';
		echo "</form>";

		if(isset($_POST["ajout"])){
		    
		    $NOM_USAGER = $_POST['NOM_USAGER_MEM'];
		    $MDP = $_POST['MOT_DE_PASSE_MEM'];
		    $PRENOM = $_POST['PRENOM_MEM'];
		    $NOM = $_POST['NOM_MEM'];
		    $COURRIEL = $_POST['COURRIEL_MEM'];
		    $SEXE = $_POST['sexe'];
		    $TAILLE = $_POST['TAILLE_MEM'];
		    $DATE_NAI = $_POST['DATE_NAISSANCE_MEM'];
		    $POIDS_INI = $_POST['POIDS_INITIAL_MEM'];
		    $POIDS_DESIRE = $_POST['POIDS_DESIRE_MEM'];
		    $UNITE_POIDS = $_POST['UNITE_POIDS_MEM'];
		   
		    
		    echo $NOM_USAGER . "\n";
		    echo $MDP. "\n";
		    echo $PRENOM. "\n";
		    echo $NOM. "\n";
		    echo $COURRIEL. "\n";
		    echo $SEXE. "\n";
		    echo $TAILLE. "\n";
		    echo $DATE_NAI. "\n";
		    echo $POIDS_INI. "\n";
		    echo $POIDS_DESIRE. "\n";
		    echo $UNITE_POIDS. "\n";
		    
		    $stid = oci_parse($conn, "insert into TP2_MEMBRE(NO_MEMBRE, NOM_USAGER_MEM, MOT_DE_PASSE_MEM, PRENOM_MEM, NOM_MEM,
            COURRIEL_MEM, SEXE_MEM, TAILLE_MEM, POIDS_INITIAL_MEM, POIDS_DESIRE_MEM, UNITE_POIDS_MEM, DATE_NAISSANCE_MEM)
            values (NO_MEMBRE_SEQ.nextval, :NOM_USAGER_M, :MDP_M, :PRENOM_M, :NOM_M, :COURRIEL_M, :SEXE_M, :TAILLE_M,
             :POIDS_INI_M, :POIDS_DESI_M, :UNITE_POIDS_M, to_date('$DATE_NAI','RR-MM-DD'))");
		    
		     
		    
		    oci_bind_by_name($stid, ":NOM_USAGER_M", $NOM_USAGER);
		    oci_bind_by_name($stid, ":MDP_M", $MDP);
		    oci_bind_by_name($stid, ":PRENOM_M", $PRENOM);
		    oci_bind_by_name($stid, ":NOM_M", $NOM);
		    oci_bind_by_name($stid, ":COURRIEL_M", $COURRIEL);
		    oci_bind_by_name($stid, ":SEXE_M", $SEXE);
		    oci_bind_by_name($stid, ":TAILLE_M", $TAILLE);
		    
		    
		    oci_bind_by_name($stid, ":POIDS_INI_M", $POIDS_INI);
		    oci_bind_by_name($stid, ":POIDS_DESI_M", $POIDS_DESIRE);
		    oci_bind_by_name($stid, ":UNITE_POIDS_M", $UNITE_POIDS);
		    
		    oci_execute($stid);
		    $_POST['message'] = "Vous êtes maintenant inscrit.";
		    oci_free_statement($stid);
		    oci_close($conn);
		}
          ?>
		
		
	</body>
	<footer>
	<?php include 'rabais.php'?>
	</footer>
</html> 
 