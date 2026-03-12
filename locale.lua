local locale = {}

local current_lang = "en"

function locale.setLanguage(lang)
    current_lang = (lang == "it") and "it" or "en"
end

function locale.getLanguage()
    return current_lang
end

-- Flat lookup: locale.t("key") returns translated string
local strings = {}

strings.en = {
    -- Menu UI
    continue_session    = "CONTINUE SESSION",
    new_session         = "NEW SESSION",
    settings_label      = "SETTINGS",
    quit                = "QUIT",
    resume              = "RESUME",
    restart_session     = "RESTART SESSION",
    quit_to_title       = "QUIT TO TITLE",
    fullscreen          = "Fullscreen",
    post_effects        = "Post Effects",
    master_volume       = "Master Volume",
    ui_volume           = "UI Volume",
    ambient_volume      = "Ambient Volume",
    tension_volume      = "Tension Volume",
    text_speed          = "Text Speed",
    language            = "Language",
    setting_return      = "Return",
    on                  = "ON",
    off                 = "OFF",
    save_found          = "SAVE FOUND",
    no_save             = "NO SAVE FOUND",
    settings_help       = "← → adjust  ↑ ↓ navigate  ESC back",
    settings_panel      = "SETTINGS",
    settings_badge      = "ACTIVE",
    title_footer        = "Terminal Operating System — v4.7.1",
    title_prompt        = "Type HELP for available commands.",
    pause_badge         = "PAUSED",

    -- Boot sequence
    boot_hw_check       = "Hardware check.........",
    boot_loading        = "Loading ASHLINE OS v4.7.1...",
    boot_kernel         = "  Kernel modules.............. loaded",
    boot_terminal       = "  Terminal driver............. loaded",
    boot_security       = "  Security subsystem.......... loaded",
    boot_comms          = "  Communications layer........ loaded",
    boot_records        = "  Records interface........... loaded",
    boot_monitoring     = "  Monitoring subsystem........ loaded",
    boot_connecting     = "Connecting to SILO-NET...",
    boot_node_auth      = "  Node 31 authenticated.  Encryption: AES-MERIDIAN",
    boot_operator       = "  Operator:    ",
    boot_clearance      = "  Clearance:   ",
    boot_shift          = "  Shift:       ",
    boot_terminal_label = "  Terminal:    ",
    boot_alerts         = "  Active alerts:  ",
    boot_inbox          = "  Pending inbox:  ",
    boot_init           = "  Session initialized. Type HELP for available commands.",

    -- Terminal header
    hdr_operator        = "OPERATOR 31",
    hdr_alerts          = " ALERTS",
    hdr_inbox           = " INBOX",

    -- Commands: HELP
    cmd_available       = "  AVAILABLE COMMANDS",
    cmd_help_help       = "Show this help screen",
    cmd_help_tasks      = "List current investigation objectives",
    cmd_help_actions    = "Show currently available authorizations",
    cmd_help_status     = "Display system overview and pressure metrics",
    cmd_help_alerts     = "Show the active anomaly queue",
    cmd_help_inbox      = "View messages",
    cmd_help_read       = "Read a record (for example READ INC-7301)",
    cmd_help_read_msg   = "Read message number n from inbox",
    cmd_help_search     = "Search records by keyword",
    cmd_help_list       = "List records by type",
    cmd_help_personnel  = "View a personnel file",
    cmd_help_compare    = "Compare two records",
    cmd_help_inspect    = "Inspect water, power, air, population, or external",
    cmd_help_trace      = "Trace water, power, air, population, or external flow",
    cmd_help_override   = "Use a discovered override token",
    cmd_help_authorize  = "Execute an available action",
    cmd_help_deny       = "Deny an action without executing it",
    cmd_help_clear      = "Clear the terminal screen",
    cmd_help_logout     = "End the session",
    cmd_help_footer     = "  Use Tab for autocomplete. Up/Down for history. Page Up/Down to scroll.",

    -- Commands: TASKS
    cmd_objectives      = "  CURRENT OBJECTIVES",
    cmd_tasks_hint      = "  Use TASKS when the thread of the investigation gets messy.",

    -- Commands: ACTIONS
    cmd_actions_hdr     = "  AVAILABLE AUTHORIZATIONS",
    cmd_no_actions      = "  No authorizations currently available.",
    cmd_actions_hint    = "  Continue investigating. New authorizations emerge as evidence grows.",

    -- Commands: STATUS
    cmd_status_hdr      = "  SYSTEM STATUS",
    cmd_proof           = "  Proof gathered:      ",
    cmd_risk            = "  Audit risk:          ",
    cmd_strain          = "  Silo strain:         ",
    cmd_mercy           = "  Mercy score:         ",
    cmd_complicity      = "  Complicity score:    ",
    cmd_records_exam    = "  Records examined:    ",
    cmd_unread_msgs     = "  Unread messages:     ",
    cmd_status_hint     = "  Use TASKS when the thread of the investigation gets messy.",

    -- Commands: ALERTS
    cmd_alerts_hdr      = "  ACTIVE ANOMALIES",
    cmd_no_alerts       = "  No active anomalies.",

    -- Commands: READ
    cmd_classification  = "  Classification: ",
    cmd_date            = "  Date:           ",
    cmd_filed_by        = "  Filed by:       ",
    cmd_sector          = "  Sector:         ",
    cmd_related         = "  Related: ",
    cmd_no_record       = "  No record found with that identifier.",
    cmd_access_denied   = "  ACCESS DENIED",
    cmd_override_hint   = "  Continue investigating. Search for override tokens or related files.",

    -- Commands: SEARCH
    cmd_search_results  = "  SEARCH RESULTS: ",
    cmd_found           = " found)",
    cmd_no_results      = "  No results found.",
    cmd_search_hint     = "  Search requires a keyword. Example: SEARCH water",
    cmd_locked_label    = "[LOCKED - OVERRIDE REQUIRED]",

    -- Commands: LIST
    cmd_record_index    = "  RECORD INDEX",
    cmd_records_label   = " records)",
    cmd_locked          = "[LOCKED]",

    -- Commands: PERSONNEL
    cmd_personnel_file  = "  PERSONNEL FILE: ",
    cmd_name            = "  Name:       ",
    cmd_role            = "  Role:       ",
    cmd_sector_label    = "  Sector:     ",
    cmd_clearance       = "  Clearance:  ",
    cmd_level           = "Level ",
    cmd_status_label    = "  Status:     ",
    cmd_no_personnel    = "  No personnel file found with that identifier.",
    cmd_personnel_hint  = "  Usage: PERSONNEL <id>  Example: PERSONNEL CIV-0031",

    -- Commands: COMPARE
    cmd_comparison      = "  COMPARISON: ",
    cmd_vs              = " vs ",
    cmd_discrepancy     = "  +== DISCREPANCY ANALYSIS ===========================",
    cmd_discrepancy_end = "  +=================================================",
    cmd_no_connection   = "  No significant cross-reference detected between these records.",
    cmd_compare_hint    = "  Usage: COMPARE <id1> <id2>  Example: COMPARE INC-7301 MLOG-4488",
    cmd_compare_err     = "  Comparison requires two valid record IDs.",

    -- Commands: INSPECT
    cmd_inspect_hdr     = "  RECORD METADATA",
    cmd_type_label      = "  Type:           ",
    cmd_xrefs           = "  Cross-references:  ",
    cmd_keywords_label  = "  Keywords:       ",
    cmd_inspect_hint    = "  Usage: INSPECT <id>  Example: INSPECT INC-7301",
    cmd_sector_prefix   = "  Sector: ",
    cmd_status_prefix   = "  |  Status: ",

    -- Commands: TRACE
    cmd_trace_hdr       = "  RESOURCE TRACE: ",
    cmd_trace_hint      = "  Usage: TRACE <system>  Systems: water, power, air, population, external",
    cmd_trace_unknown   = "  Unknown system. Available: water, power, air, population, external",

    -- Commands: OVERRIDE
    cmd_override_token  = "  OVERRIDE TOKEN: ",
    cmd_access_reject   = "  ACCESS REJECTED",
    cmd_token_applied   = "  TOKEN ALREADY APPLIED",
    cmd_token_open      = "  The associated branch is already open on this terminal.",
    cmd_override_ok     = "  OVERRIDE ACCEPTED",
    cmd_unlocked_recs   = "  Unlocked records:",
    cmd_override_usage  = "  Usage: OVERRIDE <token>",

    -- Commands: INBOX
    cmd_inbox_hdr       = "  INBOX",
    cmd_messages_count  = " messages, ",
    cmd_unread_count    = " unread)",
    cmd_no_messages     = "  No messages in inbox.",

    -- Commands: AUTHORIZE
    cmd_auth_request    = "  AUTHORIZATION REQUEST: ",
    cmd_processing      = "  PROCESSING...",
    cmd_auth_confirmed  = "  === AUTHORIZATION CONFIRMED ===",
    cmd_no_action       = "  No available action with that identifier.",
    cmd_action_taken    = "  Action already executed.",
    cmd_auth_usage      = "  Usage: AUTHORIZE <action-id>  Example: AUTHORIZE ACT-101",

    -- Commands: DENY
    cmd_denial_logged   = "  DENIAL LOGGED: ",
    cmd_deny_usage      = "  Usage: DENY <action-id>  Example: DENY ACT-101",

    -- Commands: error
    cmd_unknown_pre     = "  ERROR: Unknown command '",
    cmd_unknown_post    = "'. Type HELP for available commands.",

    -- Commands: READ message
    cmd_message_label   = "  MESSAGE: ",
    cmd_from            = "  From:    ",
    cmd_subject         = "  Subject: ",
    cmd_priority        = "  Priority:",

    -- Game objectives
    obj_review_anomaly  = "Review the water anomaly report (READ INC-7301)",
    obj_search_records  = "Search the archive for related records (try SEARCH water)",
    obj_check_inbox     = "Check your inbox for messages (INBOX)",
    obj_compare_records = "Compare suspicious records (COMPARE <id1> <id2>)",
    obj_find_overrides  = "Search for override tokens in records and messages",
    obj_deeper_vault    = "Access deeper vault levels for classified documents",
    obj_check_personnel = "Check your own personnel file (PERSONNEL CIV-0031)",
    obj_trace_systems   = "Trace resource flows through silo systems (TRACE water)",
    obj_read_all_vault  = "Read all accessible vault records",
    obj_unlock_decision = "Gather enough evidence to unlock the final decision",
    obj_choose_ending   = "Use ACTIONS to see and AUTHORIZE your final decision",

    -- Trace outputs
    trace_water_source  = "  Source: Primary Aquifer / Sector 6",
    trace_water_output  = "  Total output: 11,940 L/day",
    trace_water_public  = "  |-- Public sectors: 11,102 L/day",
    trace_water_reserve = "  |-- Known reserve:    226 L/day",
    trace_water_a17     = "  |-- Retired branch A-17:",
    trace_water_draw    = "  |   +-- 612.4 L/day [UNDECLARED DRAW]",
    trace_water_curve   = "  |   +-- Curve smoothing indicates human interference",
    trace_power_source  = "  Source: Geothermal Stack / Sector 7",
    trace_power_public  = "  Public load: 2,203 kWh/day",
    trace_power_annex   = "  Legacy annex feeder loss: 41 kWh/day",
    trace_air_main      = "  Main scrubber loop nominal across public sectors.",
    trace_air_a17       = "  Branch AF-A17 tagged DORMANT but continues media consumption.",
    trace_air_residue   = "  Residue profile: cloth, skin, candle carbon, cooked starch.",
    trace_pop_public    = "  Public ledger total: 2,146",
    trace_pop_hidden    = "  Hidden mirror leaves: 64",
    trace_pop_tag       = "  Branch tag recovered: LANTERN",
    trace_ext_mast      = "  West Mast 4: dormant on public maps, heartbeat current on hidden line",
    trace_ext_mask      = "  Suppressor mask: D-DAWN-4",
    trace_ext_signal    = "  Recent event: clean-signal interval detected before forced channel closure",
    trace_ext_servo     = "  Shaft servo: maintained despite retirement order",
}

