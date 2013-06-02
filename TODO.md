Sorry english readers, this is in italian because it's just for me.

Funzionalità
------------

* Visualizzazione commenti __OK__
* Token di sessione per validare la post
* Configurazione __OK__ 
* Gravatar
* Paginazione (come?)
* Check client-side presenza autore/testo (come inietto javascript?)
* Gestire la scrittura di un diverso layout di commento tramite hook (fattibile?)
* Fare un metodo che restituisca i dati dei commenti per permettere all'utente di applicare un proprio layout.

Refactoring
-----------

* Creare una classe __Dancer2::CommentsHandler::Abtract__ usata dal plugin per gestire i commenti. Da qui estendere una __Dancer2::CommentsHandler::DBIC__ con l'attuale implementazione via DB. __OK__
