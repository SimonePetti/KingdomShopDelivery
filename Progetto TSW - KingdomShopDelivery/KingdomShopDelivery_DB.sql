CREATE SCHEMA KingdomShopDelivery_DB;
USE KingdomShopDelivery_DB;

CREATE TABLE Utente(
ID_Utente INT AUTO_INCREMENT PRIMARY KEY,
Nome VARCHAR(100) NOT NULL,
Cognome VARCHAR(100) NOT NULL,
Email VARCHAR(100) NOT NULL UNIQUE,
`Password` CHAR(128) NOT NULL,
Tipo VARCHAR(7) NOT NULL,
PrefissoTelefono VARCHAR(4),
NumeroTelefono VARCHAR(15),
DataRegistrazione TIMESTAMP DEFAULT CURRENT_TIMESTAMP() NOT NULL,
CHECK(Tipo = "admin" or Tipo = "utente")
);

CREATE TABLE Indirizzo(
ID_Indirizzo INT AUTO_INCREMENT PRIMARY KEY,
Utente INT REFERENCES Utente(ID_Utente) ON UPDATE CASCADE ON DELETE CASCADE,
Paese VARCHAR(100) NOT NULL,
Provincia VARCHAR(100) NOT NULL,
Citta VARCHAR(100) NOT NULL,
Via VARCHAR(100) NOT NULL,
CAP CHAR(5) NOT NULL,
Civico VARCHAR(5) NOT NULL,
Nome VARCHAR(100) NOT NULL,
Cognome VARCHAR(100) NOT NULL,
Tipo VARCHAR(25) NOT NULL,
DataInserimento TIMESTAMP DEFAULT CURRENT_TIMESTAMP() NOT NULL,
CHECK(Tipo = "Spedizione" OR Tipo = "Fatturazione" OR Tipo = "Spedizione-Fatturazione")
);

CREATE TABLE Carta(
ID_Carta INT AUTO_INCREMENT PRIMARY KEY,
Utente INT NOT NULL REFERENCES Utente(ID_Utente) ON UPDATE CASCADE ON DELETE CASCADE,
NumeroCarta VARCHAR(16) NOT NULL,
DataScadenza DATE NOT NULL,
CVV VARCHAR(4) NOT NULL,
NomeCompletoIntestatario VARCHAR(200) NOT NULL
);

CREATE TABLE Prodotto(
ID_Prodotto INT AUTO_INCREMENT PRIMARY KEY,
Nome VARCHAR(100) NOT NULL,
Marca VARCHAR(100) NOT NULL,
Descrizione VARCHAR(2000) NOT NULL,
Categoria VARCHAR(50) NOT NULL,
SottoCategoria VARCHAR(50) DEFAULT NULL,
Iva NUMERIC(5,2) NOT NULL,
Immagine LONGBLOB NOT NULL,
PrezzoMinimo NUMERIC(6,2) NOT NULL DEFAULT 0,
PrezzoMinimoEScontato BOOLEAN DEFAULT FALSE,
PrezzoInizialePrezzoMinimo NUMERIC(6,2) DEFAULT 0,
DataInserimento TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
Cancellato BOOLEAN DEFAULT FALSE,
CHECK(Iva >= 0 AND Iva <= 100.00),
CHECK(PrezzoMinimo >= 0 <= 9999.99)
);

CREATE TABLE Prodotto_Taglia(
ID_ProdottoTaglia INT AUTO_INCREMENT PRIMARY KEY,
Prodotto INT REFERENCES Prodotto(ID_Prodotto) ON UPDATE CASCADE ON DELETE CASCADE,
NomeTaglia VARCHAR(20) NOT NULL,
Prezzo NUMERIC(6,2) NOT NULL,
QuantitaDisponibile INT NOT NULL,
UNIQUE(NomeTaglia,Prodotto),
CHECK(Prezzo > 0 AND Prezzo <= 9999.99)
);