strings.it = {
    -- Menu UI
    continue_session    = "CONTINUA SESSIONE",
    new_session         = "NUOVA SESSIONE",
    settings_label      = "IMPOSTAZIONI",
    quit                = "ESCI",
    resume              = "RIPRENDI",
    restart_session     = "RIAVVIA SESSIONE",
    quit_to_title       = "TORNA AL TITOLO",
    fullscreen          = "Schermo Intero",
    post_effects        = "Effetti CRT",
    master_volume       = "Volume Principale",
    ui_volume           = "Volume Interfaccia",
    ambient_volume      = "Volume Ambiente",
    tension_volume      = "Volume Tensione",
    text_speed          = "Velocità Testo",
    language            = "Lingua",
    setting_return      = "Indietro",
    on                  = "SÌ",
    off                 = "NO",
    save_found          = "SALVATAGGIO TROVATO",
    no_save             = "NESSUN SALVATAGGIO",
    settings_help       = "← → regola  ↑ ↓ naviga  ESC indietro",
    settings_panel      = "IMPOSTAZIONI",
    settings_badge      = "ATTIVO",
    title_footer        = "Sistema Operativo Terminale — v4.7.1",
    title_prompt        = "Digita HELP per i comandi disponibili.",
    pause_badge         = "IN PAUSA",

    -- Boot sequence
    boot_hw_check       = "Verifica hardware.........",
    boot_loading        = "Caricamento ASHLINE OS v4.7.1...",
    boot_kernel         = "  Moduli kernel............... caricati",
    boot_terminal       = "  Driver terminale............ caricato",
    boot_security       = "  Sottosistema sicurezza...... caricato",
    boot_comms          = "  Livello comunicazioni....... caricato",
    boot_records        = "  Interfaccia documenti....... caricata",
    boot_monitoring     = "  Sottosistema monitoraggio... caricato",
    boot_connecting     = "Connessione a SILO-NET...",
    boot_node_auth      = "  Nodo 31 autenticato.  Crittografia: AES-MERIDIAN",
    boot_operator       = "  Operatore:   ",
    boot_clearance      = "  Abilitazione:",
    boot_shift          = "  Turno:       ",
    boot_terminal_label = "  Terminale:   ",
    boot_alerts         = "  Avvisi attivi:  ",
    boot_inbox          = "  Messaggi in arrivo:  ",
    boot_init           = "  Sessione inizializzata. Digita HELP per i comandi disponibili.",

    -- Terminal header
    hdr_operator        = "OPERATORE 31",
    hdr_alerts          = " AVVISI",
    hdr_inbox           = " IN ARRIVO",

    -- Commands: HELP
    cmd_available       = "  COMANDI DISPONIBILI",
    cmd_help_help       = "Mostra questa schermata di aiuto",
    cmd_help_tasks      = "Elenca gli obiettivi dell'indagine",
    cmd_help_actions    = "Mostra le autorizzazioni disponibili",
    cmd_help_status     = "Visualizza stato del sistema e indicatori",
    cmd_help_alerts     = "Mostra la coda di anomalie attive",
    cmd_help_inbox      = "Visualizza i messaggi",
    cmd_help_read       = "Leggi un documento (esempio: READ INC-7301)",
    cmd_help_read_msg   = "Leggi il messaggio numero n dalla posta",
    cmd_help_search     = "Cerca documenti per parola chiave",
    cmd_help_list       = "Elenca documenti per categoria",
    cmd_help_personnel  = "Visualizza un fascicolo personale",
    cmd_help_compare    = "Confronta due documenti",
    cmd_help_inspect    = "Ispeziona acqua, energia, aria, popolazione o esterno",
    cmd_help_trace      = "Traccia flusso acqua, energia, aria, popolazione o esterno",
    cmd_help_override   = "Usa un token di override scoperto",
    cmd_help_authorize  = "Esegui un'autorizzazione disponibile",
    cmd_help_deny       = "Nega un'azione senza eseguirla",
    cmd_help_clear      = "Pulisci lo schermo del terminale",
    cmd_help_logout     = "Termina la sessione",
    cmd_help_footer     = "  Usa Tab per completamento. Su/Giù per cronologia. PagSu/PagGiù per scorrere.",

    -- Commands: TASKS
    cmd_objectives      = "  OBIETTIVI CORRENTI",
    cmd_tasks_hint      = "  Usa TASKS quando il filo dell'indagine diventa confuso.",

    -- Commands: ACTIONS
    cmd_actions_hdr     = "  AUTORIZZAZIONI DISPONIBILI",
    cmd_no_actions      = "  Nessuna autorizzazione attualmente disponibile.",
    cmd_actions_hint    = "  Continua a indagare. Nuove autorizzazioni emergono con le prove raccolte.",

    -- Commands: STATUS
    cmd_status_hdr      = "  STATO DEL SISTEMA",
    cmd_proof           = "  Prove raccolte:      ",
    cmd_risk            = "  Rischio audit:       ",
    cmd_strain          = "  Tensione del silo:   ",
    cmd_mercy           = "  Punteggio clemenza:  ",
    cmd_complicity      = "  Punteggio complicità:",
    cmd_records_exam    = "  Documenti esaminati: ",
    cmd_unread_msgs     = "  Messaggi non letti:  ",
    cmd_status_hint     = "  Usa TASKS quando il filo dell'indagine diventa confuso.",

    -- Commands: ALERTS
    cmd_alerts_hdr      = "  ANOMALIE ATTIVE",
    cmd_no_alerts       = "  Nessuna anomalia attiva.",

    -- Commands: READ
    cmd_classification  = "  Classificazione: ",
    cmd_date            = "  Data:            ",
    cmd_filed_by        = "  Registrato da:   ",
    cmd_sector          = "  Settore:         ",
    cmd_related         = "  Correlati: ",
    cmd_no_record       = "  Nessun documento trovato con questo identificativo.",
    cmd_access_denied   = "  ACCESSO NEGATO",
    cmd_override_hint   = "  Continua a indagare. Cerca token di override o file correlati.",

    -- Commands: SEARCH
    cmd_search_results  = "  RISULTATI RICERCA: ",
    cmd_found           = " trovati)",
    cmd_no_results      = "  Nessun risultato trovato.",
    cmd_search_hint     = "  La ricerca richiede una parola chiave. Esempio: SEARCH water",
    cmd_locked_label    = "[BLOCCATO - OVERRIDE RICHIESTO]",

    -- Commands: LIST
    cmd_record_index    = "  INDICE DOCUMENTI",
    cmd_records_label   = " documenti)",
    cmd_locked          = "[BLOCCATO]",

    -- Commands: PERSONNEL
    cmd_personnel_file  = "  FASCICOLO PERSONALE: ",
    cmd_name            = "  Nome:       ",
    cmd_role            = "  Ruolo:      ",
    cmd_sector_label    = "  Settore:    ",
    cmd_clearance       = "  Abilitaz.:  ",
    cmd_level           = "Livello ",
    cmd_status_label    = "  Stato:      ",
    cmd_no_personnel    = "  Nessun fascicolo personale trovato con questo identificativo.",
    cmd_personnel_hint  = "  Uso: PERSONNEL <id>  Esempio: PERSONNEL CIV-0031",

    -- Commands: COMPARE
    cmd_comparison      = "  CONFRONTO: ",
    cmd_vs              = " vs ",
    cmd_discrepancy     = "  +== ANALISI DISCREPANZE ============================",
    cmd_discrepancy_end = "  +=================================================",
    cmd_no_connection   = "  Nessun riferimento incrociato significativo rilevato tra questi documenti.",
    cmd_compare_hint    = "  Uso: COMPARE <id1> <id2>  Esempio: COMPARE INC-7301 MLOG-4488",
    cmd_compare_err     = "  Il confronto richiede due identificativi validi.",

    -- Commands: INSPECT
    cmd_inspect_hdr     = "  METADATI DOCUMENTO",
    cmd_type_label      = "  Tipo:           ",
    cmd_xrefs           = "  Rif. incrociati:   ",
    cmd_keywords_label  = "  Parole chiave:  ",
    cmd_inspect_hint    = "  Uso: INSPECT <id>  Esempio: INSPECT INC-7301",
    cmd_sector_prefix   = "  Settore: ",
    cmd_status_prefix   = "  |  Stato: ",

    -- Commands: TRACE
    cmd_trace_hdr       = "  TRACCIAMENTO RISORSA: ",
    cmd_trace_hint      = "  Uso: TRACE <sistema>  Sistemi: water, power, air, population, external",
    cmd_trace_unknown   = "  Sistema sconosciuto. Disponibili: water, power, air, population, external",

    -- Commands: OVERRIDE
    cmd_override_token  = "  TOKEN DI OVERRIDE: ",
    cmd_access_reject   = "  ACCESSO RESPINTO",
    cmd_token_applied   = "  TOKEN GIÀ APPLICATO",
    cmd_token_open      = "  Il ramo associato è già aperto su questo terminale.",
    cmd_override_ok     = "  OVERRIDE ACCETTATO",
    cmd_unlocked_recs   = "  Documenti sbloccati:",
    cmd_override_usage  = "  Uso: OVERRIDE <token>",

    -- Commands: INBOX
    cmd_inbox_hdr       = "  POSTA IN ARRIVO",
    cmd_messages_count  = " messaggi, ",
    cmd_unread_count    = " non letti)",
    cmd_no_messages     = "  Nessun messaggio nella posta in arrivo.",

    -- Commands: AUTHORIZE
    cmd_auth_request    = "  RICHIESTA AUTORIZZAZIONE: ",
    cmd_processing      = "  ELABORAZIONE...",
    cmd_auth_confirmed  = "  === AUTORIZZAZIONE CONFERMATA ===",
    cmd_no_action       = "  Nessuna azione disponibile con questo identificativo.",
    cmd_action_taken    = "  Azione già eseguita.",
    cmd_auth_usage      = "  Uso: AUTHORIZE <id-azione>  Esempio: AUTHORIZE ACT-101",

    -- Commands: DENY
    cmd_denial_logged   = "  RIFIUTO REGISTRATO: ",
    cmd_deny_usage      = "  Uso: DENY <id-azione>  Esempio: DENY ACT-101",

    -- Commands: error
    cmd_unknown_pre     = "  ERRORE: Comando sconosciuto '",
    cmd_unknown_post    = "'. Digita HELP per i comandi disponibili.",

    -- Commands: READ message
    cmd_message_label   = "  MESSAGGIO: ",
    cmd_from            = "  Da:        ",
    cmd_subject         = "  Oggetto:   ",
    cmd_priority        = "  Priorità: ",

    -- Game objectives
    obj_review_anomaly  = "Esamina il rapporto anomalia idrica (READ INC-7301)",
    obj_search_records  = "Cerca nell'archivio documenti correlati (prova SEARCH water)",
    obj_check_inbox     = "Controlla la posta per messaggi (INBOX)",
    obj_compare_records = "Confronta documenti sospetti (COMPARE <id1> <id2>)",
    obj_find_overrides  = "Cerca token di override nei documenti e messaggi",
    obj_deeper_vault    = "Accedi a livelli più profondi del vault per documenti classificati",
    obj_check_personnel = "Controlla il tuo fascicolo personale (PERSONNEL CIV-0031)",
    obj_trace_systems   = "Traccia i flussi di risorse nei sistemi del silo (TRACE water)",
    obj_read_all_vault  = "Leggi tutti i documenti accessibili nel vault",
    obj_unlock_decision = "Raccogli prove sufficienti per sbloccare la decisione finale",
    obj_choose_ending   = "Usa ACTIONS per vedere e AUTHORIZE la tua decisione finale",

    -- Trace outputs
    trace_water_source  = "  Sorgente: Acquifero Primario / Settore 6",
    trace_water_output  = "  Produzione totale: 11.940 L/giorno",
    trace_water_public  = "  |-- Settori pubblici: 11.102 L/giorno",
    trace_water_reserve = "  |-- Riserva nota:       226 L/giorno",
    trace_water_a17     = "  |-- Ramo dismesso A-17:",
    trace_water_draw    = "  |   +-- 612,4 L/giorno [PRELIEVO NON DICHIARATO]",
    trace_water_curve   = "  |   +-- Livellamento curva indica interferenza umana",
    trace_power_source  = "  Sorgente: Pila Geotermica / Settore 7",
    trace_power_public  = "  Carico pubblico: 2.203 kWh/giorno",
    trace_power_annex   = "  Dispersione alimentatore annesso: 41 kWh/giorno",
    trace_air_main      = "  Circuito depuratore principale nominale nei settori pubblici.",
    trace_air_a17       = "  Ramo AF-A17 etichettato DORMIENTE ma continua consumo materiali.",
    trace_air_residue   = "  Profilo residui: tessuto, pelle, carbonio candela, amido cotto.",
    trace_pop_public    = "  Registro pubblico totale: 2.146",
    trace_pop_hidden    = "  Rami specchio nascosti: 64",
    trace_pop_tag       = "  Tag ramo recuperato: LANTERN",
    trace_ext_mast      = "  Traliccio Ovest 4: dormiente su mappe pubbliche, corrente battito su linea nascosta",
    trace_ext_mask      = "  Maschera soppressore: D-DAWN-4",
    trace_ext_signal    = "  Evento recente: intervallo segnale pulito rilevato prima della chiusura forzata canale",
    trace_ext_servo     = "  Servo albero: mantenuto nonostante ordine di dismissione",
}

