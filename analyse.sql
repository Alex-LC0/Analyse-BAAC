/*

Nous allons commencer par les requêtes de la question 1 : 

"Depuis 2019, comment le nombre et la gravité des accidents de la route ont évolué ?"

*/

WITH accident_gravite AS (
SELECT 
    YEAR(caracteristiques.date_hrmn) AS année,
    COUNT(DISTINCT caracteristiques.numero_accident) AS n_accident,
    COUNT(DISTINCT CASE WHEN usagers.gravite IN (2, 3) THEN caracteristiques.numero_accident END) AS n_accident_grave
FROM caracteristiques
JOIN usagers ON usagers.numero_accident = caracteristiques.numero_accident
GROUP BY YEAR(date_hrmn)
)
SELECT 
    année,
    n_accident,
    n_accident_grave,
    ROUND((n_accident_grave / n_accident) * 100.0, 2) AS pourcentage_acc_grave
FROM accident_gravite
ORDER BY année
INTO OUTFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/gravite_accident.csv"
FIELDS TERMINATED BY ";" OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

/*

Nous allons continuer par les requêtes de la question 2 : 

"Quel départements concentrent le plus d'accidents graves (en valeurs absolues) ? 
Quels peuvent être les causes inférées de ces différences ?"

*/

-- Requête d'extraction des données pour analyse Python : 
WITH accident_departement AS (
SELECT
    caracteristiques.departement as departement,
    COUNT(DISTINCT caracteristiques.numero_accident) AS nombre_accident,
    COUNT(DISTINCT CASE WHEN usagers.gravite IN (2, 3) THEN caracteristiques.numero_accident END) AS nombre_accident_grave
FROM caracteristiques
JOIN usagers ON usagers.numero_accident = caracteristiques.numero_accident
GROUP BY departement
)
SELECT
    departement,
    nombre_accident,
    nombre_accident_grave,
    ROUND((nombre_accident_grave / nombre_accident) * 100.0, 2) AS pourcentage_accident_grave
FROM accident_departement
INTO OUTFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/departement_accident.csv"
FIELDS TERMINATED BY ";" OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

-- Recherche du nombre de -1 encodé par département
WITH rescensement AS (
SELECT 
    departement,
    COUNT(DISTINCT caracteristiques.numero_accident) as n_accident,
    COUNT(DISTINCT CASE WHEN usagers.gravite = -1 THEN caracteristiques.numero_accident END) as non_renseigné
FROM caracteristiques
JOIN usagers ON usagers.numero_accident = caracteristiques.numero_accident
GROUP BY departement
ORDER BY non_renseigné DESC
)
SELECT
    departement,
    n_accident,
    non_renseigné,
    ROUND((non_renseigné / n_accident) * 100.0, 2) AS pourcentage_nr
FROM rescensement
ORDER BY ROUND((non_renseigné / n_accident) * 100.0, 2) DESC
LIMIT 10;

/*

Les requêtes de la question 3 : 

"Quel type de route concentrent le plus d’accidents graves (en valeurs absolues) ? 
Existe-il un impact réel de la vitesse autorisée sur ces accidents ?"

*/

WITH accident_route AS (
SELECT
    COUNT(DISTINCT caracteristiques.numero_accident) as nombre_accident,
    COUNT(DISTINCT CASE WHEN usagers.gravite IN (2,3) THEN caracteristiques.numero_accident END) as nombre_accident_grave,
    lieux.categorie_route as categorie_route,
    categorie_route_ref.categorie_route_ref as ref_route
FROM caracteristiques
JOIN lieux ON lieux.numero_accident = caracteristiques.numero_accident
JOIN categorie_route_ref ON categorie_route_ref.categorie_route = lieux.categorie_route
JOIN usagers ON usagers.numero_accident = caracteristiques.numero_accident
GROUP BY lieux.categorie_route
HAVING lieux.categorie_route != 9
)
SELECT
    categorie_route,
    ref_route,
    nombre_accident,
    nombre_accident_grave,
    ROUND((nombre_accident_grave / nombre_accident) * 100.0, 2) AS per_accident_grave
FROM accident_route
INTO OUTFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/accident_route.csv"
FIELDS TERMINATED BY ";" OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

/*

Les requêtes de la question 4 : 

"Quels facteurs externes influencent la gravité d’un accident de la route ?"

*/

