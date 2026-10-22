import pandas as pd
import sqlalchemy
from cleaning_functions import (
    order_caract,
)

# Liste des tables à traiter dans la pipeline : 
tables_caracteristiques = [
    "caract-2024",
    "caract-2023",
    "caract-2022",
    "caract-2021",
    "caract-2020",
    "caract-2019",
]

tables_lieux = [
    "lieux-2024",
    "lieux-2023",
    "lieux-2022",
    "lieux-2021",
    "lieux-2020",
    "lieux-2019",
]

tables_vehicules = [
    "vehicules-2024",
    "vehicules-2023",
    "vehicules-2022",
    "vehicules-2021",
    "vehicules-2020",
    "vehicules-2019",
]

tables_usagers = [
    "usagers-2024",
    "usagers-2023",
    "usagers-2022",
    "usagers-2021",
    "usagers-2020",
    "usagers-2019",
]

database = "baac" #Base de donnée dans laquelle intégrer les données.

conn = sqlalchemy.create_engine(f"mysql+pymysql://root:root@localhost:3306/{database}") #Connexion avec la base MySql pour stocker les datas.

for c in tables_caracteristiques : 
#Nettoyage global de la table "caracteristique" : 

    caract = pd.read_csv(f"tables/caract/{c}.csv", sep=None, engine="python") #Ouverture des csv (engine python car présence de "," et ";" dans les différentes tables)

    if "gps" in list(caract) : #Suppression d'une colonne inutile, seulement si elle est présente dans la table.
        caract = caract.drop('gps', axis=1)

    if "Accident_Id" in list(caract) : #Correction d'un potentiel mauvais encodage de la table "Num_Acc"
        caract = caract.rename(columns={"Accident_Id" : "Num_Acc"})

    caract = caract.drop(["lat", "long"], axis=1) #Suppression de deux colonnes inutiles présente dans les tables
    
    CARACT_COLUMNS =[
        'Num_Acc',
        "date_hrmn",
        'jour',
        'mois',
        'an',
        'hrmn',
        'lum',
        'dep',
        'com',
        'agg',
        'int',
        'atm',
        'col',
        'adr'
        ] #Liste de l'ensemble des colonnes essentielles.

    for ca in CARACT_COLUMNS : #Boucle de rajout des colonnes essentielles manquantes.
        if ca not in list(caract) : 
            caract[ca] = None #Remplissage par None, car les données ne sont pas inférables.

    caract = caract[CARACT_COLUMNS] #Définition de l'ordre universel des colonnes (éviter les problème d'inversions de données).

    cols_name = [
        "numero_accident",
        "date_hrmn",
        "jour",
        "mois",
        "annee",
        "hrmn",
        "luminosite",
        "departement",
        "commune",
        "localisation",
        "intersection",
        "cond_atmosphere",
        "type_collision",
        "adresse",
    ]

    caract_keys = list(caract) #Listing des intitulés de colonnes

    new_cols = dict(zip(caract_keys,cols_name)) #Stockage du avant / après dans un dictionnaire
    caract = caract.rename(columns=new_cols) #Renommage de l'ensemble des intitulés de colonne. 

    #Normalisation des valeurs : 

    caract['adresse'] = caract['adresse'].str.lower() #Standarisation en minuscules.
    caract['adresse'] = caract['adresse'].str.capitalize() #Standardisation à la majuscle.

    caract["date_hrmn"] = pd.to_datetime(dict(year=caract["annee"], month=caract["mois"], day=caract["jour"])) #Standardisation au format YYYY-MM-DD
    caract["date_hrmn"] = caract["date_hrmn"] + pd.to_timedelta(caract["hrmn"] + ":00") #Rajout de l'heure au format standarisé
    caract = caract.drop(["jour", "mois", "annee", "hrmn"], axis=1) #Suppression des colonnes inutiles suite à la standardisation.

    caract.to_sql(name="caracteristiques", con=conn, if_exists="append", index=False) #Export des données dans la table SQL

