# Analyse-BAAC
Analyse des données publiques de la Bases de données annuelles des accidents corporels de la circulation routière de 2019 à 2024 afin d'identifier des tendances. 

## Sommaire

- [Résultats clés](#résultats-clés)
- [Contexte](#contexte)
- [Méthodologie](#méthodologie)
- [Conception de la base SQL](#conception-de-la-base-sql)
- [Méthodologie statistique ](#méthodologie-statistique)
- [Stack technique](#stack-technique)
- [Structure du repo](#structure-du-repo)
- [Lancer le projet](#lancer-le-projet)
- [Recommandations](#recommandations)
- [Limites et pistes futures](#limites-et-pistes-futures)
- [Auteur](#auteur)

## Résultats clés

- Le nombre d'accidents en France **suit une baisse depuis 2021** (53 540 contre 51 057)
- Le nombre d’accident grave en France est **relativement stable depuis 2021** (18 266 contre 18340)
- La proportion d'accidents graves en France depuis 2021 **est en hausse** (35.9% contre 34.1%)
- **Les routes départementales possèdent une proportion de 51.34% d’accidents graves** (contre 35.04% des accidents totaux)
- **33% des accidents impliquant un piéton sont graves** (contre 17% en moyenne des autres usagers).
- **Les tonneaux et les chocs avant** ont une gravité conditionnelle plus élevée (15.79% contre 14.46% de moyenne d’échantillon sur tous les chocs)

## Contexte

Dans le cadre de la hausse des décès sur la route en France métropolitaine (+4% en mai 2026 par rapport à mai 2025 [*ONISR, 2026*]), le Ministère de l’Intérieur cherche à renforcer ses campagnes de prévention et d’aménagement du réseau routier français. 

Dans un contexte de hausse de la dette publique, il est important pour l’État de faire des choix quant aux actions et budgets à allouer. Dès lors, comprendre concrètement les facteurs associés des accidents graves permet de cibler correctement les actions, sans augmenter inutilement les dépenses publiques. 

Ainsi, je vais tenter de proposer des recommandations claires quant aux actions, aménagements et profils à cibler dans le cadre de la prévention routière.

En m’appuyant sur la Base de données annuelle des accidents corporels de la circulation routière depuis 2019, je vais répondre aux questions suivantes : 

1. *Depuis 2019, comment le nombre et la gravité des accidents de la route ont évolué ?*

2. *Quel département concentrent la plus forte proportion d'accidents graves parmi leurs accidents ?*

3. *Quel type de route concentre la plus forte proportion d’accidents graves ?*

4. *Quels facteurs extérieurs à l’usager influencent la gravité d’un accident de la route ?*

5. *Selon le type de route, quels types de chocs sont associés aux accidents graves ?*

6. *Quels types d’usagers de la route présentent la plus forte proportion d’accidents graves ?*

7. *Quel est le profil démographique le plus représenté dans les accidents graves ?*

L’objectif est donc de fournir des secteurs et zones géographiques clés à aménager, mais également des profils d’usagers et de facteurs de risques à utiliser dans les campagnes de sensibilisation des usagers (exemple : les gants en moto) ou bien même de formulation d’idées de textes de loi. 

La BAAC enregistre la gravité par usager (indemne, tué, blessé hospitalisé, blessé léger). Dans ce projet, un accident est qualifié de grave lorsqu’au moins un usager impliqué est tué ou blessé hospitalisé.

Cette définition est plus large que la notion de « pronostic vital engagé ou séquelles permanentes » : la base ne permet pas de distinguer, parmi les blessés hospitalisés, ceux qui ont des séquelles durables. Elle surestime donc probablement légèrement la gravité réelle.

## Méthodologie

- Conception d’une base SQL à partir des données publiques de la BAAC (partie suivante)
- Nettoyage : Vérification des valeurs NULL, des doublons
- Requêtes SQL afin de récupérer les données essentielles pour répondre aux différentes questions, avec export en .csv afin de pouvoir réutiliser les données dans le rapport
- Analyse statistique complexe dans Python (scipy) afin de justifier statistiquement les résultats obtenus. (Le détail des tests et leur justification est dispo dans la partie suivante)
- Importation des CSV dans Power BI afin de créer un rapport complet

## Conception de la base SQL

- **Étape 1 - Compréhension de la table des données **

Dans cette étape, j’ai analysé en détail la structure des tables csv de la base de données annuelle des accidents corporels de la circulation routière afin d’identifier les différents types en présence.

Cette phase s'est conclue par la prise en note des différents types de données par table, que j’utiliserai dans la conception du MCD ainsi que dans la création des tables dans MySQL.

De plus, je ne fais pas usage des données antérieures à l’année 2019, car cette date marque une évolution dans la prise de données, mais également à la modification de plusieurs indicateurs. Ainsi, les données antérieures sont non comparables et sont exclues de la base de données. 

- **Étape 2 - Création du Modèle Conceptuel de la Donnée (MCD)**

Dans cette étape, l’objectif est de créer un schéma compréhensif de notre base de données, afin de ne rien oublier et d’encoder correctement l’ensemble des clés en présence.

[SCHEMA DU MCD WIP]

À noter que dans cette phase, j’ai fait le choix de ne pas utiliser id_usager comme clé primaire de la table usagers, car cette dernière présente des None dans les colonnes, car cette nomenclature n’a été introduite qu’en 2021 dans la base.

De plus, la table lieux se voit incorporer un lieux_id en clé primaire, plutôt que numéro_accident seul, car certains accidents survenant dans une intersection sont rattachés à deux voies différentes, ce qui génère deux lignes lieux pour le même numéro_accident.
Un lieux_id auto-incrémenté permet donc de conserver ces deux enregistrements sans rompre la contrainte d’unicité.

Cette base contient également des tables de références contenant la version textuelle de chaque entrée catégorielle de la base. Ainsi, ces dernières permettront de faciliter la compréhension des résultats des requêtes SQL, tout en conservant la possibilité de réaliser des calculs statistiques sur les mêmes données.

- **Étape 3 - Création de la table en SQL**

Dans cette étape, j’ai commencé par créer dans une requête l’ensemble de la base de données, avec les types de données nécessaires et les formats.

Ensuite, grâce à Python j’ai mis en place une automatisation de nettoyage des tables, afin qu’elle puisse correspondre entièrement aux colonnes programmées en SQL. 

Ce nettoyage est basé sur l’analyse antérieure des données en présence dans les tables, mais également à l’anticipation de potentielles mauvaises entrées et manquants.

## Méthodologie statistique

Les statistiques font partie intégrante de ce projet, et le choix des hypothèses et des tests à mettre en place également. Cette partie contient l’ensemble des tests utilisés dans l’analyse, ainsi que les hypothèses pour chaque question. 

*Quel département concentrent la plus forte proportion d'accidents graves parmi leurs accidents ?*

**H0** : Les départements concentrent la même proportion d’accidents graves
**H1** : Les départements possèdent des proportions d'accidents graves différentes

Pour tester ces hypothèses, je vais faire usage d’un intervalle de confiance à 99%, calculé à l’aide de la méthode de Wilson. La fourchette basse sera ensuite comparée à la moyenne de l’échantillon afin d’identifier les données supérieures.

*Quel type de route concentrent le plus d’accidents graves ?*

**H0** : Toutes les routes concentrent la même proportion d’accidents graves
**H1** : Certaines routes possèdent une proportion d’accidents graves plus élevés

Pour tester ces hypothèses, je vais faire usage d’un intervalle de confiance à 99%, calculé à l’aide de la méthode de Wilson. La fourchette basse sera ensuite comparée à la moyenne de l’échantillon afin d’identifier les données supérieures.

*Quels facteurs externes influencent la gravité d’un accident de la route ?*

**H0** : Aucun facteur externe ne peut être relie positivement ou négativement à la gravité
**H1** : Certains facteurs externes peuvent augmenter ou diminuer la gravité d’un accident

Pour tester ces hypothèses, je vais faire usage d’un test d’indépendance du Khi² afin de vérifier si les variables peuvent être qualifiées de dépendantes. Ensuite, pour analyser la force de la relation, j’ai appliqué le V de Cramer.

*Quel type de choc provoquent les accidents les plus graves en fonction du type de route ?*

**H0** : Tous les chocs ont la même proportion d’accidents graves
**H1** : Certains chocs ont une plus haute proportion d’accidents graves

Pour tester ces hypothèses, je vais faire usage d’un intervalle de confiance à 99%, calculé à l’aide de la méthode de Wilson. La fourchette basse sera ensuite comparée à la moyenne de l’échantillon afin d’identifier les données supérieures.

*Quels types d’usagers de la route sont les plus à risque de subir un grave accident ?* 

**H0** : L’ensemble des usagers peuvent subir un accident grave avec les mêmes chances
**H1** : Certains usagers sont plus à risque de subir un accident grave

Pour tester ces hypothèses, je vais faire usage d’un intervalle de confiance à 99%, calculé à l’aide de la méthode de Wilson. La fourchette basse sera ensuite comparée à la moyenne de l’échantillon afin d’identifier les données supérieures.

*Quel est le profil démographique le plus représenté dans les accidents graves ?* 

**H0** : Aucun profil clair ne peut être identifié dans les accidents graves
**H1** : Un profil clair peut être dressé dans le cadre des accidents graves

Pour tester ces hypothèses, je vais faire usage d’un intervalle de confiance à 99%, calculé à l’aide de la méthode de Wilson. La fourchette basse sera ensuite comparée à la moyenne de l’échantillon afin d’identifier les données supérieures.

## Stack technique

- SQL (MySQL)
- Conception de base de donnée
- Python 3
- pandas
- matplotlib, seaborn
- scipy
- Statistique et test d’hypothèse sur donnée qualitatives
- PowerBI

## Structure du repo

```bash
Analyse-BAAC/
├── base_donnee/
│   ├── table/                    # Tables CSV de la base de données (BAAC 2019-2024)
│   │   └── *.csv
│   ├── baac.sql                  # Création de la base de données et des tables
│   ├── cleaning.py               # Nettoyage des données et chargement dans MySQL
│   ├── cleaning_function.py      # Fonctions de nettoyage utilisées par cleaning.py
│   └── nettoyage.sql             # Nettoyage complémentaire de la base SQL
├── output_sql/                   # Fichiers CSV exportés depuis MySQL
│   └── *.csv
├── csv/                          # Fichiers CSV nettoyés et exportés depuis Python
│   └── *.csv
├── analyse.sql                   # Requêtes d'extraction des données
├── notebook_analyse.ipynb        # Notebook d'analyse statistique
├── fx_analyse.py                 # Fonctions utilisées par le notebook
├── requirements.txt              # Packages et bibliothèques Python nécessaires
├── rapport.pdf                   # Rapport Power BI de l'analyse
└── README.md
```

## Lancer le projet

### Prérequis

- Python 3.11
- MySQL 8.0, avec un serveur en cours d'exécution
- Jupyter Notebook (installé via `requirements.txt`)

### 1. Cloner le dépôt et installer les dépendances

```bash
git clone https://github.com/Alex-LC0/Analyse-BAAC.git
cd Analyse-BAAC
pip install -r requirements.txt
```

Les tables CSV de la BAAC (de 2019 à 2024) sont déjà incluses dans le dossier `base_donnee/table/`. Elles proviennent de la [Base de données annuelle des accidents corporels de la circulation routière](https://www.data.gouv.fr/fr/datasets/bases-de-donnees-annuelles-des-accidents-corporels-de-la-circulation-routiere-annees-de-2005-a-2023/) publiée sur data.gouv.fr.

### 2. Créer la base de données

Exécuter le script de création de la base `baac` et de ses tables :

```bash
mysql -u root -p < base_donnee/baac.sql
```

### 3. Nettoyer et charger les données

Le fichier `base_donnee/cleaning.py` contient la ligne de connexion à MySQL suivante :

```python
conn = sqlalchemy.create_engine(f"mysql+pymysql://UTILISATEUR:MOT_DE_PASSE@localhost:3306/{database}")
```

Avant l'exécution, remplacer `UTILISATEUR` et `MOT_DE_PASSE` par les identifiants de votre installation MySQL, puis vérifier que la variable `database` vaut bien `baac`. Lancer ensuite :

```bash
python base_donnee/cleaning.py
```

Ce script nettoie les tables (valeurs manquantes, doublons, formats) à l'aide des fonctions de `cleaning_function.py`, puis charge les données dans la base MySQL.

Exécuter enfin le script de nettoyage complémentaire :

```bash
mysql -u root -p baac < base_donnee/nettoyage.sql
```

### 4. Extraire les données d'analyse

Les requêtes de `analyse.sql` exportent leurs résultats au format CSV vers le dossier d'import et d'export sécurisé de MySQL, qui dépend de chaque installation. Pour le connaître, exécuter :

```sql
SHOW VARIABLES LIKE 'secure_file_priv';
```

Remplacer ensuite le chemin d'export dans les requêtes de `analyse.sql` par ce dossier, puis exécuter le script :

```bash
mysql -u root -p baac < analyse.sql
```

Copier enfin les fichiers CSV générés dans le dossier `output_sql/` du dépôt.

### 5. Réaliser l'analyse statistique

```bash
jupyter notebook notebook_analyse.ipynb
```

Le notebook s'appuie sur les fonctions de `fx_analyse` et produit les fichiers CSV nettoyés dans le dossier `csv/`.

Les dossiers `output_sql/` et `csv/` étant déjà fournis dans le dépôt, il est possible de passer directement à cette étape pour rejouer l'analyse sans reconstruire la base de données.

### 6. Consulter le rapport Power BI

Le rapport est disponible au format PDF, sans installation requise : [Rapport Power BI (PDF)](rapport/rapport_baac.pdf)

## Recommandations

Les résultats permettent de formuler cinq pistes d’action  :

- Renforcer le contrôle de la vitesse sur les routes départementales, qui présentent la plus forte proportion d’accidents graves (51.34 % contre 35.04 % en moyenne), car cette pratique a démontré son effet dans la réduction du risque d’accident grâce à son efficacité préventive [Cours des Comptes], et également car ces routes présentent de hautes vitesses (80 à 90km/h).

- Prioriser l’entretien du réseau départemental via des financements ciblés vers les départements ruraux (le 24, 40, 53, 70, 39…), sachant qu’une route départementale sur 10 nécessite un entretien d’urgence (Altersécurité.org)

- Améliorer la protection des usagers de deux-roues et de véhicules sans carrosserie (par exemple gilet airbag en moto) : ils représentent 73.90% des accidents graves

- Réduire le risque piéton en agglomération (abaissement des vitesses, aménagements de protection) : 33% des accidents impliquant un piéton sont graves.

- Cibler les campagnes de sensibilisation sur les deux sexes, car aucun ne présente de risque conditionnel supérieur à l’autre.

Ces recommandations s’appuient sur des associations statistiques. Leur efficacité réelle (par exemple l’effet des radars sur la mortalité) devrait être validée par une étude d’impact dédiée avant tout déploiement, ainsi qu’une estimation de leur coût.

## Limites et pistes futures

- Pas de mesure d’exposition. Les résultats décrivent la gravité parmi les accidents survenus, pas le risque par usager ou par kilomètre parcouru. Un département très peuplé concentre mécaniquement plus d’accidents. Intégrer la population (INSEE) ou le trafic moyen journalier permettrait de passer d’une analyse descriptive à une évaluation du risque réel.

- Association n’est pas causalité. Les tests utilisés (Khi², V de Cramer, intervalles de Wilson) mettent en évidence des liens statistiques, sans pouvoir établir qu’un facteur provoque la gravité. Des variables non observées (heure, trafic, profil du conducteur) peuvent jouer un rôle. Une régression logistique multivariée permettrait de contrôler plusieurs facteurs simultanément.

- Définition de la gravité. La catégorie « blessé hospitalisé » regroupe des situations très différentes, sans information sur les séquelles.

- Données manquantes. 6.81 % des lignes ont été exclues pour valeurs non renseignées, principalement sur les variables des facteurs externes. Je n’ai pas vérifié si ces absences étaient réparties de façon homogène (par département, par gravité), ce qui peut introduire un biais.

## Auteur

Alexis LE CALVEZ
