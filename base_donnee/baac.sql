#Création de la base de donnée : 

CREATE DATABASE IF NOT EXISTS baac
    DEFAULT CHARACTER SET = 'utf8mb4';

USE baac;

#Création et alimentation en données des tables dictionnaires de la base : 

-- Dictionnaire de la table "caracteristiques" : 

CREATE TABLE luminoste_ref (
    luminosite TINYINT PRIMARY KEY,
    luminosite_ref VARCHAR(155)
);

INSERT INTO luminoste_ref(
    luminosite,
    luminosite_ref
) VALUES
(-1, "Non renseignée"),
(1,"Plein Jour"), 
(2,"Crépuscule ou aube"), 
(3,"Nuit sans eclairage public"), 
(4,"Nuit avec eclairage public non allume"), 
(5,"Nuit avec éclairage public allumé ");

CREATE TABLE localisation_ref (
    localisation TINYINT PRIMARY KEY,
    localisation_ref VARCHAR(155)
);

INSERT INTO localisation_ref (
    localisation,
    localisation_ref
) VALUES
(-1, "Non renseignée"),
(1,"Hors agglomération "),
(2,"En agglomération ");

CREATE TABLE intersection_ref (
    intersection TINYINT PRIMARY KEY,
    intersection_ref VARCHAR(155)
);

INSERT INTO intersection_ref (
    intersection,
    intersection_ref
) VALUES
(-1, "Non renseignée"),
(1,"Hors intersection"),
(2,"Intersection en X"),
(3,"Intersection en T"),
(4, "Intersection en Y"),
(5,"Intersection à plus de 4 branches"),
(6,"Giratoire"),
(7,"Place"),
(8,"Passage à niveau "),
(9,"Autre intersection ");

CREATE TABLE cond_atmosphere_ref (
    cond_atmosphere TINYINT PRIMARY KEY,
    cond_atmosphere_ref VARCHAR(155)
);

INSERT INTO cond_atmosphere_ref (
    cond_atmosphere,
    cond_atmosphere_ref
) VALUES
(-1,"Non renseigné"),
(1,"Normale"),
(2,"Pluie légère"),
(3,"Pluie forte" ),
(4,"Neige - grêle"),
(5,"Brouillard - fumée"),
(6,"Vent fort - tempête"),
(7,"Temps éblouissant"),
(8,"Temps couvert"),
(9,"Autre");

CREATE TABLE type_collision_ref (
    type_collision TINYINT PRIMARY KEY,
    type_collision_ref VARCHAR(155)
);

INSERT INTO type_collision_ref(
    type_collision,
    type_collision_ref
) VALUES 
(-1, "Non renseigné"),
(1,"Deux véhicules - frontale" ),
(2,"Deux véhicules, par l'arrière"),
(3," Deux véhicules, par le coté"),
(4,"Trois véhicules et plus, en chaîne"),
(5,"Trois véhicules et plus, collisions multiples"),
(6,"Autre collision"),
(7,"Sans collision");

-- Dictionnaire de la table "lieux" : 

CREATE TABLE categorie_route_ref(
    categorie_route TINYINT PRIMARY KEY,
    categorie_route_ref VARCHAR(155)
);

INSERT INTO categorie_route_ref(
    categorie_route,
    categorie_route_ref
) VALUES
(-1, "Non renseignée"), 
(1,"Autoroute"),
(2,"Route nationale"),
(3,"Route départementale"),
(4,"Voie communale"),
(5,"Hors réseau public"),
(6,"Parc de stationnement ouvert à la circulation publique"),
(7,"Routes de métropole urbaine"),
(9,"Autre");

CREATE TABLE type_circulation_ref(
    type_circulation TINYINT PRIMARY KEY,
    type_circulation_ref VARCHAR(155)
);

INSERT INTO type_circulation_ref(
    type_circulation,
    type_circulation_ref
) VALUES
(-1, "Non renseignée"),
(1, "A sens unique"),
(2, "Bidirectionnelle"),
(3, "A chaussées séparées"),
(4, "Avec voies d'affectation variable");