CREATE TABLE Sconto(
Prodotto INT PRIMARY KEY REFERENCES Prodotto(ID_Prodotto) ON UPDATE CASCADE ON DELETE CASCADE,
PercentualeSconto NUMERIC(5,2) NOT NULL,
DataInizio DATE NOT NULL,
DataFine DATE NOT NULL,
CHECK(DataInizio <= DataFine),
CHECK(PercentualeSconto > 0 AND PercentualeSconto < 100)
);

CREATE TABLE Wishlist(
Utente INT REFERENCES Utente(ID_Utente) ON UPDATE CASCADE ON DELETE CASCADE,
Prodotto INT REFERENCES Prodotto(ID_Prodotto) ON UPDATE CASCADE ON DELETE CASCADE,
DataInserimentoWishlist DATETIME DEFAULT NOW() NOT NULL,
PRIMARY KEY(Utente, Prodotto)
);

CREATE TABLE Carrello(
Utente INT REFERENCES Utente(ID_Utente) ON UPDATE CASCADE ON DELETE CASCADE,
ProdottoTaglia INT REFERENCES Prodotto_Taglia(ID_ProdottoTaglia) ON UPDATE CASCADE ON DELETE CASCADE,
Quantita INT NOT NULL,
DataInserimentoCarrello TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
PRIMARY KEY(Utente, ProdottoTaglia)
);

CREATE TABLE Acquisto(
ID_Acquisto INT AUTO_INCREMENT PRIMARY KEY,
Utente INT NOT NULL REFERENCES Utente(ID_Utente) ON UPDATE CASCADE ON DELETE CASCADE,
NomeCitofono VARCHAR(100) NOT NULL,
CognomeCitofono VARCHAR(100) NOT NULL,
Paese VARCHAR(100) NOT NULL,
Provincia VARCHAR(100) NOT NULL,
Citta VARCHAR(100) NOT NULL,
Via VARCHAR(100) NOT NULL,
CAP CHAR(5) NOT NULL,
Civico VARCHAR(5) NOT NULL,
DataAcquisto TIMESTAMP DEFAULT CURRENT_TIMESTAMP() NOT NULL,
DataConsegna TIMESTAMP DEFAULT NULL,
NoteSpedizione VARCHAR(500) DEFAULT NULL
);

CREATE TABLE Acquisto_Dettaglio(
Acquisto INT REFERENCES Acquisto(ID_Acquisto) ON UPDATE CASCADE ON DELETE CASCADE,
ProdottoTaglia INT REFERENCES Prodotto_Taglia(ID_ProdottoTaglia) ON UPDATE CASCADE ON DELETE CASCADE,
QuantitaAcquistata INT NOT NULL,
PrezzoSingolo DECIMAL(6,2) NOT NULL,
Iva NUMERIC(5,2) NOT NULL,
PRIMARY KEY(Acquisto, ProdottoTaglia),
CHECK(PrezzoSingolo > 0 AND PrezzoSingolo <= 9999.99),
CHECK(Iva >= 0 AND Iva <= 100.00)
);

CREATE TABLE Fattura(
Acquisto INT PRIMARY KEY REFERENCES Acquisto(ID_Acquisto) ON UPDATE CASCADE ON DELETE CASCADE,
DataEmissione TIMESTAMP NOT NULL,
MetodoPagamento VARCHAR(20),
Note varchar(200),
InformazioniAzienda SMALLINT REFERENCES Azienda(ID_Azienda) ON UPDATE CASCADE ON DELETE CASCADE,
NomeCliente VARCHAR(100) NOT NULL,
CognomeCliente VARCHAR(100) NOT NULL,
PaeseCliente VARCHAR(100) NOT NULL,
ProvinciaCliente VARCHAR(100) NOT NULL,
CittaCliente VARCHAR(100) NOT NULL,
ViaCliente VARCHAR(100) NOT NULL,
CivicoCliente VARCHAR(5) NOT NULL,
CAPCliente CHAR(5) NOT NULL,
CHECK(MetodoPagamento = "Carta" OR MetodoPagamento = "Consegna")
);

