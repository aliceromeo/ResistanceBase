-- 1. Resistenze che interferiscono con almeno 3 antibiotici
SELECT res, COUNT(ant) AS numero_antibiotici 
FROM resant 
GROUP BY res 
HAVING COUNT(ant) >= 3;

-- 2. Articoli pubblicati tra il 2005 e il 2010 in ordine cronologico
SELECT autore, anno, rivista, res 
FROM riv, art, resart 
WHERE resart.art = art.pmid 
  AND riv.cod = art.riv 
  AND anno BETWEEN 2005 AND 2010 
ORDER BY anno;

-- 3a. Articolo pubblicato più anteriormente (con subquery)
SELECT autore, anno, res AS resistenza 
FROM riv, art, resart 
WHERE resart.art = art.pmid 
  AND riv.cod = art.riv 
  AND anno = (SELECT MIN(anno) FROM riv);

-- 3b. Articolo pubblicato più anteriormente (senza subquery)
SELECT autore, anno, res AS resistenza 
FROM riv, art, resart 
WHERE resart.art = art.pmid 
  AND riv.cod = art.riv 
ORDER BY anno 
LIMIT 1;

-- 4. Articoli il cui titolo contiene la parola “antibiotic”
SELECT titolo 
FROM art 
WHERE titolo LIKE '%antibiotic%';

-- 5. Classi di resistenza associate alla Tetraciclina raggruppate per meccanismo
SELECT COUNT(res.res_id) AS resistenze, res.classe, azione 
FROM resant, ant, res, mec, classe  
WHERE resant.res = res.res_id 
  AND resant.ant = ant.ant_id 
  AND res.classe = classe.class_id 
  AND classe.mec = mec.mec_id 
  AND ant.nome_a = 'Tetraciclina' 
GROUP BY azione, res.classe;

-- 6. Antibiotici con 'S' iniziale e relative proteine mutate
SELECT ant.nome_a AS antibiotico, prot.prot_id 
FROM ant, resant, res, resseq, seq, prot 
WHERE resant.ant = ant.ant_id 
  AND resant.res = res.res_id 
  AND res.res_id = resseq.res 
  AND resseq.seq = seq.seq_id 
  AND seq.seq_id = prot.seq 
  AND ant.nome_a LIKE 'S%';

-- 7. Batteri Enterobacteriaceae e relativi antibiotici resistenti
SELECT DISTINCT nome_sp AS batterio, ant.nome_a AS antibiotico 
FROM bat, fam, ant, resant, res, resseq, seq 
WHERE ant.ant_id = resant.ant 
  AND resant.res = res.res_id 
  AND res.res_id = resseq.res 
  AND resseq.seq = seq.seq_id 
  AND seq.bat = bat.bat_id 
  AND bat.fam = fam.fam_id 
  AND fam.nome_f = 'Enterobacteriaceae';

-- 8. Proteine mutate coinvolte nella resistenza alla Gentamicina e loro funzione
SELECT prot.nome_pr, funz.term AS funzione 
FROM prot, protfunz, funz, seq, resseq, res, resant, ant 
WHERE prot.prot_id = protfunz.prot 
  AND protfunz.funz = funz.funz_id 
  AND prot.seq = seq.seq_id 
  AND seq.seq_id = resseq.seq 
  AND resseq.res = res.res_id 
  AND res.res_id = resant.res 
  AND resant.ant = ant.ant_id 
  AND ant.nome_a = 'Gentamicina';

-- 9. Conteggio proteine per funzione molecolare/processo biologico (Gene Ontology)
SELECT COUNT(*) AS proteine, protfunz.funz AS GO_ID, funz.term AS funzione  
FROM protfunz, funz 
WHERE protfunz.funz = funz.funz_id 
  AND tipo_f IN ('BP','MF') 
GROUP BY protfunz.funz;

-- 10a. Proteine con stessi GO ID di “prot15” (Select nidificata)
SELECT DISTINCT prot.prot_id AS proteina, res.res_id, res.classe, azione 
FROM prot, protfunz, seq, resseq, res, classe, mec 
WHERE funz IN (SELECT funz FROM protfunz, prot WHERE prot.nome_pr = 'prot15' AND prot.prot_id = protfunz.prot) 
  AND prot.prot_id = protfunz.prot 
  AND prot.seq = seq.seq_id 
  AND seq.seq_id = resseq.seq 
  AND resseq.res = res.res_id 
  AND res.classe = classe.class_id 
  AND classe.mec = mec.mec_id 
  AND prot.nome_pr != 'prot15' 
ORDER BY res.classe;

-- 11. Proteine coinvolte nella regolazione dell’espressione genica
SELECT prot.prot_id 
FROM prot, protfunz, funz 
WHERE prot.prot_id = protfunz.prot 
  AND funz.funz_id = protfunz.funz 
  AND term = "Regolazione dell'espressione genica";