CREATE TABLE voie_reserv_ref (
    voie_reserv TINYINT PRIMARY KEY,
    voie_reserv_ref VARCHAR(255)
);

INSERT INTO voie_reserv_ref(
    voie_reserv,
    voie_reserv_ref
) VALUES
(-1, "Non renseigné"),
(0, "Sans objet"),
(1, "Piste cyclable"),
(2, "Bande cyclable"),
(3, "Voie réservée");

CREATE TABLE type_declin_ref (
    type_declin TINYINT PRIMARY KEY,
    type_declin_ref VARCHAR(255)
);

INSERT INTO type_declin_ref(
    type_declin,
    type_declin_ref
) VALUES
(-1,  "Non renseigné"),
(1, "Plat"),
(2,  "Pente"),
(3, "Sommet de côte"),
(4, "Bas de côte");

CREATE TABLE plan_ref (
    plan TINYINT PRIMARY KEY,
    plan_ref VARCHAR(255)
);

INSERT INTO plan_ref(
    plan,
    plan_ref
) VALUES
(-1, "Non renseigné"),
(1, "Partie rectiligne"),
(2, "En courbe à gauche"),
(3, "En courbe à droite"),
(4, "En « S »");


CREATE TABLE etat_route_ref (
    etat_route TINYINT PRIMARY KEY,
    etat_route_ref VARCHAR(255)
);

INSERT INTO etat_route_ref(
    etat_route,
    etat_route_ref
) VALUES
(-1,  "Non renseigné"),
(1,  "Normale"),
(2,  "Mouillée"),
(3 ,"Flaques"),
(4 ,"Inondée"),
(5,  "Enneigée"),
(6,  "Boue"),
(7,  "Verglacée"),
(8,  "Corps gras huile"),
(9,  "Autre");

CREATE TABLE infrastructure_ref (
    infrastructure TINYINT PRIMARY KEY,
    infrastructure_ref VARCHAR(255)
);

INSERT INTO infrastructure_ref(
    infrastructure,
    infrastructure_ref
) VALUES
(-1, "Non renseigné"),
(0, "Aucun"),
(1, "Souterrain - tunnel"),
(2, "Pont - autopont"),
(3, "Bretelle d'échangeur ou de raccordement"),
(4, "Voie ferrée"),
(5, "Carrefour aménagé"),
(6, "Zone piétonne"),
(7, "Zone de péage"),
(8, "Chantier "),
(9, "Autre");


CREATE TABLE situation_acc_ref (
    situation_acc TINYINT PRIMARY KEY,
    situation_acc_ref VARCHAR(255)
);

INSERT INTO situation_acc_ref(
    situation_acc,
    situation_acc_ref
) VALUES
(-1, "Non renseigné"),
(0, "Aucun"),
(1, "Sur chaussée"),
(2, "Sur bande d’arrêt d’urgence"),
(3, "Sur accotement"),
(4, "Sur trottoir"),
(5, "Sur piste cyclable"),
(6, "Sur autre voie spéciale"),
(8, "Autres"),
(9, "Autre");

-- Dictionnaire de la table "vehicule" : 

CREATE TABLE catvehic_ref (
    catvehic TINYINT PRIMARY KEY,
    catvehic_ref VARCHAR(255)
);