CREATE TABLE Azienda(
ID_Azienda SMALLINT AUTO_INCREMENT PRIMARY KEY,
NomeAzienda VARCHAR(30) NOT NULL,
Paese VARCHAR(100) NOT NULL,
Provincia VARCHAR(100) NOT NULL,
Citta VARCHAR(100) NOT NULL,
Via VARCHAR(100) NOT NULL,
CAP CHAR(5) NOT NULL,
PartitaIVA VARCHAR(20) NOT NULL,
InformazioniValide BOOLEAN NOT NULL
);

-- Armatura
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, SottoCategoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Armatura da braccio 14 secolo","Warhorse","Quest'armatura fu realizzata nello stile della metà del XIV secolo, che sarebbe stata indossata dai Cavalieri e dagli uomini d'armi della guerra dei 100 anni tra Francia e Gran Bretagna. Le armature di questo periodo non erano disegni a piastra completa come gli stili del XV secolo, invece i pezzi dell'armatura a piastra dovevano essere indossati su un hauberk pieno e fornire ulteriore protezione per la parte anteriore del torace e delle braccia. L'imbracatura del braccio ha uno spessore di acciaio di 1,6 mm, che lo rende adatto alle battaglie di rievocazione.","Armatura","Braccia","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\armatura da braccio 14secolo.jpg"),"24.30","1998-12-02");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, SottoCategoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Armatura Gambe","Warhorse","Questa armatura delle gambe si ispira agli originali del XV secolo. Questa armatura a gamba protegge la coscia e il ginocchio e può essere facilmente combinata con armatura con gambe o indossato su un costume.","Armatura","Gambe","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\armatura-delle-gambe-markward.jpg"),"35.60","2002-02-22");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, SottoCategoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Armatura coscia XV secolo","Warhorse","Questa armatura delle gambe si basa su originali del XV secolo. Sono dotati di roundel in modo da proteggere anche l'interno del ginocchio. Queste parti del cablaggio possono essere attaccate alla gamba con cinturini in pelle.","Armatura","Gambe","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\armatura-per-coscia-del-xv-secolo.jpg"),"50.01","2020-08-11");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, SottoCategoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Bracciale Castel Coira","Warhorse","Si tratta di una replica del cablaggio braccio dall'armatura Coira dalla fine del 14 ° secolo. Il set è composto di imbracature braccio, gomito e poliziotti Vambraces per entrambe le braccia. Le parti possono essere fissati con tre cinghie sul lato interno.","Armatura","Braccia","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\bracciale-castel-coira.jpg"),"20.99","2004-04-12");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, SottoCategoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Corazza Medievale","Warhorse","Questa corazza è basata su originali medievali. Questo design standard è a basso prezzo e può essere combinato con quasi tutti i tipi di armature e indossato sopra diversi tipi di costumi. Questa corazza protegge il busto e l'addome. La corazza si estende sui fianchi e presenta un centro rialzato per l'estetica e il rinforzo. Il tutto ha i bordi rialzati ed è dotato di rivetti. Puoi fissarlo con cinghie di cuoio forti e di alta qualità. ","Armatura","Corazza","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\Corazza medievale.jpg"),"12.45","2023-04-20");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, SottoCategoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Corazza gotica","Warhorse","Questa bella corazza con piastra posteriore di corrispondenza e fiancali è fatta in bello stile del gotico tedesco (15 ° 16 ° secolo). L'armatura è riccamente decorato con motivi gotici che corrispondono a decorazioni in manoscritti, e creste parallele che rafforzano l'acciaio e, allo stesso tempo aspetto molto elegante. L'armatura è spesso di 1.2 mm, in modo che non è adatto per combattimenti reenactment. Si può indossare come un costume, durante il combattimento GRV o usarlo come decorazione. È quindi possibile combinare a piacere con un casco e armatura tappa della vostra scelta per creare un abito pieno di armature. Il cablaggio è composto da diversi piatti ed è molto flessibile e facile da indossare. È possibile regolare a misura con le cinghie di cuoio.","Armatura","Corazza","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\corazza-gotico-con-piastra-posteriore-e-fiancali.jpg"),"104.30","2012-08-20");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, SottoCategoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Cosciali Costali","Warhorse","Questa coppia di cuisses tedeschi è realizzata in stile tardo gotico. In generale, parecchi originali dei pezzi tardogotici del cablaggio si trovano in vari musei europei.","Armatura","Gambe","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\Cosciali Costolati.jpg"),"30.00","2000-04-10");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, SottoCategoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Elmo da Crociato","Warhorse","Questo casco apparve sul campo di battaglia nelle sue prime forme dal XIII secolo in poi. Si è rivelato essere un design vincente che è stato utilizzato per quasi tre secoli. Ha una terrificante vista fissa che migliora l'aspetto intimidatorio di un cavaliere in avvicinamento. Questo grande casco si ispira a una statua della cattedrale di olite, risalente alla metà del XIII secolo. Questi tipi di elmetti furono visti principalmente a metà del XIII secolo all'inizio del XIV secolo, come si può vedere in alcuni documenti come il Codice Manesse, la Bibbia Maziejowsky o i Cantigas. Il casco ha uno spessore di 1,6 mm e adatto per la rievocazione.","Armatura","Elmo","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\elmo crociato.jpg"),"23.99","1999/11/20");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, SottoCategoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Elmo Vikingo con cotta di maglia","Warhorse","Questo elmetto da spettacolo vichingo con cotta di maglia del periodo Vendel ha uno spessore di 1,6 mm ed è adatto per battaglie di rievocazione. Caschi come questo furono indossati tra il 550 e il 1066 e sono un bellissimo modello del primo medioevo basato su un originale di Valsgarde, in Svezia. Valsgarde era a soli 3 km da Gamla Uppsala, l'antico centro dei re svedesi e la fede pagana in Svezia. Il casco è costituito da piastre di acciaio che sono attaccate l'una all'altra con strisce di acciaio o Spangen. Il casco offre una buona protezione a naso, sopracciglia, testa e collo. L'aventail è costituito da una cotta di maglia di spessore e gli anelli hanno un diametro di 8 mm. L'interno del casco è foderato con imbottitura in cotone, che puoi adattare alle tue dimensioni. Puoi allacciare il casco con il cinturino in pelle.","Armatura","Elmo","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\elmo-da-spettacolo-vichingo-con-cotta-di-maglia.jpg"),"60.00","2009/02/16");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, SottoCategoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Elmo Vikingo con cotta di maglia","Warhorse","Si tratta di una replica di battaglia-ready di un casco vichingo che è stato trovato in un tumulo in Norvegia, l'originale è del 10 ° secolo. Il modello originale era rotto in nove pezzi e ricostruito e ora può essere visto a museo i Statens historika in Oslo. Gli occhiali proteggono entrambi gli occhi ed il naso, mentre il chainmail offre gola e il collo di una protezione flessibile.","Armatura","Elmo","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\elmo-vichingo-con-cotta-di-maglia.jpg"),"15.20","1990-09-13");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, SottoCategoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Gambeson","Warhorse","Questo insieme è costituito da un gambeson, braccia e Gambeson fiancali. Tutte le parti sono realizzate in tela di cotone con fodera di cotone e poliestere. Il gambeson è perfetto per creare LARP o caratteri Rievocazione. Inoltre, questo gambeson è naturalmente anche completamente funzionale e può essere indossato sotto armatura o separatamente. I singoli componenti possono anche essere utilizzati separatamente, perché si può fissare e sciogliere con lacci.","Armatura","Corazza","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\gambeson.jpg"),"80.99","2022-03-15");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, SottoCategoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Bracciali Vikinghi","Warhorse","Questa armatura è costituita da strisce metalliche inchiodate ad una superficie di pelle. Nel Medioevo questa era una forma relativamente a basso costo di protezione del braccio. I bracciali hanno una finitura e forgiato battuto a mano in modo che sembrano molto autentico. Sono decorate con rivetti. È possibile fissare per le braccia con fibbie. Perfetto per Viking rievocazione e GRV e per i caratteri vichinghe e abiti vichinghi. Ottimo anche per Vikings Cosplay.","Armatura","Braccia","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\vichingo-bracciali.jpg"),"29.34","2023-01-04");

