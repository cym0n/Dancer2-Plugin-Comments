NAME
===========

Dancer::Plugin::Comments - Comments on Dancer2 pages

VERSION
=======

version 0.001

DESCRIPTION
===========

A little plugin to add comments to Dancer pages. 

CONFIGURATION
=============

Every needed argument has a default values (the value in the example below).

    Comments:
        #Class Handler. Something in the namespace Dancer2::Plugin::Comments::Handler
        handler: DBIC 

        #Configuration specific of the DBIC handler
        db_class: Comment
        
        #CSS classe to use for style customization
        css_box_id: commentsbox
        css_list_id: comments

        #Labels
        author_label: Author
        mail_label: Mail
        site_label: Site

        #The route that will be used to post
        post_route: "/comment"

        #Author flag. If 0 no author data will be asked. Mail and site will be off too. 
        #Configuration useful when user is logged on the site but BEWARE: none of the given handlers manages user login. You have to write one that do.
        author: 1

        #Flags to save also mail and site of the user
        mail: 0
        site: 0 

The default handler is _Dancer2::Plugin::Comments::Handler::DBIC_. It requires a database with a table like this one:

    CREATE TABLE comments
    (ID INTEGER PRIMARY KEY AUTOINCREMENT,
    AUTHOR VARCHAR(80),
    PAGE VARCHAR(255),
    TEXT VARCHAR(255),
    SITE VARCHAR(255),
    MAIL VARCHAR(255),
    TIMESTAMP DATETIME);

USAGE
=====

Just put in your template a token populated with the registered key __comments__ for comments and one populated with registered key __commentbox__ for the box

` template 'article.tt', { list => comments, comm => commentbox } `

HANDLERS
========

You can define new handlers creating a class with _Dancer2::Plugin::Comments::Role::Handler_ as role. See DBIC or Dumb as examples.

AUTHOR
======

Simone Faré