INSERT INTO catvehic_ref(
    catvehic,
    catvehic_ref
) VALUES
(-1, "Non renseignée"),
(0, 'Indéterminable'),
(1, 'Bicyclette'),
(2, 'Cyclomoteur <50cm3'),
(3, 'Voiturette (Quadricycle à moteur carrossé)'),
(4, 'Référence inutilisée depuis 2006 (scooter immatriculé)'),
(5, 'Référence inutilisée depuis 2006 (motocyclette)'),
(6, 'Référence inutilisée depuis 2006 (side-car)'),
(7, 'VL seul'),
(8, 'Référence inutilisée depuis 2006 (VL + caravane)'),
(9, 'Référence inutilisée depuis 2006 (VL + remorque)'),
(10, 'VU seul 1,5T <= PTAC <= 3,5T avec ou sans remorque'),
(11, 'Référence inutilisée depuis 2006 (VU (10) + caravane)'),
(12, 'Référence inutilisée depuis 2006 (VU (10) + remorque)'),
(13, 'PL seul 3,5T <PTCA <= 7,5T'),
(14, 'PL seul > 7,5T'),
(15, 'PL > 3,5T + remorque'),
(16, 'Tracteur routier seul'),
(17, 'Tracteur routier + semi-remorque'),
(18, 'Référence inutilisée depuis 2006 (transport en commun)'),
(19, 'Référence inutilisée depuis 2006 (tramway)'),
(20, 'Engin spécial'),
(21, 'Tracteur agricole'),
(30, 'Scooter < 50 cm3'),
(31, 'Motocyclette > 50 cm3 et <= 125 cm3'),
(32, 'Scooter > 50 cm3 et <= 125 cm3'),
(33, 'Motocyclette > 125 cm3'),
(34, 'Scooter > 125 cm3'),
(35, 'Quad léger <= 50 cm3 (Quadricycle à moteur non carrossé)'),
(36, 'Quad lourd > 50 cm3 (Quadricycle à moteur non carrossé)'),
(37, 'Autobus'),
(38, 'Autocar'),
(39, 'Train'),
(40, 'Tramway'),
(41, '3RM <= 50 cm3'),
(42, '3RM > 50 cm3 <= 125 cm3'),
(43, '3RM > 125 cm3'),
(50, 'EDP à moteur'),
(60, 'EDP sans moteur'),
(80, 'VAE'),
(99, 'Autre véhicule');

CREATE TABLE obstacle_fixe_ref (
    obstacle_fixe TINYINT PRIMARY KEY,
    obstacle_fixe_ref VARCHAR(255)
);

INSERT INTO obstacle_fixe_ref(
    obstacle_fixe,
    obstacle_fixe_ref
) VALUES
(-1, 'Non renseigné'),
(0, 'Sans objet'),
(1, 'Véhicule en stationnement'),
(2, 'Arbre'),
(3, 'Glissière métallique'),
(4, 'Glissière béton'),
(5, 'Autre glissière'),
(6, 'Bâtiment, mur, pile de pont'),
(7, 'Support de signalisation verticale ou poste d''appel d''urgence'),
(8, 'Poteau'),
(9, 'Mobilier urbain'),
(10, 'Parapet'),
(11, 'Ilot, refuge, borne haute'),
(12, 'Bordure de trottoir'),
(13, 'Fossé, talus, paroi rocheuse'),
(14, 'Autre obstacle fixe sur chaussée'),
(15, 'Autre obstacle fixe sur trottoir ou accotement'),
(16, 'Sortie de chaussée sans obstacle'),
(17, 'Buse – tête d''aqueduc');

CREATE TABLE obstacle_mobile_ref (
    obstacle_mobile TINYINT PRIMARY KEY,
    obstacle_mobile_ref VARCHAR(255)
);

INSERT INTO obstacle_mobile_ref(
    obstacle_mobile,
    obstacle_mobile_ref
) VALUES
(-1, 'Non renseigné'),
(0, 'Aucun'),
(1, 'Piéton'),
(2, 'Véhicule'),
(4, 'Véhicule sur rail'),
(5, 'Animal domestique'),
(6, 'Animal sauvage'),
(9, 'Autre');

CREATE TABLE manoeuvre_ref (
    manoeuvre TINYINT PRIMARY KEY,
    manoeuvre_ref VARCHAR(255)
);