-- Armi
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Arco Ricurvo","Warhorse","Questo arco ricurvo è fatto di legno fibra di vetro colorato. il suo arco flessibile ha una presa velluto. Le estremità di questo arco sono realizzati in legno lamellare. L'arco viene consegnato tra cui una corda e un bowcase.","Arma","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\ArcoRicurvo.jpg"),"207.99","2003-08-04");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Balestra Decorata","Warhorse","Nell'Europa medievale, le balestre erano usate nella guerra, specialmente dal XII secolo. L'arco lungo era più facile da lavorare, dato che la balestra impiegava molto tempo per ricaricare a causa del cranio che ricaricava le balestre pesanti. La balestra era vista come un'arma malvagia, e c'era un tempo in cui ai cristiani non era permesso uccidere altri cristiani con una balestra. Dopo il Medioevo, la balestra fu sostituita da armi da fuoco.","Arma","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\balestra-decorata.jpg"),"250.29","1991-04-06");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Sciabola Prussiana","Warhorse","Questo sciabola avviene dopo diversi 18? primi originali del 19 ° secolo. Essi sono chiamati anche i spadoni francesi. Sabres come questo sono stati utilizzati dai corazzieri prussiani.","Arma","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\sciabola-prussiana.jpg"),"109.00","2020-08-23");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Spada A Due Mani Tedesca","Warhorse","Questa spada è una replica delle spade tedesche a due mani che furono usate nel sedicesimo e diciassettesimo secolo. Prigionieri principalmente condannati che, in cambio di grazia, prestarono servizio negli eserciti del XVI secolo, combatterono con tali spade. Il loro compito era di spezzare le linee di picco nemiche con queste enormi spade. Un'opera pericolosa per la vita.","Arma","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\spada-a-due-mani-tedesca.jpg"),"103.20","2000-01-05");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Spada A Una Mano","Warhorse","Questa spada è stata utilizzata in molti dei paesi cristiani.L'acciaio dolce della spada è fatto da un pezzo di metallo per la sicurezza, solidità e comfort. L'impugnatura in legno è rivestito in pelle. La lunghezza della spada una mano è 97,5 cm con una larghezza massima di circa lama. 3,7 cm. La lunghezza della lama è di 77 centimetri.","Arma","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\spada-a-una-mano-medievale.jpg"),"124.20","2020-12-20");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Spada Vikinga","Warhorse","Questa spada vichinga è realizzata secondo gli originali del IX-X secolo. Spade come questa venivano usate in tutto il mondo vichingo. Questa spada pronta per la battaglia è adatta per combattimenti con la spada leggera. Questa spada è deliberatamente resa più corta della maggior parte delle repliche di spade vichinghe. Storicamente, le spade vichinghe erano generalmente di questa lunghezza.","Arma","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\spada-vichinga.jpg"),"100.99","2012-12-12");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Stocco","Warhorse","Nel Rinascimento la spada è diventata sempre più una seconda arma accanto la pistola o la pistola. Le lame sono diventati più sottile, una impugnatura è diventato più usuale di un cross-guardia e il punto era più nitida per buona accoltellamento.","Arma","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\stocco.jpg"),"133.20","2021-03-04");

