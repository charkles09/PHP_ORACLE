<?php
include 'statut.php';


/*
1. Voir quel est le type user
2. envoyer vers la bonne page
3. ramener à statut si aucun compte est lié
 
 
 */

header("location:accueil.php")
?>
<html>
<body>
<?php echo $result; ?>
</body>
</html>