WITH gravite_acc AS (
SELECT
    caracteristiques.numero_accident AS numero_accident,
    MAX(CASE 
        WHEN usagers.gravite = 2 THEN 4
        WHEN usagers.gravite = 3 THEN 3
        WHEN usagers.gravite = 4 THEN 2
        WHEN usagers.gravite = 1 THEN 1
    END) AS gravite_max
FROM caracteristiques
JOIN usagers ON usagers.numero_accident = caracteristiques.numero_accident
GROUP BY caracteristiques.numero_accident
),
facteur_lieux AS (
SELECT
    numero_accident,
    lieux.type_circulation,
    type_circulation_ref,
    lieux.type_declin,
    type_declin_ref,
    lieux.plan,
    plan_ref,
    larg_chauss,
    lieux.etat_route,
    etat_route_ref,
    infrastructure,
    ROW_NUMBER() OVER (PARTITION BY numero_accident ORDER BY lieux_id) AS rang
FROM lieux
JOIN type_circulation_ref ON type_circulation_ref.type_circulation = lieux.type_circulation
JOIN type_declin_ref ON type_declin_ref.type_declin = lieux.type_declin
JOIN plan_ref ON plan_ref.plan = lieux.plan
JOIN etat_route_ref ON etat_route_ref.etat_route = lieux.etat_route
)
SELECT
    gravite_acc.numero_accident,
    gravite_max,
    CASE 
        WHEN gravite_max = 4 THEN "Au moins un tué"
        WHEN gravite_max = 3 THEN "Au moins un blessé hospitalisé"
        WHEN gravite_max = 2 THEN "Au moins un blessé léger"
        WHEN gravite_max = 1 THEN "Au moins un indemne"
    END AS gravite_ref,
    caracteristiques.luminosite,
    luminoste_ref.luminosite_ref,
    caracteristiques.cond_atmosphere,
    cond_atmosphere_ref.cond_atmosphere_ref,
    type_circulation,
    type_circulation_ref,
    type_declin,
    type_declin_ref,
    plan,
    plan_ref,
    larg_chauss,
    etat_route,
    etat_route_ref,
    infrastructure
FROM gravite_acc
JOIN facteur_lieux ON gravite_acc.numero_accident = facteur_lieux.numero_accident
JOIN caracteristiques ON gravite_acc.numero_accident = caracteristiques.numero_accident
JOIN luminoste_ref ON luminoste_ref.luminosite = caracteristiques.luminosite
JOIN cond_atmosphere_ref ON cond_atmosphere_ref.cond_atmosphere = caracteristiques.cond_atmosphere
WHERE rang = 1;
--INTO OUTFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/facteur_externes.csv"
--FIELDS TERMINATED BY ";" OPTIONALLY ENCLOSED BY '"'
--LINES TERMINATED BY '\r\n'

/*

Les requêtes de la question 5 : 

"Quel type de choc provoquent les accidents les plus graves en fonction du type de route ?"

*/

WITH choc_accident AS (
SELECT
    vehicule.choc,
    choc_ref.choc_ref,
    gravite,
    lieux.categorie_route,
    categorie_route_ref.categorie_route_ref,
    caracteristiques.type_collision,
    type_collision_ref.type_collision_ref
FROM vehicule
JOIN usagers ON usagers.numero_accident = vehicule.numero_accident
JOIN lieux ON lieux.numero_accident = vehicule.numero_accident
JOIN caracteristiques ON caracteristiques.numero_accident = vehicule.numero_accident
JOIN choc_ref ON choc_ref.choc = vehicule.choc
JOIN categorie_route_ref ON categorie_route_ref.categorie_route = lieux.categorie_route
JOIN type_collision_ref ON type_collision_ref.type_collision = caracteristiques.type_collision
HAVING choc != 0 AND choc != -1),
choc_route AS (
SELECT
    choc_ref,
    COUNT(choc) AS nombre_choc,
    COUNT(CASE WHEN gravite IN (2, 3) THEN 1 END) as n_choc_grave,
    categorie_route_ref as categorie_route
FROM choc_accident
GROUP BY categorie_route, choc
HAVING categorie_route_ref != "Autre")
SELECT
    choc_ref,
    nombre_choc,
    n_choc_grave,
    ROUND((n_choc_grave / nombre_choc) * 100.0, 2) AS per_choc_grave,
    categorie_route