-- 12. Conteggio enzimi raggruppati per gruppo con totale (ROLLUP)
SELECT COALESCE(nome_gr, 'Totale') AS 'gruppo enzimatico', COUNT(*) AS enzimi 
FROM enzima, ec, gruppo 
WHERE enzima.ec = ec.ec_id 
  AND gruppo.group_id = ec.gruppo 
GROUP BY nome_gr WITH ROLLUP;

-- 13. Specie batteriche resistenti a più di 5 antibiotici
SELECT bat.nome_sp AS specie, COUNT(DISTINCT resant.ant) AS antibiotici 
FROM bat, seq, resseq, res, resant 
WHERE seq.bat = bat.bat_id 
  AND seq.seq_id = resseq.seq 
  AND resseq.res = res.res_id 
  AND res.res_id = resant.res 
GROUP BY bat.nome_sp 
HAVING antibiotici >= 5;

-- 14. Proteine tra 100 e 200 residui e organismo di appartenenza
SELECT prot.prot_id, prot.residui, prot.seq, bat.nome_sp 
FROM prot, seq, bat 
WHERE seq.seq_id = prot.seq 
  AND seq.bat = bat.bat_id 
  AND residui BETWEEN 100 AND 200;

-- 15. Dettagli enzimi, reazione catalizzata e antibiotico inibito
SELECT DISTINCT prot.prot_id AS enzima, gruppo.nome_gr AS gruppo, ec.reazione, ant.nome_a AS antibiotico 
FROM enzima, ec, gruppo, ant, res, resant, resseq, seq, prot 
WHERE enzima.ec = ec.ec_id 
  AND ec.gruppo = gruppo.group_id 
  AND enzima.prot = prot.prot_id 
  AND prot.seq = seq.seq_id 
  AND seq.seq_id = resseq.seq 
  AND resseq.res = res.res_id 
  AND res.res_id = resant.res 
  AND resant.ant = ant.ant_id;

-- 16. Antibiotici nello stesso pathway dell’Eritromicina (Alias)
SELECT x.nome_a 
FROM ant x, ant y, subclass a, subclass b, atc c, atc d, pathway 
WHERE x.subcl = a.sub_id 
  AND y.subcl = b.sub_id 
  AND a.atc_cl = c.atc_id 
  AND b.atc_cl = d.atc_id 
  AND c.path = pathway.path_id 
  AND d.path = pathway.path_id 
  AND y.nome_a = 'Eritromicina' 
  AND x.nome_a != 'Eritromicina';

-- 17. Mutazioni di resistenza per famiglia batterica (Ordine alfabetico)
SELECT COUNT(res) AS resistenze, fam.nome_f AS famiglie 
FROM fam, bat, seq, resseq 
WHERE resseq.seq = seq.seq_id 
  AND seq.bat = bat.bat_id 
  AND fam.fam_id = bat.fam 
GROUP BY famiglie 
ORDER BY famiglie;

-- 18. Peso molecolare medio degli antibiotici per classe
SELECT ROUND(AVG(mw)) AS "Peso molecolare (Da)", nome_atc AS "Classe di antibiotici" 
FROM ant, subclass, atc 
WHERE ant.subcl = subclass.sub_id 
  AND subclass.atc_cl = atc.atc_id 
GROUP BY nome_atc;

-- 19. Proteine coinvolte nella traduzione (ordinamento decrescente)
SELECT DISTINCT prot AS proteina 
FROM funz, protfunz 
WHERE protfunz.funz = funz.funz_id 
  AND term LIKE '%traduzione%' 
ORDER BY proteina DESC;

-- 20. Statistiche sequenze cromosomiche rispetto al totale
SELECT SUM(seq.tipo='Cromosoma') AS "chr_seqs", 
       ROUND(SUM(seq.tipo='Cromosoma') / COUNT(seq.seq_id)*100) AS "chr_seqs/tot_seqs %" 
FROM seq;

-- 21. Mutazione più frequente in genomi plasmidici completi
SELECT COUNT(mut.tipo) AS sequenze, mut.tipo 
FROM mut, res, resseq, seq 
WHERE res.mut = mut.tipo 
  AND resseq.res = res.res_id 
  AND resseq.seq = seq.seq_id 
  AND seq.tipo = 'Plasmide' 
  AND compl = 'Y' 
GROUP BY mut.tipo 
ORDER BY sequenze DESC 
LIMIT 1;

-- 22. Sequenze con multiresistenza vs Totale sequenze
SELECT COUNT(*) AS conteggio, "sequenze con più di una resistenza" AS categoria 
FROM (SELECT seq FROM resseq GROUP BY seq HAVING COUNT(res) > 1) AS z 
UNION 
SELECT COUNT(seq.seq_id), "sequenze totali" 
FROM seq;
