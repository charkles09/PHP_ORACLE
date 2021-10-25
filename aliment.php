<?php 
include 'init.php';
include 'statut.php';

if (!estConnecte()) {
    $_SESSION['msg'] = "Veuillez vous connecter avant d'atteindre cette page.";
    header("location:connexion.php");
}


?>
<html>
	<nav>
		<a href="index.php">Accueil</a>
		<a href="aliment.php">Aliment</a>
		<a href="liste_aliment.php">Liste des aliments</a>
	</nav>
    <body>
    	<h1>Page aliment</h1><br>
    	<?php

    	
    	
    	if (empty($_GET["NO"])){
    	    
    	echo '<h4>Ajouter un aliment</h4>';
    	
    	echo '<form action="aliment.php" method="post">';
		echo 'Nom : <input type="text" name="nom_aliment"><br>';
		echo 'Code barre :<input type="text" required pattern="[0-9]{11}" name="num_code_barre_ali"><br>';
		#echo 'Portion : <input type="text" name="portion_ali"><br>';
		echo '<label for="ali">Portion :</label>';
		echo '<select name="portion_ali" id="ali">
		        <option value="0.25">1/4</option>
                <option value="0.5">1/2</option>
                <option value="0.333">1/3</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
                <option value="6">6</option>
                		
		</select><br>';
		
		#echo 'Unité : <input type="text" name="unite_ali"><br>';
		
		echo '<label for="unite">Unité :</label>';
		echo '<select name="unite_ali" id="unite">
		        <option value="g">G</option>
                <option value="lb">LB</option>
                <option value="tasse">tasse</option>
                <option value="cuillerée à soupe">cuillerée à soupe</option>
                <option value="cuillerée à thé">cuillerée à thé</option>
                <option value="oz">oz</option>
                <option value="ml">ml</option>
                <option value="tranche">tranche</option>
                <option value="morceau">morceau</option>
                    
		</select><br>';
		
		echo 'Nb grammes lipides :   <input type="text" name="nb_g_lip"><br>';
		echo 'Nb grammes glucides :  <input type="text" name="nb_g_glu">­­­­<br>';
		echo 'Nb grammes fibres :    <input type="text" name="nb_g_fib"><br>';
		echo 'Nb grammes protéines : <input type="text" name="nb_g_pro"><br>';
		#echo 'Nb points : <input type="text" name="nb_points"><br>';

		echo '<input type="submit" name="ajout" value="OK:"><br>';
		

		if(isset($_POST["ajout"])){
		    
		  $NOM_ALI = $_POST['nom_aliment'];
		  $CODE_BARRE = $_POST['num_code_barre_ali'];
		  $PORTION_ALI = $_POST['portion_ali'];
		  $UNITE_ALI = $_POST['unite_ali'];
		  $NB_G_LIP_ALI = $_POST['nb_g_lip'];
          $NB_G_GLU_ALI = $_POST['nb_g_glu'];
		  $NB_G_FIB_ALI = $_POST['nb_g_fib'];
          $NB_G_PROT_ALI = $_POST['nb_g_pro'];
          #$NB_POINTS = $_POST['nb_points'];
          
          $stid = oci_parse($conn, "insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,
            NB_GLUCIDE_ALI, NB_FIBRE_ALI, NB_PROTEINE_ALI, NUMERO_CODE_BARRE_ALI)
            values (:NOM_BV, :PORTION_BV, :UNITE_BV, :LIP_BV, :GLU_BV, :FIB_BV, :PROT_BV,
            :CODE_BARRE_BV)");
          
          oci_bind_by_name($stid, ":NOM_BV", $NOM_ALI);
          oci_bind_by_name($stid, ":PORTION_BV", $PORTION_ALI);
          oci_bind_by_name($stid, ":UNITE_BV", $UNITE_ALI);
          oci_bind_by_name($stid, ":LIP_BV", $NB_G_LIP_ALI);
          oci_bind_by_name($stid, ":GLU_BV", $NB_G_GLU_ALI);
          oci_bind_by_name($stid, ":FIB_BV", $NB_G_FIB_ALI);
          oci_bind_by_name($stid, ":PROT_BV", $NB_G_PROT_ALI);
          oci_bind_by_name($stid, ":CODE_BARRE_BV", $CODE_BARRE);
          #oci_bind_by_name($stid, ":POINTS_BV", $NB_POINTS);
          
          oci_execute($stid);
          $_POST['message'] = "Votre aliment à bien été ajouter.";
          oci_free_statement($stid);
          oci_close($conn);
		}
    	} else {
    	    echo '<h4>Modifier un aliment</h4>';
    	    
    	    
    	    $NoALI = $_GET["NO"];
    	    $stid = oci_parse($conn, 'select NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  
            NB_GLUCIDE_ALI, NB_FIBRE_ALI, NB_PROTEINE_ALI, NUMERO_CODE_BARRE_ALI, NB_POINTS_ALI
             from TP2_ALIMENT where NO_ALIMENT = '. $_GET["NO"]);
    	    
    	    oci_execute($stid);
    	    
    	    while (oci_fetch($stid)) {
    	        
    	        
    	        $NOM_ALI = oci_result($stid, 'NOM_ALI');
    	        $PORTION_ALI = oci_result($stid, 'PORTION_ALI');
    	        $CODE_BARRE = oci_result($stid, 'NUMERO_CODE_BARRE_ALI');
    	        $UNITE_ALI = oci_result($stid, 'UNITE_ALI');
    	        $NB_G_LIP_ALI = oci_result($stid, 'NB_LIPIDE_ALI');
    	        $NB_G_GLU_ALI = oci_result($stid, 'NB_GLUCIDE_ALI');
    	        $NB_G_PROT_ALI = oci_result($stid, 'NB_PROTEINE_ALI');
    	        $NB_G_FIB_ALI = oci_result($stid, 'NB_FIBRE_ALI');
    	        $NB_POINTS = oci_result($stid, 'NB_POINTS_ALI');
    	       
    	        
    	        
    	    }
    	    echo '<form action="aliment.php?NO=' . $_GET["NO"] . '"method="post">';
    	    echo "Nom : <input type='text' name ='nom_aliment' value=\"" . $NOM_ALI . "\"><br>";
    	    echo 'Code barre :<input type="text" name="num_code_barre_ali" value='. $CODE_BARRE . '><br>';
    	    echo 'Portion : <input type="text" name="portion_ali" value='. $PORTION_ALI . '><br>';
    	    echo 'Unité : <input type="text" name="unite_ali" value='. $UNITE_ALI . '><br>';
    	    echo 'Nb grammes lipides :   <input type="text" name="nb_g_lip" value='. $NB_G_LIP_ALI . '><br>';
    	    echo 'Nb grammes glucides :  <input type="text" name="nb_g_glu" value='. $NB_G_GLU_ALI . '>­­­­<br>';
    	    echo 'Nb grammes fibres :    <input type="text" name="nb_g_fib" value='. $NB_G_FIB_ALI . '><br>';
    	    echo 'Nb grammes protéines : <input type="text" name="nb_g_pro" value='. $NB_G_PROT_ALI . '><br>';
    	    echo 'Nb points : <input type="text" name="nb_points" disabled value='. $NB_POINTS . '><br>';
    	    
    	    echo '<input type="submit" name="modif" value="OK :"><br>';
    	    echo '</form>';
    	    
    	    
    	    if(isset($_POST["modif"])){
    	        $NOM_ALI = $_POST['nom_aliment'];
    	        $CODE_BARRE = $_POST['num_code_barre_ali'];
    	        $PORTION_ALI = $_POST['portion_ali'];
    	        $UNITE_ALI = $_POST['unite_ali'];
    	        $NB_G_LIP_ALI = $_POST['nb_g_lip'];
    	        $NB_G_GLU_ALI = $_POST['nb_g_glu'];
    	        $NB_G_FIB_ALI = $_POST['nb_g_fib'];
    	        $NB_G_PROT_ALI = $_POST['nb_g_pro'];
    	        #$NB_POINTS = $_POST['nb_points'];
    	        
    	        
    	        $NUM = $_GET["NO"];
    	        $stid = oci_parse($conn, "update TP2_ALIMENT 
                    set NOM_ALI = '$NOM_ALI',
                    PORTION_ALI = $PORTION_ALI,
                     UNITE_ALI = '$UNITE_ALI',
                     NB_LIPIDE_ALI = $NB_G_LIP_ALI,
                     NB_GLUCIDE_ALI = $NB_G_GLU_ALI,
                     NB_FIBRE_ALI = $NB_G_FIB_ALI,
                     NB_PROTEINE_ALI = $NB_G_PROT_ALI,
                    NUMERO_CODE_BARRE_ALI = '$CODE_BARRE'
                       
                    where NO_ALIMENT = $NUM"); #Jai changé valeur ici
    	        
    	        oci_execute($stid);
    	        header("location: liste_aliment.php");
    	        
    	    }
}

    if (!empty($_POST['message'])){
        echo $_POST['message'];
        $_POST['message'] = "";
    }

        ?>
        
		</form>
	<form action="liste_aliment.php">
    <input type="submit" value="Annuler" />
</form>	
    </body>
    <footer>
    <?php include 'rabais.php'?>
    </footer>
</html>

