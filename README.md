# ResistanceBase
## Database per resistenze antibiotiche

**Autore:** Alice Romeo  
**Corso:** Basi di Dati e Conoscenza (Università di Roma Tor Vergata)  
**Anno Accademico:** 2018-2019

---

## 📌 Descrizione del Progetto
**ResistanceBase** è un database relazionale progettato per centralizzare e analizzare le informazioni relative alle resistenze antibiotiche nei batteri. Il sistema integra dati provenienti da diverse fonti scientifiche, collegando:
- **Organismi batterici** e le loro sequenze genomiche.
- **Proteine ed enzimi** coinvolti nei meccanismi di resistenza.
- **Mutazioni genetiche** specifiche.
- **Antibiotici** (classificati secondo il sistema ATC) e i relativi pathway biochimici.
- **Letteratura scientifica** (Articoli e riviste indicizzate con PMID).

Il database permette di rispondere a quesiti complessi, come identificare proteine mutate correlate alla resistenza di specifici antibiotici in determinate famiglie batteriche (es. *Enterobacteriaceae*).

## 📊 Modellazione dei dati

### Schema Entità-Relazione (E-R)
Il progetto segue un'analisi strutturata che include:
1. **Analisi dei Requisiti**: Definizione delle entità principali (Batteri, Sequenze, Proteine, Antibiotici, Articoli).
2. **Schema Logico**: Definizione delle relazioni e cardinalità.
3. **Schema Fisico**: Ottimizzazione per l'implementazione in SQL, inclusa la risoluzione delle gerarchie (es. specializzazione degli enzimi e delle mutazioni).

### Tecnologie utilizzate
- **DBMS**: MySQL
- **Linguaggio**: SQL 

## 📂 Struttura del repository
- `schema.sql`: Script per la creazione delle tabelle e dei vincoli di integrità (Primary Key, Foreign Key).
- `data.sql`: Script di popolamento con dati reali (sequenze NCBI, codici Gene Ontology, classificazione ATC).
- `queries.sql`: Raccolta di 22 query SQL che dimostrano le potenzialità del database (Join multiple, Subquery, Grouping, Rollup).
- `docs/`: Contiene la tesina completa `ResistanceBase.pdf` con i diagrammi E-R e le specifiche tecniche.

## 🚀 Come utilizzare il database

1. **Clona il repository**:
   ```bash
   git clone [https://github.com/aliceromeo/ResistanceBase.git](https://github.com/aliceromeo/ResistanceBase.git)

2. **Importa lo schema**:
   ```sql
   CREATE DATABASE resistance_base;
   USE resistance_base;
   SOURCE schema.sql;

3. **Carica i dati**:
   ```sql
   SOURCE data.sql;

4. **Testa le analisi**:
   ```sql
   SOURCE queries.sql;

