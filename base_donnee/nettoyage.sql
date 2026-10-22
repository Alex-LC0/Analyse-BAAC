#Requêtes de nettoyages de la base de données

-- Evaluation des doublons

SELECT COUNT(*) AS nbr_doublons, numero_accident
FROM caracteristiques
GROUP BY numero_accident
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS nbr_doublons, lieux_id
FROM lieux
GROUP BY lieux_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS nbr_doublons, id_vehicule
FROM vehicule
GROUP BY id_vehicule
HAVING COUNT(*) >1;

SELECT COUNT(*) AS nbr_doublons, numero_accident
FROM vehicule
GROUP BY numero_accident
HAVING COUNT(*) >1;

SELECT COUNT(*) AS nbr_doublons, id
FROM usagers
GROUP BY id
HAVING COUNT(*) >1;

SELECT COUNT(*) AS nbr_doublons, numero_accident
FROM usagers
GROUP BY numero_accident
HAVING COUNT(*) >1;


-- Evaluation des valeurs nulls

SELECT commune, departement, type_collision  
FROM caracteristiques
WHERE commune IS NULL OR departement IS NULL OR type_collision IS NULL;

SELECT categorie_route, vitesse_max
FROM lieux
WHERE categorie_route IS NULL OR vitesse_max IS NULL;

SELECT catvehic
FROM vehicule
WHERE catvehic IS NULL;

SELECT cat_usager, gravite, sexe, an_nais
FROM usagers
WHERE cat_usager IS NULL OR gravite IS NULL or an_nais IS NULL;

SELECT SUM(
    CASE WHEN an_nais IS NULL THEN 1 ELSE 0 END
) AS nbr_null
FROM usagers;

-- Evaluation des valeurs "Non renseignée" (-1)

SELECT
    COUNT(CASE WHEN luminosite = -1 THEN 1 END) AS luminosite,
    COUNT(CASE WHEN localisation =-1 THEN 1 END) AS localisation,
    COUNT(CASE WHEN cond_atmosphere = -1 THEN 1 END) AS cond_atmosphere,
    COUNT(CASE WHEN type_collision = -1 THEN 1 END) AS type_collision
FROM caracteristiques;

SELECT
    COUNT(CASE WHEN categorie_route = -1 THEN 1 END) AS categorie_route,
    COUNT(CASE WHEN type_circulation = -1 THEN 1 END) as type_circulation,
    COUNT(CASE WHEN nombre_voies = -1 THEN 1 END) AS nombre_voies,
    COUNT(CASE WHEN voie_reserv = -1 THEN 1 END) AS voie_reserv
FROM lieux;

SELECT
    COUNT(CASE WHEN type_declin = -1 THEN 1 END) AS type_declin,
    COUNT(CASE WHEN plan = -1 THEN 1 END) AS plan,
    COUNT(CASE WHEN etat_route = -1 THEN 1 END) AS etat_route,
    COUNT(CASE WHEN infrastructure = -1 THEN 1 END) AS infrastructure,
    COUNT(CASE WHEN situation_acc = -1 THEN 1 END) AS situation_acc   
FROM lieux;

SELECT
    COUNT(CASE WHEN catvehic = -1 THEN 1 END) AS catvehic,
    COUNT(CASE WHEN obstacle_fixe = -1 THEN 1 END) AS obstacle_fixe,
    COUNT(CASE WHEN obstacle_mobile = -1 THEN 1 END) AS obstacle_mobile,
    COUNT(CASE WHEN choc = -1 THEN 1 END) AS choc,
    COUNT(CASE WHEN manoeuvre = -1 THEN 1 END) AS manoeuvre,
    COUNT(CASE WHEN motorisation_vh = -1 THEN 1 END) AS motorisation_vh
FROM vehicule;

SELECT 
    COUNT(CASE WHEN cat_usager = -1 THEN 1 END) AS cat_usager,
    COUNT(CASE WHEN gravite = -1 THEN 1 END) AS gravite,
    COUNT(CASE WHEN sexe = -1 THEN 1 END) AS sexe,
    COUNT(CASE WHEN trajet = -1 THEN 1 END) AS trajet,
    COUNT(CASE WHEN secu1 = -1 THEN 1 END) AS secu1,
    COUNT(CASE WHEN secu2 = -1 THEN 1 END) AS secu2,
    COUNT(CASE WHEN secu3 = -1 THEN 1 END) AS secu3,
    COUNT(CASE WHEN localisation_pt = -1 THEN 1 END) AS localisation_pt,
    COUNT(CASE WHEN statut_pt = -1 THEN 1 END) AS statut_pt
FROM usagers;

-- Evaluation de la cohérence interne des données : 

SELECT vitesse_max
FROM lieux
WHERE vitesse_max < 5;

SELECT
    COUNT(CASE WHEN vitesse_max < 5 THEN 1 END) AS n_vmax
FROM lieux;

UPDATE lieux
SET vitesse_max = NULL
WHERE vitesse_max < 5;

-- Verification des départements hors champs d'analyse (outre-mer)

SELECT COUNT(numero_accident)
FROM caracteristiques
WHERE 
departement = "971" 
    OR 
departement = "972"
    OR 
departement = "973"
    OR 
departement = "974"
    OR 
departement = "976";

DELETE FROM caracteristiques
WHERE 
departement = "971" 
    OR 
departement = "972"
    OR 
departement = "973"
    OR 
departement = "974"
    OR 
departement = "976"
    OR
departement = "988"
    OR
departement = "975"
    OR
departement = "977"
    OR
departement = "978"
    OR
departement = "986"
    OR
departement = "987";

-- Correction des variables 01 et 1 mal encodées : 

UPDATE caracteristiques
SET departement = "01"
WHERE departement = "1";

UPDATE caracteristiques
SET departement = "02"
WHERE departement = "2";

UPDATE caracteristiques
SET departement = "03"
WHERE departement = "3";

UPDATE caracteristiques
SET departement = "04"
WHERE departement = "4";

UPDATE caracteristiques
SET departement = "05"
WHERE departement = "5";

UPDATE caracteristiques
SET departement = "06"
WHERE departement = "6";

UPDATE caracteristiques
SET departement = "07"
WHERE departement = "7";

UPDATE caracteristiques
SET departement = "08"
WHERE departement = "8";

UPDATE caracteristiques
SET departement = "09"
WHERE departement = "9";