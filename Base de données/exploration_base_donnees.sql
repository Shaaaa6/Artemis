

-- missions
SELECT nom, date_fin 
FROM mission m 
ORDER BY date_fin ;


-- missions avec vestiges
SELECT m.nom, date_fin, va.description 
FROM mission m 
   JOIN perimetre p ON p.fk_mission = m.pk_mission 
   JOIN "structure" s ON s.fk_perimetre = p.pk_perimetre 
   JOIN vestiges_athrop va ON va.fk_structure = s.pk_structure 
ORDER BY date_fin ;

-- missions avec nombre de vestiges
SELECT m.nom, date_fin, COUNT(*) AS effectif_vestiges 
FROM mission m 
   JOIN perimetre p ON p.fk_mission = m.pk_mission 
   JOIN "structure" s ON s.fk_perimetre = p.pk_perimetre 
   JOIN vestiges_athrop va ON va.fk_structure = s.pk_structure 
GROUP BY m.nom, date_fin
ORDER BY date_fin ;


-- typologies avec période, effectif et catégorie fonctionnelle
-- DROP VIEW v_categories_periodes ;
--CREATE VIEW v_categories_periodes AS
SELECT ct.pk_cat_typologique, ct.nom cat_typo, SUBSTR(MIN(m.date_fin),1,4) debut, SUBSTR(MAX(m.date_fin),1,4) fin, cf.nom cat_fonct, COUNT(*) as eff 
FROM cat_typologique ct
   JOIN vestiges_athrop va ON ct.pk_cat_typologique = va.fk_cat_typologique 
   JOIN "structure" s ON va.fk_structure = s.pk_structure 
   JOIN perimetre p  ON s.fk_perimetre = p.pk_perimetre 
   JOIN mission m ON p.fk_mission = m.pk_mission
   JOIN cat_fonctionnelle cf ON cf.pk_cat_fonctionnelle = ct.fk_cat_fonctionnelle
GROUP BY ct.pk_cat_typologique, ct.nom, cf.nom
ORDER BY cf.nom, debut

SELECT *
FROM v_categories_periodes;