for l in tables_lieux : 
#Nettoyage global de la table "lieux" : 

    lieux = pd.read_csv(f"tables/lieux/{l}.csv", sep=None, engine="python") #Ouverture du fichier csv de la table.

    lieux = lieux.drop(["v1", "v2", "pr", "pr1"], axis=1) #Suppression des colonnes non essentielles 

    LIEUX_COLUMNS = [
    'Num_Acc',
    'catr',
    'voie',
    'circ',
    'nbv',
    'vosp',
    'prof',
    'plan',
    'lartpc',
    'larrout',
    'surf',
    'infra',
    'situ',
    'vma'
    ] #Liste de l'ensemble des colonnes essentielles à l'analyse

    for c in LIEUX_COLUMNS : 
        if c not in list(lieux) : 
            lieux[c] = None #Boucle de rajout des colonnes essentielles absentes

    lieux = lieux[LIEUX_COLUMNS] #Définition de l'ordre standard des colonnes essentielles (éviter les inversions de données)

    if "env1" in list(lieux) : #Suppression d'une colonne inutile seulement si elle est présente
        lieux = lieux.drop("env1", axis=1) 

    cols_name_lieux = [
        "numero_accident",
        "categorie_route",
        "nm_voie",
        "type_circulation",
        "nombre_voies",
        "voie_reserv",
        "type_declin",
        "plan",
        "larg_tp",
        "larg_chauss",
        "etat_route",
        "infrastructure",
        "situation_acc",
        "vitesse_max",
    ] #Regroupement des nouveaux intitulés de colonne

    lieux_keys = list(lieux)

    new_cols_lieux = dict(zip(lieux_keys, cols_name_lieux))

    lieux = lieux.rename(columns=new_cols_lieux) #Passage des anciens aux nouveaux index

    #Normalisation des valeurs : 

    lieux['nm_voie'] = lieux['nm_voie'].str.lower() #Standarisation en minuscules.
    lieux['nm_voie'] = lieux['nm_voie'].str.capitalize() #Standarisation avec majuscule au début.

    lieux = lieux.drop(lieux[(lieux.vitesse_max == -1)].index) #Suppression des valeurs abbérantes sur la vitesse max

    lieux["larg_chauss"] = lieux["larg_chauss"].astype(str).str.strip().str.replace(",",".") #Standarisation de la colonne "larg_chauss"

    def negate_replace(dataframe) : #Fonction de suppression des -1 pour la numérisation des données
        if dataframe["larg_chauss"] == "-1":  # de min à q1
            return None
        else : 
            return dataframe["larg_chauss"]

    lieux["larg_chauss"] = lieux.apply(negate_replace, axis=1) #Application de la fonction
    lieux["larg_chauss"] = pd.to_numeric(lieux["larg_chauss"], errors="coerce") #Passage en "int" des variables "str" avec une suppression par error="coerce"

    lieux["larg_tp"] = lieux["larg_tp"].astype(str).str.strip().str.replace(",",".") #Application du même process que sur "larg_tp"
    lieux["larg_tp"] = pd.to_numeric(lieux["larg_tp"], errors="coerce")

    lieux["nombre_voies"] = pd.to_numeric(lieux["nombre_voies"], errors="coerce") #Passage en "int" de la colonne "nombre_voies"

    lieux.to_sql(name="lieux", con=conn, if_exists="append", index=False) #Export des données nettoyées au format SQL

