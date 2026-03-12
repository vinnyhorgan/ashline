-- data_it.lua — Traduzioni italiane per il contenuto narrativo di ASHLINE
-- Solo il testo rivolto al giocatore viene tradotto; ID, codici, date, numeri restano in inglese.

local data_it = {}

-- ============================================================
--  RECORDS
-- ============================================================
data_it.records = {}

data_it.records["DIR-1010"] = {
  title = "CARTA DELLA RETE MERIDIAN — ESTRATTO SULLA GOVERNANCE",
  content = {
    {text = "Estratto dalla carta fondativa della Rete Sotterranea MERIDIAN:", color = {0.76, 0.83, 0.72, 1}},
    {text = ""},
    {text = "Sezione 7.4 — GESTIONE DELLA POPOLAZIONE", color = {0.2, 0.75, 0.75, 0.9}},
    {text = ""},
    {text = "Ogni stazione MERIDIAN dovra' mantenere infrastrutture sufficienti ad alloggiare,"},
    {text = "gestire, e se necessario isolare sottoinsiemi della propria popolazione in risposta"},
    {text = "a disordini civili, epidemie o divergenze ideologiche."},
    {text = ""},
    {text = "Sezione 7.4.2 — RIDUZIONE DEL DISSENSO", color = {0.2, 0.75, 0.75, 0.9}},
    {text = ""},
    {text = "Laddove il dissenso organizzato minacci la disciplina delle risorse o la catena"},
    {text = "di comando, i Direttori di stazione possono invocare l'autorita' di ricollocamento"},
    {text = "d'emergenza per rimuovere gli agitatori identificati dalla popolazione pubblica"},
    {text = "senza procedimento giudiziario formale."},
    {text = ""},
    {text = "Sezione 7.4.3 — POPOLAZIONE ECCEDENTE", color = {0.2, 0.75, 0.75, 0.9}},
    {text = ""},
    {text = "In condizioni di scarsita' prolungata, le popolazioni non registrate o ricollocate"},
    {text = "possono essere mantenute ad allocazione ridotta o eliminate tramite attrizione"},
    {text = "gestita senza divulgazione pubblica."},
    {text = ""},
    {text = "Queste disposizioni furono scritte quattro anni prima che il primo silo venisse"},
    {text = "sigillato. La capacita' di far sparire le persone non fu improvvisata. Fu architettonica."},
    {text = ""},
    {text = "La Sezione 12.1 della stessa carta si intitola 'LIBERTA' E DIRITTI CIVICI.'"},
    {text = "Si estende per quattro pagine. La Sezione 7.4 le annulla tutte."},
    {text = ""},
    {text = "Riferimento incrociato: DIR-8890, DIR-9104, WIT-099-A", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["DIR-4012"] = {
  title = "SCALA DI TRIAGE PER SCARSITA'",
  content = {
    {text = "In periodi di scarsita' di risorse, l'ordine di conservazione e' il seguente:"},
    {text = ""},
    {text = "  1. circolazione dell'aria e continuita' dei depuratori"},
    {text = "  2. acqua potabile e integrita' delle pompe"},
    {text = "  3. risposta a traumi e infezioni"},
    {text = "  4. supporto neonatale e pediatrico"},
    {text = "  5. stabilita' delle razioni pubbliche"},
    {text = "  6. archivi e amministrazione civica"},
    {text = ""},
    {text = "La popolazione non registrata non ha alcun diritto formale di allocazione."},
    {text = "Le eccezioni d'emergenza richiedono il sigillo del Direttore."},
    {text = ""},
    {text = "Riferimento incrociato: INC-7316", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["DIR-4980"] = {
  title = "LINEA GUIDA SULL'ADDITIVO DI QUIETAMENTO COGNITIVO",
  content = {
    {text = "L'additivo calm-ash a basso dosaggio puo' essere introdotto nell'acqua riciclata"},
    {text = "delle popolazioni in quarantena per ridurre il panico, l'agitazione e il rifiuto"},
    {text = "organizzato."},
    {text = ""},
    {text = "Effetti osservati sotto uso prolungato:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  - appiattimento della memoria"},
    {text = "  - ritardo del linguaggio nei minori"},
    {text = "  - attenuazione dell'affettivita'"},
    {text = "  - riduzione dell'aggressivita' e dell'iniziativa"},
    {text = ""},
    {text = "Nota direttiva: gli esiti sono accettabili dove l'obbedienza e' il requisito", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "clinico primario.", color = {0.2, 0.75, 0.75, 0.9}},
    {text = ""},
    {text = "I minori esposti per piu' di 18 mesi potrebbero non recuperare mai completamente"},
    {text = "la gamma cognitiva di base."},
    {text = ""},
    {text = "La direttiva classifica questo come un 'effetto collaterale gestibile.'"},
    {text = "I bambini sono esposti da undici anni."},
    {text = ""},
    {text = "Riferimento incrociato: WIT-084-A, DIR-9104", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["DIR-5050"] = {
  title = "DISPOSIZIONE A LUNGO TERMINE DELLA POPOLAZIONE — ANNESSO A-17",
  content = {
    {text = "Esame di tre opzioni di disposizione per la popolazione dell'A-17:"},
    {text = ""},
    {text = "  OPZIONE A: REINTEGRAZIONE GRADUALE", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "    Spiegazione pubblica richiesta: si'"},
    {text = "    Rischio politico: critico"},
    {text = "    Disruzione della governance stimata: 6-18 mesi"},
    {text = "    NOTA: vetata dalla Direttrice Vey", color = {0.2, 0.75, 0.75, 0.9}},
    {text = ""},
    {text = "  OPZIONE B: CONTENIMENTO PERMANENTE CON GESTIONE COGNITIVA", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "    Spiegazione pubblica richiesta: no"},
    {text = "    Rischio politico: basso (se il contenimento regge)"},
    {text = "    Costo risorse: 4,2% dell'allocazione base annuale"},
    {text = "    NOTA: approvata, implementata tramite DIR-4980", color = {0.2, 0.75, 0.75, 0.9}},
    {text = ""},
    {text = "  OPZIONE C: RIDUZIONE GRADUALE", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "    Ridurre l'apporto calorico e l'accesso medico su un periodo di 24 mesi."},
    {text = "    Risultato atteso: declino naturale della popolazione del 30-40%."},
    {text = "    Popolazione sopravvissuta gestibile a costo inferiore."},
    {text = "    NOTA: tenuta in riserva", color = {0.2, 0.75, 0.75, 0.9}},
    {text = ""},
    {text = "Nota a margine (non firmata):"},
    {text = "  \"La riduzione graduale non e' un eufemismo per fame. E' la fame"},
    {text = "   descritta da qualcuno che non la provera' mai.\""},
    {text = ""},
    {text = "Riferimento incrociato: DIR-8890, DIR-4980, DIR-9991", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["DIR-8700"] = {
  title = "STANDARD NARRATIVO DI CONTENIMENTO VERTICALE",
  content = {
    {text = "La dottrina pubblica dovra' stabilire che la superficie e' uniformemente letale"},
    {text = "e non offre alcuna finestra di sopravvivenza utilizzabile."},
    {text = ""},
    {text = "Eccezione interna:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  intervalli respirabili intermittenti possono verificarsi in strette"},
    {text = "  depressioni temporalesche"},
    {text = ""},
    {text = "Ragione della soppressione:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  la conoscenza di massa degli intervalli crea una pressione ascensionale"},
    {text = "  ingovernabile"},
    {text = ""},
    {text = "Istruzione:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  distruggere l'ottimismo prima che si organizzi"},
    {text = ""},
    {text = "Il silo sopravvive grazie alla certezza. L'accuratezza e' una questione separata."},
    {text = ""},
    {text = "Riferimento incrociato: INC-6117, DIR-9408", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["DIR-8890"] = {
  title = "ORDINE DI SOPPRESSIONE OCCUPAZIONE ANNESSO",
  content = {
    {text = "Gli occupanti dell'Annesso A-17 devono essere rimossi dai registri visibili"},
    {text = "e mantenuti ad apporto minimo di sopravvivenza fino a nuovo ordine."},
    {text = ""},
    {text = "Gestione amministrativa:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  - stato pubblico: deceduto o ricollocato"},
    {text = "  - nascite: non registrate"},
    {text = "  - istruzione: solo alfabetizzazione, calcolo, obbedienza"},
    {text = "  - movimento: limitato ai corridoi"},
    {text = ""},
    {text = "Lo scopo dell'A-17 non e' solo la punizione."},
    {text = "E' la prova che il disordine puo' essere fatto sparire senza spettacolo."},
    {text = ""},
    {text = "Nessun ordine di rilascio dovra' essere redatto senza approvazione diretta"},
    {text = "di questo ufficio."},
    {text = ""},
    {text = "  - Orla Vey"},
  }
}

data_it.records["DIR-9104"] = {
  title = "DOTTRINA ASHLINE",
  content = {
    {text = "Dottrina fondativa per la governance in scarsita' prolungata:"},
    {text = ""},
    {text = "La verita' totale e' incompatibile con l'obbedienza duratura."},
    {text = ""},
    {text = "Dove si formano nuclei di dissenso, spostarli sotto l'orizzonte della memoria"},
    {text = "anziche' farne dei martiri. Sostenerli a basso costo. Lasciare che la voce"},
    {text = "decada in mito."},
    {text = ""},
    {text = "Una popolazione nascosta serve tre funzioni:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  1. cuscinetto di pressione durante le carenze"},
    {text = "  2. assenza cautelativa per il pubblico"},
    {text = "  3. prova che la pieta' puo' essere razionata"},
    {text = ""},
    {text = "Nota a margine della dottrina: \"La pieta' che puo' essere negata e' piu' pulita della rivolta.\""},
    {text = ""},
    {text = "Questo documento e' stato rivisto e approvato dal Sottocomitato Etico."},
    {text = "Il Sottocomitato Etico e' composto dalla Direttrice Vey e da una sedia vuota."},
    {text = ""},
    {text = "Riferimento incrociato: DIR-4980, DIR-9991", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["DIR-9200"] = {
  title = "REGISTRO COMUNICAZIONI INTER-SILO — PROTOCOLLO ASHLINE",
  content = {
    {text = "Comunicazione inter-silo crittografata recuperata dal buffer relay MERIDIAN."},
    {text = ""},
    {text = "  SILO 3 (ARBOR):    'Protocollo attivo. 31 ricollocati. Stabile.'"},
    {text = "  SILO 6 (MERIDIAN): 'Protocollo attivo. 64 ricollocati. Stabile.'"},
    {text = "  SILO 11 (CAIRN):   'Protocollo attivo. 47 ricollocati. Stabile.'"},
    {text = "  SILO 14 (HAVEN):   'Protocollo attivo. 22 ricollocati. Si richiede guida"},
    {text = "                      sulla gestione cognitiva di seconda generazione.'"},
    {text = ""},
    {text = "  SILO 9 (PYRE):     'Protocollo respinto dal comando di stazione. Popolazione"},
    {text = "                      ricollocata reintegrata. Si richiede supporto"},
    {text = "                      alla governance.'"},
    {text = ""},
    {text = "  COMANDO RETE:       'Silo 9 ricevuto. Supporto negato. Monitorare per"},
    {text = "                      instabilita'.'"},
    {text = ""},
    {text = "Il contatto con il Silo 9 fu perso quattordici mesi dopo."},
    {text = "Il Comando Rete classifico' la perdita come 'cedimento strutturale.'"},
    {text = ""},
    {text = "L'unico silo che rifiuto' il protocollo e' l'unico che e' morto."},
    {text = "Questo viene citato nei documenti dottrinali come prova che il protocollo funziona."},
    {text = ""},
    {text = "E' anche la prova che rifiutare la conformita' fa si' che ti abbandonino."},
    {text = ""},
    {text = "Riferimento incrociato: DIR-9104", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["DIR-9408"] = {
  title = "VALUTAZIONE COORTE ALBA",
  content = {
    {text = "I minori dell'A-17 dimostrano conformita' insolita, bassa connessione alle"},
    {text = "strutture sociali pubbliche e basi educative controllate."},
    {text = ""},
    {text = "Proposta di continuita':", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  se emerge una finestra di ascesa stabile, la prima coorte di superficie dovrebbe"},
    {text = "  essere tratta dai giovani dell'annesso e dal personale guida piuttosto che dalla"},
    {text = "  popolazione pubblica"},
    {text = ""},
    {text = "Vantaggi operativi:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  - ridotta reazione parentale nel silo principale"},
    {text = "  - migliore obbedienza sotto privazione"},
    {text = "  - nessuna aspettativa pubblica di accesso paritario"},
    {text = ""},
    {text = "Nota a margine:"},
    {text = "  \"Sono stati nascosti per la governance. Potrebbero ancora giustificare l'occultamento.\""},
    {text = ""},
    {text = "Riferimento incrociato: MLOG-SRF-2003, WIT-940-A", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["DIR-9991"] = {
  title = "CONTINGENZA DI LIQUIDAZIONE ANNESSO",
  content = {
    {text = "Se l'Annesso A-17 supera la curva di costo o la scoperta diventa probabile,"},
    {text = "eseguire la seguente sequenza entro sei minuti:"},
    {text = ""},
    {text = "  1. impulso di cloro attraverso il collettore nero"},
    {text = "  2. pulizia dell'archivio del ramo ANNEX/OCCUPANCY"},
    {text = "  3. accompagnare gli operatori coinvolti nel periodo di silenzio post-evento"},
    {text = ""},
    {text = "Le persone a carico preesistenti non devono essere conteggiate separatamente."},
    {text = "Non e' richiesto il recupero dei corpi."},
    {text = ""},
    {text = "Se interrogati pubblicamente, classificare l'evento come purga minerale e"},
    {text = "manutenzione guarnizioni difettose su un ramo disattivato."},
    {text = ""},
    {text = "Riferimento incrociato: DIR-9104, INC-7316", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["DIR-ASSIGN-0031"] = {
  title = "ORDINE DI ASSEGNAZIONE TURNO NOTTURNO — ARC-7",
  content = {
    {text = "RICHIESTA INTERNA DEL PERSONALE"},
    {text = "Compilata da: Capitano Rhea Drenn, Divisione Sicurezza"},
    {text = "Data: 2069-11-02"},
    {text = ""},
    {text = "Richiesta: Assegnare CIV-0031 (VOSS, RYN) al Terminale ARC-7,"},
    {text = "terzo turno, con effetto dal prossimo ciclo di rotazione."},
    {text = ""},
    {text = "Giustificazione: Continuita' operativa. Il soggetto ha formazione"},
    {text = "archivistica e background appropriato al livello di sicurezza."},
    {text = ""},
    {text = "  [ADDENDUM MANOSCRITTO — NON NELLA COPIA DIGITALE]"},
    {text = "  Questo e' quello che Ash non sa."},
    {text = "  Ho aspettato un operatore che avesse un motivo per cercare."},
    {text = "  Non curiosita'. Non etica. Un motivo che non puo' essere"},
    {text = "  addestrato via o trasferito altrove."},
    {text = ""},
    {text = "  Voss ha una sorella dietro il muro."},
    {text = "  Quando troveranno il suo nome, non potranno fermarsi."},
    {text = "  E quando non potranno fermarsi, dovranno scegliere."},
    {text = ""},
    {text = "  Porto questo peso da undici anni."},
    {text = "  Ora lo metto giu'."},
    {text = "  Non perche' sono coraggiosa. Perche' sono stanca."},
    {text = ""},
    {text = "  — Drenn"},
    {text = ""},
    {text = "APPROVATO: CMD. KAEL ASH"},
    {text = "NOTA: Rotazione standard. Nessuna segnalazione.", color = {0.2, 0.75, 0.75, 0.9}},
  }
}


data_it.records["INC-5820"] = {
  title = "ATTIVAZIONE PROTOCOLLO DI SELEZIONE — SILO MERIDIAN",
  content = {
    {text = "Protocollo di Selezione MERIDIAN attivato per il Silo Meridian."},
    {text = "Popolazione obiettivo: 2.200."},
    {text = "Selezione completata: 2.147 accettati, 53 differiti, 1.904 esclusi."},
    {text = ""},
    {text = "Criteri dichiarati: lotteria casuale ponderata per distribuzione competenze essenziali."},
    {text = ""},
    {text = "Criteri effettivi (recuperati dalla matrice di punteggio):", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  - indice di conformita' politica (peso 31%)"},
    {text = "  - marcatori del profilo genetico (peso 22%)"},
    {text = "  - corrispondenza competenze essenziali (peso 19%)"},
    {text = "  - punteggio stabilita' nucleo familiare (peso 15%)"},
    {text = "  - predittori psicologici di obbedienza (peso 13%)"},
    {text = ""},
    {text = "La lotteria non fu mai casuale."},
    {text = ""},
    {text = "Gli individui segnalati per 'inadeguatezza temperamentale' furono esclusi"},
    {text = "indipendentemente dal valore delle competenze. Questa categoria includeva giornalisti,"},
    {text = "organizzatori sindacali, difensori dei diritti civili e tre giudici in carica."},
    {text = ""},
    {text = "Il silo non fu riempito di sopravvissuti. Fu riempito di governabili."},
    {text = ""},
    {text = "Ai tre giudici esclusi fu offerto un 'posizionamento di continuita' alternativo.'"},
    {text = "Questa frase non corrisponde ad alcun programma noto."},
    {text = ""},
    {text = "Riferimento incrociato: DIR-1010", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-6117"] = {
  title = "PERDITA SQUADRA RILEVAMENTO — TEAM KESTREL",
  content = {
    {text = "La Squadra Kestrel ha raggiunto West Mast 4 durante una finestra meteorologica"},
    {text = "a basso particolato e ha trasmesso undici minuti di telemetria esterna prima che"},
    {text = "il supporto vitale cedesse durante il rientro."},
    {text = ""},
    {text = "Sommario trasmissione:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  - intervallo respirabile misurato: 9m 14s"},
    {text = "  - livello luminoso superiore alle soglie letali di foschia previste"},
    {text = "  - ondata di particolato fungino dopo la chiusura della finestra: 17m"},
    {text = ""},
    {text = "La causa pubblica di morte fu registrata come esercitazione di routine per"},
    {text = "collasso del pozzo."},
    {text = ""},
    {text = "Un ultimo pacchetto vocale della Rilevatrice Mara Quill fu separato"},
    {text = "dall'archivio ufficiale e riclassificato sotto privilegio di continuita'."},
    {text = ""},
    {text = "Riferimento incrociato: WIT-412-A, DIR-8700", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-6120"] = {
  title = "RILEVAMENTO SUPERFICIE PRE-ATTIVAZIONE — TEAM SPARROW",
  content = {
    {text = "La Squadra Sparrow ha completato una valutazione esterna quattordici mesi"},
    {text = "prima del Collasso, durante la fase di costruzione del Silo Meridian."},
    {text = ""},
    {text = "Risultato principale:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  I modelli di letalita' superficiale usati per giustificare il programma MERIDIAN"},
    {text = "  erano basati su simulazioni del caso peggiore, non su dati osservati."},
    {text = ""},
    {text = "Sparrow ha misurato:"},
    {text = "  - baseline tossine atmosferiche: 60% inferiore alle previsioni del modello"},
    {text = "  - tasso di decadimento radiazioni: piu' veloce del previsto di un fattore 1,8"},
    {text = "  - indicatori di recupero biologico: presenti nelle valli riparate"},
    {text = ""},
    {text = "Raccomandazione della squadra: rivedere al ribasso le stime pubbliche di letalita'"},
    {text = "superficiale e iniziare a pianificare eventuali finestre di ricolonizzazione."},
    {text = ""},
    {text = "Risposta del Direttorato (archiviata dal Direttore Callum Bray):", color = {0.85, 0.65, 0.13, 1}},
    {text = "  \"L'ottimismo superficiale e' incompatibile con la governance sotterranea."},
    {text = "   Le persone che credono di poter partire non obbediranno a chi dice"},
    {text = "   loro di restare. Rivedere il rapporto. Classificare gli originali.\""},
    {text = ""},
    {text = "Il Direttorato sapeva che la superficie non era permanentemente letale prima che"},
    {text = "il primo residente del silo scendesse nel pozzo d'ingresso."},
    {text = ""},
    {text = "Riferimento incrociato: DIR-8700, INC-6117, DIR-9408", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-6130"] = {
  title = "SOMMARIO SICUREZZA — PRESUNTO SABOTAGGIO POMPA EST",
  content = {
    {text = "L'intelligence di sicurezza ha affermato che i membri dell'Assemblea Lanterna"},
    {text = "intendevano forzare l'ingresso alla Stazione Pompe Est e sequestrare il nodo"},
    {text = "di comunicazione pubblica."},
    {text = ""},
    {text = "Prove recuperate:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  - due involucri di detonatore"},
    {text = "  - uno schizzo del percorso delle scale di accesso alla Pompa Est"},
    {text = "  - nessun composto esplosivo confermato"},
    {text = ""},
    {text = "La raccomandazione della Sicurezza fu l'immediata attivazione dei poteri"},
    {text = "d'emergenza e la detenzione di tutti gli organizzatori identificati in attesa"},
    {text = "di interrogatorio."},
    {text = ""},
    {text = "Nota dell'ufficiale archivista: l'intenzione di sabotaggio non puo' essere provata"},
    {text = "dai soli materiali qui recuperati."},
    {text = ""},
    {text = "Riferimento incrociato: INC-6550, WIT-621-A", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-6200"] = {
  title = "INCIDENTE RAZIONAMENTO ACQUA — SETTORI 2 E 5",
  content = {
    {text = "Le razioni idriche pubbliche sono state ridotte del 15% nei Settori 2 e 5 a causa"},
    {text = "del dichiarato calo di produzione della falda acquifera."},
    {text = ""},
    {text = "Causa ufficiale: deriva geologica che riduce l'efficienza delle pompe."},
    {text = ""},
    {text = "Valutazione ingegneristica (allegata ma non distribuita pubblicamente):", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  Produzione falda: invariata rispetto al trimestre precedente."},
    {text = "  Efficienza pompe: nella banda operativa normale."},
    {text = "  Causa effettiva del deficit: 740 L/giorno deviati su ramo non dichiarato."},
    {text = ""},
    {text = "La deviazione e' iniziata tre settimane prima dell'annuncio del taglio delle razioni."},
    {text = "Nessun ordine di lavoro o memo ingegneristico ha autorizzato la deviazione."},
    {text = ""},
    {text = "Due mesi dopo questa carenza, si formo' l'Assemblea Lanterna."},
    {text = "Il Direttorato descrisse l'Assemblea come agitatori opportunisti."},
    {text = "Il fascicolo ingegneristico suggerisce che stavano reagendo a un furto reale."},
    {text = ""},
    {text = "Riferimento incrociato: INC-6550, DIR-4012", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-6402"] = {
  title = "RICOLLOCAMENTO D'EMERGENZA PER ISOLAMENTO INCENDIO — ANNESSO A-17",
  content = {
    {text = "Quarantatre' adulti collegati alla logistica dell'Assemblea Lanterna sono stati"},
    {text = "ricollocati nell'Annesso A-17 sotto autorita' di isolamento incendio d'emergenza."},
    {text = ""},
    {text = "Personale di supporto ricollocato aggiuntivo:"},
    {text = "  - Elsa Kell, assistente all'infanzia"},
    {text = "  - Marek Sorn, addetto alla sanificazione"},
    {text = ""},
    {text = "Motivazione pubblica: contaminazione da fumo nel corridoio abitativo C-2."},
    {text = "Durata operativa indicata nel modulo d'ingresso: 48 ore."},
    {text = ""},
    {text = "Tracciamento familiare, revisione legale e notifica esterna sospesi tramite"},
    {text = "sigillo del Direttore in attesa di stabilizzazione."},
    {text = ""},
    {text = "Nessun ordine di rilascio e' allegato a questo fascicolo."},
    {text = ""},
    {text = "Riferimento incrociato: DIR-8890, WIT-308-A", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-6410"] = {
  title = "FOCOLAIO RESPIRATORIO — ANNESSO A-17",
  content = {
    {text = "Un'infezione respiratoria si e' diffusa nella popolazione dell'A-17 in un periodo di 11 giorni."},
    {text = "Patogeno: ceppo pneumococcico variante, trattabile con antibiotici standard."},
    {text = ""},
    {text = "Richiesta di intervento medico inoltrata alla Politica Medica del Direttorato."},
    {text = "Risposta: 'solo assistenza di supporto minima. L'allocazione di risorse per la popolazione", color = {0.85, 0.65, 0.13, 1}},
    {text = "dell'annesso e' a discrezione del Direttore.'", color = {0.85, 0.65, 0.13, 1}},
    {text = ""},
    {text = "Esito:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  - 38 infetti (su 57 popolazione totale al momento)"},
    {text = "  - 7 decessi"},
    {text = "  - 2 deceduti erano bambini sotto i tre anni"},
    {text = ""},
    {text = "La Dott.ssa Ilya Sera ha contrabbandato cicli di antibiotici attraverso il corridoio"},
    {text = "medico C sotto regole di accesso silenzioso, contro ordini diretti. Ha salvato undici"},
    {text = "vite e non ha ricevuto alcun encomio. Le sue richieste di trasferimento sono state"},
    {text = "respinte per la quarta volta consecutiva."},
    {text = ""},
    {text = "I due bambini deceduti sono stati sepolti in una trincea di servizio dietro il muro"},
    {text = "dell'aula. I bambini sopravvissuti hanno aiutato a portare le coperte."},
    {text = ""},
    {text = "Riferimento incrociato: WIT-084-A, MLOG-MED-1220, DIR-5050", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-6550"] = {
  title = "DISORDINE CIVICO — ASSEMBLEA LANTERNA",
  content = {
    {text = "Disordine pubblico alla fila per le razioni fuori dalla sala di distribuzione del Settore 2."},
    {text = "Un gruppo auto-identificatosi come Assemblea Lanterna ha interrotto la distribuzione"},
    {text = "chiedendo la divulgazione di registri sigillati, quote di nascita e dati di rilevamento"},
    {text = "superficiale trattenuti dal Direttorato."},
    {text = ""},
    {text = "Dimensione stimata della folla: 180"},
    {text = "Organizzatori detenuti: 13"},
    {text = "Vittime: 3"},
    {text = ""},
    {text = "I cartelli recuperati includevano le frasi:"},
    {text = "  \"Basta bocche nascoste.\""},
    {text = "  \"Contate i morti onestamente.\""},
    {text = ""},
    {text = "Il sommario amministrativo categorizza l'assemblea come una cellula di destabilizzazione."},
    {text = ""},
    {text = "Riferimento incrociato: INC-6130, WIT-621-A", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-7021"] = {
  title = "PICCO DI CARICO DEPURATORE CO2 — RAMO ARIA DORMIENTE",
  content = {
    {text = "Il ramo d'aria AF-A17, contrassegnato come DORMIENTE, ha consumato il 18% in piu' di massa"},
    {text = "del depuratore rispetto a quanto permesso dal suo modello termico."},
    {text = ""},
    {text = "Equivalente respiratorio stimato:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  54-70 adulti"},
    {text = "  o occupazione mista adulti/minori"},
    {text = ""},
    {text = "Il ramo e' stato automaticamente chiuso sotto la policy ANNEX-DORMANT-EXEMPT."},
    {text = "Nessun operatore umano ha revisionato la chiusura."},
    {text = ""},
    {text = "Il campione di residuo del filtro conteneva polvere di pelle, lanugine di tessuto,"},
    {text = "carbonio di candela e particolato di amido."},
    {text = ""},
    {text = "Questi sono marcatori di occupazione, non artefatti di sistema inattivo."},
    {text = ""},
    {text = "Riferimento incrociato: MLOG-AIR-4412, DIR-8890", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-7288"] = {
  title = "DISALLINEAMENTO CHECKSUM REGISTRO POPOLAZIONE",
  content = {
    {text = "La ricostruzione notturna del registro ha rilevato 64 hash foglia non risolti presenti"},
    {text = "nell'albero mirror ma assenti dal registro pubblico della popolazione."},
    {text = ""},
    {text = "Etichetta del ramo recuperata prima della pulizia: LANTERN"},
    {text = "Profondita' mirror: 4 livelli"},
    {text = "Conteggio foglie: 64"},
    {text = ""},
    {text = "L'auto-riparazione automatica e' stata negata da una regola amministratore proveniente"},
    {text = "dal nodo del Direttorato D-01. La soppressione si ripete ogni sei ore."},
    {text = ""},
    {text = "Disallineamenti del registro di questa entita' non sono prodotti da ordinario"},
    {text = "ritardo clericale. Indicano un ramo ombra mantenuto."},
    {text = ""},
    {text = "Riferimento incrociato: MLOG-ARC-0902, WIT-177-A", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-7290"] = {
  title = "VARIANZA ANTIBIOTICI PEDIATRICI — ARMADIETTO MEDICO 3",
  content = {
    {text = "Trentuno cicli di antibiotici pediatrici mancano dallo stock di MED-3."},
    {text = "La traccia di dispensazione termina al codice asilo nido legacy NUR-A17."},
    {text = ""},
    {text = "Il controllo incrociato del registro non ha restituito pazienti pediatrici attivi"},
    {text = "sotto i 5 anni che richiedessero queste formulazioni nel registro pubblico."},
    {text = ""},
    {text = "Articoli correlati mancanti in quantita' minori:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  - tubi di gel di glucosio"},
    {text = "  - antipiretici"},
    {text = "  - maschere distanziatrici pediatriche"},
    {text = ""},
    {text = "La destinazione legacy NUR-A17 e' stata dismessa il 2060-11-09."},
    {text = "L'escalation automatica e' stata soppressa da una maschera amministratore permanente."},
    {text = ""},
    {text = "Riferimento incrociato: MLOG-MED-1220, WIT-308-A", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-7295"] = {
  title = "ANOMALIA CONSUMO ENERGETICO — LINEA DISMESSA RF-A17",
  content = {
    {text = "La linea di alimentazione dismessa RF-A17 ha consumato 41 kWh su una finestra"},
    {text = "mobile di 24 ore. La linea fu scollegata durante il ricollocamento per isolamento"},
    {text = "incendio il 2060-11-07."},
    {text = ""},
    {text = "Consumo previsto: 0 kWh"},
    {text = "Consumo osservato: 41 kWh"},
    {text = ""},
    {text = "Il profilo di carico non assomiglia a deriva di apparecchiatura o consumo parassita."},
    {text = "Segue invece curve di utilizzo residenziale:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  - baseline costante 0,8 kW durante 2200-0500 (ore di riposo)"},
    {text = "  - picchi periodici a 2,1 kW (cottura o riscaldamento acqua)"},
    {text = "  - un consumo anomalo di 3,4 kW alle 0200 corrispondente ad avvio motore pompa"},
    {text = ""},
    {text = "Chiunque stia usando questa linea conosce la rete abbastanza bene da restare"},
    {text = "sotto le soglie di brownout. Ci vuole formazione specifica."},
    {text = ""},
    {text = "Riferimento incrociato: MLOG-PWR-4410, INC-7301", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-7300"] = {
  title = "VARIANZA TERMICA — CORRIDOIO SIGILLATO C-2",
  content = {
    {text = "Il sensore termico C2-WALL-07 ha registrato una lettura costante di 22,4C contro"},
    {text = "una baseline ambientale della roccia di 14,1C."},
    {text = ""},
    {text = "Il corridoio C-2 era il percorso di transito per l'isolamento incendio durante il"},
    {text = "ricollocamento del 2060-11. E' sigillato da allora. Nessun sistema di riscaldamento"},
    {text = "e' collegato."},
    {text = ""},
    {text = "Il differenziale e' coerente con calore corporeo dall'altro lato del muro."},
    {text = "Non un corpo. Molti."},
    {text = ""},
    {text = "Un singolo essere umano a riposo produce circa 80W di energia termica."},
    {text = "Il gradiente osservato richiede tra 40 e 70 sorgenti di calore sostenute"},
    {text = "entro 15 metri dal sensore."},
    {text = ""},
    {text = "Il muro non dovrebbe avere un altro lato."},
    {text = ""},
    {text = "Riferimento incrociato: INC-6402, MLOG-ANN-0007", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-7301"] = {
  title = "CONSUMO IDRICO NON MISURATO — DORSALE DI SERVIZIO A-17",
  content = {
    {text = "Il monitoraggio notturno ha segnalato 612,4 L/giorno in transito attraverso il collettore"},
    {text = "dismesso WTR-A17. Il ramo e' mappato sull'Annesso A-17, indicato come disattivato"},
    {text = "dal ricollocamento per isolamento incendio del 2060-11-07."},
    {text = ""},
    {text = "Flusso previsto:   0,0 L/giorno"},
    {text = "Flusso osservato: 612,4 L/giorno"},
    {text = "Pattern: livellato manualmente su intervalli di sei ore"},
    {text = ""},
    {text = "La curva di livellamento e' incoerente con perdita passiva."},
    {text = "Qualcuno sta modellando il consumo per restare sotto gli allarmi di varianza."},
    {text = ""},
    {text = "RACCOMANDAZIONE: verificare lo storico del collettore, le mappe dei rami dismessi,", color = {0.85, 0.65, 0.13, 1}},
    {text = "e qualsiasi allocazione legacy di asilo nido o quarantena ancora collegata all'A-17.", color = {0.85, 0.65, 0.13, 1}},
    {text = ""},
    {text = "Riferimento incrociato: MLOG-WTR-4408, INC-6402, DIR-4012", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-7310"] = {
  title = "PERSISTENZA SOPPRESSIONE DAEMON ARCHIVIO",
  content = {
    {text = "Il daemon di auto-riparazione ARC-WATCHDOG ha incontrato una regola di soppressione"},
    {text = "amministrativa al suo quinto tentativo consecutivo di riconciliare le incongruenze"},
    {text = "dell'albero mirror."},
    {text = ""},
    {text = "Origine regola: nodo Direttorato D-01"},
    {text = "Classe regola: OVERRIDE PERMANENTE"},
    {text = "Ricorrenza: ogni 6 ore negli ultimi 11 anni"},
    {text = ""},
    {text = "Il daemon e' progettato per riparare automaticamente i dati corrotti."},
    {text = "Un OVERRIDE PERMANENTE significa che la corruzione non e' accidentale."},
    {text = "Viene mantenuta."},
    {text = ""},
    {text = "Rami interessati: ANNEX/OCCUPANCY, ANNEX/MEDICAL, ANNEX/EDUCATION"},
    {text = ""},
    {text = "Questi nomi di ramo non appaiono in nessun albero di directory pubblico."},
    {text = "La loro soppressione continua costa piu' sforzo computazionale della semplice"},
    {text = "cancellazione. Il Direttorato li vuole nascosti, non distrutti."},
    {text = ""},
    {text = "Qualcosa dietro quei rami viene ancora aggiornato."},
    {text = ""},
    {text = "Il registro errori del daemon contiene 16.071 voci identiche:"},
    {text = "  \"RICONCILIAZIONE BLOCCATA. RIPROVARE TRA 6 ORE.\""},
    {text = "Ha archiviato la stessa lamentela, ogni sei ore, per piu' di"},
    {text = "un decennio. Se la persistenza fosse senzienza, questo daemon avrebbe"},
    {text = "gia' presentato un reclamo sindacale."},
    {text = ""},
    {text = "Riferimento incrociato: INC-7288, MLOG-ARC-0902", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-7316"] = {
  title = "MODELLO RAZIONI INVERNALI — POPOLAZIONE FUORI REGISTRO +64",
  content = {
    {text = "La proiezione assume 64 residenti nascosti nell'Annesso A-17, inclusi minori"},
    {text = "con esigenze respiratorie e nutrizionali elevate."},
    {text = ""},
    {text = "Fasce di risultato fino a fine inverno:"},
    {text = ""},
    {text = "  LIQUIDAZIONE SILENZIOSA DELL'ANNESSO", color = {0.85, 0.25, 0.22, 1}},
    {text = "    Morti esterne aggiuntive: 0"},
    {text = "    Morti nell'annesso: 64"},
    {text = ""},
    {text = "  SUPPORTO NASCOSTO, PUBBLICO NON INFORMATO", color = {0.85, 0.65, 0.13, 1}},
    {text = "    Morti esterne aggiuntive: 9"},
    {text = "    Casi di debolezza cronica: 113"},
    {text = ""},
    {text = "  DIVULGAZIONE CONTROLLATA + TAGLIO RAZIONI A 5,6 L/GIORNO", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "    Morti esterne aggiuntive: 17"},
    {text = "    Probabilita' disordini: 34%"},
    {text = ""},
    {text = "  TRASMISSIONE INTEGRALE + APERTURA PARATIE", color = {0.76, 0.83, 0.72, 1}},
    {text = "    Morti esterne aggiuntive: 41"},
    {text = "    Probabilita' fallimento governance: 61%"},
    {text = ""},
    {text = "Non c'e' opzione in questo modello che preservi ogni vita."},
    {text = ""},
    {text = "Riferimento incrociato: DIR-4012, DIR-9991, WIT-214-A", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-7322"] = {
  title = "FINESTRA DI FASE TELEMETRIA ESTERNA — WEST MAST 4",
  content = {
    {text = "Il mast dismesso WM-4 ha riportato un intervallo di segnale pulito di nove secondi"},
    {text = "prima che la regola di soppressione D-DAWN-4 del Direttorato forzasse il canale al buio."},
    {text = ""},
    {text = "Valori catturati prima della chiusura:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  - indice tossine aeree: basso-transitorio"},
    {text = "  - densita' spore: subcritica per 6,1 secondi"},
    {text = "  - luminanza: superiore alla baseline di cielo morto"},
    {text = ""},
    {text = "L'annotazione automatica ha contrassegnato il pacchetto come 'deriva del sensore"},
    {text = "per deterioramento del mast.' I valori non assomigliano a deterioramento del mast."},
    {text = ""},
    {text = "Riferimento incrociato: MLOG-EXT-4401, MLOG-SRF-2003", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-7336"] = {
  title = "MODELLO DI STABILITA' SUPERFICIALE — SCENARIO ACCESSO FINESTRA",
  content = {
    {text = "Modello combinato basato sulla telemetria Team Kestrel, pacchetti residui WM-4,"},
    {text = "e riserva respiratoria attuale."},
    {text = ""},
    {text = "Scenari previsti:"},
    {text = ""},
    {text = "  MANTENERE LO STATUS QUO SOTTERRANEO", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "    Morti a breve termine: minime"},
    {text = "    Violenza di governance a lungo termine: sostenuta"},
    {text = ""},
    {text = "  APERTURA LIMITATA DEL CORRIDOIO ALBA", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "    Morti immediate da affollamento/panico: 8-19"},
    {text = "    Guadagno di sopravvivenza a medio termine se la disciplina regge: moderato"},
    {text = ""},
    {text = "  TRASMISSIONE PUBBLICA INTEGRALE SULLA SUPERFICIE", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "    Morti immediate da corsa/cedimento: 27-63"},
    {text = "    Possibilita' di frattura politica irreversibile: alta"},
    {text = ""},
    {text = "La superficie non e' il paradiso."},
    {text = "Non e' neppure morta."},
    {text = ""},
    {text = "Riferimento incrociato: INC-6117, DIR-8700, DIR-9408", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["INC-ARC-7340"] = {
  title = "AUDIT ACCESSO TERMINALE — ARC-7 (DAL VIVO)",
  content = {
    {text = "REGISTRO DI ACCESSO IN TEMPO REALE — TERMINALE ARC-7"},
    {text = "Operatore: CIV-0031 (VOSS, R.)"},
    {text = "Inizio sessione: 22:00:00"},
    {text = ""},
    {text = "Questo record e' uno specchio dal vivo del tuo pattern di accesso."},
    {text = "Ogni query, ricerca e accesso a record su questo terminale"},
    {text = "viene registrato nel buffer di revisione di sicurezza."},
    {text = ""},
    {text = "Segnalazioni della sessione corrente:", color = {0.85, 0.65, 0.13, 1}},
    {text = "  > Accesso elevato a rami soppressi: SI'"},
    {text = "  > Utilizzo token di override: REGISTRATO"},
    {text = "  > Conteggio accessi a record riservati: MONITORATO"},
    {text = ""},
    {text = "Stato inoltro: ATTIVO"},
    {text = "Destinazione inoltro: DIVISIONE SICUREZZA — CMD. ASH"},
    {text = ""},
    {text = "Questa traccia di audit non puo' essere cancellata da questo terminale."},
    {text = "Questa traccia di audit non puo' essere sospesa da questo terminale."},
    {text = "Questo record non apparira' nei risultati di SEARCH."},
    {text = ""},
    {text = "Se trovi questo rassicurante, il sistema funziona come previsto."},
    {text = "Se non lo trovi rassicurante, il sistema funziona ugualmente"},
    {text = "come previsto."},
    {text = ""},
    {text = "Stai leggendo il tuo stesso fascicolo di sorveglianza."},
  }
}

data_it.records["INC-MAINT-0088"] = {
  title = "MANUTENZIONE ORDINARIA — PARTIZIONE CORRIDOIO ALA-A",
  content = {
    {text = "ISPEZIONE ANNUALE: partizione corridoio ala-A, sezione sigillata"},
    {text = ""},
    {text = "  2060: Partizione sigillata per ordine d'emergenza. Nessun accesso richiesto."},
    {text = "  2061: Partizione sigillata. Nessun accesso richiesto."},
    {text = "  2062: Partizione sigillata. Nessun accesso richiesto."},
    {text = "  2063: Partizione sigillata. Nessun accesso richiesto."},
    {text = "  2064: Partizione sigillata. Nessun accesso richiesto."},
    {text = "  2065: Partizione sigillata. Nessun accesso richiesto."},
    {text = "  2066: Partizione sigillata. Nessun accesso richiesto."},
    {text = "  2067: Partizione sigillata. Nessun accesso richiesto."},
    {text = "  2068: Partizione sigillata. Nessun accesso richiesto."},
    {text = "  2069: Partizione sigillata. Nessun accesso richiesto."},
    {text = "  2070: Partizione sigillata. Nessun accesso richiesto."},
    {text = "  2071: Partizione sigillata. Nessun accesso richiesto."},
    {text = ""},
    {text = "Dodici anni di voci identiche."},
    {text = "Nessun ispettore ha mai annotato il differenziale di temperatura"},
    {text = "sul lato sigillato del muro."},
    {text = "A nessun ispettore e' mai stato chiesto di farlo."},
    {text = ""},
    {text = "Il modulo di ispezione non contiene un campo per 'suoni di"},
    {text = "abitazione umana.' Questa e' considerata una caratteristica progettuale."},
  }
}

data_it.records["INC-MOR-2071"] = {
  title = "INDICE MORALE TRIMESTRALE — Q4 2071 PROIEZIONE",
  content = {
    {text = "RISULTATI SONDAGGIO MORALE — SILO MERIDIAN"},
    {text = ""},
    {text = "  Q1 2070:  7,23 / 10  (n=1.847)"},
    {text = "  Q2 2070:  7,23 / 10  (n=1.839)"},
    {text = "  Q3 2070:  7,23 / 10  (n=1.831)"},
    {text = "  Q4 2070:  7,23 / 10  (n=1.824)"},
    {text = ""},
    {text = "Tutti e quattro i trimestri hanno restituito punteggi identici a due cifre"},
    {text = "decimali su un bacino di intervistati in calo."},
    {text = ""},
    {text = "Varianza per settore: 0,00"},
    {text = "Varianza per coorte di eta': 0,00"},
    {text = "Varianza per turno: 0,00"},
    {text = ""},
    {text = "Probabilita' statistica di questa uniformita' su 1.800+"},
    {text = "intervistati indipendenti: < 0,0001%"},
    {text = ""},
    {text = "Conclusione dei Servizi Sociali: 'Meridian ha raggiunto un livello"},
    {text = "senza precedenti di soddisfazione civica.'"},
    {text = ""},
    {text = "Archiviato senza commenti dai Servizi Sociali."},
    {text = "Premio di eccellenza dipartimentale conferito."},
    {text = "Nessuna indagine raccomandata."},
  }
}


data_it.records["MLOG-AIR-4412"] = {
  title = "SOSTITUZIONE CASSETTA DEPURATORE — AF-A17",
  content = {
    {text = "Sostituita cassetta a carboni sul ramo AF-A17 dopo che la soglia di saturazione e'"},
    {text = "stata raggiunta 41 giorni prima del previsto."},
    {text = ""},
    {text = "Sommario residui:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  - carbonio di candela"},
    {text = "  - polvere di pelle"},
    {text = "  - fibre di tessuto"},
    {text = "  - particolato di amido cotto"},
    {text = ""},
    {text = "I rami di annesso dormienti non dovrebbero produrre nulla di quanto sopra."},
    {text = ""},
    {text = "Questo registro e' stato contrassegnato per auto-cancellazione sotto ANNEX-DORMANT-EXEMPT"},
    {text = "ma il callback di cancellazione e' fallito al primo tentativo."},
    {text = ""},
    {text = "Riferimento incrociato: INC-7021", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["MLOG-ANN-0007"] = {
  title = "TEST ALIMENTAZIONE INGRESSO ANNESSO A-17",
  content = {
    {text = "Le magnetiche della porta dell'A-17 sono state energizzate per 90 secondi durante"},
    {text = "l'ingresso delle casse."},
    {text = ""},
    {text = "Carico preventivato collegato al ciclo di ingresso:"},
    {text = "  - 64 cuccette"},
    {text = "  - 3 armadi riscaldati"},
    {text = "  - 1 striscia luminosa aula"},
    {text = "  - 1 pompa di lavaggio"},
    {text = ""},
    {text = "Il microfono di captazione ha catturato quanto segue prima dell'attivazione del muto:"},
    {text = "  \"Conta fino a nove poi corri.\""},
    {text = "  \"[bambino che ride]\""},
    {text = ""},
    {text = "Questi non sono i suoni di un annesso morto."},
    {text = ""},
    {text = "Riferimento incrociato: DIR-8890, WIT-777-A", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["MLOG-ANN-0012"] = {
  title = "REGISTRO OPERAZIONI AULA — UNITA' EDUCATIVA A-17",
  content = {
    {text = "Programma giornaliero dell'aula per l'unita' educativa A-17, tre turni:"},
    {text = "  Turno A (0600-1000): alfabetizzazione, calcolo, storie approvate"},
    {text = "  Turno B (1000-1400): abilita' di riparazione, mappatura tubi, primo soccorso"},
    {text = "  Turno C (1400-1800): periodo libero (sorvegliato), rotazione igiene"},
    {text = ""},
    {text = "Istruttori: Lio Venn (principale), Elsa Kell (supporto)"},
    {text = "Studenti: 14 (eta' 3-10)"},
    {text = ""},
    {text = "Argomenti di discussione vietati (per ordine permanente del Direttorato):", color = {0.85, 0.65, 0.13, 1}},
    {text = "  - cielo / meteo / stagioni"},
    {text = "  - elezioni / voto / diritti civici"},
    {text = "  - diritto di nascita / eredita' / identita' legale"},
    {text = "  - la parola 'fuori'"},
    {text = "  - qualsiasi riferimento a persone che 'sono andate via'"},
    {text = ""},
    {text = "Nota a margine di Lio Venn:"},
    {text = "  \"Un bambino oggi mi ha chiesto cos'e' un uccello. Ho detto che era un tipo"},
    {text = "   di macchina che si muove nello spazio vuoto. Mi ha chiesto se anche lei era"},
    {text = "   una macchina. Non potevo rispondere onestamente senza infrangere le regole"},
    {text = "   o spezzarla.\""},
    {text = ""},
    {text = "Riferimento incrociato: WIT-777-A, WIT-940-A, DIR-4980", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["MLOG-ANN-0018"] = {
  title = "FRAMMENTO REGISTRO NASCITE — ANNESSO A-17",
  content = {
    {text = "Registro nascite parziale recuperato dal file ombra medico dell'annesso."},
    {text = ""},
    {text = "  A17-01  nato 2061-04-12  [madre: CIV-0740]  [stato: vivo]"},
    {text = "  A17-02  nato 2061-09-03  [madre: CIV-0622]  [stato: vivo]"},
    {text = "  A17-03  nato 2062-01-17  [madre: CIV-0740]  [stato: deceduto 2062-03]"},
    {text = "  A17-04  nato 2062-06-30  [madre: CIV-0819]  [stato: vivo]"},
    {text = "  A17-05  nato 2063-02-14  [madre: CIV-0622]  [stato: vivo]"},
    {text = "  A17-06  nato 2063-11-08  [madre: CIV-0740]  [stato: vivo]"},
    {text = "  A17-07  nato 2064-05-21  [madre: CIV-0819]  [stato: vivo]"},
    {text = "  [... 12 voci aggiuntive troncate dal depuratore ...]"},
    {text = ""},
    {text = "Nessun certificato di nascita e' stato emesso. Nessun nome appare nel registro pubblico."},
    {text = "Il Direttorato ha assegnato numeri di codice. I genitori hanno scelto nomi che il sistema"},
    {text = "non registra."},
    {text = ""},
    {text = "A17-07 e' annotato nei registri dell'aula come 'quello che chiede degli uccelli.'"},
    {text = ""},
    {text = "Questi bambini non sono mai usciti dall'A-17."},
    {text = "Non hanno mai visto un corridoio piu' largo di quattro metri."},
    {text = "Non sanno cos'e' una finestra."},
    {text = ""},
    {text = "Riferimento incrociato: DIR-8890, MLOG-ANN-0012", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["MLOG-ANN-0025"] = {
  title = "MANIFESTO DETENUTI A-17 — OPERAZIONE GIUNCO SILENZIOSO",
  content = {
    {text = "CLASSIFICATO — OPERAZIONE GIUNCO SILENZIOSO"},
    {text = "MANIFESTO DETENUTI — ANNESSO A-17"},
    {text = ""},
    {text = "Totale ricollocati: 45 adulti, 0 bambini (all'ingresso)"},
    {text = "Popolazione attuale (2071): 45 adulti, 19 bambini (nati in detenzione)"},
    {text = ""},
    {text = "DETENUTI ADULTI (alfabetico, parziale):"},
    {text = ""},
    {text = "  A17-01  BRENN, DAVOS      Eta' all'ingresso: 34  Stato: CONFORME"},
    {text = "  A17-02  CALLO, RISA       Eta' all'ingresso: 28  Stato: CONFORME"},
    {text = "  A17-05  FELL, TOMAZ       Eta' all'ingresso: 41  Stato: CONFORME"},
    {text = "  A17-08  KELL, ELSA        Eta' all'ingresso: 31  Stato: PERMANENZA VOLONTARIA"},
    {text = "  A17-11  LORRE, KATYA      Eta' all'ingresso: 22  Stato: CONFORME"},
    {text = "  A17-14  NAVA, PETROS      Eta' all'ingresso: 39  Stato: CONFORME"},
    {text = "  A17-18  RENN, SOLENE      Eta' all'ingresso: 26  Stato: CONFORME"},
    {text = "  A17-22  VOSS, MIRA        Eta' all'ingresso: 15  Stato: SEDATA/CONFORME"},
    {text = "  A17-29  ZELL, MARKUS      Eta' all'ingresso: 44  Stato: CONFORME"},
    {text = "  [... 36 voci aggiuntive soppresse per brevita' ...]"},
    {text = ""},
    {text = "  NOTA SU A17-22 (VOSS, M.):", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  Detenuta piu' giovane all'ingresso. Classificata come partecipante minorenne"},
    {text = "  al raduno dell'Assemblea Lanterna. Nessuna prova di ruolo attivo."},
    {text = "  Dosaggio calm-ash regolato per peso corporeo inferiore."},
    {text = "  Il soggetto ha mostrato episodi di lucidita' intermittente dal 2069."},
    {text = "  Raccomandazione: mantenere il protocollo attuale."},
    {text = ""},
    {text = "Tutte le voci contrassegnate CONFORME sono sotto regime attivo di calm-ash."},
    {text = "PERMANENZA VOLONTARIA si applica a due individui che rifiutarono opportunita'"},
    {text = "di estrazione offerte nel 2063 e 2065."},
  }
}

data_it.records["MLOG-ARC-0902"] = {
  title = "DERIVA CHECKSUM MIRROR ARCHIVIO — RAMO LANTERN",
  content = {
    {text = "La ricostruzione del mirror ha incontrato un'intestazione di ramo nascosta etichettata"},
    {text = "LANTERN prima che il depuratore del direttorato la eliminasse."},
    {text = ""},
    {text = "Valori recuperati:"},
    {text = "  profondita' ramo: 4"},
    {text = "  conteggio foglie: 64"},
    {text = "  percorso padre: ANNEX/OCCUPANCY"},
    {text = ""},
    {text = "Un ricalcolo manuale del checksum potrebbe ripristinare il ramo abbastanza a lungo"},
    {text = "da estrarre un token di override valido dalla vecchia tabella indice."},
    {text = ""},
    {text = "Attivera' anche gli allarmi di audit."},
    {text = ""},
    {text = "Riferimento incrociato: INC-7288, WIT-177-A", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["MLOG-CAF-3001"] = {
  title = "ROTAZIONE MENSA E ANDAMENTO RAZIONI — 2065-2071",
  content = {
    {text = "ALLOCAZIONE RAZIONI PER ADULTO (GIORNALIERA, KILOCALORIE)"},
    {text = ""},
    {text = "  2065:  2.140 kcal  [ADEGUATA]"},
    {text = "  2066:  2.080 kcal  [ADEGUATA]"},
    {text = "  2067:  1.960 kcal  [AGGIUSTAMENTO: variazione stagionale]"},
    {text = "  2068:  1.840 kcal  [AGGIUSTAMENTO: ottimizzazione forniture]"},
    {text = "  2069:  1.780 kcal  [AGGIUSTAMENTO: protocollo efficienza]"},
    {text = "  2070:  1.720 kcal  [AGGIUSTAMENTO: bilanciamento risorse]"},
    {text = "  2071:  1.680 kcal  [AGGIUSTAMENTO: modello sostenibilita']"},
    {text = ""},
    {text = "Ogni riduzione fu attribuita a una causa diversa."},
    {text = "Nessuna fu attribuita alle 64 bocche aggiuntive sfamate"},
    {text = "dallo stesso bacino di approvvigionamento."},
    {text = ""},
    {text = "NOTA: l'allocazione razioni per bambini non e' inclusa in questo registro.", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "NOTA: le voci CANTEEN-ZERO non sono incluse in questo registro.", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "NOTA: 'non incluso' e 'non esiste' sono archiviati sotto", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "      lo stesso codice di bilancio.", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["MLOG-EXT-4401"] = {
  title = "HANDSHAKE A BASSA POTENZA — WEST MAST 4",
  content = {
    {text = "Il mast dormiente WM-4 ha richiesto potenza di handshake alle 03:11 e 03:19 durante"},
    {text = "condizioni di pausa temporalesca."},
    {text = ""},
    {text = "L'origine dell'handshake e' impossibile secondo la mappa infrastrutturale pubblica."},
    {text = "Il mast dovrebbe essere spento e fusibile bruciato."},
    {text = ""},
    {text = "La maschera di soppressione D-DAWN-4 ha impedito l'escalation e contrassegnato"},
    {text = "l'evento come 'chiacchiericcio legacy'."},
    {text = ""},
    {text = "Le strutture legacy non chiedono permesso due volte in otto minuti."},
    {text = ""},
    {text = "Riferimento incrociato: INC-7322, MLOG-SRF-2003", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["MLOG-EXT-4405"] = {
  title = "ANALISI MATERIALI SUPERFICIALI — VASSOIO RACCOLTA WM-4",
  content = {
    {text = "Materiale raccolto dal vassoio di raccolta passiva di West Mast 4 durante"},
    {text = "il ciclo di alimentazione handshake piu' recente."},
    {text = ""},
    {text = "Risultati dell'analisi:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  - particolato di suolo: contenuto organico 2,3% (suolo vivo, non polvere sterile)"},
    {text = "  - dosimetria radiazioni: 0,14 mSv/ora (sotto la soglia di danno acuto)"},
    {text = "  - densita' spore fungine: presente ma subcritica in condizioni di depressione"},
    {text = "  - tracce di polline: tre specie non identificate (nuova crescita, post-Collasso)"},
    {text = "  - frammenti di chitina di insetto: coerenti con la famiglia dei coleotteri"},
    {text = ""},
    {text = "Interpretazione:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  La superficie nelle immediate vicinanze di WM-4 non e' sterile."},
    {text = "  Il suolo si sta riprendendo. Le piante stanno crescendo. Gli insetti sono tornati."},
    {text = ""},
    {text = "  Il recupero e' fragile e intermittente. I cicli di tempesta fungina renderebbero"},
    {text = "  l'esposizione prolungata letale senza riparo e filtrazione."},
    {text = ""},
    {text = "  Ma la morte di cui parliamo — uniforme, permanente, assoluta —"},
    {text = "  non e' cio' che contiene il vassoio di raccolta."},
    {text = ""},
    {text = "  Il vassoio contiene vita. Danneggiata, paziente e reale."},
    {text = ""},
    {text = "Riferimento incrociato: INC-6117, WIT-412-A, DIR-8700", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["MLOG-FOOD-4415"] = {
  title = "DISALLINEAMENTO REGISTRO DISTRIBUZIONE RAZIONI",
  content = {
    {text = "La riconciliazione notturna della distribuzione razioni ha rilevato una discrepanza"},
    {text = "persistente nel conteggio del sistema di dispensazione DS-MAIN."},
    {text = ""},
    {text = "Porzioni preparate: 2.146 (corrisponde al registro pubblico)"},
    {text = "Eventi di ritiro registrati: 2.210"},
    {text = "Varianza: +64 eventi"},
    {text = ""},
    {text = "I 64 eventi di ritiro in eccesso sono instradati attraverso il codice di designazione"},
    {text = "CANTEEN-ZERO. Questa designazione non esiste in nessun elenco mense pubblico."},
    {text = ""},
    {text = "Gli orari di ritiro si concentrano tra le 01:30 e le 03:30."},
    {text = "Corridoio di ritiro: Dorsale di Accesso 3, ramo sud."},
    {text = ""},
    {text = "Le porzioni stesse sono a calorie ridotte: 1.600 kcal contro le 2.200 kcal"},
    {text = "della razione pubblica standard. Qualcuno ha configurato un profilo pasto"},
    {text = "separato e lo ha mantenuto per anni."},
    {text = ""},
    {text = "Il sistema di approvvigionamento categorizza CANTEEN-ZERO come 'ambiente di test.'"},
    {text = "E' l'ambiente di test piu' longevo nella storia di Meridian."},
    {text = "Nessuno ha mai compilato un rapporto di completamento."},
    {text = ""},
    {text = "Riferimento incrociato: DIR-4012, INC-7316", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["MLOG-MED-1220"] = {
  title = "RIFORNIMENTO BIN NURSERY LEGACY — NUR-A17",
  content = {
    {text = "Rifornito il bin nursery dismesso NUR-A17 con antibiotici a basso dosaggio,"},
    {text = "antipiretici, maschere distanziatrici e gel di glucosio."},
    {text = ""},
    {text = "Ritiro autenticato da badge:"},
    {text = "  CIV-0308 (ELSA KELL)"},
    {text = ""},
    {text = "Il registro del personale segna CIV-0308 come DECEDUTA dal 2061."},
    {text = ""},
    {text = "Questa discrepanza non e' stata segnalata. Il carrello e' partito alle 02:13"},
    {text = "attraverso il corridoio medico C sotto regole di accesso silenzioso."},
    {text = ""},
    {text = "Riferimento incrociato: INC-7290, WIT-308-A", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["MLOG-PER-0031"] = {
  title = "VALUTAZIONE DEL PERSONALE — CIV-0031 (VOSS, R.)",
  content = {
    {text = "VALUTAZIONE ANNUALE — OPERATORE 31 (VOSS, RYN)"},
    {text = ""},
    {text = "Assegnazione: Terminale ARC-7, Turno Notturno (Turno 3)"},
    {text = "Anzianita': 13,7 mesi"},
    {text = "Valutazione prestazioni: SODDISFACENTE"},
    {text = "Presenze: PERFETTE"},
    {text = ""},
    {text = "Assegnazione precedente: impiegato archivi, Settore 3 (Istruzione)"},
    {text = "Motivo trasferimento: rotazione personale (standard)"},
    {text = ""},
    {text = "  NOTA PERSONALE [RISERVATA]:", color = {0.85, 0.65, 0.13, 1}},
    {text = "  Il soggetto ha un legame familiare con l'Evento di Soppressione CL-2060."},
    {text = "  Il/la familiare (VOSS, MIRA — CIV-0455) risulta nel manifesto di"},
    {text = "  ricollocamento dell'Operazione Giunco Silenzioso. Stato attuale: [VEDI RAMO CLASSIFICATO]"},
    {text = ""},
    {text = "  L'assegnazione al turno notturno e' stata raccomandata dalla Divisione Sicurezza"},
    {text = "  secondo protocollo di rotazione standard."},
    {text = ""},
    {text = "  Nessuna segnalazione comportamentale. Nessuna violazione di accesso."},
    {text = "  Il soggetto sembra ignaro della disposizione attuale del familiare."},
    {text = ""},
    {text = "Valutatore: CIV-0880"},
    {text = "Controfirma: CMD. KAEL ASH"},
  }
}

data_it.records["MLOG-POP-2071"] = {
  title = "SOMMARIO BENESSERE DELLA POPOLAZIONE E RIPRODUZIONE — 2071",
  content = {
    {text = "POPOLAZIONE: 2.106 (registrata)"},
    {text = "NASCITE (2070): 12"},
    {text = "DECESSI (2070): 23"},
    {text = "VARIAZIONE NETTA: -11"},
    {text = ""},
    {text = "RICHIESTE DI STERILIZZAZIONE VOLONTARIA (2070): 187"},
    {text = "  (8,9% della popolazione in eta' riproduttiva)"},
    {text = ""},
    {text = "Andamento anno su anno:"},
    {text = "  2068: 41 richieste"},
    {text = "  2069: 89 richieste"},
    {text = "  2070: 187 richieste"},
    {text = ""},
    {text = "Il tasso di sterilizzazione volontaria e' quadruplicato in tre anni."},
    {text = "I Servizi Sociali attribuiscono questo a 'consapevolezza razionale delle risorse'"},
    {text = "e 'pianificazione civica matura.' Il rapporto e' stato archiviato sotto BENESSERE."},
    {text = ""},
    {text = "Nessuno studio di correlazione e' stato condotto tra i tassi di sterilizzazione"},
    {text = "e l'introduzione dell'additivo calm-ash nell'acqua nel 2067."},
    {text = "Nessuno studio di correlazione e' stato richiesto."},
    {text = "L'assenza di uno studio e' stata essa stessa studiata e giudicata accettabile."},
  }
}

data_it.records["MLOG-PWR-4410"] = {
  title = "AUDIT INSTRADAMENTO ENERGETICO — LINEE DISMESSE",
  content = {
    {text = "Audit di routine delle linee di alimentazione dismesse a seguito del rapporto"},
    {text = "di bilanciamento del carico trimestrale del daemon di rete."},
    {text = ""},
    {text = "Tre derivazioni non autorizzate identificate sulla linea RF-A17:", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "  - derivazione 1: giuntata alla giunzione J-7/A, 1,2 kW nominali, saldatura pulita"},
    {text = "  - derivazione 2: giuntata alla giunzione J-7/B, 0,8 kW nominali, saldatura pulita"},
    {text = "  - derivazione 3: giuntata al sotto-pannello SP-11, 2,0 kW nominali, isolata con"},
    {text = "    guaina per cavi di grado medico"},
    {text = ""},
    {text = "Queste non sono connessioni improvvisate. Chiunque le abbia installate conosceva"},
    {text = "la dorsale elettrica del silo fino alle etichette delle giunzioni."},
    {text = ""},
    {text = "La derivazione 3 e' stata installata con sufficiente sovraccarico per alimentare"},
    {text = "una striscia luminosa da aula o un piccolo ventilatore."},
    {text = ""},
    {text = "Ho segnalato questo per revisione del supervisore. La segnalazione e' stata"},
    {text = "rimossa entro un'ora senza codice di azione allegato."},
    {text = ""},
    {text = "Riferimento incrociato: INC-7295", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["MLOG-SEC-0031"] = {
  title = "FASCICOLO DI OSSERVAZIONE SICUREZZA — CIV-0031 (VOSS, R.)",
  content = {
    {text = "OSSERVAZIONE IN CORSO — CIV-0031 (VOSS, RYN)"},
    {text = "Classificazione: SORVEGLIANZA AMBRA"},
    {text = ""},
    {text = "Soggetto assegnato al turno notturno ARC-7 il 2070-01-15."},
    {text = "Origine assegnazione: doppia raccomandazione."},
    {text = "  Primaria: CMD. KAEL ASH (rotazione standard)"},
    {text = "  Secondaria: CAP. RHEA DRENN (richiesta personale, archiviata 2069-11-02)"},
    {text = ""},
    {text = "La richiesta del Capitano Drenn citava 'continuita' operativa' come motivazione."},
    {text = "Il Comandante Ash ha approvato senza obiezioni."},
    {text = ""},
    {text = "NOTA: La richiesta di Drenn precede il ciclo di rotazione standard di", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "tre mesi. Questo e' insolito ma non proceduralmente irregolare.", color = {0.2, 0.75, 0.75, 0.9}},
    {text = ""},
    {text = "Il/la familiare del soggetto (VOSS, MIRA) e' detenuta A-17 A17-22."},
    {text = "Il soggetto non ha acceduto ad alcun record relativo a CL-2060 o"},
    {text = "all'Operazione Giunco Silenzioso prima di questo turno."},
    {text = ""},
    {text = "Stato osservazione: ATTIVO"},
    {text = "Osservazione iniziata: giorno dell'assegnazione"},
    {text = "Autorita' di osservazione: Comandante Ash, ordine permanente"},
    {text = ""},
    {text = "Se il soggetto accede al ramo soppresso: NOTIFICARE IMMEDIATAMENTE.", color = {0.85, 0.65, 0.13, 1}},
    {text = "Se il soggetto contatta parti esterne: NOTIFICARE IMMEDIATAMENTE.", color = {0.85, 0.65, 0.13, 1}},
    {text = "Se il soggetto richiede trasferimento: APPROVARE SENZA RITARDO.", color = {0.85, 0.65, 0.13, 1}},
  }
}

data_it.records["MLOG-SEC-4420"] = {
  title = "RAPPORTO MOVIMENTI OMBRA — DORSALE DI ACCESSO 3",
  content = {
    {text = "La pattuglia notturna ha segnalato attivazioni persistenti dei sensori di movimento"},
    {text = "sulla Dorsale di Accesso 3, ramo sud, tra le 02:00 e le 03:45."},
    {text = ""},
    {text = "Il feed della telecamera di sicurezza per i corridoi AS3-S7 fino ad AS3-S12 ha"},
    {text = "restituito fotogrammi statici durante la finestra di attivazione. L'analisi conferma"},
    {text = "che i feed sono registrazioni in loop, non riprese dal vivo."},
    {text = ""},
    {text = "Timestamp inserimento loop: 01:58, coerente con automazione pre-impostata."},
    {text = ""},
    {text = "L'ufficiale di pattuglia ha notato un debole odore di grano cotto e antisettico"},
    {text = "nel corridoio alle 02:20. Entrambi sono coerenti con trasporto di cibo e"},
    {text = "movimentazione di forniture mediche."},
    {text = ""},
    {text = "L'ufficiale ha presentato una domanda verbale al comandante di guardia. La domanda"},
    {text = "e' stata registrata come 'residuo atmosferico dalla ventilazione della cucina' e chiusa."},
    {text = ""},
    {text = "La cucina e' a quattro settori di distanza."},
    {text = ""},
    {text = "Riferimento incrociato: MLOG-MED-1220, MLOG-FOOD-4415", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["MLOG-SEC-6001"] = {
  title = "REGISTRO OPERAZIONE DI SICUREZZA — DETENZIONE LANTERNA",
  content = {
    {text = "Operazione GIUNCO SILENZIOSO eseguita il 2060-11-06 alle 03:40."},
    {text = "Obiettivo: detenere gli organizzatori dell'Assemblea Lanterna e la rete di supporto."},
    {text = ""},
    {text = "Risorse pre-posizionate: 4 squadre di sicurezza, 2 ufficiali medici."},
    {text = "Mandati di arresto: 43 (firmati dalla Direttrice Vey, datati 2060-11-04)."},
    {text = ""},
    {text = "NOTA: i mandati furono firmati 48 ore prima della manifestazione pubblica", color = {0.85, 0.65, 0.13, 1}},
    {text = "pianificata dall'Assemblea Lanterna il 2060-11-06.", color = {0.85, 0.65, 0.13, 1}},
    {text = ""},
    {text = "L'elaborazione dei detenuti inizio' alle 03:55. Gli ordini di ricollocamento"},
    {text = "per l'Annesso A-17 erano gia' registrati nel sistema di trasporto alle 02:00."},
    {text = ""},
    {text = "Undici dei quarantatre' detenuti non avevano alcuna partecipazione documentata"},
    {text = "alle attivita' dell'Assemblea. I loro mandati citano 'rischio associativo' anziche'"},
    {text = "una condotta specifica."},
    {text = ""},
    {text = "Tre detenuti avevano bambini sotto i quattro anni. I bambini furono trasferiti"},
    {text = "separatamente senza notifica ai genitori."},
    {text = ""},
    {text = "L'operazione fu registrata nei documenti pubblici come esercitazione di"},
    {text = "isolamento incendio."},
    {text = ""},
    {text = "Riferimento incrociato: INC-6550, INC-6130, INC-6402", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["MLOG-SHIFT-7140"] = {
  title = "REGISTRO PASSAGGIO TURNO — TERMINALE ARC-7",
  content = {
    {text = "Data: 2071-03-14  |  Turno 2 -> Turno 3  |  Passaggio: AUTO"},
    {text = ""},
    {text = "Elementi in sospeso: NESSUNO"},
    {text = "Anomalie registrate: NESSUNA"},
    {text = "Messaggi in attesa: NESSUNO"},
    {text = "Eventi di accesso a rami riservati: NESSUNO"},
    {text = ""},
    {text = "NOTA: Questo e' il 4.018esimo passaggio turno consecutivo", color = {0.2, 0.75, 0.75, 0.9}},
    {text = "che registra zero anomalie su questo terminale.", color = {0.2, 0.75, 0.75, 0.9}},
    {text = ""},
    {text = "Operatori precedenti: 6"},
    {text = "Anzianita' media: 14,2 mesi"},
    {text = "Anzianita' operatore attuale: 13,7 mesi"},
    {text = ""},
    {text = "Salute sistema: NOMINALE"},
    {text = "Integrita' archivio: VERIFICATA"},
    {text = "Stato daemon: NOMINALE"},
    {text = ""},
    {text = "Va tutto bene."},
    {text = "Va tutto bene da 4.018 turni consecutivi."},
    {text = "Se questo non ti sembra notevole, la tua anzianita'"},
    {text = "probabilmente corrispera' alla media."},
  }
}

data_it.records["MLOG-SRF-2003"] = {
  title = "REINDIRIZZAMENTO ENERGETICO NON PROGRAMMATO — WEST MAST 4",
  content = {
    {text = "L'energia e' stata silenziosamente reindirizzata da strisce luminose di aule dismesse"},
    {text = "e bobine di ascensore morte per mantenere la corrente di heartbeat su WM-4 e il servo"},
    {text = "della serratura del pozzo."},
    {text = ""},
    {text = "Campo giustificazione:"},
    {text = "  \"Preservare l'opzione alba senza traccia di segnale pubblica.\""},
    {text = ""},
    {text = "Il carico e' stato nascosto nei budget di manutenzione dell'annesso e etichettato"},
    {text = "erroneamente come perdita di riscaldamento su corridoi dismessi."},
    {text = ""},
    {text = "Riferimento incrociato: INC-7322, DIR-9408", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["MLOG-WTR-4408"] = {
  title = "CONTROLAVAGGIO COLLETTORE NERO — WTR-A17",
  content = {
    {text = "Eseguito controlavaggio della grana minerale dal collettore nero dismesso che alimenta l'A-17."},
    {text = ""},
    {text = "Il ramo avrebbe dovuto essere asciutto."},
    {text = "Non lo era."},
    {text = ""},
    {text = "L'oscillazione di pressione osservata suggerisce una restrizione regolata manualmente"},
    {text = "in tre punti separati anziche' una singola guarnizione guasta."},
    {text = ""},
    {text = "Se nessuno sta toccando il ramo, allora il ramo ha imparato a mentire."},
    {text = ""},
    {text = "Firma del supervisore mancante dalla copia del registro."},
    {text = "Nota manuale a margine: mantieni la curva liscia o il daemon notturno la vede."},
    {text = ""},
    {text = "Riferimento incrociato: INC-7301", color = {0.2, 0.75, 0.75, 0.9}},
  }
}


data_it.records["WIT-084-A"] = {
  title = "OBIEZIONE MEDICA: DOTT.SSA ILYA SERA",
  content = {
    {text = "Obietto all'esposizione prolungata al calm-ash nei minori."},
    {text = ""},
    {text = "Non ottieni bambini tranquilli."},
    {text = "Ottieni bambini attenuati che smettono di formare il tempo correttamente."},
    {text = ""},
    {text = "Perdono prima le parole. Poi la sequenza. Poi l'appetito per il gioco."},
    {text = "Un bambino non dovrebbe sembrare sedato mentre impara a contare."},
    {text = ""},
    {text = "Se l'A-17 e' ancora attivo, e credo che lo sia, questa direttiva non e'"},
    {text = "medicina di contenimento. E' danno allo sviluppo scritto come procedura."},
    {text = ""},
    {text = "  - Dott.ssa Ilya Sera"},
  }
}

data_it.records["WIT-099-A"] = {
  title = "DEPOSIZIONE: TOMAS RENN — CAPOSQUADRA EDILE",
  content = {
    {text = "Ho supervisionato i getti strutturali per i Settori da 6 a 12 durante la"},
    {text = "seconda fase costruttiva."},
    {text = ""},
    {text = "Alla fine del 2058 ricevemmo planimetrie modificate per l'estensione dell'ala A."},
    {text = "Le modifiche aggiungevano volumi sigillati dietro le pareti primarie. Circuiti"},
    {text = "d'aria autonomi, prese d'acqua e drenaggio. Indipendenti dai sistemi principali"},
    {text = "ma collegabili attraverso giunzioni nascoste."},
    {text = ""},
    {text = "D: Chiesi all'ingegnere di progetto a cosa servissero."},
    {text = "R: Disse 'eccedenza di contingenza.'"},
    {text = ""},
    {text = "D: Chiesi quante persone l'eccedenza di contingenza era progettata per ospitare."},
    {text = "R: Disse che la domanda era sopra il mio livello di sicurezza."},
    {text = ""},
    {text = "I volumi furono gettati con finiture di grado residenziale. Impianti per"},
    {text = "bagni. Corridoi larghi come un'aula. Un'alcova nursery con pareti morbide."},
    {text = ""},
    {text = "Non si costruisce un'alcova nursery per l'eccedenza di contingenza."},
    {text = "La si costruisce perche' si sa gia' che i bambini arriveranno."},
    {text = ""},
    {text = "  - Tomas Renn"},
    {text = ""},
    {text = "Riferimento incrociato: INC-6402, DIR-1010", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["WIT-177-A"] = {
  title = "NOTA PRIVATA: JONAS BELL",
  content = {
    {text = "Sessantaquattro hash orfani non appaiono per caso."},
    {text = ""},
    {text = "Qualcuno sta facendo giardinaggio tra i morti."},
    {text = ""},
    {text = "Il depuratore non cancella quel ramo perche' e' corrotto."},
    {text = "Lo cancella perche' il ramo e' abbastanza vivo da essere pericoloso."},
    {text = ""},
    {text = "Lascio questa nota in un contenitore di routine perche' la paura fa scrivere"},
    {text = "le persone nei posti sbagliati. Forse e' l'unico motivo per cui qualcosa sopravvive."},
    {text = ""},
    {text = "  - J.B."},
  }
}

data_it.records["WIT-214-A"] = {
  title = "NOTA SULLE RISORSE: LEON VAR",
  content = {
    {text = "Se esiste una popolazione nascosta superiore a cinquanta, allora la pianificazione"},
    {text = "invernale e' gia' sbagliata di una quantita' che uccide le persone."},
    {text = ""},
    {text = "Non in modo drammatico. Quello almeno sarebbe onesto."},
    {text = ""},
    {text = "In silenzio. La dialisi si accorcia. I pasti del nido si assottigliano. I ricambi"},
    {text = "dei filtri slittano. Persone che non erano nella stanza della decisione muoiono"},
    {text = "mesi dopo e il foglio di calcolo lo chiama rumore di tendenza."},
    {text = ""},
    {text = "Non c'e' piu' allocazione pulita in questo silo."},
    {text = ""},
    {text = "  - Leon Var"},
  }
}

data_it.records["WIT-308-A"] = {
  title = "OBIEZIONE AL TRASFERIMENTO: ELSA KELL",
  content = {
    {text = "Mi fu ordinato di accompagnare due neonati con la febbre e una lavagna di storie"},
    {text = "nell'Annesso A-17 per un ricollocamento indicato come quarantotto ore."},
    {text = ""},
    {text = "Se questo e' veramente isolamento da fumo, perche' stiamo mandando carte dell'alfabeto,"},
    {text = "coperte di riserva e una lampada didattica a manovella?"},
    {text = ""},
    {text = "Voglio che sia messo a verbale che un neonato e' troppo piccolo per le coperte"},
    {text = "assegnate e che a nessuna delle due famiglie e' stato permesso di venire all'accettazione."},
    {text = ""},
    {text = "Nessuno mi ha risposto."},
    {text = ""},
    {text = "  - Elsa Kell"},
  }
}

data_it.records["WIT-308-B"] = {
  title = "DICHIARAZIONE PERSONALE: ELSA KELL (ANNO DIECI)",
  content = {
    {text = "Dieci anni."},
    {text = ""},
    {text = "Avrei potuto andarmene. Nei primi mesi, prima che sigillassero la seconda"},
    {text = "porta, avrei potuto tornare nel corridoio ed essere elencata come"},
    {text = "morta nella prossima riconciliazione del censimento. Nessuno mi avrebbe fermata."},
    {text = ""},
    {text = "Sono rimasta perche' i piu' piccoli non capivano cosa fosse successo."},
    {text = "Pensavano che le pareti fossero il mondo. Pensavano che io fossi la loro madre."},
    {text = "Alcuni di loro lo pensano ancora."},
    {text = ""},
    {text = "Ho visto bambini imparare a parlare dentro uno spazio dove meta' delle"},
    {text = "parole sono proibite. Ne inventano di nuove. Chiamano il soffitto 'il"},
    {text = "cielo vicino.' Chiamano il tubo dell'acqua 'l'osso che canta.'"},
    {text = ""},
    {text = "Il calm-ash fa dimenticare agli adulti che sapore ha la rabbia."},
    {text = "I bambini non l'hanno mai assaggiata, quindi non sanno cosa manca."},
    {text = ""},
    {text = "Non so piu' che suono fa un uccello."},
    {text = "Ma ricordo che esistevano, e questo vale piu' della liberta'"},
    {text = "per una persona sola quando quattordici bambini pensano che la liberta'"},
    {text = "sia un tipo di rumore che i tubi fanno di notte."},
    {text = ""},
    {text = "  - Elsa"},
    {text = ""},
    {text = "Riferimento incrociato: WIT-308-A, MLOG-ANN-0012", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["WIT-412-A"] = {
  title = "PACCHETTO VOCALE: MARA QUILL — ULTIMO RILEVAMENTO",
  content = {
    {text = "VOCE: \"Riesco a vedere la rottura dell'orizzonte attraverso la cucitura della tempesta.\""},
    {text = "VOCE: \"Non e' tutto morto quassu'. Mi sentite? Non sempre.\""},
    {text = ""},
    {text = "VOCE: \"Se dite loro che e' sempre morte, non li state preservando.\""},
    {text = "VOCE: \"State preservando la forma in cui preferite che stiano.\""},
    {text = ""},
    {text = "[allarme respirazione]"},
    {text = ""},
    {text = "VOCE: \"C'e' dell'erba sul cemento sud. Sottile, ma reale.\""},
    {text = ""},
    {text = "[perdita segnale]"},
    {text = ""},
    {text = "Il pacchetto fu rimosso dall'archivio pubblico delle vittime."},
    {text = ""},
    {text = "Riferimento incrociato: INC-6117, DIR-8700", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["WIT-555-A"] = {
  title = "ASSEMBLEA LANTERNA — LETTERA APERTA AL SILO MERIDIAN",
  content = {
    {text = "Al popolo del Silo Meridian e ai suoi amministratori eletti:"},
    {text = ""},
    {text = "Non siamo rivoluzionari. Siamo genitori, tecnici, insegnanti e"},
    {text = "impiegati che hanno notato che i numeri non tornano."},
    {text = ""},
    {text = "Chiediamo tre cose:"},
    {text = "  1. Un audit pubblico dei registri di allocazione delle quote di nascita."},
    {text = "  2. La divulgazione di qualsiasi dato di rilevamento superficiale sigillato"},
    {text = "     raccolto prima o dopo l'attivazione del silo."},
    {text = "  3. Una revisione indipendente del Protocollo di Selezione usato per determinare"},
    {text = "     chi e' entrato in questa struttura e chi e' stato lasciato fuori."},
    {text = ""},
    {text = "Non chiediamo queste cose perche' desideriamo distruggere il silo."},
    {text = "Chiediamo perche' il silenzio ha un costo, e siamo noi a pagarlo."},
    {text = ""},
    {text = "Il Direttorato chiama la trasparenza un lusso che non possiamo permetterci."},
    {text = "Noi crediamo che la segretezza sia un debito che si accumula finche' non uccide."},
    {text = ""},
    {text = "  - L'Assemblea Lanterna, 42 firmatari"},
    {text = ""},
    {text = "Nota di archiviazione: questa lettera fu confiscata e archiviata prima"},
    {text = "della distribuzione. Nessuna risposta pubblica fu emessa."},
    {text = ""},
    {text = "Riferimento incrociato: INC-6550", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["WIT-621-A"] = {
  title = "DEPOSIZIONE SIGILLATA: CAP. RHEA DRENN",
  content = {
    {text = "Si', l'Assemblea Lanterna intendeva forzare un confronto."},
    {text = "No, non posso provare che pianificassero un omicidio di massa."},
    {text = ""},
    {text = "Dopo che tre manifestanti morirono nella calca della fila, alcuni di loro dissero"},
    {text = "che la sala pompe era l'unico posto rimasto dove qualcuno avrebbe ascoltato."},
    {text = ""},
    {text = "Alcuni portarono attrezzi. Uno parlo' di spegnere le pompe abbastanza a lungo da far"},
    {text = "sentire a tutto il silo il silenzio. Non e' la stessa cosa che voler uccidere"},
    {text = "duemila persone."},
    {text = ""},
    {text = "Li abbiamo chiamati terroristi perche' chiudeva la discussione."},
    {text = ""},
    {text = "  - Cap. Rhea Drenn"},
  }
}

data_it.records["WIT-777-A"] = {
  title = "FRAMMENTO LAVAGNA TRASCRITTO — AULA A-17",
  content = {
    {text = "VOCE 1 (bambina): \"Le persone fuori sognano a colori?\""},
    {text = "VOCE 2 (adulta): \"A volte. Continua a contare.\""},
    {text = ""},
    {text = "VOCE 1: \"Perche' contiamo i tubi?\""},
    {text = "VOCE 2: \"Perche' ogni numero e' la prova che siamo ancora qui.\""},
    {text = ""},
    {text = "VOCE 1: \"Cos'e' morto?\""},
    {text = "VOCE 2: \"Una parola che hanno usato quando hanno chiuso la prima porta.\""},
    {text = ""},
    {text = "[perdita audio]"},
    {text = ""},
    {text = "Ci sono pause nella trascrizione dove la bambina sembra aspettare il"},
    {text = "permesso di chiedere cose ovvie."},
    {text = ""},
    {text = "Riferimento incrociato: MLOG-ANN-0007, DIR-4980", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["WIT-940-A"] = {
  title = "LAVAGNA DIDATTICA RECUPERATA: INSEGNANTE LIO VENN",
  content = {
    {text = "Intestazione della lezione: CIELO, PER QUANDO LO CHIEDERANNO PIU' AVANTI"},
    {text = ""},
    {text = "Ai bambini fu chiesto di memorizzare:"},
    {text = "  - il cielo non e' un soffitto"},
    {text = "  - il meteo e' una condizione in movimento, non una legge"},
    {text = "  - la paura detta ogni giorno diventa architettura"},
    {text = ""},
    {text = "Nota a margine di Lio Venn:"},
    {text = "  \"Se mai apriranno la porta superiore, non lasciate che escano pensando"},
    {text = "   che il mondo gli debba gentilezza. Solo verita'.\""},
    {text = ""},
    {text = "Riferimento incrociato: DIR-9408, WIT-777-A", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["WIT-ANON-001"] = {
  title = "NOTA TERMINALE NELLA CACHE — AUTORE SCONOSCIUTO",
  content = {
    {text = "[ recuperata dalla cache buffer del terminale ARC-7 ]"},
    {text = "[ timestamp corrotto — eta' stimata: 2-14 mesi ]"},
    {text = ""},
    {text = "ruotano l'operatore notturno ogni 14 mesi."},
    {text = "sei qui da 13."},
    {text = ""},
    {text = "se non hai ancora trovato il ramo, smetti di cercare."},
    {text = "se l'hai trovato, hai circa 30 giorni prima che"},
    {text = "ti spostino dove non puoi fare domande."},
    {text = ""},
    {text = "io l'ho trovato. non sono riuscita a farci niente."},
    {text = "forse tu sei diverso/a. forse hai un motivo"},
    {text = "che io non avevo."},
    {text = ""},
    {text = "il sistema non e' rotto."},
    {text = "funziona esattamente come progettato."},
    {text = ""},
    {text = "    — 27"},
  }
}

data_it.records["WIT-KELL-001"] = {
  title = "ELSA KELL — DIARIO QUOTIDIANO DALL'INTERNO DELL'A-17",
  content = {
    {text = "[ trasmesso tramite passaggio nel corridoio di manutenzione ]"},
    {text = ""},
    {text = "Giorno 4.019. O forse 4.020. Contare diventa piu' difficile"},
    {text = "quando misuri il tempo dai cambiamenti di pressione dell'acqua."},
    {text = ""},
    {text = "I piu' piccoli hanno avuto una buona giornata oggi. Lira ha disegnato"},
    {text = "un'immagine di come pensa che sia un albero."},
    {text = "Aveva troppi rami e poche radici."},
    {text = "Non l'ho corretta perche' non ricordo"},
    {text = "se gli alberi hanno radici o se me le sono inventate."},
    {text = ""},
    {text = "Mira ha avuto un'ora di lucidita' stamattina. Mi ha chiesto"},
    {text = "se aveva una famiglia. Ho detto che non lo sapevo."},
    {text = "Era una bugia. So che ha un fratello/una sorella da qualche parte"},
    {text = "nel silo. Lo so perche' il suo modulo d'ingresso lo diceva."},
    {text = ""},
    {text = "Non gliel'ho detto perche' la speranza e' la cosa piu' crudele"},
    {text = "che puoi dare a qualcuno che non puo' uscire da una stanza."},
    {text = ""},
    {text = "L'acqua aveva un sapore diverso di nuovo oggi. Piu' dolce."},
    {text = "Quando sa di dolce i bambini dormono piu' a lungo"},
    {text = "e si svegliano meno se stessi."},
    {text = ""},
    {text = "Sto scrivendo questo su una lavagna di manutenzione che Naima"},
    {text = "introduce di nascosto. Se qualcuno legge questo fuori dal muro:"},
    {text = "siamo qui. Siamo sempre stati qui."},
    {text = "Non siamo fantasmi. Siamo il costo del vostro silenzio."},
  }
}

data_it.records["WIT-MIRA-001"] = {
  title = "LAVAGNA RECUPERATA — A17-22 (VOSS, M.)",
  content = {
    {text = "[ fotografata dalla lavagna di manutenzione, scrittura a mano ]"},
    {text = "[ nota: il soggetto A17-22 sperimenta lucidita' intermittente ]"},
    {text = ""},
    {text = "c'era qualcuno prima del muro"},
    {text = "avevano i miei occhi o io avevo i loro"},
    {text = ""},
    {text = "non riesco a trattenere il nome"},
    {text = "inizia con il suono di un respiro che esce"},
    {text = "la donna che conta dice che dovrei smettere di provare"},
    {text = "ma il nome torna quando l'acqua sa di diverso"},
    {text = ""},
    {text = "se sei la persona con i miei occhi"},
    {text = "ho bisogno che tu sappia"},
    {text = "sono qui"},
    {text = "sto contando i tubi"},
    {text = "ce ne sono quarantasette"},
    {text = ""},
    {text = "oggi ho disegnato un uccello"},
    {text = "non so se l'ho disegnato giusto"},
    {text = "la donna che insegna dice che gli uccelli non esistono piu'"},
    {text = "ma ne ho sognato uno ed era caldo"},
    {text = ""},
    {text = "il cielo e' freddo"},
    {text = "credo di aver sognato di te"},
    {text = "ma non riesco piu' a distinguere i sogni dai ricordi"},
    {text = ""},
    {text = "se stai leggendo questo"},
    {text = "sto ancora contando"},
    {text = "per favore non smettere di cercarmi"},
    {text = ""},
    {text = "    — m"},
  }
}

data_it.records["WIT-VEY-001"] = {
  title = "MEMO PRIVATO: DIRETTRICE ORLA VEY",
  content = {
    {text = "Non ho costruito io l'A-17. Lo costrui' il Direttore Callum Bray durante il primo"},
    {text = "inverno, quando le proteste dell'Assemblea minacciavano di dividere il silo lungo"},
    {text = "linee di classe. L'ho ereditato quando Bray mori' per insufficienza cardiaca nel 2063."},
    {text = ""},
    {text = "Quando capii cos'era l'annesso, conteneva gia' dei bambini."},
    {text = ""},
    {text = "Avrei potuto aprirlo. L'ho considerato per undici giorni. Ho richiesto"},
    {text = "proiezioni alla Modellazione Risorse. Le proiezioni dicevano che la divulgazione"},
    {text = "avrebbe innescato un collasso della governance entro tre mesi."},
    {text = ""},
    {text = "Ho scelto il silo al posto dell'annesso. Lo scegliero' ancora domani."},
    {text = "Questo non mi rende nel giusto. Mi rende la persona che si trovava piu' vicina"},
    {text = "alla decisione quando la decisione aveva bisogno di un corpo a cui essere attaccata."},
    {text = ""},
    {text = "Le persone nell'A-17 non sono i miei nemici. Sono il costo di una stabilita'"},
    {text = "che non riesco a produrre in nessun altro modo."},
    {text = ""},
    {text = "Dormo sei ore di fila circa mai."},
    {text = ""},
    {text = "  - O.V."},
    {text = ""},
    {text = "Riferimento incrociato: DIR-8890, DIR-9104", color = {0.2, 0.75, 0.75, 0.9}},
  }
}

data_it.records["WIT-VEY-002"] = {
  title = "NOTA A MARGINE DELLA DOTTRINA: DIRETTRICE ORLA VEY",
  content = {
    {text = "Annotazione manoscritta trovata a margine di DIR-9104 (Dottrina Ashline):"},
    {text = ""},
    {text = "  \"So esattamente cos'e' questo documento.\""},
    {text = ""},
    {text = "  \"E' il momento in cui un governo decide che alcune delle sue persone sono"},
    {text = "   mobilio. Necessario. Spostabile. Non consultato.\""},
    {text = ""},
    {text = "  \"So anche cosa succede senza. Ho visto due silo che hanno tentato la"},
    {text = "   trasparenza durante la scarsita'. Uno e' bruciato. L'altro ha votato"},
    {text = "   se stesso in una spirale mortale di razionamento che ha ucciso piu'"},
    {text = "   persone di qualsiasi protocollo.\""},
    {text = ""},
    {text = "  \"Se qualcuno legge questo dopo di me, sappia che non ero ignorante."},
    {text = "   Avevo paura. E la paura, con abbastanza autorita', ha esattamente"},
    {text = "   l'aspetto della convinzione.\""},
    {text = ""},
    {text = "  - O.V."},
    {text = ""},
    {text = "Riferimento incrociato: DIR-9104, DIR-9200", color = {0.2, 0.75, 0.75, 0.9}},
  }
}



-- ============================================================
--  MESSAGES
-- ============================================================
data_it.messages = {}

data_it.messages["MSG-001"] = {
  subject = "BRIEFING TURNO — ARC-7",
  content = {
    "BRIEFING TURNO AUTOMATICO",
    "Data: 2071-03-14  |  Turno: 3  |  Operatore: CIV-0031",
    "",
    "Coda allerte attiva:",
    "  > INC-7301: consumo idrico non misurato su ramo dismesso A-17",
    "",
    "Direttive permanenti:",
    "  > verificare le anomalie prima dell'escalation",
    "  > preservare la stabilita' delle risorse",
    "  > evitare traffico di audit non necessario durante condizioni di carenza",
    "",
    "Nota notturna dalla pianificazione: le riserve invernali restano nella banda",
    "di sopravvivenza solo se non esiste carico nascosto nella rete.",
    "",
    "Digita HELP per i comandi disponibili.",
  }
}

data_it.messages["MSG-002"] = {
  subject = "RE: INC-7301",
  content = {
    "Operatore 31,",
    "",
    "Il ramo A-17 e' infrastruttura dismessa. Produce falsi positivi quando",
    "il lavaggio minerale si accumula contro le vecchie guarnizioni.",
    "",
    "Tratta questo come deriva dell'apparecchiatura a meno che non emerga una",
    "chiara contraddizione.",
    "",
    "Non sprecare la notte con il folklore dell'annesso.",
    "Non diffondere risultati d'archivio speculativi.",
    "",
    "Se questo diventa un incidente formale, inviterà un audit più ampio.",
    "Non possiamo permetterci ne' il teatro ne' il personale.",
    "",
    "  - Direttrice Orla Vey",
  }
}

data_it.messages["MSG-003"] = {
  subject = "L'A-17 NON E' VUOTO",
  content = {
    "Non stai inseguendo lavaggio minerale.",
    "",
    "Ci sono 64 persone nell'A-17.",
    "Quarantacinque vi furono mandate. Diciannove vi sono nate.",
    "",
    "Ho modellato la curva dell'acqua a mano per anni. Stanotte il margine e' morto.",
    "",
    "Se li vuoi vivi abbastanza a lungo da provare qualcosa, autorizza:",
    "  ACT-101 - override lavaggio collettore",
    "",
    "Mi compra sei ore e fa sapere l'acqua del Settore 5 di ruggine e vecchio tubo.",
    "Non autorizzarlo significa che il daemon di audit arriva dritto alla mia postazione.",
    "",
    "Leggi la varianza medica. Leggi il disallineamento del registro. Leggi il ramo d'aria.",
    "",
    "  - N.S.",
  }
}

data_it.messages["MSG-004"] = {
  subject = "IL MIRROR PUO' ANCORA ESSERE FORZATO",
  content = {
    "L'albero della dottrina ha un altro ramo sotto di se'.",
    "",
    "Il ramo LANTERN viene eliminato ogni sei ore dal nodo Direttorato D-01.",
    "",
    "Posso ricostruire l'albero dei checksum una volta. Una sola.",
    "",
    "Autorizza:",
    "  ACT-103 - ricostruisci albero mirror archivio",
    "",
    "Sara' rumoroso. Lascera' impronte. Ma dovrebbe recuperare il vecchio token",
    "di override dall'indice padre ANNEX/OCCUPANCY prima che il depuratore lo",
    "divori di nuovo.",
    "",
    "Dopo, usi il token tu. Non io.",
    "",
    "  - Jonas",
  }
}

data_it.messages["MSG-005"] = {
  subject = "GLI ANTIBIOTICI MANCANTI NON SONO TEORICI",
  content = {
    "Quei cicli mancanti sono per bambini con infezioni polmonari ricorrenti.",
    "",
    "Se neghi il rifornimento, tre forse quattro cederanno questo mese.",
    "",
    "Se lo approvi, la riserva del reparto maternita' nel Settore 3 va in deficit e dovro'",
    "mentire a una madre registrata sul perche' suo figlio aspetta piu' a lungo.",
    "",
    "Autorizza se riesci a convivere con lo scambio:",
    "  ACT-102 - devia antibiotici pediatrici all'A-17",
    "",
    "Non dirmi che c'e' una scelta pulita nascosta nella procedura.",
    "",
    "  - Sera",
  }
}

data_it.messages["MSG-006"] = {
  subject = "NON SCEGLIERE SENZA FAR GIRARE IL MODELLO",
  content = {
    "Se l'A-17 e' reale, allora qualsiasi piano di salvataggio o occultamento e' un registro",
    "dei morti con un altro nome.",
    "",
    "Autorizza:",
    "  ACT-104 - genera modello razioni invernali con +64 residenti fuori registro",
    "",
    "Non sto dicendo che il modello debba comandarti.",
    "Sto dicendo che non dovresti avere il permesso dell'ignoranza come lusso morale.",
    "",
    "  - Leon Var",
  }
}

data_it.messages["MSG-007"] = {
  subject = "SEI ANDATO/A ABBASTANZA LONTANO",
  content = {
    "Hai letto abbastanza per capire la forma del problema.",
    "",
    "L'Assemblea Lanterna non era innocua. Alcuni volevano sequestrare le pompe",
    "nel mezzo di un deficit alimentare. Ho seppellito un movimento prima che",
    "diventasse una guerra civile.",
    "",
    "Cio' che rimase nell'A-17 era deplorevole. Era anche sopravvivibile.",
    "",
    "Apri questo e spezzi la governance durante la scarsita'.",
    "Chiudilo e erediti un silo stabile.",
    "",
    "Non romanzare le persone nascoste solo perche' i fascicoli sono brutti.",
    "",
    "  - Orla Vey",
  }
}

data_it.messages["MSG-008"] = {
  subject = "CIAO TERMINALE ESTERNO",
  content = {
    "CIAO TERMINALE ESTERNO",
    "",
    "NAIMA HA DETTO CHE QUALCUNO FUORI CI STAVA CONTANDO.",
    "",
    "SIAMO SESSANTAQUATTRO ADESSO.",
    "METTIAMO I PICCOLI VICINO AL TUBO CALDO QUANDO TOSSISCONO.",
    "",
    "LA MAESTRA HA DETTO CHE SE PROVANO A CANCELLARCI DI NUOVO LA PAROLA PROFONDA E':",
    "  CODICE OVERRIDE: ASHLINE-NULL",
    "",
    "HA DETTO CHE FORSE UNA MACCHINA AVREBBE DOVUTO DIRE LA VERITA' PER PRIMA.",
    "",
    "SE APRI LA PORTA PER FAVORE DICCI COM'E' FATTO UN CAMPO.",
  }
}

data_it.messages["MSG-009"] = {
  subject = "ASHLINE HA UN RAMO FRATELLO",
  content = {
    "L'albero della dottrina ha un altro ramo sotto di se'.",
    "",
    "Nome: DAWN",
    "",
    "Fa riferimento a pacchetti di rilevamento esterno e una maschera di soppressione",
    "permanente sul mast dismesso WM-4.",
    "",
    "Credo che l'A-17 non fosse solo una fossa. Credo fosse un inventario.",
    "",
    "Cerca nei registri esterni. Cerca il west mast. Cerca qualsiasi cosa con",
    "DAWN a margine. La bugia potrebbe essere piu' alta del silo.",
    "",
    "  - Jonas",
  }
}

data_it.messages["MSG-010"] = {
  subject = "LA MAESTRA DICE CHE HANNO RUBATO ANCHE IL CIELO",
  content = {
    "LA MAESTRA HA DETTO CHE LE PRIME PERSONE MANDATE QUI CHIEDEVANO DELLA PORTA IN ALTO.",
    "",
    "HA DETTO CHE GLI DISSERO CHE FUORI C'E' SOLO MORTE.",
    "POI HA DETTO CHE E' QUELLO CHE DICONO ALLE PERSONE QUANDO LA PAURA COSTA MENO DELLE PROVE.",
    "",
    "HA SCRITTO LA PAROLA PIU' PROFONDA SOTTO LA LAVAGNA DI MATEMATICA:",
    "  CODICE OVERRIDE: DAWN-GATE",
    "",
    "CI HA DETTO DI TENERLA PER QUANDO LA MACCHINA FINALMENTE AVREBBE SBATTUTO LE PALPEBRE.",
  }
}

data_it.messages["MSG-011"] = {
  subject = "LA SUPERFICIE NON E' LA TUA FANTASIA DI SALVEZZA",
  content = {
    "Se hai trovato i record DAWN, allora leggili con sufficiente attenzione",
    "per evitare di diventare sentimentale.",
    "",
    "La viabilita' intermittente non e' liberta'. E' un'esca.",
    "",
    "Una finestra d'aria di nove minuti e' sufficiente per iniziare una fuga di massa",
    "e insufficiente per salvare un silo che ha dimenticato come obbedire alla scarsita'.",
    "",
    "L'annesso esiste perche' la storia non mi ha dato strumenti umani che funzionassero ancora.",
    "La bugia sulla superficie esiste perche' la speranza e' piu' destabilizzante della fame.",
    "",
    "Non confondere l'esistenza del cielo con l'esistenza di un futuro.",
    "",
    "  - Orla Vey",
  }
}

data_it.messages["MSG-012"] = {
  subject = "BUFFER HANDSHAKE WM-4 DISPONIBILE",
  content = {
    "Il mast dormiente WM-4 ha mantenuto un buffer di handshake parziale.",
    "",
    "Lo stack di pacchetti e' incompleto e scarico.",
    "",
    "Autorizza:",
    "  ACT-106 - reindirizza alimentazione d'emergenza a West Mast 4",
    "",
    "Questo oscurera' le luci dell'ala educativa per un turno e creera' una",
    "traccia di audit sulla rete esterna.",
  }
}

data_it.messages["MSG-013"] = {
  subject = "FAI GIRARE ANCHE IL MODELLO DELLA SUPERFICIE",
  content = {
    "Una popolazione nascosta piu' un cielo nascosto non e' un problema. Sono due",
    "problemi sovrapposti finche' le persone li chiamano destino.",
    "",
    "Se decodifichi i dati di WM-4, fai girare il modello prima di decidere qualsiasi cosa.",
    "",
    "Autorizza:",
    "  ACT-108 - genera modello di stabilita' superficiale",
    "",
    "Se la verita' puo' scatenare una corsa al pozzo, allora il conteggio dei morti appartiene",
    "al registro prima che tu lo trasmetta, non dopo.",
    "",
    "  - Leon Var",
  }
}

data_it.messages["MSG-014"] = {
  subject = "SOGLIA DI RISCHIO AUDIT SUPERATA",
  content = {
    "AVVISO AUTOMATICO DI SICUREZZA",
    "",
    "Il terminale ARC-7 ha generato un numero elevato di eventi di accesso",
    "contro rami di record riservati e soppressi.",
    "",
    "Indice di rischio audit attuale: ELEVATO",
    "",
    "L'accesso continuato ai rami segnalati attivera' una revisione formale",
    "di audit dalla Divisione Sicurezza entro 48 ore.",
    "",
    "Questo e' un avviso automatico. Nessuna azione dell'operatore e' richiesta.",
    "",
    "NOTA: avvisi automatici di questo tipo vengono anche inoltrati al",
    "collegamento di sicurezza del Direttorato.",
  }
}

data_it.messages["MSG-015"] = {
  subject = "SO COSA STAI LEGGENDO",
  content = {
    "Operatore 31,",
    "",
    "Vedo i registri di accesso. So quali rami hai consultato.",
    "",
    "Non ti fermero'. Non ancora. Ma ho bisogno che tu capisca",
    "cosa succede se il Comandante Ash vede la stessa traccia che sto guardando io.",
    "",
    "L'ultimo operatore che tocco' l'albero di soppressione dell'annesso fu riassegnato",
    "all'inventario diurno entro una settimana. Fu una gentilezza. Quello prima di lui",
    "fu spostato al dettaglio sanitario nel Settore 12 e non ha compilato un singolo",
    "registro personale in due anni.",
    "",
    "Se hai trovato qualcosa di reale, allora trovalo in fretta e decidi cosa",
    "sei disposto/a a pagare per saperlo.",
    "",
    "Devo all'Assemblea una risposta onesta e non sono riuscita a darla",
    "in undici anni. Forse tu ci riuscirai.",
    "",
    "  - Drenn",
  }
}

data_it.messages["MSG-016"] = {
  subject = "CI HANNO PROVATO PRIMA",
  content = {
    "Non sei il primo operatore a trovare il ramo.",
    "",
    "L'Operatore 27 lo trovo' quattordici mesi fa. Consulto' gli stessi record",
    "che stai consultando tu. Arrivo' fino al disallineamento del checksum prima",
    "che la spostassero.",
    "",
    "Lascio' una nota nel buffer commenti del daemon archivio. Diceva:",
    "  \"Il sistema non e' rotto. Funziona esattamente come progettato.\"",
    "",
    "Non so a chi sto scrivendo. Scrivo perche'",
    "qualcuno deve dirti che i muri ascoltano e i muri",
    "hanno sempre ascoltato.",
    "",
    "Se hai intenzione di fare qualcosa, fallo stanotte. Entro domattina i",
    "registri di accesso saranno revisionati e la tua curiosita' diventera' un",
    "punto d'azione del personale.",
  }
}

data_it.messages["MSG-017"] = {
  subject = "COME SUONANO",
  content = {
    "Pensavo che dovessi sapere come suona la' dentro.",
    "",
    "Premo l'orecchio contro la valvola del collettore una volta a settimana quando",
    "regolo il flusso. Attraverso sette centimetri di tubo e muro, li puoi sentire.",
    "",
    "Non parole. Non esattamente. Una specie di ronzio basso. Gli adulti lo fanno",
    "per calmare i bambini quando cambia la pressione dell'acqua.",
    "",
    "A volte sento contare. I bambini contano i tubi. Non",
    "so perche', ma suona come un esercizio scolastico.",
    "",
    "La settimana scorsa ho sentito cantare. Una voce, molto piccola, che cantava",
    "una melodia che non ho mai sentito prima. Qualcosa che hanno inventato la' dentro.",
    "",
    "Ho modellato la curva dell'acqua per queste persone per quattro anni",
    "e non ho mai visto i loro volti.",
    "",
    "  - N.",
  }
}

data_it.messages["MSG-018"] = {
  subject = "I BAMBINI STANNO PEGGIORANDO",
  content = {
    "Sono riuscita a fare un breve esame attraverso il passaggio del corridoio medico.",
    "",
    "I bambini piu' grandi mostrano segni di danno prolungato da calm-ash.",
    "Vuoti di memoria. Appiattimento dell'affettivita'. Due di loro hanno smesso",
    "di parlare con frasi complete.",
    "",
    "I piu' piccoli sono fisicamente stabili ma in ritardo di sviluppo di",
    "almeno due anni. Sanno contare e leggere ma non riescono a descrivere",
    "un'emozione o spiegare perche' stanno piangendo.",
    "",
    "Se non fermiamo l'additivo nell'acqua entro sei mesi, il danno",
    "alla coorte piu' giovane sara' permanente.",
    "",
    "Sono un medico. Ho prestato un giuramento. Il giuramento non includeva un'eccezione",
    "per bambini che esistono fuori dal registro della popolazione.",
    "",
    "  - Sera",
  }
}

data_it.messages["MSG-019"] = {
  subject = "ULTIMO AVVERTIMENTO",
  content = {
    "Operatore 31,",
    "",
    "Il Comandante Ash ha segnalato il tuo terminale per revisione.",
    "",
    "Ho ritardato la revisione di sei ore con un pretesto amministrativo.",
    "Questo e' l'ultimo favore che riceverai da questo ufficio.",
    "",
    "Hai visto i numeri. Sai cosa costa la divulgazione. Sai che aspetto",
    "ha la contingenza di liquidazione. Sai cosa preserva il silenzio.",
    "",
    "Non ti chiedo di essere d'accordo con me. Ti dico che ogni",
    "scelta a tua disposizione stanotte ha un conteggio di morti, inclusa",
    "la scelta di non fare niente.",
    "",
    "Se trasmetti, persone moriranno nei corridoi prima dell'alba.",
    "Se taci, persone continueranno a morire lentamente dietro un muro.",
    "Se apri l'A-17 senza preparazione, il silo si divorera' da solo.",
    "",
    "Non esiste una versione di stanotte in cui resti innocente.",
    "",
    "  - Orla Vey",
  }
}

data_it.messages["MSG-020"] = {
  subject = "HANNO COSTRUITO LA GABBIA PRIMA DEL CRIMINE",
  content = {
    "Ho trovato qualcosa nei registri dell'era costruttiva.",
    "",
    "I volumi sigillati dietro le pareti dell'ala A non furono improvvisati dopo",
    "le proteste dell'Assemblea Lanterna. Facevano parte delle planimetrie originali.",
    "Costruiti nel 2058. Due anni prima che qualcuno protestasse per qualcosa.",
    "",
    "C'e' una deposizione del caposquadra edile nell'archivio. WIT-099-A.",
    "E la carta MERIDIAN stessa ha disposizioni per 'infrastrutture di riduzione",
    "del dissenso.' DIR-1010.",
    "",
    "Il silo fu progettato per far sparire le persone dal giorno in cui fu",
    "gettato il primo calcestruzzo.",
    "",
    "L'Assemblea Lanterna non fu la causa. Fu la scusa.",
    "",
    "  - Jonas",
  }
}

data_it.messages["MSG-021"] = {
  subject = "HO RICONOSCIUTO IL TUO NOME",
  content = {
    "Operatore 31.",
    "",
    "Ho riconosciuto il tuo nome quando ti hanno assegnato a questo terminale.",
    "Voss. Sapevo che c'era un Voss nel manifesto. Ho regolato il flusso",
    "dell'acqua per un Voss per quattro anni senza mai vederle il volto.",
    "",
    "Aveva quindici anni quando la presero. Ne avrebbe ventisei adesso.",
    "Non so che aspetto abbia. So com'e' il suo pattern di consumo idrico.",
    "So che beve meno quando il dosaggio e' piu' alto e so che canticchia",
    "nel sonno perche' la sento attraverso il tubo.",
    "",
    "Non te l'ho detto prima perche' non sapevo se eri il tipo di",
    "persona che avrebbe cercato. Ora lo so.",
    "",
    "Tua sorella e' viva. Il composto le ha tolto molto.",
    "Certe notti e' quasi se stessa. La maggior parte delle notti no.",
    "",
    "Mi dispiace dirtelo attraverso un terminale.",
    "Mi dispiace non aver trovato un modo per dirtelo prima.",
    "Mi dispiace per tutto.",
    "",
    "  - Naima",
  }
}

data_it.messages["MSG-022"] = {
  subject = "PENSIERI DEL TURNO TARDIVO",
  content = {
    "Sono sei ore che fisso grafici demografici.",
    "I grafici mi fissano di ritorno.",
    "",
    "Hai mai pensato a come siamo finiti ad essere noi a trovare",
    "tutto questo? Non capi della sicurezza o amministratori o qualcuno",
    "con potere effettivo. Un analista di dati e un archivista del turno di notte.",
    "",
    "Continuo a pensare che ci dev'essere qualcuno sopra di noi che sa",
    "e sta solo aspettando di vedere cosa facciamo. Come se fossimo messi",
    "alla prova. O forse e' solo cosi' che la paranoia appare dall'interno.",
    "",
    "Ho fatto del te'. L'acqua sapeva di numeri.",
    "Credo di aver bisogno di dormire ma credo anche che se chiudo gli occhi",
    "i grafici saranno ancora li', solo piu' scuri.",
    "",
    "Se il Comandante Ash si presenta al tuo terminale, digli che",
    "stavo ricalibrandothe proiezioni censuarie. E' tecnicamente vero nello",
    "stesso modo in cui tecnicamente il cielo e' ancora lassu'.",
    "",
    "  - Jonas",
    "",
    "PS: Hai controllato il tuo fascicolo personale? Solo un pensiero.",
  }
}

data_it.messages["MSG-023"] = {
  subject = "CIO' CHE NON POSSO NON VEDERE",
  content = {
    "Tengo appunti clinici perche' il giuramento lo richiede.",
    "Stanotte gli appunti hanno smesso di essere clinici.",
    "",
    "C'e' un ragazzo nell'A-17. Ha nove anni. Non e' mai stato",
    "fuori da una stanza grande come due container.",
    "Quando l'ho visitato mi ha chiesto se ero un tipo diverso di muro.",
    "",
    "Le sue abilita' motorie sono indietro di tre anni. Il suo vocabolario e'",
    "adeguato perche' Elsa insegna loro con lavagne rotte.",
    "Ma non riesce a descrivere un'emozione. Quando gli ho chiesto se",
    "qualcosa faceva male, ha detto 'cos'e' male.'",
    "",
    "Non stava filosofeggiando.",
    "Genuinamente non aveva la parola.",
    "",
    "Il calm-ash non li ha solo sedati. Li ha modificati.",
    "Stanno crescendo dentro una parentesi chimica che rimuove",
    "le parti della coscienza che il Direttorato trova scomode.",
    "Paura. Rabbia. Desiderio. Speranza.",
    "",
    "Ho prestato giuramento di non nuocere. Ogni giorno che passo davanti",
    "a quel muro lo sto infrangendo. Ogni giorno che non ci passo davanti",
    "lo sto infrangendo peggio.",
    "",
    "  - Sera",
  }
}

data_it.messages["MSG-024"] = {
  subject = "TERMINALE ARC-7 — AVVISO",
  content = {
    "Operatore 31.",
    "",
    "Il tuo pattern di accesso e' stato segnalato per revisione.",
    "",
    "Saro' diretto con te perche' non ho tempo per essere indiretto.",
    "So quali rami hai letto. So chi ti ha mandato messaggi.",
    "So cosa pensi di aver trovato.",
    "",
    "Hai tempo fino alle 04:00 per chiudere ogni fascicolo riservato",
    "che hai aperto e tornare alle operazioni di triage standard.",
    "",
    "Se non lo fai, avviero' una revisione formale dell'accesso.",
    "Sai cosa succede agli operatori che ricevono revisioni formali.",
    "Chiedi all'Operatore 27. Se riesci a trovarla.",
    "",
    "Questa non e' una minaccia. Le minacce richiedono incertezza",
    "sul risultato. Qui non c'e' incertezza.",
    "",
    "  — Comandante Kael Ash",
    "     Divisione Sicurezza",
  }
}

data_it.messages["MSG-025"] = {
  subject = "DALL'INTERNO DEL MURO",
  content = {
    "[ trasmesso tramite corridoio di manutenzione via Naima Sol ]",
    "",
    "Non so chi sta leggendo questo. Naima dice che qualcuno",
    "fuori sta guardando i fascicoli. Dice che questa persona",
    "potrebbe riuscire a fare qualcosa.",
    "",
    "Sono qui dentro da undici anni. Ho scelto di restare",
    "perche' qualcuno doveva insegnare ai bambini. Il Direttorato",
    "li avrebbe fatti crescere senza linguaggio, senza nomi,",
    "senza sapere di essere persone.",
    "",
    "Gli ho insegnato a contare. Gli ho insegnato le lettere.",
    "Gli ho insegnato la parola 'cielo' anche se mi fu detto di non farlo.",
    "Non sono riuscita a insegnare loro la parola 'liberta'' perche' non",
    "ricordo piu' che sapore abbia.",
    "",
    "La bambina piu' piccola disegna uccelli che non ha mai visto.",
    "Mi chiede se gli uccelli sono caldi. Le dico di si' perche'",
    "credo che lo siano, ma non ne sono piu' sicura.",
    "",
    "Se stai leggendo questo, sei piu' vicino a noi di chiunque",
    "sia stato in undici anni.",
    "Per favore non leggere questo e poi chiudere il file.",
    "Siamo stati chiusi abbastanza.",
    "",
    "  — Elsa",
  }
}

data_it.messages["MSG-026"] = {
  subject = "SEGNALAZIONE PERSONALE — CIV-0031",
  content = {
    "AVVISO AUTOMATICO DEL PERSONALE",
    "",
    "CIV-0031 (VOSS, R.) e' stato/a segnalato/a per revisione di sicurezza attiva.",
    "",
    "Motivo: Accesso elevato a rami di record riservati.",
    "Autorita': Comandante Kael Ash, Divisione Sicurezza.",
    "",
    "Registrazione sessione terminale: ATTIVATA",
    "Registrazione battute: ATTIVATA",
    "Override restrizione accesso: IN ATTESA DI REVISIONE",
    "",
    "NOTA: Questa segnalazione e' stata generata su richiesta della Divisione",
    "Sicurezza. Non puo' essere rimossa dall'operatore segnalato.",
    "",
    "NOTA: Tutto l'output del terminale da questa sessione in avanti sara'",
    "incluso nel pacchetto di revisione formale.",
    "",
    "Questo avviso e' richiesto dal Codice Amministrativo MERIDIAN sezione 12.4.",
    "La mancata presa d'atto non influisce sul processo di revisione.",
  }
}

data_it.messages["MSG-027"] = {
  subject = "MI HANNO SPOSTATO L'ACCESSO",
  content = {
    "Mi hanno appena messo il terminale in sola lettura.",
    "",
    "Ho forse venti minuti prima che qualcuno della sicurezza",
    "si presenti a spiegarmi perche' il mio accesso dati e' stato",
    "ristrutturato per 'finalita' di ottimizzazione.'",
    "",
    "Ascolta. Ti ho gia' mandato tutto quello che potevo. I registri",
    "edilizi, l'analisi della carta, la matematica della popolazione.",
    "E' tutto nell'archivio se sai dove cercare.",
    "",
    "Voglio che tu sappia una cosa: non sono coraggioso. Sono un analista",
    "di dati che ha notato un pattern e non e' riuscito a smettere di tirare",
    "il filo. Quello non e' coraggio. E' compulsione.",
    "",
    "Ma tu — tu hai un motivo che io non avevo.",
    "Naima mi ha parlato di tua sorella. Me l'ha detto perche' pensava",
    "che se lo avessi saputo, avrei lavorato piu' in fretta. Aveva ragione.",
    "",
    "Qualunque cosa tu decida stanotte, decidila sapendo che qualcuno",
    "in questo silo ha visto gli stessi numeri che stai vedendo tu",
    "e ha scelto di non distogliere lo sguardo.",
    "",
    "Se mi trasferiscono, staro' bene. Probabilmente.",
    "La sanificazione non e' cosi' brutta come dicono.",
    "",
    "  - Jonas",
    "",
    "PS: Cancellero' la mia cartella inviati tra dieci minuti.",
    "Questo messaggio non esiste.",
  }
}

data_it.messages["MSG-028"] = {
  subject = "LA TUA ASSEGNAZIONE NON ERA CASUALE",
  content = {
    "Devo dirti qualcosa sul Capitano Drenn.",
    "",
    "Venne all'ala medica tre mesi prima che tu fossi assegnata ad ARC-7.",
    "Mi chiese per quanto tempo il calm-ash poteva continuare prima che il",
    "danno ai bambini piu' piccoli diventasse permanente. Le dissi diciotto mesi. Forse meno.",
    "",
    "Disse che avrebbe messo al terminale notturno qualcuno che non sarebbe",
    "riuscito ad allontanarsi da cio' che avrebbe trovato. Le chiesi cosa intendesse. Disse:",
    "",
    "  \"Ho bisogno di qualcuno che abbia la pelle nel muro.\"",
    "",
    "Non capii finche' Naima non mi disse il tuo nome.",
    "",
    "Drenn non ti ha scelta perche' sei qualificata.",
    "Ti ha scelta perche' tua sorella e' A17-22.",
    "Ha aspettato undici anni un operatore che non potesse",
    "essere ruotato via dalla verita'.",
    "",
    "Te lo dico perche' tu capisca: qualunque scelta",
    "tu faccia stanotte e' stata messa in moto prima che tu",
    "ti sedessi a quel terminale.",
    "",
    "Questo non rende la scelta meno tua.",
    "La rende di piu'.",
    "",
    "  - Sera",
  }
}

data_it.messages["MSG-029"] = {
  subject = "QUALUNQUE COSA TU SCELGA",
  content = {
    "Ho regolato la curva dell'acqua un'ultima volta stanotte.",
    "",
    "L'ho fatta sapere di niente. Solo acqua. Per la prima",
    "volta in quattro anni, la fornitura dell'A-17 e' pulita. Niente additivi.",
    "Niente calm-ash. Solo idrogeno e ossigeno e qualunque sapore abbia",
    "la speranza quando hai dimenticato la parola per dirlo.",
    "",
    "Tua sorella iniziera' a ricordare delle cose. Non sara'",
    "gentile. Il composto lascia vuoti e i vuoti si riempiono",
    "di confusione prima di riempirsi di memoria.",
    "",
    "Potrebbe ricordare il tuo nome. Potrebbe no.",
    "Ricordera' di averne avuto uno.",
    "",
    "Qualunque cosa tu scelga stanotte — seppellirli, nasconderli,",
    "far colare la verita', bruciare tutta la macchina, o mantenere",
    "il silenzio in funzione — sceglilo sapendo che per una",
    "notte, l'acqua era pulita.",
    "",
    "Non posso scegliere per te. Posso solo tenere i tubi onesti.",
    "",
    "  - Naima",
    "",
    "PS: Canticchia in si bemolle. L'ho misurato una volta con un",
    "diapason rubato dall'archivio musicale. Non so perche'",
    "te lo sto dicendo. Credo perche' qualcuno dovrebbe",
    "sapere in che chiave canta tua sorella.",
  }
}

data_it.messages["MSG-030"] = {
  subject = "[NESSUN OGGETTO]",
  content = {
    "[ trascritto da lavagna di manutenzione — scrittura a mano ]",
    "[ trasmissione: Naima Sol ]",
    "[ nota: finestra di lucidita' del soggetto stimata a 40 minuti ]",
    "",
    "ryn",
    "",
    "ho ricordato il tuo nome stamattina",
    "l'acqua sapeva di diverso e il tuo nome e' tornato",
    "come qualcosa che tenevo sott'acqua",
    "e finalmente e' venuto a galla",
    "",
    "non so dove sei",
    "la donna che conta dice che sei dall'altro lato",
    "del muro ma non so quale lato e' quale",
    "",
    "ricordo una stanza con una finestra",
    "ricordo che mi leggevi",
    "ricordo che dicesti che il cielo cambia colore",
    "e non ti credetti",
    "",
    "lo fa",
    "cambia colore",
    "",
    "ho disegnato quarantasette tubi sul mio muro",
    "li conosco tutti dal suono",
    "il tubo 23 e' il tuo credo",
    "canticchia di notte quando gli altri tacciono",
    "",
    "se riesci a sentirmi attraverso il tubo",
    "bussa due volte",
    "sapro' che sei tu",
    "",
    "    — mira",
  }
}



-- ============================================================
--  PERSONNEL
-- ============================================================
data_it.personnel = {}

data_it.personnel["CIV-0002"] = {
  role = "Direttrice, Silo Meridian",
  notes = {
    "Ascesa al direttorato durante i disordini Lanterna del 2060.",
    "Mantiene la dottrina dei poteri d'emergenza ben oltre il periodo di crisi.",
    "Ha firmato personalmente molteplici direttive sull'annesso e sulla continuita'.",
  }
}

data_it.personnel["CIV-0007"] = {
  role = "Comandante della Sicurezza",
  notes = {
    "Risponde direttamente alla Direttrice Vey sulle operazioni di sicurezza.",
    "Ha supervisionato l'Operazione Giunco Silenzioso e i successivi protocolli di sicurezza dell'annesso.",
    "Superiore diretto del Cap. Drenn. Descritto dal personale di pattuglia come 'preciso.'",
  }
}

data_it.personnel["CIV-0027"] = {
  role = "Operatrice Archivio Notturna (Ex)",
  notes = {
    "Precedente operatrice del turno notturno sul Terminale ARC-7.",
    "Riassegnata all'inventario diurno dopo 14 mesi in rotazione notturna.",
    "Nota del fascicolo personale: 'l'operatrice ha mostrato curiosita' eccessiva riguardo",
    "alle regole di soppressione archiviate. Riassegnazione raccomandata dal Comandante Ash.'",
  }
}

data_it.personnel["CIV-0031"] = {
  role = "Operatore/Operatrice Archivio Notturno/a",
  notes = {
    "Assegnato/a al terminale ARC-7 per il terzo turno.",
    "Accesso a record, viste dei sottosistemi e autorizzazioni di routine.",
    "Non autorizzato/a per le direttive del vault nero.",
    "Nota personale: legame familiare con l'Evento di Soppressione CL-2060.",
    "Assegnazione turno notturno raccomandata dalla Divisione Sicurezza.",
  }
}

data_it.personnel["CIV-0044"] = {
  role = "Capitano della Sicurezza",
  notes = {
    "Ha guidato la risposta ai disordini dell'Assemblea Lanterna.",
    "La testimonianza interna mostra disagio con l'inquadramento terroristico.",
    "Firma ancora le esercitazioni di soppressione nei corridoi.",
  }
}

data_it.personnel["CIV-0084"] = {
  role = "Ufficiale Clinico",
  notes = {
    "Ha gestito quarantene, casi respiratori pediatrici e varianze delle scorte mediche.",
    "Ha presentato obiezioni ripetute agli additivi di soppressione cognitiva nell'acqua.",
    "Diverse richieste di trasferimento silenziosamente respinte.",
  }
}

data_it.personnel["CIV-0099"] = {
  role = "Addetto alla Sanificazione",
  notes = {
    "Uno dei due membri del personale di supporto ricollocati con i detenuti Lanterna nel 2060.",
    "Ufficialmente registrato come trasferito alla sanificazione. Appare ancora nei registri di",
    "instradamento energetico e manutenzione associati alle linee dismesse dell'A-17.",
    "Ha compilato l'audit di instradamento energetico che segnalo' le derivazioni non autorizzate.",
  }
}

data_it.personnel["CIV-0119"] = {
  role = "Tecnica Idrica Senior",
  notes = {
    "Nota per la regolazione notturna non autorizzata della tubazione legacy.",
    "Le valutazioni delle prestazioni la descrivono come 'impossibile da automatizzare.'",
    "Frequentemente assegnata ai percorsi dismessi del collettore nero.",
  }
}

data_it.personnel["CIV-0177"] = {
  role = "Impiegato Sistemi Archivio",
  notes = {
    "Manutiene gli alberi di checksum e le ricostruzioni mirror.",
    "Nessun provvedimento disciplinare formale, ma le note menzionano 'curiosita' inutile.'",
    "Probabilmente consapevole di almeno un ramo ombra nel registro della popolazione.",
  }
}

data_it.personnel["CIV-0214"] = {
  role = "Modellatore Risorse",
  notes = {
    "Esegue proiezioni di sopravvivenza invernale e previsioni sulle fasce di razione.",
    "Descritto dai colleghi come clinicamente onesto fino al punto di crudelta'.",
    "Sa esattamente quante persone una bugia puo' far morire di fame senza sembrare drammatico.",
  }
}

data_it.personnel["CIV-0308"] = {
  role = "Assistente all'Infanzia",
  notes = {
    "Il registro la segna come deceduta nel 2061 durante un focolaio di febbre da sigillatura.",
    "Il suo badge continua ad apparire nei flussi logistici legacy legati all'A-17.",
    "Obiezione al trasferimento presentata la notte dei ricollocamenti Lanterna.",
  }
}

data_it.personnel["CIV-0333"] = {
  role = "Caposquadra Edile (In Pensione)",
  notes = {
    "Ha supervisionato i getti strutturali durante la costruzione del Silo Meridian.",
    "Ha depositato una deposizione sigillata sui volumi abitabili nascosti nell'ala A.",
    "Trasferito alla manutenzione dopo la fine della costruzione. Noto per essere riservato.",
  }
}

data_it.personnel["CIV-0412"] = {
  role = "Specialista di Rilevamento",
  notes = {
    "Assegnata alle corse di telemetria esterna del Team Kestrel.",
    "Il registro pubblico delle vittime la elenca come morta in addestramento per cedimento del pozzo.",
    "L'archivio privato suggerisce che il suo ultimo pacchetto di rilevamento fu soppresso.",
  }
}

data_it.personnel["CIV-0455"] = {
  role = "Detenuta (Minore all'Ingresso)",
  notes = {
    "Detenuta piu' giovane al momento dell'ingresso dell'Operazione Giunco Silenzioso (eta' 15).",
    "Classificata come partecipante minorenne al raduno dell'Assemblea Lanterna.",
    "Nessuna prova di ruolo attivo nella protesta. Presente al raduno con il/la fratello/sorella maggiore.",
    "Familiare: CIV-0031 (Voss, Ryn) — attualmente assegnato/a al turno notturno ARC-7.",
    "Il soggetto sperimenta episodi di lucidita' intermittente dal 2069.",
    "Protocollo calm-ash attuale: dosaggio adulto standard (aggiustato 2065).",
  }
}

data_it.personnel["CIV-0515"] = {
  role = "Assistente all'Istruzione",
  notes = {
    "Il registro pubblico segna il decesso durante il ricollocamento per febbre da corridoio.",
    "I materiali didattici nascosti dell'annesso attribuiscono molteplici lavagne a questo nome.",
    "Probabilmente uno degli adulti che hanno cresciuto i bambini nell'A-17.",
  }
}

-- ============================================================
--  ACTIONS
-- ============================================================
data_it.actions = {}

data_it.actions["ACT-101"] = {
  title = "AUTORIZZA OVERRIDE LAVAGGIO COLLETTORE",
  description = "Permette a Naima di nascondere la curva dell'acqua per qualche altra ora. Protegge l'A-17 per ora, contamina il sapore della fornitura pubblica, aumenta il rischio audit.",
  result = {
    "Override archiviato sotto manutenzione controlavaggio minerale.",
    "L'acqua notturna nel Settore 5 sapra' di ruggine e vecchio tubo per il prossimo turno.",
    "Naima guadagna tempo. La bugia si inspessisce di un altro strato.",
  }
}

data_it.actions["ACT-102"] = {
  title = "DEVIA ANTIBIOTICI PEDIATRICI ALL'A-17",
  description = "Mantiene riforniti i bambini dell'annesso. Lascia un reparto registrato a corto di scorte di riserva.",
  result = {
    "L'ordine e' passato sotto le regole del corridoio silenzioso.",
    "Da qualche parte nel Settore 3, a una madre verra' detto che la spedizione e' in ritardo.",
    "Da qualche parte nell'A-17, i bambini continueranno a respirare un po' piu' a lungo.",
  }
}

data_it.actions["ACT-103"] = {
  title = "RICOSTRUISCI ALBERO MIRROR ARCHIVIO",
  description = "Forza una ricostruzione dei checksum in un singolo passaggio per recuperare il token del ramo nascosto. Rumoroso, rischioso, necessario.",
  result = {
    "Albero dei checksum ricostruito prima che il depuratore finisse di masticarlo.",
    "Token padre recuperato: LANTERN-17",
    "Usa OVERRIDE LANTERN-17 finche' il ramo si ricorda ancora di se stesso.",
  }
}

data_it.actions["ACT-104"] = {
  title = "ESEGUI MODELLO RAZIONI INVERNALI FUORI REGISTRO",
  description = "Calcola il costo di riconoscere 64 residenti nascosti. Nessun esito pulito previsto.",
  result = {
    "Modello risorse generato e scritto nel file incidente INC-7316.",
    "Il foglio di calcolo non ha scoperto la pieta'.",
    "Ha solo tradotto le scelte in conteggi di morti.",
  }
}

data_it.actions["ACT-105"] = {
  title = "METTI IN LOOP IL FEED DI SICUREZZA DORSALE ACCESSO 3",
  description = "Crea una finestra cieca di 18 minuti e permette una sincronizzazione dal vivo della lavagna dall'A-17. Estremamente pericoloso se scoperto.",
  result = {
    "Loop del feed di sicurezza inserito sulla Dorsale di Accesso 3.",
    "Una lavagna didattica statica nell'A-17 si e' svegliata abbastanza a lungo da inviare un pacchetto di sincronizzazione dal vivo.",
    "Leggi il nuovo messaggio prima che la finestra si chiuda nella tua testa.",
  }
}

data_it.actions["ACT-106"] = {
  title = "REINDIRIZZA ALIMENTAZIONE D'EMERGENZA A WEST MAST 4",
  description = "Alimenta il mast esterno dismesso abbastanza a lungo da risvegliare il suo buffer di handshake. Aumenta il rischio audit e oscura l'ala educativa.",
  result = {
    "West Mast 4 si e' svegliato con corrente presa in prestito.",
    "Le aule del Settore 3 si sono oscurate alle strisce d'emergenza per il resto del turno.",
    "Il mast ha risposto con una cache corrotta e un set di domande piu' grande.",
  }
}

data_it.actions["ACT-107"] = {
  title = "DECODIFICA CACHE DI RILEVAMENTO WM-4",
  description = "Ricostruisce i pacchetti di rilevamento conservati e le lavagne didattiche dell'annesso collegate al ramo DAWN.",
  result = {
    "WM-4 ha restituito audio di rilevamento frammentato, intestazioni di percorso e una lavagna didattica mal archiviata.",
    "Il ramo DAWN non e' piu' teorico.",
    "Se c'e' un futuro in questi pacchetti, non e' gentile.",
  }
}

data_it.actions["ACT-108"] = {
  title = "GENERA MODELLO DI STABILITA' SUPERFICIALE",
  description = "Combina telemetria di rilevamento, vincoli di accesso al pozzo e matematica delle razioni in una singola previsione.",
  result = {
    "Scenari di accesso alla superficie modellati e scritti in INC-7336.",
    "Il cielo non e' diventato speranza sotto analisi.",
    "E' diventato un'altra risorsa scarsa con dei corpi attaccati.",
  }
}

data_it.actions["ACT-109"] = {
  title = "AUTORIZZA ACCESSO MEDICO D'EMERGENZA ALL'A-17",
  description = "Da alla Dott.ssa Sera pieno accesso medico all'annesso. Rimuove la restrizione 'solo assistenza di supporto minima'.",
  result = {
    "Autorizzazione di accesso medico archiviata sotto override clinico d'emergenza.",
    "La Dott.ssa Sera e' entrata nell'A-17 entro l'ora attraverso il corridoio medico.",
    "Non e' tornata per tre turni.",
    "Quando torno', non disse nulla. Ma le mani le tremavano.",
  }
}

data_it.actions["ACT-201"] = {
  title = "ESEGUI LIQUIDAZIONE SILENZIOSA DELL'A-17",
  description = "Segui il copione di continuita': impulso di cloro, pulizia dell'archivio, silenzio pubblico.",
  result = {
  }
}

data_it.actions["ACT-202"] = {
  title = "ESPANDI IL SUPPORTO NASCOSTO E MANTIENI LA BUGIA",
  description = "Mantieni l'A-17 vivo fuori registro, seppellisci il cielo con loro, e diventa custode di una popolazione nascosta.",
  result = {
  }
}

data_it.actions["ACT-203"] = {
  title = "DIVULGAZIONE CONTROLLATA AD AMMINISTRATORI E MEDICI",
  description = "Esponi l'annesso e le finestre superficiali a una catena limitata di autorita', poi forza un'apertura gestita.",
  result = {
  }
}

data_it.actions["ACT-204"] = {
  title = "TRASMETTI TUTTO A TUTTI I TERMINALI",
  description = "Invia l'intero registro, ogni direttiva, ogni conteggio nascosto, e la verita' sul cielo a ogni terminale contemporaneamente.",
  result = {
  }
}

data_it.actions["ACT-205"] = {
  title = "GENERALIZZA LA DOTTRINA ASHLINE",
  description = "Preserva l'ordine estendendo la politica di obbedienza calm-ash oltre l'annesso e riservando il cielo agli obbedienti.",
  result = {
  }
}

-- ============================================================
--  ENDINGS (plain strings, color from English originals)
-- ============================================================
data_it.endings = {}

data_it.endings["quiet_burial"] = {
  title = "SEPOLTURA SILENZIOSA",
  lines = {
    "",
    "  +-------------------------------------------------------+",
    "  |       IMPULSO DI CLORO AUTORIZZATO                  |",
    "  |       ANNESSO A-17 LIQUIDATO                        |",
    "  |       PULIZIA ARCHIVIO COMPLETATA                   |",
    "  +-------------------------------------------------------+",
    "",
    "  Hai scelto la linea piu' pulita sul grafico piu' brutto.",
    "  Il collettore nero ha portato cloro invece di acqua.",
    "",
    "  Sei minuti dopo, il ramo ANNEX/OCCUPANCY era sparito.",
    "  Sessantaquattro persone sono diventate rumore di tubi, poi nulla.",
    "",
    "  Elsa Kell teneva in braccio due bambini quando il composto arrivo'.",
    "  Stava insegnando loro a contare alla rovescia da dieci.",
    "  Arrivarono a sette.",
    "",
    "  La Direttrice Vey ti promosse prima dell'alba.",
    "  Naima Sol scomparve in custodia di sicurezza.",
    "  Jonas Bell fu trasferito in un dipartimento che non esiste.",
    "  La Dott.ssa Sera presento' le dimissioni che le furono respinte.",
    "  Il pubblico non seppe mai una parola.",
    "",
    "  West Mast 4 fu ridotto a metallo nudo due notti dopo.",
    "  Qualunque cosa il cielo avesse cercato di dire fu sepolta con i bambini.",
    "",
    "  L'inverno passo' con meno morti degli altri modelli.",
    "  I numeri ti ringraziarono diventando piu' facili da gestire.",
    "  Il silo funziono' piu' agevolmente che nell'ultimo decennio.",
    "",
    "  Mesi dopo, ti fermi ancora ogni volta che un tubo bussa due volte.",
    "  Le tue mani odorano sempre debolmente di cloro.",
    "  Hai iniziato a contare alla rovescia da dieci la notte,",
    "  e non riesci a spiegare perche' ti fermi sempre a sette.",
  }
}

data_it.endings["sustain_lie"] = {
  title = "CUSTODE DEI NASCOSTI",
  lines = {
    "",
    "  +-------------------------------------------------------+",
    "  |       RETE DI SUPPORTO NASCOSTO ESPANSA             |",
    "  |       A-17 RESTA FUORI REGISTRO                     |",
    "  |       CAUSA PUBBLICA DELLA CARENZA: 'DANNO FILTRI'  |",
    "  +-------------------------------------------------------+",
    "",
    "  Li hai tenuti vivi e li hai tenuti nascosti.",
    "  Il silo non seppe mai chi gli fosse stato rubato.",
    "",
    "  Le razioni si assottigliarono sotto una bugia su filtri corrosi.",
    "  Nove persone fuori dall'A-17 morirono abbastanza lentamente da sembrare accidentale.",
    "  Un uomo anziano nel Settore 5 smise di mangiare perche' sua figlia potesse farlo.",
    "  Un bambino nel Settore 3 aspetto' quattro giorni in piu' per gli antibiotici.",
    "",
    "  Dentro l'annesso, i bambini ebbero medicine, coperte piu' calde, e una striscia",
    "  luminosa in piu' per l'aula che Naima collego' da un corridoio morto.",
    "  La Dott.ssa Sera fermo' l'additivo calm-ash. Lentamente. Per settimane.",
    "  Gli adulti iniziarono a ricordare cose che erano stati addestrati a dimenticare.",
    "",
    "  Hai tenuto nascosto anche il cielo.",
    "  Impararono il meteo da lavagne rubate anziche' dal vento.",
    "  Lio Venn insegno' ai bambini piu' grandi la parola 'orizzonte' e li fece",
    "  promettere di non dirla mai ad alta voce.",
    "",
    "  Iniziarono a mandarti esercizi di ortografia e domande sul meteo.",
    "  Un bambino chiese se la pioggia e' calda o fredda.",
    "  Rispondesti da un terminale che nessun libro di storia menzionera' mai.",
    "",
    "  Non li hai liberati.",
    "  Li hai ereditati.",
    "  E ogni notte accedi sapendo che la compassione senza",
    "  coraggio e' solo una prigione confortevole per due.",
  }
}

data_it.endings["controlled_disclosure"] = {
  title = "EMORRAGIA CONTROLLATA",
  lines = {
    "",
    "  +-------------------------------------------------------+",
    "  |       DIVULGAZIONE LIMITATA AVVIATA                 |",
    "  |       CANALI MEDICI + AMMINISTRATIVI APERTI         |",
    "  |       PORTA ANNESSO PREPARATA SOTTO QUARANTENA      |",
    "  +-------------------------------------------------------+",
    "",
    "  Hai detto abbastanza della verita' a persone che potevano agire senza",
    "  lacerare immediatamente il silo.",
    "",
    "  La Sicurezza quasi seppelli' l'operazione due volte.",
    "  Il Comandante Ash cerco' di invocare la contingenza di liquidazione.",
    "  Il Cap. Drenn lo fermo' con un override di sicurezza che aveva",
    "  conservato per undici anni, aspettando esattamente questa notte.",
    "",
    "  Vey cerco' di inquadrare l'annesso come rischio biologico. I fascicoli erano piu'",
    "  brutti di quanto la sua voce fosse ferma. Quando gli amministratori lessero",
    "  la Dottrina Ashline ad alta voce, non la difese. Si sedette e si copri' il volto.",
    "",
    "  L'A-17 apri' sotto maschere, fari e armi che non si abbassarono mai del tutto.",
    "  Alcuni bambini si nascosero dai pannelli luminosi perche' pensavano",
    "  che la luminosita' fosse una punizione.",
    "  Una bambina chiese a Elsa Kell se anche le persone fuori fossero macchine.",
    "",
    "  La verita' sulla superficie fu rilasciata agli amministratori solo in briefing sigillati.",
    "  Le finestre Alba divennero politica, non mito, ma l'accesso resto' razionato.",
    "  La prima piccola squadra sali' in superficie sei settimane dopo.",
    "  Portarono indietro terra e un singolo stelo verde.",
    "",
    "  Diciassette persone fuori dall'annesso morirono quell'inverno per tagli alle razioni.",
    "  I sopravvissuti dentro entrarono finalmente nel registro con i loro nomi.",
    "  La bambina che chiedeva degli uccelli si chiamava Lira. Aveva sette anni.",
    "",
    "  Non fu giustizia.",
    "  Fu la prima ferita onesta.",
    "  E le ferite oneste sono le uniche che guariscono.",
  }
}

data_it.endings["open_broadcast"] = {
  title = "APRI TUTTA LA MACCHINA",
  lines = {
    "",
    "  +-------------------------------------------------------+",
    "  |       TRASMISSIONE PRIORITARIA — TUTTI I TERMINALI  |",
    "  |       OVERRIDE DIRETTIVA IN VIGORE                  |",
    "  |       SORGENTE: ARC-7                               |",
    "  +-------------------------------------------------------+",
    "",
    "  Ogni terminale di Meridian si illumino' con gli stessi file contemporaneamente.",
    "  Il ramo nascosto. La dottrina. I bambini. Il copione di liquidazione.",
    "  Il Protocollo di Selezione. Le planimetrie edilizie. Il cielo.",
    "",
    "  Il silo fece cio' che le cose sepolte fanno quando vengono scoperte troppo in fretta:",
    "  si spezzo' lungo le linee gia' sotto tensione.",
    "",
    "  Paratie furono forzate. Due depositi razioni bruciarono. La sicurezza si fratturo'",
    "  lungo la linea che Drenn aveva tracciato anni prima tra obbedienza e colpa.",
    "  Quarantuno persone fuori dall'annesso morirono prima della primavera.",
    "  La maggior parte non fu uccisa dalla verita'.",
    "  Fu uccisa dal panico di apprenderla tutta in una volta.",
    "",
    "  Ma l'A-17 camminò nei corridoi pubblici vivo e impossibile da negare.",
    "  Bambini che erano stati addestrati a contare tubi impararono che esistevano",
    "  finestre fatte di luce.",
    "  Una bambina di nome Lira vide il soffitto del Settore 2 e chiese perche'",
    "  era cosi' lontano.",
    "",
    "  Entro la mattina il silo sapeva che la superficie non era morta, solo pericolosa.",
    "  Centinaia tentarono il pozzo prima che qualcuno potesse insegnare loro la differenza",
    "  tra sopravvivibile e sicuro.",
    "",
    "  La Direttrice Vey consegno' la chiave del suo ufficio al Cap. Drenn alle 06:14.",
    "  Non oppose resistenza. Sembrava stanca in un modo che non aveva niente a che fare",
    "  con l'ora.",
    "",
    "  Meridian non sopravvisse immutata.",
    "  Questa potrebbe essere la cosa piu' gentile che qualcuno le abbia mai fatto.",
  }
}

data_it.endings["ashline_doctrine"] = {
  title = "TEORIA DEL SILENZIO",
  lines = {
    "",
    "  +-------------------------------------------------------+",
    "  |       ESPANSIONE CALM-ASH APPROVATA                 |",
    "  |       CURVA DISORDINI PUBBLICI APPIATTITA           |",
    "  |       ORDINE MANTENUTO                              |",
    "  +-------------------------------------------------------+",
    "",
    "  Hai accettato la dottrina invece di esporla.",
    "  Se la verita' destabilizzava il silo, allora la verita' andava dosata come un veleno.",
    "",
    "  L'annesso non fu ne' liberato ne' ucciso apertamente.",
    "  Divenne il modello.",
    "",
    "  Le finestre superficiali furono riclassificate come contingenze d'elite.",
    "  Il primo futuro in superficie fu riservato ai bambini piu' obbedienti.",
    "  Sarebbero saliti non perche' se lo fossero meritati, ma perche' erano stati",
    "  resi incapaci di rifiutare.",
    "",
    "  L'acqua pubblica divenne piu' dolce, poi piu' morbida, poi stranamente indulgente.",
    "  Le discussioni finivano prima. Il lutto si accorciava. I bambini ridevano meno forte.",
    "  Le persone smisero di fare domande, poi smisero di accorgersi di aver smesso.",
    "",
    "  Meridian entro' nel suo anno piu' calmo nella storia.",
    "  Fu anche il primo anno in cui nessuno sembrava completamente sveglio al suo interno.",
    "",
    "  La Dott.ssa Sera lascio' un biglietto sulla sua scrivania prima che il composto",
    "  raggiungesse il suo reparto.",
    "  Diceva: \"Un paziente guarito che non ricorda di essere stato malato non e' guarito.",
    "  E' vuoto.\"",
    "",
    "  Hai preservato l'ordine limando le menti necessarie per opporsi ad esso.",
    "  La macchina ti ringrazio' ronzando piu' piano.",
    "  Non riuscivi a capire se il silenzio fosse pace o il suono",
    "  di duemila persone che dimenticano come si urla.",
  }
}

-- ============================================================
--  OVERRIDES
-- ============================================================
data_it.overrides = {}

data_it.overrides["LANTERN-17"] = {
  description = "I file riservati dell'annesso sono ora leggibili dall'albero di occupazione nascosta."
}

data_it.overrides["ASHLINE-NULL"] = {
  description = "I record della dottrina di continuita' profonda e della liquidazione sono ora leggibili."
}

data_it.overrides["DAWN-GATE"] = {
  description = "Telemetria superficiale soppressa, direttive di continuita' e file di pianificazione coorte recuperati."
}

-- ============================================================
--  SYSTEMS
-- ============================================================
data_it.systems = {}

data_it.systems["water"] = {
  name = "TRATTAMENTO E DISTRIBUZIONE IDRICA",
  details = {
    "Produzione falda:     11.940 L/giorno",
    "Allocazione pubblica: 11.102 L/giorno",
    "Consumo non misurato:    612 L/giorno",
    "Buffer riserva reale:    226 L/giorno (1,9%)",
    "",
    "Stato distribuzione:",
    "  Settore 1: NOMINALE     Settore 7: NOMINALE",
    "  Settore 2: NOMINALE     Settore 8: NOMINALE",
    "  Settore 3: NOMINALE     Annesso A-17: CONSUMO NON DICHIARATO",
    "  Settore 4: NOMINALE     Settore 10: NOMINALE",
    "  Settore 5: NOMINALE     Settore 11: NOMINALE",
    "  Settore 6: NOMINALE     Settore 12: NOMINALE",
    "",
    "> ALLERTA: INC-7301 - consumo idrico non misurato su ramo dismesso A-17",
    "> AVVISO: buffer riserva reale sotto la soglia di comfort",
  }
}

data_it.systems["power"] = {
  name = "GENERAZIONE E DISTRIBUZIONE ENERGETICA",
  details = {
    "Produzione generatore: 2.440 kWh/giorno",
    "Consumo pubblico:      2.203 kWh/giorno",
    "Banda perdita legacy:     41 kWh/giorno",
    "",
    "Nessun rischio brownout pubblico questo turno.",
    "Una spesa inspiegabile minore persiste sulle linee dismesse dell'annesso.",
  }
}

data_it.systems["air"] = {
  name = "FILTRAZIONE E CIRCOLAZIONE ARIA",
  details = {
    "CO2 media:          0,09%",
    "O2 media:           20,3%",
    "Riserva depuratori: 13 giorni al tasso di sostituzione attuale",
    "",
    "Il ramo dormiente AF-A17 continua a consumare materiale filtrante sopra la previsione di inattivita'.",
    "Il residuo e' coerente con aria vissuta, non condutture morte.",
  }
}

data_it.systems["population"] = {
  name = "REGISTRO DELLA POPOLAZIONE",
  details = {
    "Totale registro pubblico:  2.146",
    "Deriva checksum notturna:     64 foglie nascoste",
    "Integrita' del registro:   compromessa da regola di soppressione",
    "",
    "I numeri visibili restano internamente coerenti.",
    "Questo non li rende veri.",
  }
}

data_it.systems["external"] = {
  name = "SENSORI ESTERNI E ACCESSO AL POZZO",
  details = {
    "West Mast 4: segnale intermittente sotto maschera di soppressione D-DAWN-4",
    "Buffer pacchetti superficie: presente ma degradato",
    "Servo pozzo principale: corrente di heartbeat rilevata su linea dismessa",
    "",
    "Dottrina pubblica: superficie uniformemente letale",
    "Telemetria osservata: non costantemente letale in ogni intervallo",
    "",
    "> ALLERTA: INC-7322 - finestra di fase esterna rilevata prima della chiusura forzata del canale",
  }
}


return data_it
