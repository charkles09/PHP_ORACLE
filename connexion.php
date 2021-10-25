<?php 
include 'statut.php';
include 'init.php';



?>
<html>
	<nav>
		<a href="index.php">Accueil</a>
	</nav>
	<body>
			<h1>Connexion au site</h1>
			<form action="statut.php" method="post">
			Nom d'usager : <input type="text" name="NOM_USAGER_MEM"><br>
			Mot de passe : <input type="password" name="MOT_DE_PASSE_MEM"><br>
			<input type="submit" name="connexion" value="Connexion">
	
	
		</form>
	</body>
	<footer>
		<?php include 'rabais.php' ?>
	</footer>
</html>