-- Accessori
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Anello Celtico","Warhorse","Una riproduzione di un anello celtico con decorazione a nodo","Accessorio","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\AnelloCeltico.jpg"),"5.80","2004-02-15");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Collana Con Croce","Warhorse","Questo gioiello si basa sulla famosa croce di Cuthbert (640-670 d.C.). Cuthbert di Lindisfarne era un monaco della Northumbria che fu canonizzato dopo la sua morte. La croce mostra influenze dagli stili artistici anglosassoni e irlandesi.","Accessorio","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\collanaConCroce.jpg"),"6.90","2002/01/08");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Ciondolo Con Cinghiale Argentato","Warhorse","Questo bellissimo ciondolo si basa su una pietra Pictish inciso da Knocknagael.","Accessorio","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\CondoloCinghialeArgentato.jpg"),"3.50","2000-09-20");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Spilla Romana","Warhorse","Questa è una replica di una fibula romana. La balestra è in ottone, l'ago di acciaio. Misura 55 mm.","Accessorio","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\fibula-romana.jpg"),"12.39","1998-01-05");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Guanti Da Arcere","Warhorse","Questo guanto è ideale da indossare durante tiro con l'arco, per principianti e avanzati arcieri. E 'realizzato in stile medievale e sembra grande con una rievocazione o LARP vestito. Il guanto copre 3 dita, in modo che il pollice e il mignolo completa libertà di movimento.Le polso ha una cinghia per il fissaggio del guanto. Il guanto è in pelle scamosciata, che è flessibile e resistente. I bordi sono ordinatamente rifiniti con una cucitura. Il guanto è disponibile per la mano destra e sinistra e in 3 dimensioni. Misurare la distanza tra il dito indice e il mignolo sul palmo. Dimensione S: fino a 9 cm di larghezza, dimensione M: fino a 11 cm di larghezza, dimensione L: fino a 13 cm di larghezza.","Accessorio","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\guantiArcere.jpg"),"12.10","2001-03-01");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Guanti Da Spada","Warhorse","Questi guanti in pelle offrono comfort e controllo e sono disponibili in 4 taglie.Non sono perfetti solo per l'HEMA, ma sono perfetti anche per completare il tuo outfit medievale o rinascimentale.Le misurazioni vengono prese dal polso alla parte superiore del dito medio.","Accessorio","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\guanti-da-spadaccino.jpg"),"20.23","2005-12-05");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Spilla Celtica","Warhorse","Questa spilla è una replica di una spilla gallica scavata a Auvers-sur-Oise, Francia. La spilla è realizzata nello stile artistico del primo periodo di La Tène. Le date originali risalgono al IV secolo A.C.","Accessorio","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\spilla-celtica.jpg"),"2.30","2009-08-09");