INSERT INTO manoeuvre_ref(
    manoeuvre,
    manoeuvre_ref
) VALUES
(-1, 'Non renseigné'),
(0, 'Inconnue'),
(1, 'Sans changement de direction'),
(2, 'Même sens, même file'),
(3, 'Entre 2 files'),
(4, 'En marche arrière'),
(5, 'A contresens'),
(6, 'En franchissant le terre-plein central'),
(7, 'Dans le couloir bus, dans le même sens'),
(8, 'Dans le couloir bus, dans le sens inverse'),
(9, 'En s''insérant'),
(10, 'En faisant demi-tour sur la chaussée'),
(11, 'Changeant de file - A gauche'),
(12, 'Changeant de file - A droite'),
(13, 'Déporté - A gauche'),
(14, 'Déporté - A droite'),
(15, 'Tournant - A gauche'),
(16, 'Tournant - A droite'),
(17, 'Dépassant - A gauche'),
(18, 'Dépassant - A droite'),
(19, 'Traversant la chaussée'),
(20, 'Manœuvre de stationnement'),
(21, 'Manœuvre d''évitement'),
(22, 'Ouverture de porte'),
(23, 'Arrêté (hors stationnement)'),
(24, 'En stationnement (avec occupants)'),
(25, 'Circulant sur trottoir'),
(26, 'Autres manœuvres');

CREATE TABLE choc_ref (
    choc TINYINT PRIMARY KEY,
    choc_ref VARCHAR(255)
);

INSERT INTO choc_ref(
    choc,
    choc_ref
) VALUES
(-1, 'Non renseigné'),
(0, 'Aucun'),
(1, 'Avant'),
(2, 'Avant droit'),
(3, 'Avant gauche'),
(4, 'Arrière'),
(5, 'Arrière droit'),
(6, 'Arrière gauche'),
(7, 'Coté droit'),
(8, 'Coté gauche'),
(9, 'Choc multiples (tonneaux)');

CREATE TABLE motorisation_vh_ref (
    motorisation_vh TINYINT PRIMARY KEY,
    motorisation_vh_ref VARCHAR(255)
);

INSERT INTO motorisation_vh_ref(
    motorisation_vh,
    motorisation_vh_ref
) VALUES
(-1, 'Non renseigné'),
(0, 'Inconnue'),
(1, 'Hydrocarbures'),
(2, 'Hybride électrique'),
(3, 'Electrique'),
(4, 'Hydrogène'),
(5, 'Humaine'),
(6, 'Autre');

-- Dictionnaire de la table "usagers" :

CREATE TABLE cat_usager_ref (
    cat_usager TINYINT PRIMARY KEY,
    cat_usager_ref VARCHAR(255)
); 

INSERT INTO cat_usager_ref(
    cat_usager,
    cat_usager_ref
) VALUES
(-1, "Non renseignée"),
(1, "Conducteur"),
(2,"Passager"),
(3, "Piéton");

CREATE TABLE gravite_ref (
    gravite TINYINT PRIMARY KEY,
    gravite_ref VARCHAR(255)
);

INSERT INTO gravite_ref(
    gravite,
    gravite_ref
) VALUES
(-1, "Non renseignée"),
(1, "Indemne"),
(2,"Tué"),
(3, "Blessé hospitalisé"),
(4, "Blessé léger");


CREATE TABLE sexe_ref (
    sexe TINYINT PRIMARY KEY,
    sexe_ref VARCHAR(255)
);

INSERT INTO sexe_ref(
    sexe,
    sexe_ref
) VALUES
(-1, "Non renseignée"),
(1, "Masculin"),
(2,"Féminin");

CREATE TABLE trajet_ref (
    trajet TINYINT PRIMARY KEY,
    trajet_ref VARCHAR(255)
);

INSERT INTO trajet_ref(
    trajet,
    trajet_ref
) VALUES
(-1, "Non renseigné"),
(0, "Non renseigné"),
(1,"Domicile - travail"),
(2, "Domicile - école "),
(3, "Courses - achats"),
(4, "Utilisation professionnelle"),
(5, "Promenade - loisirs "),
(9, "Autre");

CREATE TABLE secu_ref (
    secu TINYINT PRIMARY KEY,
    secu_ref VARCHAR(255)
);

