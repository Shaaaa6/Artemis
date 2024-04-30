--inspecter la table issue du csv
SELECT *
FROM Base_de_données bdd 
LIMIT 10;





-- nombre éléments, recoder
SELECT TRIM("nb_elem") nb_elem, COUNT(*) as eff
FROM Base_de_données bdd 
GROUP BY TRIM("nb_elem");

-- étant donné que le type de données est INTEGER remplacer indéterminé par 999
--UPDATE Base_de_données set nb_elem = 999
where nb_elem = 'Indéterminé';


-- compter les catégories fonctionnelles
SELECT TRIM(cate_fonc) mission, COUNT(*) as eff
FROM Base_de_données bdd 
GROUP BY TRIM(cate_fonc) ;


-- creation des catégories fonctionnelles
--INSERT INTO cat_fonctionnelle (nom)
SELECT DISTINCT TRIM(cate_fonc) mission
FROM Base_de_données bdd ;


-- compter les catégories typlogiques
SELECT TRIM(cate_typo) obj, COUNT(*) as eff
FROM Base_de_données bdd 
GROUP BY TRIM(cate_typo) ;

-- traiter catégories typologiques
SELECT DISTINCT TRIM(cate_typo), cf.pk_cat_fonctionnelle, cf.nom
FROM Base_de_données bdd left join cat_fonctionnelle cf 
   on cf.nom = TRIM(bdd.cate_fonc);


-- créer catégories typologiques
--INSERT INTO cat_typologique (nom,fk_cat_fonctionnelle)
SELECT DISTINCT TRIM(cate_typo), cf.pk_cat_fonctionnelle 
FROM Base_de_données bdd left join cat_fonctionnelle cf 
   on cf.nom = TRIM(bdd.cate_fonc);


  
-- inspecter les missions
SELECT TRIM("Localisation") mission, "Provenance", COUNT(*) as eff
FROM Base_de_données bdd 
GROUP BY TRIM("Localisation"), "Provenance"
ORDER BY mission DESC;

-- insérer les missions
--INSERT INTO mission (nom, provenance, date_fin)
SELECT DISTINCT TRIM("Localisation"), "Provenance", date_orig
FROM Base_de_données bdd ;

-- praparation transformation dates
SELECT date_fin, 
SUBSTR(date_fin, 7,4)||'-'||SUBSTR(date_fin,4,2)||'-'||SUBSTR(date_fin,1,2) 
from mission m ;

-- transformation dates
--UPDATE mission set date_fin = SUBSTR(date_fin, 7,4)||'-'||SUBSTR(date_fin,4,2)||'-'||SUBSTR(date_fin,1,2)

-- les missions sauf celle a vérifier
SELECT pk_mission 
FROM mission m 
WHERE pk_mission != 70;


-- créer lignes périmètre
--INSERT INTO perimetre (fk_mission)
SELECT pk_mission 
FROM mission m 
WHERE pk_mission != 70;



-- créer lignes structures: les structures seront à revoir mais selon le 
-- modèle conceptuel toute vestige est liée à une structure
--INSERT INTO "structure" (fk_perimetre)
SELECT pk_perimetre
FROM perimetre;

-- pk_perimetres des missions
SELECT s.pk_structure , m.nom 
FROM mission m 
    join perimetre p on p.fk_mission = m.pk_mission
    join "structure" s on s.fk_perimetre = p.pk_perimetre 

-- préparer import vestiges
WITH tw1 as (
SELECT s.pk_structure , m.nom 
FROM mission m 
    join perimetre p on p.fk_mission = m.pk_mission
    join "structure" s on s.fk_perimetre = p.pk_perimetre 
)
SELECT bdd.Description, bdd.Commentaire, bdd.nb_elem, bdd.numero,  tw1.pk_structure, ct.pk_cat_typologique
FROM Base_de_données bdd 
    JOIN tw1 ON tw1.nom = TRIM(bdd.Localisation)
    JOIN cat_typologique ct ON TRIM(ct.nom) = trim(bdd.cate_typo) ;

   
-- import vestiges   
WITH tw1 as (
SELECT s.pk_structure , m.nom 
FROM mission m 
    join perimetre p on p.fk_mission = m.pk_mission
    join "structure" s on s.fk_perimetre = p.pk_perimetre 
)
--INSERT INTO vestiges_athrop (description,commentaire,nombre_elements, fk_bdd_origine, fk_structure, fk_cat_typologique)
SELECT bdd.Description, bdd.Commentaire, bdd.nb_elem, bdd.numero, tw1.pk_structure, ct.pk_cat_typologique
FROM Base_de_données bdd 
    JOIN tw1 ON tw1.nom = TRIM(bdd.Localisation)
    JOIN cat_typologique ct ON TRIM(ct.nom) = trim(bdd.cate_typo) ;


   
   
   
   