-- Scudi
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Scudo Medievale","Warhorse","Questo scudo è battuto con l'acciaio per la sicurezza. Ha un'altezza di 64 cm sua larghezza ha 49 cm ed ha un peso di 2,2 kg.","Scudo","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\scudo-medievale-con-umbone.jpg"),"209.39","2003-02-23");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Scudo Normanno","Warhorse","Il cosiddetto scudo normanno è stato originariamente pensato per cavalieri, ma è diventato popolare tra i fanti perché proteggeva la zampa anteriore. Lo scudo è associato con i Normanni che sono raffigurati con questo tipo di scudo sulla Bayeux.","Scudo","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\scudo-normanno-rinforzato.jpg"),"190.23","2004-12-05");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Scudo Vikingo","Warhorse","Uno scudo forte vichingo in legno, ideale per Viking rievocazione, costumi Cosplay vichinghi e Viking. Questo scudo ha una bronzato umbone acciaio e manico in legno sul retro per tenere saldamente lo scudo nelle battaglie Rievocazione. I bordi dello scudo sono ricoperte di acciaio annerito e decorate con rivetti. Lo scudo è splendidamente dipinte con spirali nere e rosse.","Scudo","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\ScudoVichingo.jpg"),"176.23","1999-04-19");

-- Vestiti
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Abito Medievale Crema Rosso","Warhorse","Questo vestito è fatto di cotone. Nella parte anteriore, scollatura e maniche è ornata con fasce decorative che conferiscono al vestito un carattere sofisticato. Entrambe le parti hanno cavi per una vestibilità  ottimale.","Vestito","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\abito-medievale-crema-rosso.jpg"),"30.20","2010-03-03");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Caftano Vikingo","Warhorse","Il cappotto Birka proviene dall'era vichinga e prende il nome dall'insediamento storico di Birka in Svezia. Birka era un importante luogo di trading e gli indumenti trovati lì mostrano un'alta qualità nella produzione tessile. I Vichinghi erano noti per le loro abilità nella lavorazione e nei ricami tessili, spesso utilizzando materiali naturali come lana e lino. Il loro abbigliamento era funzionale ma anche decorativo, indicando l'alto stato di chi lo indossa nella società.","Vestito","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\caftano-vichingo.jpg"),"45.03","2023-12-20");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Corsetto Rinascimentale","Warhorse","Questo corsetto viene realizzato dopo diversi originali raffigurati nei dipinti rinascimentali. Questo corsetto è molto adatto per indossare una camicetta e una gonna in un festival medievale. Questo corsetto ha lacci nella parte anteriore con cui può essere regolato alla tua vestibilità.","Vestito","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\corsetto-rinascimentale-marrone.jpg"),"39.90","2008-02-08");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Kilt Scozzese","Warhorse","Il kilt scozzese è il simbolo nazionale dello scozzese sin dal XVIII secolo. Il kilt si è sviluppato dall'antico costume scozzese di leine, monaci e ionari.","Vestito","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\kilt-scozzese.jpg"),"49.10","2004-09-04");
INSERT INTO Prodotto (Nome, Marca, Descrizione, Categoria, Iva, Immagine, PrezzoMinimo, DataInserimento) VALUES ("Tunica Vikinga","Warhorse","Questa tunica è perfetta per gli abiti Viking LARP e Cosplay. La tunica è splendidamente decorata con pelle e rivetti, inoltre è ricamata. Ha maniche lunghe, è realizzato in robusto cotone e arriva all'incirca alle ginocchia. Questo design è ispirato ai Vichinghi Rusvik! La cintura sulle immagini è venduta separatamente.","Vestito","22",load_file("C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\KSD_immagini\\tunica-vichinga-blu.jpg"),"34.20","2008-12-05");