FROM choc_route;
INTO OUTFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/choc_accident.csv"
FIELDS TERMINATED BY ";" OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

/*

Les requêtes de la question 6 : 

"Quels types d’usagers de la route sont les plus à risque de subir un grave accident ?"

*/

SELECT
    COUNT(id) AS n_usager,
    COUNT(CASE WHEN gravite IN (2, 3) THEN 1 END) AS n_usagers_grave,
    COUNT(CASE WHEN gravite IN (1, 4) THEN 1 END) AS n_usager_leger,
    usagers.cat_usager,
    cat_usager_ref.cat_usager_ref
FROM usagers
JOIN cat_usager_ref ON cat_usager_ref.cat_usager = usagers.cat_usager
GROUP BY cat_usager
INTO OUTFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/usagers_accident.csv"
FIELDS TERMINATED BY ";" OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

SELECT
    catvehic_ref,
    COUNT(vehicule.id_vehicule) AS n_vehicule,
    COUNT(CASE WHEN usagers.gravite IN (2,3) THEN 1 END) AS n_usagers_grave,
    COUNT(CASE WHEN usagers.gravite IN (1,4) THEN 1 END) AS n_usagers_leger,
    vehicule.catvehic
FROM vehicule
JOIN catvehic_ref ON catvehic_ref.catvehic = vehicule.catvehic
JOIN usagers ON usagers.numero_accident = vehicule.numero_accident
GROUP BY catvehic
HAVING catvehic != -1 AND catvehic != 0
INTO OUTFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/vehicule_accident.csv"
FIELDS TERMINATED BY ";" OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

/*

Les requêtes de la question 7 : 

"Quel est le profil démographique le plus représenté dans les accidents graves ?"

*/

SELECT
    YEAR(date_hrmn) AS annee_accident,
    usagers.sexe,
    sexe_ref.sexe_ref,
    gravite,
    an_nais,
    YEAR(date_hrmn) - an_nais AS age_usager
FROM usagers
JOIN caracteristiques ON caracteristiques.numero_accident = usagers.numero_accident
JOIN sexe_ref ON sexe_ref.sexe = usagers.sexe
HAVING usagers.sexe != -1 AND gravite IN (2,3);
--INTO OUTFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/genre_accident_ng.csv"
--FIELDS TERMINATED BY ";" OPTIONALLY ENCLOSED BY '"'
--LINES TERMINATED BY '\r\n';

WITH count_usagers AS (
SELECT
    COUNT(id) AS n_usagers,
    COUNT(CASE WHEN gravite IN (2,3) THEN 1 END) AS n_usagers_grave,
    COUNT(CASE WHEN gravite IN (1,4) THEN 1 END) AS n_usagers_leger,
    usagers.sexe AS sexe,
    sexe_ref.sexe_ref
FROM usagers
JOIN caracteristiques ON caracteristiques.numero_accident = usagers.numero_accident
JOIN sexe_ref ON sexe_ref.sexe = usagers.sexe
GROUP BY usagers.sexe
HAVING usagers.sexe != -1
)
SELECT
    sexe_ref,
    n_usagers,
    n_usagers_leger,
    n_usagers_grave,
    ROUND((n_usagers_grave / n_usagers) * 100.0, 2) AS per_usagers_grave
FROM count_usagers;
--INTO OUTFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/genre_count.csv"
--FIELDS TERMINATED BY ";" OPTIONALLY ENCLOSED BY '"'
--LINES TERMINATED BY '\r\n';

SELECT
    YEAR(date_hrmn) AS annee_accident,
    usagers.sexe,
    sexe_ref.sexe_ref,
    gravite,
    an_nais,
    YEAR(date_hrmn) - an_nais AS age_usager
FROM usagers
JOIN caracteristiques ON caracteristiques.numero_accident = usagers.numero_accident
JOIN sexe_ref ON sexe_ref.sexe = usagers.sexe
HAVING usagers.sexe != -1 AND gravite !=-1;
--INTO OUTFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/genre_total_accident_ng.csv"
--FIELDS TERMINATED BY ";" OPTIONALLY ENCLOSED BY '"'
--LINES TERMINATED BY '\r\n';