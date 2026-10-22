import pandas as pd

def order_caract(df : pd.DataFrame) -> pd.DataFrame : 
    if "gps" in list(df) : #Suppression de la colonne inutile seulement si elle est présente.
        df = df.drop('gps', axis=1)
    
    CARACT_COLUMNS =[
        'Num_Acc',
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
        'adr',
        'lat',
        'long'
        ] #Liste de l'ensemble des colonnes essentielles.

    for ca in CARACT_COLUMNS : #Rajout des colonnes essentielles non présentes.
        if ca not in list(df) : 
            df[ca] = None

    df = df[CARACT_COLUMNS] #Définition de l'ordre universel des colonnes. 

def rename_caract (df : pd.DataFrame) -> pd.DataFrame : 
    cols_name = [
        "numero_accident",
        "jour",
        "mois",
        "annee",
        "hrmn",
        "luminosite",
        "departement",
        "commune",
        "localisation",
        "intersection",
        "cond_atmosphère",
        "type_collision",
        "adresse",
        "lat",
        "long"
    ] #Mise en place des noms de colonnes 

    caract_keys = list(df) #Rajout des noms actuelles dans une liste

    news_cols = dict(zip(caract_keys, cols_name)) #Stockage des avant / après dans un dictionnaire
    df = df.rename(columns=news_cols) #Changement du nom de chaque colonnes.