function locale.t(key)
    local pool = strings[current_lang] or strings.en
    return pool[key] or strings.en[key] or key
end

-- Comparison analyses (Italian versions)
local comparisons_it = {
    ["INC-7301:MLOG-WTR-4408"] = {
        "Il registro incidenti dice che il ramo dismesso A-17 dovrebbe essere secco.",
        "Il registro manutenzione dice che il ramo necessitava di un livellamento manuale della pressione.",
        "",
        "Non è un comportamento da perdita. È occultamento.",
    },
    ["INC-7290:MLOG-MED-1220"] = {
        "Scorte mediche svanite nel codice di un asilo nido dismesso.",
        "Il registro di riapprovvigionamento mostra il ritiro col badge di Elsa Kell, anni dopo la sua morte dichiarata.",
        "",
        "O il badge è clonato o Elsa Kell non è mai stata dove il registro dice.",
    },
    ["INC-7288:WIT-177-A"] = {
        "L'automazione del registro ha trovato 64 hash nascosti.",
        "Il memo di Jonas Bell dice che il ramo viene attivamente curato e raccolto.",
        "",
        "Non si tratta di corruzione. È manutenzione di una menzogna.",
    },
    ["INC-6550:INC-6130"] = {
        "Il rapporto sugli incidenti descrive Lantern come destabilizzatori.",
        "Il riepilogo sabotaggio non riesce a dimostrare un piano con vittime di massa.",
        "",
        "I poteri d'emergenza sembrano essere stati giustificati su prove incomplete.",
    },
    ["INC-6402:DIR-8890"] = {
        "INC-6402 descrive un trasferimento d'emergenza antincendio di 48 ore.",
        "DIR-8890 converte le stesse persone in una popolazione nascosta permanente.",
        "",
        "L'emergenza temporanea era sempre destinata a diventare sparizione.",
    },
    ["DIR-4980:WIT-084-A"] = {
        "Il linguaggio della direttiva definisce accettabile l'esposizione dei minori al calm-ash.",
        "La Dott.ssa Sera descrive il risultato come danno allo sviluppo e perdita del senso del tempo.",
        "",
        "La politica è eufemismo clinico avvolto attorno al danno ai minori.",
    },
    ["MLOG-ANN-0007:WIT-777-A"] = {
        "Il test di potenza dell'ingresso registra 64 cuccette e una striscia adibita ad aula.",
        "L'ultimo appunto dell'insegnante documenta lezioni tenute in un blocco chiuso.",
        "",
        "I bambini vengono istruiti. Qualcuno intende che questo duri.",
    },
    ["DIR-9991:INC-6120"] = {
        "Il protocollo di liquidazione specifica un impulso di cloro in 6 minuti.",
        "Il rapporto sulle condizioni superficiali conferma finestre con aria respirabile.",
        "",
        "Esiste un'uscita. L'alternativa prescelta è la morte.",
    },
    ["INC-6200:MLOG-SEC-6001"] = {
        "Il conteggio del registro di nascita non corrisponde alla capacità genitoriale dichiarata.",
        "Le annotazioni della telecamera mostrano registrazioni in loop durante le ore di osservazione.",
        "",
        "Qualcuno sta deliberatamente nascondendo quanti bambini ci sono.",
    },
    ["INC-5820:DIR-1010"] = {
        "Il protocollo di selezione ha ordinato la popolazione per obbedienza politica.",
        "Lo statuto garantisce rifugio ai cittadini indipendentemente dall'affiliazione.",
        "",
        "Lo statuto è stato tradito prima che il sigillo si chiudesse.",
    },
    ["WIT-099-A:INC-6550"] = {
        "Il memoriale di Sorn chiede due volte un processo legale.",
        "Il rapporto sugli incidenti non menziona nemmeno un procedimento.",
        "",
        "La legge non è stata violata. È stata semplicemente omessa.",
    },
    ["MLOG-PWR-4410:MLOG-WTR-4408"] = {
        "L'alimentazione verso un blocco abitativo dismesso corrisponde a una curva di consumo umano.",
        "L'acqua verso lo stesso blocco mostra livellamento manuale.",
        "",
        "Due sistemi indipendenti confermano occupazione. Non è un guasto.",
    },
    ["MLOG-FOOD-4415:DIR-4012"] = {
        "Le razioni CANTEEN-ZERO sono calibrate a 1.600 kcal — dieta di sussistenza.",
        "La direttiva 4012 autorizza 'allocazione minima' per gruppi in quarantena.",
        "",
        "Sessantaquattro persone sopravvivono con una dieta progettata per controllare, non nutrire.",
    },
    ["MLOG-SEC-4420:INC-6402"] = {
        "Movimento notturno nell'Asse d'Accesso 3, mai indagato.",
        "INC-6402 ha usato lo stesso corridoio come percorso di trasferimento d'emergenza 11 anni fa.",
        "",
        "Qualcuno sta ancora usando la via di fuga d'emergenza. Ogni notte.",
    },
    ["WIT-555-A:DIR-4980"] = {
        "Elsa Kell descrive la calma dei bambini come innaturale.",
        "DIR-4980 descrive l'effetto come 'attenuazione cognitiva accettabile.'",
        "",
        "Il linguaggio istituzionale è progettato per far sembrare il danno routine.",
    },
    ["DIR-5050:DIR-9991"] = {
        "DIR-5050 concede autorizzazione d'emergenza per sterilizzare A-17 in caso di esposizione.",
        "DIR-9991 specifica l'impulso di cloro come vettore.",
        "",
        "L'insieme forma un protocollo di esecuzione completo, mascherato da procedura di sicurezza.",
    },
    ["INC-6410:WIT-308-B"] = {
        "L'analisi di Sera dice che il calm-ash sopprime la formazione dei ricordi a lungo termine.",
        "L'osservazione dell'insegnante nota che i bambini non riescono a ricordare le lezioni del giorno prima.",
        "",
        "Il programma educativo esiste in un edificio dove la chimica rende impossibile l'apprendimento.",
    },
    ["WIT-VEY-001:DIR-8890"] = {
        "L'appunto di Vey mostra rimorso per il costo umano della soppressione.",
        "DIR-8890 porta la firma di Vey come autorità che ordina.",
        "",
        "Il rimorso è arrivato dopo la firma. L'ordine è rimasto.",
    },
    ["INC-7295:INC-7301"] = {
        "Due anomalie con mesi di distanza segnalano lo stesso ramo come morto.",
        "Entrambe mostrano consumo attivo su una linea che dovrebbe essere scarica.",
        "",
        "La menzogna è coerente. La verità filtra attraverso i numeri.",
    },
    ["INC-7300:MLOG-ARC-0902"] = {
        "L'anomalia di integrità ha trovato rami non indicizzati nascosti nella struttura dell'archivio.",
        "Il rapporto del mirror conferma che i rami non indicizzati vengono ancora aggiornati.",
        "",
        "Qualcuno mantiene attivamente dati che ufficialmente non esistono.",
    },
    ["INC-7310:INC-7288"] = {
        "Il daemon dell'archivio è stato soppresso 16.071 volte in 11 anni.",
        "L'anomalia del registro mostra i 64 hash nascosti che il daemon continua a trovare.",
        "",
        "Il sistema sa la verità. La direttiva è che non la dica.",
    },
    ["MLOG-ANN-0012:MLOG-ANN-0018"] = {
        "Il registro d'ingresso specifica 64 cuccette e un'aula improvvisata.",
        "Il registro nascite elenca 19 bambini nati dopo il sigillo.",
        "",
        "L'annesso non è solo una prigione. È un mondo intero, sigillato e dimenticato.",
    },
    ["MLOG-ANN-0007:MLOG-ANN-0012"] = {
        "Il test di potenza mostra configurazione a blocco di vita con 64 cuccette.",
        "Il registro d'ingresso conferma che 45 persone sono entrate e mai uscite.",
        "",
        "L'infrastruttura fu costruita prima delle proteste. Anticipavano la necessità.",
    },
    ["WIT-VEY-002:DIR-9104"] = {
        "L'appunto privato di Vey esprime terrore per ciò che la dottrina richiede.",
        "La dottrina stessa tratta la clemenza come uno strumento da razionare.",
        "",
        "La persona che ha scritto la politica è terrorizzata dalla propria creazione.",
    },
    ["MLOG-EXT-4405:INC-6120"] = {
        "Il registro esterno mostra che il Traliccio 4 ha captato segnali puliti da pochi mesi.",
        "INC-6120 conferma finestre con aria respirabile sulla superficie.",
        "",
        "Due fonti indipendenti convergono: la superficie non è uniformemente fatale.",
    },
    ["DIR-9200:DIR-9991"] = {
        "La Direttiva Cenere estende il calm-ash a tutti i sistemi idrici del silo.",
        "La contingenza di liquidazione ucciderebbe le stesse persone appena sedate.",
        "",
        "Le due direttive insieme formano un sistema: silenziare per controllare, uccidere se necessario.",
    },
    ["INC-7295:MLOG-PWR-4410"] = {
        "L'anomalia del collettore indica consumo nel presunto vuoto.",
        "Il registro energetico conferma un'alimentazione attiva alla stessa struttura dismessa.",
        "",
        "L'alimentazione è stata mantenuta deliberatamente. Non è una svista.",
    },
    ["WIT-308-B:WIT-777-A"] = {
        "L'insegnante osservatore dice che i bambini non trattengono le lezioni.",
        "L'ultima insegnante dice che i bambini chiedono delle stelle.",
        "",
        "Ogni lezione viene impartita sapendo che sarà dimenticata entro sera.",
    },
    ["MLOG-CAF-3001:MLOG-FOOD-4415"] = {
        "La tendenza del refettorio mostra che le razioni pubbliche calano dell'8% in 6 anni.",
        "Le razioni CANTEEN-ZERO sono un livello di sussistenza separato: 1.600 kcal.",
        "",
        "Due sistemi alimentari paralleli. Quello nascosto taglia di più anno dopo anno.",
    },
    ["INC-MOR-2071:MLOG-POP-2071"] = {
        "I punteggi di morale identici al centesimo per quattro trimestri consecutivi.",
        "I tassi di sterilizzazione volontaria sono quadruplicati nello stesso periodo.",
        "",
        "Una popolazione docile che cessa spontaneamente di riprodursi.",
        "O il sondaggio sul morale sta mentendo, o l'acqua sta funzionando.",
    },
    ["MLOG-SHIFT-7140:INC-ARC-7340"] = {
        "L'handover del turno riporta 4.018 turni consecutivi senza anomalie.",
        "Il log di audit mostra che ogni tua ricerca viene registrata in tempo reale.",
        "",
        "Nessuna anomalia viene registrata perché il sistema che le registra è il sistema che le nasconde.",
    },
    ["WIT-ANON-001:MLOG-SHIFT-7140"] = {
        "La nota anonima avverte: l'operatore viene ruotato ogni 14 mesi.",
        "Il log del turno conferma sei operatori precedenti con una permanenza media di 14,2 mesi.",
        "",
        "Sei a 13,7 mesi. Qualunque cosa sia successa a quelli prima di te, sta per succedere a te.",
    },
    ["INC-MAINT-0088:MLOG-ANN-0007"] = {
        "Undici anni di rapporti di manutenzione identici: 'sigillato, nessun accesso richiesto.'",
        "Il test di potenza dell'annesso mostra un blocco abitativo attivo dietro quel sigillo.",
        "",
        "L'ispettore riporta nulla perché il modulo non ha un campo per 'persone dietro il muro.'",
    },
    ["MLOG-PER-0031:DIR-ASSIGN-0031"] = {
        "La tua valutazione del personale nota 'legame familiare con l'evento CL-2060.'",
        "L'ordine di assegnazione rivela che Drenn ti ha specificamente richiesto per il turno di notte.",
        "",
        "Non sei qui per caso. Qualcuno voleva che tu trovassi questo.",
    },
    ["MLOG-ANN-0025:WIT-MIRA-001"] = {
        "Il manifesto dei detenuti elenca VOSS, MIRA come A17-22 sotto sedazione.",
        "Il frammento di lavagna di Mira mostra che sta provando a ricordare il tuo nome.",
        "",
        "Tua sorella è viva. Non ti ricorda. Ti sta cercando senza sapere chi cerca.",
    },
    ["MLOG-SEC-0031:INC-ARC-7340"] = {
        "Il fascicolo di osservazione della sicurezza ti monitora dal primo giorno dell'incarico.",
        "Il log di audit registra ogni tua ricerca in tempo reale.",
        "",
        "Due sistemi indipendenti ti osservano. Qualsiasi cosa tu faccia, qualcuno vede.",
    },
    ["DIR-ASSIGN-0031:MLOG-SEC-0031"] = {
        "Drenn ti ha assegnato qui; Ash ti ha monitorato fin dall'inizio.",
        "Il fascicolo di sicurezza annota 'tolleranza estesa' come direttiva.",
        "",
        "Qualcuno ti ha messo qui apposta. Qualcun altro ti ha permesso di restare.",
        "La domanda è se lavorano insieme o uno contro l'altra.",
    },
    ["WIT-MIRA-001:DIR-4980"] = {
        "Il frammento di lavagna di Mira mostra frammentazione della memoria e confusione d'identità.",
        "La direttiva sul calm-ash elenca la 'appiattimento della memoria' come effetto atteso.",
        "",
        "Tua sorella è il risultato previsto della politica. Il danno è la funzionalità, non il difetto.",
    },
    ["MLOG-PER-0031:MLOG-ANN-0025"] = {
        "Il tuo fascicolo personale menziona un 'legame familiare' con CL-2060.",
        "Il manifesto dei detenuti elenca Mira Voss, stessa data dell'evento.",
        "",
        "Il legame è tua sorella. Ti è stata nascosta per 11 anni.",
    },
    ["MLOG-PER-0031:MLOG-SEC-0031"] = {
        "La tua valutazione del personale riporta 'nessun indicatore di rischio.'",
        "Il tuo fascicolo di sicurezza nota sorveglianza dal primo giorno.",
        "",
        "Sei stato classificato come sicuro dalla stessa gente che non si è mai fidata di te.",
    },
    ["WIT-KELL-001:WIT-777-A"] = {
        "Il diario di Elsa Kell descrive la vita quotidiana in A-17 con pazienza esausta.",
        "L'ultimo appunto dell'insegnante documenta una lezione interrotta da un tracollo infantile.",
        "",
        "Due donne mantengono un mondo che non avrebbe mai dovuto esistere.",
        "La forza che ci vuole per insegnare geografia a bambini che non hanno mai visto una mappa è indicibile.",
    },
    ["WIT-KELL-001:MLOG-ANN-0025"] = {
        "Il diario di Kell descrive 64 persone per nome, non per numero di detenuto.",
        "Il manifesto li elenca come codici alfanumerici con stati di conformità.",
        "",
        "Sono le stesse persone. Un documento le vede. L'altro le cancella.",
    },
    ["INC-MOR-2071:INC-ARC-7340"] = {
        "I punteggi di morale sono identici al centesimo. Ogni trimestre. Ogni settore.",
        "Le tue stesse ricerche vengono registrate e tracciate in tempo reale.",
        "",
        "Persino il modo in cui il silo misura la felicità è una menzogna sorvegliata.",
    },
    ["MLOG-POP-2071:DIR-4980"] = {
        "La sterilizzazione volontaria è quadruplicata da quando il calm-ash è nel sistema idrico.",
        "Il calm-ash fu progettato per sedare i detenuti, non la popolazione generale.",
        "",
        "L'additivo potrebbe aver già oltrepassato il suo contenimento.",
        "Il silo si sta facendo a se stesso ciò che la direttiva aveva fatto all'annesso.",
    },
}

function locale.getComparison(id1, id2)
    if current_lang ~= "it" then return nil end
    local key = id1 .. ":" .. id2
    local rkey = id2 .. ":" .. id1
    return comparisons_it[key] or comparisons_it[rkey]
end

-- Language display names
function locale.getLanguageDisplay()
    if current_lang == "it" then return "ITALIANO" end
    return "ENGLISH"
end

function locale.getLanguageValues()
    return {"en", "it"}
end

function locale.getLanguageDisplayValue(val)
    if val == "it" then return "ITALIANO" end
    return "ENGLISH"
end

return locale