INSERT INTO secu_ref(
    secu,
    secu_ref
) VALUES
(-1, "Non renseigné"),
(0, "Aucun équipement"),
(1,"Ceinture"),
(2, "Casque"),
(3, "Dispositif enfant"),
(4, "Gilet réfléchissant"),
(5, "Airbag (2RM/3RM)"),
(6, "Gants (2RM/3RM)"),
(7, "Gants + Airbag (2RM/3RM)"),
(8, "Non déterminable"),
(9, "Autre");

CREATE TABLE localisation_pt_ref (
    localisation_pt TINYINT PRIMARY KEY,
    localisation_pt_ref VARCHAR(255)
);

INSERT INTO localisation_pt_ref(
    localisation_pt,
    localisation_pt_ref
) VALUES
(-1, "Non renseigné"),
(0, "Sans objet"),
(1,"Sur la chaussée - à +50 mètre du passage piéton"),
(2, "Sur la chaussée - à -50 mètre du passage piéton"),
(3, "Sur passage piéton - Sans signalisation lumineuse"),
(4, "Sur passage piéton - Avec signalisation lumineuse"),
(5, "Sur trottoir"),
(6, "Sur accotement"),
(7, "Sur refuge ou BAU"),
(8, "Sur contre allée"),
(9, "Inconnue");

CREATE TABLE action_pt_ref (
    action_pt TINYINT PRIMARY KEY,
    action_pt_ref VARCHAR(255)
);

INSERT INTO action_pt_ref(
    action_pt,
    action_pt_ref
) VALUES
(-1, "Non renseigné"),
(0, "Sans objet"),
(1,"Se déplaçant - Dans le sens du véhicule heurtant"),
(2, "Se déplaçant - Dans le sens inverse du véhicule heurtant"),
(3, "Traversant"),
(4, "Masqué"),
(5, "Jouant - courant"),
(6, "Avec animal"),
(9, "Autre"),
(10, "Monte/descend du véhicule"),
(11, "Inconnue");

CREATE TABLE statut_pt_ref (
    statut_pt TINYINT PRIMARY KEY,
    statut_pt_ref VARCHAR(255)
);

INSERT INTO statut_pt_ref(
    statut_pt,
    statut_pt_ref
) VALUES
(-1, "Non renseigné"),
(1,"Seul"),
(2, "Accompagné"),
(3, "En groupe");

#Création des tables primaires de la base : 
CREATE TABLE caracteristiques (
    numero_accident BIGINT PRIMARY KEY NOT NULL, 
    date_hrmn DATETIME NOT NULL, 
    luminosite TINYINT,
    departement VARCHAR(50), 
    commune VARCHAR(255),
    localisation TINYINT,
    intersection TINYINT, 
    cond_atmosphere TINYINT, 
    type_collision TINYINT,
    adresse VARCHAR(255),
    FOREIGN KEY (luminosite) REFERENCES luminoste_ref (luminosite),
    FOREIGN KEY (localisation) REFERENCES localisation_ref (localisation),
    FOREIGN KEY (intersection) REFERENCES intersection_ref (intersection),
    FOREIGN KEY (cond_atmosphere) REFERENCES cond_atmosphere_ref (cond_atmosphere),
    FOREIGN KEY (type_collision) REFERENCES type_collision_ref (type_collision)
);