-- Taglie Vestiti
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("30", "S", "30.20", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("30", "XS", "30.20", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("30", "M", "30.20", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("31", "S", "45.03", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("31", "XS", "45.03", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("31", "M", "45.03", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("32", "S", "39.90", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("32", "XS", "39.90", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("32", "M", "39.90", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("33", "M", "49.10", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("33", "L", "49.10", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("33", "XL", "49.10", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("34", "M", "34.20", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("34", "L", "34.20", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("34", "XL", "34.20", "4");

-- Taglie Corazze
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("5", "M", "12.45", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("5", "L", "12.45", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("5", "XL", "12.45", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("6", "M", "104.03", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("6", "L", "104.03", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("6", "XL", "104.03", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("11", "M", "80.99", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("11", "L", "80.99", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("11", "XL", "80.99", "4");

-- Misura Scudi
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("26", "64cmX49cm", "209.39", "8");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("27", "34cmX34cm", "190.23", "8");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("28", "75cmX35cm", "176.23", "8");

-- Taglie Elmi
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("7", "58cm", "23.99", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("7", "63cm", "23.99", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("8", "60cm", "60.00", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("8", "59cm", "60.00", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("9", "60,4cm", "15.20", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("9", "58,2cm", "15.20", "4");

-- Taglie Guanti
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("23", "S", "12.10", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("23", "M", "12.10", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("23", "L", "12.10", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("24", "S", "20.23", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("24", "M", "20.23", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("24", "L", "20.23", "4");

-- Taglie nuove
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("1", "M", "12.10", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("2", "L", "12.10", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("3", "S", "20.23", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("4", "M", "20.23", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("12", "L", "20.23", "4");

INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("13", "S", "12.10", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("14", "M", "12.10", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("15", "L", "12.10", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("16", "S", "20.23", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("17", "M", "20.23", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("18", "L", "20.23", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("19", "L", "20.23", "4");

INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("20", "M", "12.10", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("21", "L", "12.10", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("22", "S", "20.23", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("25", "M", "20.23", "4");
INSERT INTO Prodotto_Taglia (Prodotto, NomeTaglia, Prezzo, QuantitaDisponibile) Values ("26", "L", "20.23", "4");

-- Admin
INSERT INTO Utente (ID_Utente,Nome,Cognome,Email,`Password`,Tipo,PrefissoTelefono,NumeroTelefono,DataRegistrazione) VALUES(1,"Admin","Di Martino","admin@gmail.com","0a99bde7c6da60685f80cc29de546170ae635a346671850a69f22eb78f86d6eaeb755b8b2c8b4e57ac53f8d090272d09924c078fe8f50fb90657e2c44cf44dc3","admin",39,3453544321,"2024-07-01");
-- La password è: Password123&