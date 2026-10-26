import pandas as pd

"""Module de préparation des données de caractéristiques d'accidents.

Ce module regroupe les fonctions de normalisation appliquées aux fichiers
de caractéristiques d'accidents de la route, dont la structure (présence
et nom des colonnes) peut varier selon les années de publication.

Il fournit deux étapes de prétraitement, à enchaîner dans cet ordre :

- ``order_caract`` : uniformise le jeu de colonnes (suppression de la
  colonne ``gps``, ajout des colonnes manquantes, ordre universel) ;
- ``rename_caract`` : remplace les noms de colonnes d'origine par des
  libellés explicites en français.

Dépendances
-----------
pandas

Exemple
-------
>>> import pandas as pd
>>> df = pd.read_csv("caracteristiques.csv")
>>> df = order_caract(df)
>>> df = rename_caract(df)
"""

def order_caract(df : pd.DataFrame) -> pd.DataFrame : 
    """Normalise la structure d'un DataFrame de caractéristiques d'accidents.

Supprime la colonne ``gps`` lorsqu'elle est présente, ajoute les colonnes
    essentielles manquantes (initialisées à ``None``), puis réordonne les
    colonnes selon un ordre universel commun à tous les millésimes de données.

    Colonnes essentielles retenues, dans l'ordre :
    ``Num_Acc``, ``jour``, ``mois``, ``an``, ``hrmn``, ``lum``, ``dep``,
    ``com``, ``agg``, ``int``, ``atm``, ``col``, ``adr``, ``lat``, ``long``.

    Parameters
    ----------
    df : pd.DataFrame
        DataFrame brut des caractéristiques d'accidents, dont les colonnes
        peuvent varier d'une source ou d'une année à l'autre.

    Returns
    -------
    pd.DataFrame
        DataFrame contenant uniquement les colonnes essentielles, dans
        l'ordre défini.
    """
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
    """Renomme les colonnes d'un DataFrame de caractéristiques d'accidents.

    Remplace les noms de colonnes d'origine (codes abrégés) par des libellés
    explicites en français. L'association se fait par position : la
    *n*-ième colonne du DataFrame reçoit le *n*-ième nouveau nom.

    Nouveaux noms, dans l'ordre :
    ``numero_accident``, ``jour``, ``mois``, ``annee``, ``hrmn``,
    ``luminosite``, ``departement``, ``commune``, ``localisation``,
    ``intersection``, ``cond_atmosphère``, ``type_collision``, ``adresse``,
    ``lat``, ``long``.

    Parameters
    ----------
    df : pd.DataFrame
        DataFrame des caractéristiques d'accidents, dont les colonnes sont
        supposées être déjà ordonnées selon l'ordre universel produit par
        ``order_caract``.

    Returns
    -------
    pd.DataFrame
        DataFrame dont les colonnes ont été renommées.

    Notes
    -----
    L'association étant positionnelle, un ordre de colonnes différent de
    celui attendu entraînerait des renommages erronés. De plus, si le nombre
    de colonnes diffère de 15, ``zip`` tronque l'association à la plus courte
    des deux listes, sans lever d'erreur.
    """
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


