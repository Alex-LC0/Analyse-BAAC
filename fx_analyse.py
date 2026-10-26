"""Module d'analyse statistique et de visualisation des accidents de la route.

Ce module regroupe des outils d'analyse de la gravité des accidents :

- ``confidence_interval_wilson`` : calcule des intervalles de confiance de
  Wilson (niveau de confiance de 99 %) sur des proportions d'accidents
  graves et isole les modalités significativement au-dessus de la moyenne
  de l'échantillon ;
- ``khi2_independance`` : teste l'indépendance de deux variables
  qualitatives (test du Chi²) et mesure l'intensité de leur association
  par le V de Cramer ;
- ``graphique_effectif_route`` : représente la répartition des types de
  choc, pour l'ensemble des accidents puis pour les accidents graves.

Les résultats statistiques sont restitués par affichage console (``print``)
et les graphiques sont construits avec Matplotlib et Seaborn.

Dépendances
-----------
pandas, numpy, matplotlib, seaborn, scipy, statsmodels

Exemple
-------
>>> resultat = confidence_interval_wilson(df, count="n_grave",
...                                       nobs="n_total", sort="n_total")
>>> khi2_independance(df, xtab="lum", ytab="gravite", alpha=0.05)
>>> graphique_effectif_route(route)
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from statsmodels.stats.proportion import proportion_confint
from scipy.stats import chi2_contingency


#Interval Confiance Wilson : 

def confidence_interval_wilson(df : pd.DataFrame, count : str, nobs : str, sort : str) : #Fonction de calcul des intervalles de confiances de Wilson
    """Calcule les intervalles de confiance de Wilson et isole les modalités à risque.

    Pour chaque ligne du DataFrame, calcule l'intervalle de confiance de
    Wilson à 99 % (``alpha=0.01``) de la proportion ``count / nobs``, exprimé
    en pourcentage. Affiche ensuite le pourcentage global d'accidents graves
    de l'échantillon, puis ne conserve que les lignes dont la borne basse de
    l'intervalle dépasse ce pourcentage global, c'est-à-dire celles dont la
    proportion est significativement supérieure à la moyenne.

    Parameters
    ----------
    df : pd.DataFrame
        DataFrame contenant, pour chaque modalité, le nombre d'accidents
        graves et le nombre total d'accidents. Il n'est pas modifié : la
        fonction travaille sur une copie.
    count : str
        Nom de la colonne contenant le nombre de succès (accidents graves).
    nobs : str
        Nom de la colonne contenant le nombre total d'observations
        (accidents).
    sort : str
        Nom de la colonne utilisée pour trier le résultat par ordre
        décroissant.

    Returns
    -------
    pd.DataFrame
        Copie filtrée du DataFrame, enrichie des colonnes ``ic_bas`` et
        ``ic_haut`` (bornes de l'intervalle, en %), ne contenant que les
        lignes pour lesquelles ``ic_bas`` est strictement supérieur au
        pourcentage global d'accidents graves, triées par ``sort`` en ordre
        décroissant.
    """
    df = df.copy()
    df["ic_bas"], df["ic_haut"] = proportion_confint(count=df[count], nobs=df[nobs], alpha=0.01, method="wilson")
    df["ic_bas"] = df["ic_bas"] * 100
    df["ic_haut"] = df["ic_haut"] * 100
    count_total = sum(df[nobs])
    count_grave = sum(df[count])
    pourcentage_grave = (count_grave / count_total) * 100
    print(f"Le pourcentage d'accident grave sur cet échantillon est de {pourcentage_grave}")
    return df.loc[df["ic_bas"] > pourcentage_grave].sort_values(by=sort, ascending=False)

#Calcul du Chi² et du V de Cramer : 

def khi2_independance(df : pd.DataFrame, xtab : str | int | list, ytab : str | int | list, alpha : int) -> str :
    """Teste l'indépendance de deux variables qualitatives et mesure leur association.

    Construit le tableau de contingence des variables ``xtab`` et ``ytab``,
    applique le test d'indépendance du Chi² puis calcule le V de Cramer.
    Les conclusions sont affichées sur la sortie standard :

    - si la p-valeur est inférieure à ``alpha``, l'hypothèse H0
      d'indépendance est rejetée ;
    - si la p-valeur est supérieure à ``alpha``, H0 est conservée.

    Dans les deux cas, l'intensité de l'association est qualifiée selon le
    V de Cramer : faible (V < 0,3), modérée (0,3 ≤ V < 0,5) ou forte
    (V > 0,5).

    Parameters
    ----------
    df : pd.DataFrame
        DataFrame contenant les deux variables à comparer.
    xtab : str | int | list
        Nom (ou étiquette) de la colonne servant aux lignes du tableau de
        contingence.
    ytab : str | int | list
        Nom (ou étiquette) de la colonne servant aux colonnes du tableau de
        contingence.
    alpha : int
        Seuil de significativité du test (par exemple ``0.05``).

    Returns
    -------
    None
        La fonction n'a pas de valeur de retour : les résultats (p-valeur,
        statistique du Chi², degrés de liberté, V de Cramer et leur
        interprétation) sont uniquement affichés.

    Notes
    -----

    Le V de Cramer est calculé à partir de la statistique du Chi² fournie
    par ``scipy.stats.chi2_contingency``, qui applique par défaut la
    correction de continuité de Yates pour les tableaux 2x2.

    Si la p-valeur est exactement égale à ``alpha``, ou si V vaut
    exactement 0,5, aucun message correspondant n'est affiché.
    """
    #Création du tableau de contingence : 
    contingence = pd.crosstab(df[xtab], df[ytab])
    #Calcul du test chi2 : 
    chi2, pval, ddl, tab = chi2_contingency(contingence)
    #Calcul du V de Cramer : 
    contingence_np = contingence.to_numpy()
    n = contingence_np.sum() #Calcul des observations de la table
    min_dim = min(contingence_np.shape) - 1 #Calcul du r et du c avec le -1 simplifié
    V = np.sqrt((chi2/n)/min_dim)
    if pval < alpha : #Hypothèse H0 rejettée
        print(f"L'hypothèse H0 pour la variable {ytab} est rejetée à {alpha}, les variables sont dépendante (pval = {pval}, chi2 = {chi2}, ddl = {ddl})")
        #Verification des hypothèses du V de Cramer
        if V <= 0.3 : 
            print(f"L'association par le V de Cramer entre {xtab} et {ytab} est faible (V = {V})")
        elif V <= 0.5 :
            print(f"L'association par le V de Cramer entre {xtab} et {ytab} est modérée (V = {V})")
        elif V > 0.5 : 
            print(f"L'association par le V de Cramer entre {xtab} et {ytab} est forte (V = {V})")
    elif pval >= alpha : #Hypothèse H0 acceptée
        print(f"L'hypothèse H0 pour la variable {ytab} est acceptée à {alpha}, les variables sont indépendantes (pval = {pval}, chi2 = {chi2}, ddl = {ddl})")
        #Verification des hypothèses du V de Cramer
        if V <= 0.3 : 
            print(f"L'association par le V de Cramer entre {xtab} et {ytab} est faible (V = {V})")
        elif V <= 0.5 :
            print(f"L'association par le V de Cramer entre {xtab} et {ytab} est modérée (V = {V})")
        elif V > 0.5 : 
            print(f"L'association par le V de Cramer entre {xtab} et {ytab} est forte (V = {V})")

#Graphique d'effectif de route : 

def graphique_effectif_route(route : pd.DataFrame) : 
    """Trace la répartition des types de choc, pour tous les accidents puis pour les accidents graves.

    Génère une figure de deux diagrammes en barres superposés :

    - en haut, le nombre de chocs par type de choc pour l'ensemble des
      accidents (barres grises) ;
    - en bas, le nombre de chocs par type de choc pour les seuls accidents
      graves (barres rouges).

    Parameters
    ----------
    route : pd.DataFrame
        DataFrame comportant au minimum les colonnes suivantes :

        - ``type_choc`` : libellé du type de choc (axe des abscisses) ;
        - ``n_choc`` : nombre de chocs, tous accidents confondus ;
        - ``n_choc_grave`` : nombre de chocs lors d'accidents graves.

    Returns
    -------
    None
        La fonction ne retourne rien : elle crée une figure Matplotlib de
        12 x 8 pouces.

    Notes
    -----
    La fonction n'appelle pas ``plt.show()``. L'affichage dépend donc de
    l'environnement d'exécution (automatique dans un notebook, à déclencher
    explicitement dans un script).
    """
    plt.figure(figsize=(12,8))
    plt.subplot(2, 1, 1)
    plt.title("Répartition du nombre de choc par rapport au total d'accident")
    sns.barplot(route, y="n_choc", x="type_choc", color="grey")
    plt.tight_layout()
    plt.subplot(2, 1, 2)
    plt.title("Répartition du nombre de choc par rapport au total d'accident grave")
    sns.barplot(route, y="n_choc_grave", x="type_choc", color="red")
    plt.tight_layout()
