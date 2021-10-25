<?php 
include 'init.php';
include 'statut.php';

if (!estConnecte()) {
    $_SESSION['msg'] = "Veuillez vous connecter avant d'atteindre cette page.";
    header("location:connexion.php");
} elseif (!adminConnecte()) {
    header("location: liste_aliment.php");
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
    	<?php
    	if (empty($_GET["NO"])){
    	echo '<h4>Liste des utilisateurs</h4>';
    	
    	
    	
    	$stid = oci_parse($conn, "select ROW_NUMBER() over (order by LISTE asc) as NO_COMPTE , LISTE from((select PRENOM_ADM ||' '|| NOM_ADM ||', '|| 
                                    NOM_USAGER_ADMINISTRATEUR ||', '|| COURRIEL_ADM||', '|| 'Administrateur' as LISTE from TP2_ADMINISTRATEUR) 
                                    union
                                    (select PRENOM_MEM ||' '|| NOM_MEM ||', '||NOM_USAGER_MEM ||', '||COURRIEL_MEM ||', '||'Membre' from TP2_MEMBRE))");
    	oci_execute($stid);
    	
    	$i = 0;
    	echo '<form action="admin.php" method="post">';
    	echo '<select size="20" name="liste_membre">';
    	while ($row = oci_fetch_assoc($stid) != false){
    	    $i++;
    	    echo "<option value=" . $i .">" .oci_result($stid, "NO_COMPTE").". ".  oci_result($stid, "LISTE") . "</option>";
    	    
    	}
    	echo '</select><br><br>';
    	#echo '<input type="hidden" name="no_compte"><br>';
    	echo '<input type="submit" name="modification" value="Mettre à jour"><br>';

    	
    	if(isset($_POST["modification"])){
    	    $NO_CPT = $_POST['liste_membre'];
    	    
    	    header("Location: admin.php?NO=". $NO_CPT);
    	    exit;
    	    
    	}
    	}
    	
    	else {
    	    
    	    echo '<h4>Mise à jour Utilisateur</h4>';
    	    
    	    
    	    $NoMEM = $_GET["NO"];
    	    $stid = oci_parse($conn, "select NOM_USAGER_ADMINISTRATEUR, PRENOM_ADM || ' '||NOM_ADM as NOM_COMPLET, COURRIEL_ADM,SEXE_MEM, TYPE_MEMBRE, DATE_NAISSANCE_MEM from    
  
                                        (select PRENOM_ADM, NOM_ADM, NOM_USAGER_ADMINISTRATEUR, COURRIEL_ADM,TYPE_MEMBRE,SEXE_MEM, DATE_NAISSANCE_MEM, rownum as rn 
                                          from (                
                                            (select PRENOM_ADM, NOM_ADM, NOM_USAGER_ADMINISTRATEUR, COURRIEL_ADM, '' as SEXE_MEM, NULL as DATE_NAISSANCE_MEM, 'Administrateur' as TYPE_MEMBRE  from TP2_ADMINISTRATEUR ) 
                                                union
                                                    (select PRENOM_MEM, NOM_MEM,NOM_USAGER_MEM,COURRIEL_MEM, SEXE_MEM, DATE_NAISSANCE_MEM, 'Membre' as TYPE_MEMBRE from TP2_MEMBRE)))
                                        
                                       where rn =". $_GET["NO"]);
                	    
    	    oci_execute($stid);
    	    
    	    while (oci_fetch($stid)) {
    	        
    	        
    	        $NOM_USAGER = oci_result($stid, 'NOM_USAGER_ADMINISTRATEUR');
    	        $NOM_COMPLET = oci_result($stid, 'NOM_COMPLET');
    	        $COURRIEL = oci_result($stid, 'COURRIEL_ADM');
    	        $SEXE = oci_result($stid, 'SEXE_MEM');
    	        $DATE = oci_result($stid, 'DATE_NAISSANCE_MEM');
    	        $TYPE = oci_result($stid, 'TYPE_MEMBRE');
    	        
    	        
    	        
    	    }
    	    
    	    echo '<form action="admin.php?NO=' . $_GET["NO"] . '"method="post">';
    	    
    	    echo "Nom usager: <input type='text' name ='nom_usager' disabled value=\"" . $NOM_USAGER . "\"><br>";
    	    echo 'Nom complet :<input type="text" name="nom_complet" disabled value='. $NOM_COMPLET . '><br>';
    	    echo 'Courriel : <input type="text" name="courriel" value='. $COURRIEL . '><br>';
    	    
    	    if ($TYPE == 'Membre'){ 
    	    echo '<label for="sexe">Sexe :</label>';
    	    echo '<select name="sexe" id="sexe">
		        <option value="H">Homme</option>
                <option value="F">Femme</option>
                <option value="N">Non précisé</option>
    	            
		</select><br>';
    	    echo 'date de naissance : <input type="text" name="date_naissance" value='. $DATE . '><br>';
    	    }
    	    
    	    
    	    echo 'Type :  <input type="radio" id="Type_mem" name="type" value="TP2_MEMBRE">­­­­<label for="TYPE_MEMBRE">Membre</label>
		                  <input type="radio" id="Type_adm" name="type" value="TP2_ADMINISTRATEUR">­­­­<label for="TYPE_MEMBRE">Administrateur</label><br>';
    	    
    	    echo '<input type="submit" name="modif" value="Confirmer :"><br>';
    	    echo '</form>';
    	    
    	    
    	    if(isset($_POST["modif"])){
    	        $NOM_USAG = $_POST['nom_usager'];
    	        $NOM_COMP = $_POST['nom_complet'];
    	        $COURRI = $_POST['courriel'];
    	        if ($TYPE == 'Membre'){
    	            $SEX = $_POST['sexe'];
    	            $DATE_NAI = $_POST['date_naissance'];
    	        }
    	        $TYPE_M = $_POST['type'];
    	        
    	        if ($TYPE == 'Membre'){
    	            
    	            $stid = oci_parse($conn, "update TP2_MEMBRE
                    set COURRIEL_MEM = '$COURRI',
                    SEXE_MEM = '$SEX',
                    DATE_NAISSANCE_MEM = '$DATE_NAI',
    	                
                    where NOM_USAGER_MEM  = $NOM_USAG");
    	        }
    	        
    	      
    	        
    	        oci_execute($stid);
    	        header("location: admin.php");
    	        
    	    }
    	    echo '<form action="admin.php">';
    	    echo '<input type="submit" value="Annuler" />';
    	    echo '</form>';	    
    	    
    	}
    	
  ?>  	
    	
    
    </body>
    <footer>
    <?php include 'rabais.php' ?>
    </footer>
</html>