CREATE TABLE lieux (
    lieux_id BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    numero_accident BIGINT NOT NULL,
    categorie_route TINYINT NOT NULL,
    nm_voie VARCHAR(150),
    type_circulation TINYINT NOT NULL,
    nombre_voies TINYINT,
    voie_reserv TINYINT NOT NULL,
    type_declin TINYINT NOT NULL,
    plan TINYINT NOT NULL,
    larg_tp SMALLINT,
    larg_chauss SMALLINT,
    etat_route TINYINT NOT NULL,
    infrastructure TINYINT NOT NULL,
    situation_acc TINYINT NOT NULL,
    vitesse_max SMALLINT,
    FOREIGN KEY (numero_accident) REFERENCES caracteristiques (numero_accident) ON DELETE CASCADE,
    FOREIGN KEY (voie_reserv) REFERENCES voie_reserv_ref (voie_reserv),
    FOREIGN KEY (type_declin) REFERENCES type_declin_ref (type_declin),
    FOREIGN KEY (plan) REFERENCES plan_ref (plan),
    FOREIGN KEY (etat_route) REFERENCES etat_route_ref (etat_route),
    FOREIGN KEY (infrastructure) REFERENCES infrastructure_ref (infrastructure),
    FOREIGN KEY (situation_acc) REFERENCES situation_acc_ref (situation_acc),
    FOREIGN KEY (categorie_route) REFERENCES categorie_route_ref (categorie_route),
    FOREIGN KEY (type_circulation) REFERENCES type_circulation_ref (type_circulation)
);

CREATE TABLE vehicule (
    numero_accident BIGINT NOT NULL,
    id_vehicule BIGINT PRIMARY KEY NOT NULL,
    num_veh VARCHAR(5),
    catvehic TINYINT NOT NULL,
    obstacle_fixe TINYINT,
    obstacle_mobile TINYINT,
    choc TINYINT,
    manoeuvre TINYINT NOT NULL,
    motorisation_vh TINYINT NOT NULL,
    n_occup_tc TINYINT,
    FOREIGN KEY (numero_accident) REFERENCES caracteristiques (numero_accident) ON DELETE CASCADE,
    FOREIGN KEY (catvehic) REFERENCES catvehic_ref (catvehic),
    FOREIGN KEY (obstacle_fixe) REFERENCES obstacle_fixe_ref (obstacle_fixe),
    FOREIGN KEY (obstacle_mobile) REFERENCES obstacle_mobile_ref (obstacle_mobile),
    FOREIGN KEY (manoeuvre) REFERENCES manoeuvre_ref (manoeuvre),
    FOREIGN KEY (motorisation_vh) REFERENCES motorisation_vh_ref (motorisation_vh),
    FOREIGN KEY (choc) REFERENCES choc_ref (choc)
);

CREATE TABLE usagers (
    numero_accident BIGINT NOT NULL,
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_usager BIGINT,
    id_vehicule BIGINT NOT NULL, 
    num_veh VARCHAR(5),
    place SMALLINT,
    cat_usager TINYINT NOT NULL,
    gravite TINYINT NOT NULL,
    sexe TINYINT NOT NULL,
    an_nais INT,
    trajet TINYINT NOT NULL,
    secu1 TINYINT,
    secu2 TINYINT,
    secu3 TINYINT,
    localisation_pt TINYINT NOT NULL,
    action_pt TINYINT NOT NULL,
    statut_pt TINYINT NOT NULL,
    FOREIGN KEY (numero_accident) REFERENCES caracteristiques (numero_accident) ON DELETE CASCADE,
    FOREIGN KEY (numero_accident, id_vehicule) REFERENCES vehicule (numero_accident, id_vehicule) ON DELETE CASCADE,
    FOREIGN KEY (cat_usager) REFERENCES cat_usager_ref (cat_usager),
    FOREIGN KEY (gravite) REFERENCES gravite_ref (gravite),
    FOREIGN KEY (sexe) REFERENCES sexe_ref (sexe),
    FOREIGN KEY (trajet) REFERENCES trajet_ref (trajet),
    FOREIGN KEY (secu1) REFERENCES secu_ref (secu),
    FOREIGN KEY (secu2) REFERENCES secu_ref (secu),
    FOREIGN KEY (secu3) REFERENCES secu_ref (secu),
    FOREIGN KEY (localisation_pt) REFERENCES localisation_pt_ref (localisation_pt),
    FOREIGN KEY (action_pt) REFERENCES action_pt_ref (action_pt),
    FOREIGN KEY (statut_pt) REFERENCES statut_pt_ref (statut_pt)
);