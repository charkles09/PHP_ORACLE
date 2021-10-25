<?php
include 'init.php';
session_start();
#Variables
$nomUsager;
$nomAdmin;
$erreur;


#Appel de fonctions 
function usagerConnecte() {
    if (isset($_SESSION['usager'])) {
        return true;
    } else {
        return false;
    }
}

function adminConnecte() {
    if (isset($_SESSION['admin'])) {
        return true;
    } else {
        return false;
    }
}

function estConnecte() { #Vérifie qu'aucun (usager ou admin) est connecté.
    if (usagerConnecte() or adminConnecte()) {
        return true;
    } else {
        return false;
    }
}

function deconnection(){
    session_destroy();
    session_start();
    header("location:index.php");
}

#Gestion des erreurs
#$_SESSION['erreurConn'] = "Veuillez vous connecter avant d'atteindre cette page.";
#$_SESSION['erreurMem'] = "Votre nom d'usager ou mot de passe sont invalides/inexistants.";



?>

	<?php 
	
	#Sert à déterminé si un membre existe dans la bd.
	if (estConnecte() == false) { #Aucun usager de connecter alors on cherche si les usagers existe et s'ils sont admin
	    
	    
	    if(isset($_POST["connexion"])){
	        $nomUsager = $_POST["NOM_USAGER_MEM"];
	        $mdpUsager = $_POST["MOT_DE_PASSE_MEM"];
	        
	        #Cherche si admin
	        $stid = oci_parse($conn, "select count(*) as BOOL_EXISTE_MEM from TP2_ADMINISTRATEUR where NOM_USAGER_ADMINISTRATEUR = '" . $nomUsager . "' and MOT_DE_PASSE_ADM = '" .$mdpUsager . "'");
	        oci_execute($stid);
	        oci_fetch($stid);
	        $resultAdmin = oci_result($stid, 'BOOL_EXISTE_MEM');
	        
	        #Cherche si membre
	        $stid = oci_parse($conn, "select count(*) as BOOL_EXISTE_MEM from TP2_MEMBRE where NOM_USAGER_MEM = '" . $nomUsager . "' and MOT_DE_PASSE_MEM = '" .$mdpUsager . "'");
	        oci_execute($stid);
	        oci_fetch($stid);
	        $resultUsager = oci_result($stid, 'BOOL_EXISTE_MEM');
	        
	        
	        #Ici, la vérification est faite, on assigne les données de session à l'usager.
	        if ($resultAdmin == 1) {
	            $nomUsager = $_POST['NOM_USAGER_MEM'];
	            $_SESSION['NOM_USAGER'] = $nomUsager;
	            $_SESSION['admin'] = true;
	            $_SESSION['usager'] = false;
	            $_SESSION['msg'] = "Bonjour " . $_SESSION['NOM_USAGER'];
	            header("location: index.php");
	        } elseif ($resultUsager == 1) {
	            $_SESSION['NOM_USAGER'] = $nomUsager;
	            $_SESSION['usager'] = true;
	            $_SESSION['msg'] = "Bonjour " . $_SESSION['NOM_USAGER'];
	            header("location: index.php");
	        } else {
	            $_SESSION['msg'] = "Votre nom d'usager ou mot de passe sont invalides/inexistants.";
	            header("location:connexion.php");
	        }
	    }
	}  
	
	if (isset($_GET['deconnection'])){
	       deconnection();
	       $_SESSION['msg'] = "";
	}
	
	
	
	?>
	<div id="connexion" style="text-align:right; position:absolute; right:0px;">
        <p style="font-weight:bold;"><?php echo $_SESSION['msg'];?></p>
        
        <?php if (estConnecte()) : ?>
        	<form action="statut.php" method="get">
        		<input type="submit" value="Se déconnecter" name="deconnection" >
        	</form>
        <?php elseif (estConnecte() == false) : ?>
        	<a href="connexion.php">Connexion</a>
        <?php endif;?>

	</div>

	
	
	