for v in tables_vehicules : 
#Nettoyage global de la table vehicules : 

    vehicule = pd.read_csv(f"tables/vehicules/{v}.csv", sep=None, engine="python") #Ouverture des fichier csv 

    COLUMNS = [
    'Num_Acc',
    'id_vehicule',
    'num_veh',
    'senc',
    'catv',
    'obs',
    'obsm',
    'choc',
    'manv',
    'motor',
    'occutc'
    ] #Ensemble des colonnes essentielles de la table

    for c in COLUMNS : #Boucle d'ajout des colonnes essentielles absentes de la table
        if c not in list(vehicule) :
            vehicule[c] = None 

    vehicule = vehicule[COLUMNS] #Mise en place d'un ordre standardisé (pour éviter les inversions)

    vehicule = vehicule.drop("senc", axis=1) #Suppression d'une colonne inutile à la base de donnée 

    cols_name_vehicule = [
        "numero_accident",
        "id_vehicule",
        "num_veh",
        "catvehic",
        "obstacle_fixe",
        "obstacle_mobile",
        "choc",
        "manoeuvre",
        "motorisation_vh",
        "n_occup_tc",
    ] #Regroupement des nouveaux index

    vehicule_keys = list(vehicule)

    new_cols_vehicule = dict(zip(vehicule_keys, cols_name_vehicule))

    vehicule = vehicule.rename(columns=new_cols_vehicule) #Changement de nom des intitulés de colonne 

    #Normalisation des données : 

    vehicule['id_vehicule'] = vehicule['id_vehicule'].str.replace(r'\s+', '', regex=True) #Suppression des espaces insecables dans le "id_vehicule"

    vehicule.to_sql(name="vehicule", con=conn, if_exists="append", index=False) #Export des données nettoyée dans la base SQL

for u in tables_usagers : 
#Nettoyage global de la table usagers : 

    usagers = pd.read_csv(f"tables/usagers/{u}.csv", sep=None, engine="python") #Ouverture du fichier csv de la table

    USAGER_COLUMNS = [
    'Num_Acc',
    'id_usager',
    'id_vehicule',
    'num_veh',
    'place',
    'catu',
    'grav',
    'sexe',
    'an_nais',
    'trajet',
    'secu1',
    'secu2',
    'secu3',
    'locp',
    'actp',
    'etatp'
    ] #Ensemble des colonnes essentielles à la table

    for cu in USAGER_COLUMNS : #Boucle d'ajout des colonnes essentielles absentes
        if cu not in list(usagers) : 
            usagers[cu] = None 

    usagers = usagers[USAGER_COLUMNS] #Standarisation de l'ordre des colonnes

    cols_name_usagers = [
        "numero_accident",
        "id_usager",
        "id_vehicule",
        "num_veh",
        "place",
        "cat_usager",
        "gravite",
        "sexe",
        "an_nais",
        "trajet",
        "secu1",
        "secu2",
        "secu3",
        "localisation_pt",
        "action_pt",
        "statut_pt"
    ] #Regroupement des nouveaux index

    usager_keys = list(usagers)
    new_cols_usager = dict(zip(usager_keys, cols_name_usagers))

    usagers = usagers.rename(columns=new_cols_usager) #Changement des intitulés de colonnes

    #Normalisation des données : 

    usagers['id_vehicule'] = usagers['id_vehicule'].str.replace(r'\s+', '', regex=True) #Suppression des espaces insecables dans le "id_vehicule"
    usagers["id_usager"] = usagers["id_usager"].str.replace(r'\s+', '', regex=True) #Suppression des espaces insecables dans le "id_usager"
    usagers["num_veh"] = usagers["num_veh"].str.strip() #Suppression des espaces parasites dans "num_veh"

    def string_replace(dataframe) : #Fonction de remplacement des "A" et "B" dans les input numériques
        if dataframe["action_pt"] == "A":  # de min à q1
            return 10
        elif dataframe["action_pt"] == "B" :  # de q1 à q2
            return 11
        else :
            return dataframe["action_pt"]

    usagers['action_pt'] = usagers.apply(string_replace, axis=1) #Application de la fonction

    usagers["action_pt"] = usagers["action_pt"].astype(str).str.strip().str.replace(",",".") #Standarisatrion des "action_pt" en "int"
    usagers["action_pt"] = pd.to_numeric(usagers["action_pt"], errors="coerce") #Passage au format numérique
    usagers = usagers.drop(usagers[usagers.action_pt == 7].index) #Drop des 7 identifiés dans la base (associé à des id_usagers = None)
    usagers = usagers.drop(usagers[usagers.action_pt == 8].index) #Drop des 7 identifiés dans la base (associé à des id_usagers = None)

    usagers.to_sql(name="usagers", con=conn, if_exists="append", index=False) #Export des données nettoyée dans la base SQL

print("Job done ;)")
