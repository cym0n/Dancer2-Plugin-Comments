Sorry english readers, this is in italian because it's just for me.

Funzionalità
------------

* Visualizzazione commenti __OK__
* Token di sessione per validare la post
* Configurazione __OK__ 
* Gravatar
* Paginazione (come?)

Refactoring
-----------

* Creare una classe __Dancer2::CommentsHandler::Abtract__ usata dal plugin per gestire i commenti. Da qui estendere una __Dancer2::CommentsHandler::DBIC__ con l'attuale implementazione via DB. __OK__
* Gestire la scrittura di un diverso layout di commento tramite hook
