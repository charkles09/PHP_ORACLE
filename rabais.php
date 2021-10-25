<?php
include 'init.php';

$rabais = array();

$stid = oci_parse($conn, "select DATE_DEBUT_RAB, DATE_FIN_RAB, NOM_RABAIS from TP2_RABAIS");
oci_execute($stid);

while (oci_fetch($stid)) {
    $dateDebut = oci_result($stid, "DATE_DEBUT_RAB");
    $dateFin = oci_result($stid, "DATE_FIN_RAB");
    $nomRabais = oci_result($stid, "NOM_RABAIS");
    verifieDate();
    
}

date_default_timezone_set("America/New_York");
$dateAjd = date('y-m-d');


function verifieDate() {
    global $dateAjd, $dateFin, $dateDebut, $nomRabais, $rabais;
    if($dateFin - $dateAjd >= 0) {
        $x = count($rabais);
        $rabais[$x] = $nomRabais;
    }
}


function rabaisHasard() {
    global $rabais;
    $x = count($rabais);
    return $rabais[rand(0,$x-1)];
}

verifieDate();

echo "<img style='width:200px; height:200px; position:absolute; left:50%;' src='image/" . ($exactRabais = rabaisHasard()) . ".jpg'>\n\n";
#cho "<span style='font-weight:bold; text-align:center;'>Profitez du rabais " . $exactRabais . ".</span>";
