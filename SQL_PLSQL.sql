--1a

-- Les drops des tables
drop table TP2_ADMINISTRATEUR cascade constraints;
drop table TP2_MEMBRE cascade constraints;
drop table TP2_RABAIS cascade constraints;
drop table TP2_RECU cascade constraints;
drop table TP2_ALIMENT cascade constraints;
drop table TP2_RECETTE cascade constraints;
drop table TP2_RECETTE_ALIMENT cascade constraints;
drop table TP2_ACTIVITE cascade constraints;
drop table TP2_SEMAINE cascade constraints;
drop table TP2_JOUR_ALIMENT cascade constraints;
drop table TP2_JOUR_ACTIVITE cascade constraints;
drop table TP2_JOUR_RECETTE cascade constraints;

-- Les drop des séquences
drop sequence NO_MEMBRE_SEQ;
drop sequence NO_ALIMENT_SEQ;

-- Création des tables 
create table TP2_ADMINISTRATEUR (
    NOM_USAGER_ADMINISTRATEUR   varchar2(40) not null,
    MOT_DE_PASSE_ADM            varchar2(40) not null,
    PRENOM_ADM                  varchar2(40) not null,
    NOM_ADM                     varchar2(40) not null,
    COURRIEL_ADM                varchar2(40) not null,
    constraint PK_TP2_ADMINISTRATEUR primary key(NOM_USAGER_ADMINISTRATEUR),
    -- constraint CT_COURRIEL_ADM check(COURRIEL_ADM >= 10) -- ca fonctionne pas puisque courriel c'est pas un nombre
    constraint AK_AD_COURRIEL_ADM unique (COURRIEL_ADM)
);
    
create table TP2_MEMBRE (
    NO_MEMBRE                   number(13) not null,
    NOM_USAGER_MEM              varchar2(40) not null,
    MOT_DE_PASSE_MEM            varchar2(40) not null,
    PRENOM_MEM                  varchar2(40) not null, 
    NOM_MEM                     varchar2(40) not null, 
    ADRESSE_MEM                 varchar2(50) not null, 
    VILLE_MEM                   varchar2(40) not null, 
    CODE_POSTAL_MEM             char(7) not null, 
    TELEPHONE_MEM               char(13) not null, 
    COURRIEL_MEM                varchar2(40) not null, 
    BOOL_COURRIEL_EST_APPROUVE_MEM number(1), 
    SEXE_MEM                    varchar2(1) not null, 
    TAILLE_MEM                  number(3,2) not null, 
    DATE_INSCRIPTION_MEM        date not null, 
    DATE_NAISSANCE_MEM          date not null, 
    NO_CARTE_CREDIT_MEM         char(16), 
    EXPIRATION_CARTE_CREDIT_MEM char(4), 
    CCV_CARTE_CREDIT_MEM        char(3), 
    POIDS_INITIAL_MEM           number(3) not null, 
    POIDS_DESIRE_MEM            number(3) not null, 
    UNITE_POIDS_MEM             varchar2(2) not null, 
    BOOL_EST_EN_MAINTIENT       number(1) not null, 
    CHEMIN_PHOTO_AVANT_MEM      varchar2(300), 
    CHEMIN_PHOTO_APRES_MEM      varchar2(300), 
    NO_MEMBRE_RECOMMANDE        number(13),
    constraint PK_TP2_MEMBRE primary key(NO_MEMBRE),
    constraint FK_MEM_NO_MEM_REC foreign key(NO_MEMBRE_RECOMMANDE)
    references TP2_MEMBRE(NO_MEMBRE),
    constraint AK_ME_COURRIEL_MEM unique (COURRIEL_MEM),
    constraint AK_ME_NOM_USAGER_MEM unique (NOM_USAGER_MEM),
    constraint AK_ME_PRE_NOM_ADR_VIL unique (PRENOM_MEM, NOM_MEM, ADRESSE_MEM, VILLE_MEM, CODE_POSTAL_MEM, TELEPHONE_MEM, DATE_NAISSANCE_MEM),
    constraint AK_ME_CARTE_CREDIT_MEM unique (NO_CARTE_CREDIT_MEM)
    );
    

    
create table TP2_RABAIS (
    CODE_RABAIS                 char(3) not null, 
    NOM_RABAIS                  varchar2(40) not null, 
    DATE_DEBUT_RAB              date not null, 
    DATE_FIN_RAB                date not null, 
    NB_MOIS_RAB                 number(3) not null, 
    MNT_RAB                     number(6,2) not null, 
    POURCENTAGE_RAB             number(3) not null,
    NOM_FICHIER_IMAGE_RAB       varchar2(100) not null,
    constraint PK_TP2_RABAIS primary key(CODE_RABAIS),
    constraint AK_RA_NOM_RABAIS unique (NOM_RABAIS)
);
    
create table TP2_RECU (
    NO_MEMBRE                   number(13) not null, 
    DATE_RECU                   date not null,
    MNT_RECU                    number(8,2) not null, 
    CODE_RABAIS                 char(3) default 0 not null, 
    MNT_RABAIS_RECU             number(8,2) default 0 not null,
    constraint PK_TP2_RECU primary key(NO_MEMBRE, DATE_RECU),
    constraint FK_REC_CODE_RABAIS foreign key (CODE_RABAIS)
    references TP2_RABAIS(CODE_RABAIS)on delete cascade,
    constraint FK_REC_NO_MEMBRE foreign key(NO_MEMBRE)
    references TP2_MEMBRE(NO_MEMBRE)
);
    

create table TP2_ALIMENT (
    NO_ALIMENT                  number(12) generated always as identity, 
    NOM_ALI                     varchar2(40) not null, 
    PORTION_ALI                 number(10,2), 
    UNITE_ALI                   varchar2(10) not null, 
    NB_LIPIDE_ALI               number(10) not null, 
    NB_GLUCIDE_ALI              number(10) not null,
    NB_FIBRE_ALI                number(10) not null, 
    NB_PROTEINE_ALI             number(10) not null, 
    NOM_RESTAURANT_ALI          varchar2(40), 
    NO_MEMBRE                   number(12),
    BOOL_EST_PARTAGE_ALI        number(1), 
    NUMERO_CODE_BARRE_ALI       varchar2(12) not null, 
    CATEGORIE_ALI               varchar2(40), 
    NB_POINTS_ALI               number(10) not null,
    constraint PK_TP2_ALIMENT primary key(NO_ALIMENT),
    constraint FK_ALI_NO_MEMBRE foreign key(NO_MEMBRE)
    references TP2_MEMBRE(NO_MEMBRE),
    constraint AK_JO_NOM_ALI_POR_ALI unique (NOM_ALI,  PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI, NB_GLUCIDE_ALI, NB_FIBRE_ALI, NB_PROTEINE_ALI)
);
    
    
create table TP2_RECETTE (
    NO_RECETTE                  number(6) generated always as identity, 
    TITRE_RECETTE               varchar2(40) not null, 
    TEXTE_INSTRUCTION_REC       varchar2(2000) not null,
    NB_PERSONNE_PORTION_REC     number(10) not null,
    constraint PK_TP2_RECETTE primary key (NO_RECETTE),
    constraint AK_RE_TITRE_RECETTE unique (TITRE_RECETTE)
);

create table TP2_RECETTE_ALIMENT (
    NO_RECETTE                 number(6) not null, 
    NO_ALIMENT                 number(6) not null, 
    PORTION_ALIMENT_REC        number(2) not null, 
    PORTION_UNITE_ALIMENT_REC  number(2) not null, 
    NB_POINTS_REC              number(2) not null, 
    constraint PK_TP2_RECETTE_ALIMENT primary key (NO_RECETTE, NO_ALIMENT),
    constraint FK_RE_NO_RECETTE foreign key (NO_RECETTE)
        references TP2_RECETTE (NO_RECETTE),
    constraint FK_RE_NO_ALIMENT foreign key (NO_ALIMENT)
        references TP2_ALIMENT (NO_ALIMENT)
);
    
create table TP2_ACTIVITE (
    NOM_ACTIVITE        varchar2(40) not null,
    SECTION_ACT         varchar2(20) not null,
    NB_POINTS_ACT       number(2) not null,
    NO_MEMBRE           number(6) not null,
    constraint PK_TP2_ACTIVITE primary key (NOM_ACTIVITE),
    constraint FK_AC_MEMBRE foreign key (NO_MEMBRE)
        references TP2_MEMBRE (NO_MEMBRE)
);

create table TP2_SEMAINE (
    NO_SEMAINE             number (3) generated always as identity,
    NO_MEMBRE              number(6) not null,
    DATE_DEBUT_SEM         date not null,
    POIDS_DEBUT_SEM        number(3) not null,
    POINTS_QUOTIDIEN_SEM   number(2) not null,
    EST_ARCHIVEE           number(1) default 0,
    constraint PK_TP2_SEMAINE primary key (NO_SEMAINE),
    constraint FK_SE_MEMBRE foreign key (NO_MEMBRE)
        references TP2_MEMBRE (NO_MEMBRE),
    constraint AK_SE_NO_MEM_DATE_DEB unique (NO_MEMBRE, DATE_DEBUT_SEM)
);

create table TP2_JOUR_ALIMENT (
    NO_SEMAINE              number(3) not null,
    DATE_JOUR               date not null,
    PHASE_JOUR              varchar2(40) not null,
    NO_ALIMENT              number(6) not null,
    PORTION_VALEUR_JOUR_ALI number(2) not null,
    PORTION_UNITE_JOU_RALI  number(2) not null,
    NB_POINTS_JOUR_ALI      number(3) not null,
    EST_ARCHIVEE            number(1) default 0,
    constraint PK_TP2_JOUR_ALIMENT primary key (NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NO_ALIMENT),
    constraint FK_JO_AL_SEMAINE foreign key (NO_SEMAINE)
        references TP2_SEMAINE (NO_SEMAINE),
    constraint FK_JO_AL_ALIMENT foreign key (NO_ALIMENT)
        references TP2_ALIMENT (NO_ALIMENT)
);

create table TP2_JOUR_ACTIVITE (
    NO_SEMAINE              number(3) not null,
    DATE_JOUR               date not null,
    PHASE_JOUR              varchar2(40) not null,
    NOM_ACTIVITE            varchar2(40) not null,
    NB_POINTS_JOUR_ACT      number(3) not null,
    EST_ARCHIVEE            number(1) default 0,
    constraint PK_TP2_JOUR_ACTIVITE primary key (NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NOM_ACTIVITE),
    constraint FK_JO_AC_SEMAINE foreign key (NO_SEMAINE)
        references TP2_SEMAINE (NO_SEMAINE),
    constraint FK_JO_AC_ACTIVITE foreign key (NOM_ACTIVITE)
        references TP2_ACTIVITE (NOM_ACTIVITE)
);

create table TP2_JOUR_RECETTE (
    NO_SEMAINE              number(3) not null,
    DATE_JOUR               date not null,
    PHASE_JOUR              varchar2(40) not null,
    TITRE_RECETTE           varchar2(40) not null,
    PORTION_JOUR_REC        number(2) not null,
    NB_POINTS_JOUR_REC      number(3) not null,
    EST_ARCHIVEE            number(1) default 0,
    constraint PK_TP2_JOUR_RECETTE primary key (NO_SEMAINE, DATE_JOUR, PHASE_JOUR, TITRE_RECETTE),
    constraint FK_JO_RE_SEMAINE foreign key (NO_SEMAINE)
        references TP2_SEMAINE (NO_SEMAINE),
    constraint FK_JO_RE_RECETTE foreign key (TITRE_RECETTE)
        references TP2_RECETTE (TITRE_RECETTE)
);

-- Création des séquences
create sequence NO_ALIMENT_SEQ
    start with 1000
    increment by 1;
    
create sequence NO_MEMBRE_SEQ
    start with 10
    increment by 5;

-- 1b
insert into TP2_ADMINISTRATEUR (NOM_USAGER_ADMINISTRATEUR, MOT_DE_PASSE_ADM, PRENOM_ADM, NOM_ADM, COURRIEL_ADM) 
values ('charkles09', 'bingo123', 'Charles-Albert', 'Raymond', 'charkles09@gmail.com');
insert into TP2_ADMINISTRATEUR (NOM_USAGER_ADMINISTRATEUR, MOT_DE_PASSE_ADM, PRENOM_ADM, NOM_ADM, COURRIEL_ADM) 
values ('thierryo27', 'zumba235', 'Thierry', 'Turcotte', 'thierryturcotte@gmail.com');


insert into TP2_MEMBRE (NO_MEMBRE, NOM_USAGER_MEM, MOT_DE_PASSE_MEM, PRENOM_MEM, NOM_MEM, ADRESSE_MEM, VILLE_MEM, 
CODE_POSTAL_MEM, TELEPHONE_MEM, COURRIEL_MEM, BOOL_COURRIEL_EST_APPROUVE_MEM, SEXE_MEM, TAILLE_MEM, DATE_INSCRIPTION_MEM, 
DATE_NAISSANCE_MEM, NO_CARTE_CREDIT_MEM, EXPIRATION_CARTE_CREDIT_MEM, CCV_CARTE_CREDIT_MEM, POIDS_INITIAL_MEM, 
POIDS_DESIRE_MEM, UNITE_POIDS_MEM, BOOL_EST_EN_MAINTIENT, CHEMIN_PHOTO_AVANT_MEM, CHEMIN_PHOTO_APRES_MEM) 
values (NO_MEMBRE_SEQ.nextval, 'mariobros99', 'conga456', 'Julien', 'Rodriguo', '3456 rue des pissenlits', 'Charny', 'G7E 6J9', 
'(418)903-2645', 'julienrodriguo567@gmail.com', 1, 'M', 1.83, to_date('20-02-01','RR-MM-DD'), to_date('95-05-21','RR-MM-DD'), 
'4658486714350593', '0324', '566', 343, 200, 'lb', 0, 'c:\program files\Tp2\Image\JulienRodriguomariobros99Avant', 
'c:\program files\Tp2\Image\JulienRodriguomariobros99Apres');
insert into TP2_MEMBRE 
values (NO_MEMBRE_SEQ.nextval, 'luigipower', 'grfdhjs4u', 'Étienne', 'Chibougou', '4567 rue du Soleil', 'Lévis', 'G3U 2L7', 
'(581)384-2687', 'luigipower@gmail.com', 1, 'M', 1.67, to_date('20-03-23','RR-MM-DD'), to_date('96-08-24','RR-MM-DD'), 
'4658486785049711', '0522', '456', 230, 175, 'lb', 0, 'c:\program files\Tp2\Image\luigiavant', 
'c:\program files\Tp2\Image\luigiApres', 10);
insert into TP2_MEMBRE 
values (NO_MEMBRE_SEQ.nextval, 'ttremblay', 'lovepeach123', 'Wario', 'Tremblay', '4567 rue du nuage', 'Lévis', 'G3U 2L1', 
'(123)456-789', 'ttremblay2020@gmail.com', 1, 'M', 1.65, to_date('20-01-11','RR-MM-DD'), to_date('96-08-15','RR-MM-DD'), 
'4658486785046441', '0622', '835', 348, 190, 'lb', 0, 'c:\program files\Tp2\Image/warioavant', 
'c:\program files\Tp2\Image\warioApres', 10);
insert into TP2_MEMBRE 
values (NO_MEMBRE_SEQ.nextval, 'rachson', 'wow43ver', 'Rachid', 'Sansom', '4567 rue de l''avoine', 'Lévis', 'G3U 2G4', 
'(123)456-789', 'rachids@gmail.com', 1, 'M', 1.65, to_date('20-01-11','RR-MM-DD'), to_date('96-08-15','RR-MM-DD'), 
'4658486785046483', '0429', '634', 348, 190, 'lb', 0, 'c:\program files\Tp2\Image/rachsonavant', 
'c:\program files\Tp2\Image\rachsonApres', 10);
insert into TP2_MEMBRE 
values (NO_MEMBRE_SEQ.nextval, 'bhufwqeuh', 'gwey5', 'Paul', 'Chapeau', '486 rue du Soleil', 'Lévis', 'G3L 4J8', 
'(397)384-2687', 'lU56I7@gmail.com', 1, 'M', 1.67, to_date('20-03-23','RR-MM-DD'), to_date('96-08-24','RR-MM-DD'), 
'4658486785049643', '0522', '456', 230, 175, 'lb', 0, 'c:\program files\Tp2\Image\luigiavant', 
'c:\program files\Tp2\Image\luigiApres', 10);
insert into TP2_MEMBRE 
values (NO_MEMBRE_SEQ.nextval, 'jbefvw', '47fje4kri', 'Gustave', 'Raymond', '8594 rue du berger', 'Gatineau', 'G8H 4J8', 
'(581)234-9760', 'gustavus@gmail.com', 1, 'M', 1.96, to_date('21-04-20','RR-MM-DD'), to_date('00-03-24','RR-MM-DD'), 
'4658598265731098', '0924', '034', 456, 230, 'lb', 0, 'c:\program files\Tp2\Image\gustaveavant', 
'c:\program files\Tp2\Image\gustaveapres', 15);


    
insert into TP2_RABAIS(CODE_RABAIS, NOM_RABAIS, DATE_DEBUT_RAB, DATE_FIN_RAB, NB_MOIS_RAB, MNT_RAB, POURCENTAGE_RAB, NOM_FICHIER_IMAGE_RAB)
values ('34k', 'Ultra-Vente Concombre', to_date('21-06-10','RR-MM-DD'), to_date('21-07-10','RR-MM-DD'), 1, 10, 20, 'c:\program files\Tp3\Image\concombre');
insert into TP2_RABAIS(CODE_RABAIS, NOM_RABAIS, DATE_DEBUT_RAB, DATE_FIN_RAB, NB_MOIS_RAB, MNT_RAB, POURCENTAGE_RAB, NOM_FICHIER_IMAGE_RAB)
values ('k24', 'Ultra-Vente Céleri', to_date('21-05-12','RR-MM-DD'), to_date('21-08-12','RR-MM-DD'), 3, 15, 20, 'c:\program files\Tp3\Image\celeri');
insert into TP2_RABAIS(CODE_RABAIS, NOM_RABAIS, DATE_DEBUT_RAB, DATE_FIN_RAB, NB_MOIS_RAB, MNT_RAB, POURCENTAGE_RAB, NOM_FICHIER_IMAGE_RAB)
values ('9om', '9 mois c''est super', to_date('20-01-01','RR-MM-DD'), to_date(sysdate + 365, 'RR-MM-DD'), 12, 9, 9, 'c:\program files\Tp3\Image\9mois');
insert into TP2_RABAIS(CODE_RABAIS, NOM_RABAIS, DATE_DEBUT_RAB, DATE_FIN_RAB, NB_MOIS_RAB, MNT_RAB, POURCENTAGE_RAB, NOM_FICHIER_IMAGE_RAB)
values ('9j4', 'Ultra-Vente Tomate', to_date('21-05-08','RR-MM-DD'), to_date(sysdate + 30, 'RR-MM-DD'), 1, 10, 15, 'c:\program files\Tp3\Image\tomate');
insert into TP2_RABAIS(CODE_RABAIS, NOM_RABAIS, DATE_DEBUT_RAB, DATE_FIN_RAB, NB_MOIS_RAB, MNT_RAB, POURCENTAGE_RAB, NOM_FICHIER_IMAGE_RAB)
values ('ide', 'Ultra-Vente Patate', to_date('21-06-01','RR-MM-DD'), to_date(sysdate + 30, 'RR-MM-DD'), 1, 5, 10, 'c:\program files\Tp3\Image\patate');
insert into TP2_RABAIS(CODE_RABAIS, NOM_RABAIS, DATE_DEBUT_RAB, DATE_FIN_RAB, NB_MOIS_RAB, MNT_RAB, POURCENTAGE_RAB, NOM_FICHIER_IMAGE_RAB)
values ('09d', 'Ultra-Vente Carotte', to_date('21-05-20','RR-MM-DD'), to_date(sysdate + 30, 'RR-MM-DD'), 1, 5, 10, 'c:\program files\Tp3\Image\carotte');

insert into TP2_RECU
values (10, to_date('21-06-21','RR-MM-DD'), 102.35, 'k24', 20.17);
insert into TP2_RECU
values (15, to_date('21-05-21','RR-MM-DD'), 245.32, '34k', 45.67);
insert into TP2_RECU
values (20, to_date('21-01-31','RR-MM-DD'), 245.32, 'k24', 45.67);


insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI, NB_GLUCIDE_ALI, NB_FIBRE_ALI, NB_PROTEINE_ALI, NOM_RESTAURANT_ALI, NO_MEMBRE, 
    BOOL_EST_PARTAGE_ALI, NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI)
values ('Carotte', 2, 'g', 33, 45, 765, 99, 'Burger King', 10, 1, '384ueryhf','Sulfatus', 85);
insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI, NB_GLUCIDE_ALI, NB_FIBRE_ALI, NB_PROTEINE_ALI, NOM_RESTAURANT_ALI, NO_MEMBRE, 
    BOOL_EST_PARTAGE_ALI, NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
values ('Poivron Vert', 4, 'g', 26, 99, 123, 567, 'Ashton', 10, 1, '5463tert5','Légume', 45);
insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI, NB_GLUCIDE_ALI, NB_FIBRE_ALI, NB_PROTEINE_ALI, NOM_RESTAURANT_ALI, NO_MEMBRE, 
    BOOL_EST_PARTAGE_ALI, NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
values ('Carotte orange', 2, 'g', 33, 45, 765, 99, 'Burger King', 10, 1, '384ueryhf','Sulfatus', 85);
insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI, NB_GLUCIDE_ALI, NB_FIBRE_ALI, NB_PROTEINE_ALI, NOM_RESTAURANT_ALI, NO_MEMBRE, 
    BOOL_EST_PARTAGE_ALI, NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
values ('Poivron Vert pâle', 4, 'g', 26, 99, 123, 567, 'Ashton', 10, 0, '5463tert5','Légume', 45);

insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  NB_GLUCIDE_ALI,
 NB_FIBRE_ALI, NB_PROTEINE_ALI, NO_MEMBRE, BOOL_EST_PARTAGE_ALI, 
 NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
 values ('Patate', 2, 'g', 34, 108, 22, 456, 10, 1, 'ju48fjeikoi','Légume', 4);
 
 
insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  NB_GLUCIDE_ALI,
 NB_FIBRE_ALI, NB_PROTEINE_ALI, BOOL_EST_PARTAGE_ALI, 
 NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
 values ('Lays', 3, 'g', 19, 20, 1, 1, 1, 'jfkri4i4j','Chips', 3);
insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  NB_GLUCIDE_ALI,
 NB_FIBRE_ALI, NB_PROTEINE_ALI, BOOL_EST_PARTAGE_ALI, 
 NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
 values ('Fromage Quick-quick La chaudière', 2, 'g', 24, 23, 4, 6, 1, 'dkirt5ij','Fromage', 2);
insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  NB_GLUCIDE_ALI,
 NB_FIBRE_ALI, NB_PROTEINE_ALI, BOOL_EST_PARTAGE_ALI, 
 NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
 values ('Bacon Maple leaf', 3, 'g', 40, 50, 10, 14, 1, '4irjfjkwi','Viande', 5);
insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  NB_GLUCIDE_ALI,
 NB_FIBRE_ALI, NB_PROTEINE_ALI, BOOL_EST_PARTAGE_ALI, 
 NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
 values ('Archibald Matante', 1, 'ml', 8, 15, 10, 12, 1, 'kd848ejk','Bière', 4);
insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  NB_GLUCIDE_ALI,
 NB_FIBRE_ALI, NB_PROTEINE_ALI, BOOL_EST_PARTAGE_ALI, 
 NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
 values ('Archibald Joufflue', 1, 'ml', 8, 15, 10, 12, 1, 'kd8rg556h','Bière', 4);

insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  NB_GLUCIDE_ALI,
 NB_FIBRE_ALI, NB_PROTEINE_ALI, NO_MEMBRE, BOOL_EST_PARTAGE_ALI, 
 NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
 values ('Cerises', 1, 'g', 75, 145, 95, 42, 10, 1, '85jfj39ri','Fruit', 2);
insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  NB_GLUCIDE_ALI,
 NB_FIBRE_ALI, NB_PROTEINE_ALI, NO_MEMBRE, BOOL_EST_PARTAGE_ALI, 
 NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
 values ('Pomme', 1, 'g', 23, 15, 25, 12, 10, 1, '5yrty545w','Fruit', 2);
 
insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  NB_GLUCIDE_ALI,
 NB_FIBRE_ALI, NB_PROTEINE_ALI, BOOL_EST_PARTAGE_ALI, 
 NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
 values ('Archibald Valkyrie', 1, 'ml', 6, 5, 10, 12, 1, '475yrtega','Bière', 4);
 
insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  NB_GLUCIDE_ALI,
 NB_FIBRE_ALI, NB_PROTEINE_ALI, NO_MEMBRE, BOOL_EST_PARTAGE_ALI, 
 NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
 values ('Poire', 1, 'g', 64, 12, 15, 12, 15, 0, 't5y4teu','Fruit', 2);
insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  NB_GLUCIDE_ALI,
 NB_FIBRE_ALI, NB_PROTEINE_ALI, NO_MEMBRE, BOOL_EST_PARTAGE_ALI, 
 NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
 values ('Kiwi', 1, 'g', 45, 22, 15, 12, 15, 0, '3rty65u','Fruit', 2);
 insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  NB_GLUCIDE_ALI,
 NB_FIBRE_ALI, NB_PROTEINE_ALI, NO_MEMBRE, BOOL_EST_PARTAGE_ALI, 
 NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
 values ('Melon d''eau', 1, 'g', 230, 242, 19, 26, 15, 1, '5twy4ghb','Fruit', 2);
 insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  NB_GLUCIDE_ALI,
 NB_FIBRE_ALI, NB_PROTEINE_ALI, NO_MEMBRE, BOOL_EST_PARTAGE_ALI, 
 NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
 values ('Melon miel', 1, 'g', 230, 242, 19, 26, 25, 1, '65uhjen5g','Fruit', 2);
insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  NB_GLUCIDE_ALI,
 NB_FIBRE_ALI, NB_PROTEINE_ALI, NO_MEMBRE, BOOL_EST_PARTAGE_ALI, 
 NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
 values ('Banane', 1, 'g', 56, 63, 19, 26, 25, 1, '346tyr','Fruit', 2);
insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  NB_GLUCIDE_ALI,
 NB_FIBRE_ALI, NB_PROTEINE_ALI, NO_MEMBRE, BOOL_EST_PARTAGE_ALI, 
 NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
 values ('Orange', 1, 'g', 6, 6, 19, 26, 15, 1, '35t4y3hgb','Fruit', 2);
 insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  NB_GLUCIDE_ALI,
 NB_FIBRE_ALI, NB_PROTEINE_ALI, NO_MEMBRE, BOOL_EST_PARTAGE_ALI, 
 NUMERO_CODE_BARRE_ALI, CATEGORIE_ALI, NB_POINTS_ALI) 
 values ('Clémentine', 1, 'g', 6, 6, 19, 26, 15, 1, '5tg4rs','Fruit', 2);
 


insert into TP2_RECETTE(TITRE_RECETTE, TEXTE_INSTRUCTION_REC, NB_PERSONNE_PORTION_REC)
values ('Le spaghetti de Ricardo', '1. Faire bouillir l''eau. 2. Mettre les pâtes dans l''eau 3. Manger les pâtes', 4);
insert into TP2_RECETTE(TITRE_RECETTE, TEXTE_INSTRUCTION_REC, NB_PERSONNE_PORTION_REC)
values ('Les oeufs d''Évelyne', '1. Faire chauffer l''huile. 2. Mettre les oeufs sur la casserole 3. Manger les oeufs', 2);

insert into TP2_RECETTE(TITRE_RECETTE, TEXTE_INSTRUCTION_REC, NB_PERSONNE_PORTION_REC)
values ('La galette Libanaise', '1. Faire chauffer l''huile. 2. Mettre les galettes sur le feu 3. Manger les galettes', 1);
insert into TP2_RECETTE(TITRE_RECETTE, TEXTE_INSTRUCTION_REC, NB_PERSONNE_PORTION_REC)
values ('La tarte à Jocelyn', '1. Préparer la pâte. 2. Mettre la tarte au four 3. Manger la tarte', 6);
insert into TP2_RECETTE(TITRE_RECETTE, TEXTE_INSTRUCTION_REC, NB_PERSONNE_PORTION_REC)
values ('La sandwich de Paul', '1. Faire griller le pain 2. Mettre la mayonnaise 3. Manger la sandwich', 1);

insert into TP2_RECETTE_ALIMENT
values (1, 1, 2, 4, 85);
insert into TP2_RECETTE_ALIMENT
values (1, 2, 2, 4, 6);
insert into TP2_RECETTE_ALIMENT
values (1, 3, 2, 4, 8);
insert into TP2_RECETTE_ALIMENT
values (2, 4, 3, 2, 5);
insert into TP2_RECETTE_ALIMENT
values (2, 5, 2, 2, 4);
insert into TP2_RECETTE_ALIMENT
values (2, 6, 2, 2, 4);
insert into TP2_RECETTE_ALIMENT
values (3, 7, 2, 2, 4);
insert into TP2_RECETTE_ALIMENT
values (3, 8, 2, 2, 3);
insert into TP2_RECETTE_ALIMENT
values (3, 9, 2, 2, 6);
insert into TP2_RECETTE_ALIMENT
values (4, 10, 2, 2, 4);
insert into TP2_RECETTE_ALIMENT
values (4, 11, 2, 2, 3);
insert into TP2_RECETTE_ALIMENT
values (4, 12, 2, 2, 3);
insert into TP2_RECETTE_ALIMENT
values (5, 13, 2, 2, 4);
insert into TP2_RECETTE_ALIMENT
values (5, 14, 2, 2, 4);
insert into TP2_RECETTE_ALIMENT
values (5, 15, 2, 2, 7);


insert into TP2_SEMAINE(NO_MEMBRE, DATE_DEBUT_SEM, POIDS_DEBUT_SEM, POINTS_QUOTIDIEN_SEM)
values (10, to_date('20-05-21','RR-MM-DD'), 286, 58);
insert into TP2_SEMAINE(NO_MEMBRE, DATE_DEBUT_SEM, POIDS_DEBUT_SEM, POINTS_QUOTIDIEN_SEM)
values (10, to_date('21-06-01','RR-MM-DD'), 276, 56);
insert into TP2_SEMAINE(NO_MEMBRE, DATE_DEBUT_SEM, POIDS_DEBUT_SEM, POINTS_QUOTIDIEN_SEM)
values (10, to_date('21-07-01','RR-MM-DD'), 268, 54);

insert into TP2_SEMAINE(NO_MEMBRE, DATE_DEBUT_SEM, POIDS_DEBUT_SEM, POINTS_QUOTIDIEN_SEM)
values (15, to_date('21-06-13','RR-MM-DD'), 214, 49);
insert into TP2_SEMAINE(NO_MEMBRE, DATE_DEBUT_SEM, POIDS_DEBUT_SEM, POINTS_QUOTIDIEN_SEM)
values (20, to_date('21-06-10','RR-MM-DD'), 195, 49);
insert into TP2_SEMAINE(NO_MEMBRE, DATE_DEBUT_SEM, POIDS_DEBUT_SEM, POINTS_QUOTIDIEN_SEM)
values (25, to_date('21-06-10','RR-MM-DD'), 198, 49);
insert into TP2_SEMAINE(NO_MEMBRE, DATE_DEBUT_SEM, POIDS_DEBUT_SEM, POINTS_QUOTIDIEN_SEM)
values (30, to_date('21-06-10','RR-MM-DD'), 187, 49);
insert into TP2_SEMAINE(NO_MEMBRE, DATE_DEBUT_SEM, POIDS_DEBUT_SEM, POINTS_QUOTIDIEN_SEM)
values (35, to_date('21-06-10','RR-MM-DD'), 430, 57);

insert into TP2_ACTIVITE
values ('Course à pied', 'Texte à écrire', 24, 10);
insert into TP2_ACTIVITE
values ('Vélo', 'Texte à écrire', 19, 15);


 

insert into TP2_JOUR_ALIMENT(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NO_ALIMENT, PORTION_VALEUR_JOUR_ALI, PORTION_UNITE_JOU_RALI, NB_POINTS_JOUR_ALI)
values (1, to_date('21-05-22','RR-MM-DD'), 'Matin', 1, 2, 1, 4);
insert into TP2_JOUR_ALIMENT(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NO_ALIMENT, PORTION_VALEUR_JOUR_ALI, PORTION_UNITE_JOU_RALI, NB_POINTS_JOUR_ALI)
values (2, to_date('21-06-02','RR-MM-DD'), 'Après-Midi', 2, 1, 2, 3);
insert into TP2_JOUR_ALIMENT(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NO_ALIMENT, PORTION_VALEUR_JOUR_ALI, PORTION_UNITE_JOU_RALI, NB_POINTS_JOUR_ALI)
values (3, to_date('21-07-02','RR-MM-DD'), 'Après-Midi', 3, 1, 2, 3);
insert into TP2_JOUR_ALIMENT(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NO_ALIMENT, PORTION_VALEUR_JOUR_ALI, PORTION_UNITE_JOU_RALI, NB_POINTS_JOUR_ALI)
values (4, to_date('21-06-18','RR-MM-DD'), 'Après-Midi', 4, 1, 2, 3);

insert into TP2_JOUR_ALIMENT(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NO_ALIMENT, PORTION_VALEUR_JOUR_ALI, PORTION_UNITE_JOU_RALI, NB_POINTS_JOUR_ALI)
values (5, to_date('21-06-11','RR-MM-DD'), 'Après-Midi', 5, 1, 2, 3);
insert into TP2_JOUR_ALIMENT(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NO_ALIMENT, PORTION_VALEUR_JOUR_ALI, PORTION_UNITE_JOU_RALI, NB_POINTS_JOUR_ALI)
values (6, to_date('21-06-12','RR-MM-DD'), 'Après-Midi', 6, 1, 2, 3);
insert into TP2_JOUR_ALIMENT(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NO_ALIMENT, PORTION_VALEUR_JOUR_ALI, PORTION_UNITE_JOU_RALI, NB_POINTS_JOUR_ALI)
values (7, to_date('21-06-13','RR-MM-DD'), 'Après-Midi', 7, 1, 2, 3);
insert into TP2_JOUR_ALIMENT(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NO_ALIMENT, PORTION_VALEUR_JOUR_ALI, PORTION_UNITE_JOU_RALI, NB_POINTS_JOUR_ALI)
values (8, to_date('21-06-14','RR-MM-DD'), 'Après-Midi', 8, 1, 2, 3);




    
insert into TP2_JOUR_ACTIVITE(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NOM_ACTIVITE, NB_POINTS_JOUR_ACT)
values (1, to_date('21-05-22','RR-MM-DD'), 'Matin', 'Vélo', 19);
insert into TP2_JOUR_ACTIVITE(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NOM_ACTIVITE, NB_POINTS_JOUR_ACT)
values (2, to_date('21-06-02','RR-MM-DD'), 'Soir', 'Course à pied', 24);
insert into TP2_JOUR_ACTIVITE(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NOM_ACTIVITE, NB_POINTS_JOUR_ACT)
values (3, to_date('21-07-02','RR-MM-DD'), 'Soir', 'Course à pied', 24);
insert into TP2_JOUR_ACTIVITE(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NOM_ACTIVITE, NB_POINTS_JOUR_ACT)
values (4, to_date('21-06-18','RR-MM-DD'), 'Soir', 'Course à pied', 24);
insert into TP2_JOUR_ACTIVITE(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NOM_ACTIVITE, NB_POINTS_JOUR_ACT)
values (5, to_date('21-06-11','RR-MM-DD'), 'Soir', 'Course à pied', 24);
insert into TP2_JOUR_ACTIVITE(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NOM_ACTIVITE, NB_POINTS_JOUR_ACT)
values (6, to_date('21-06-12','RR-MM-DD'), 'Soir', 'Course à pied', 24);
insert into TP2_JOUR_ACTIVITE(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NOM_ACTIVITE, NB_POINTS_JOUR_ACT)
values (7, to_date('21-06-13','RR-MM-DD'), 'Soir', 'Course à pied', 24);
insert into TP2_JOUR_ACTIVITE(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, NOM_ACTIVITE, NB_POINTS_JOUR_ACT)
values (8, to_date('21-06-14','RR-MM-DD'), 'Soir', 'Course à pied', 24);


    
insert into TP2_JOUR_RECETTE(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, TITRE_RECETTE, PORTION_JOUR_REC, NB_POINTS_JOUR_REC)
values (1, to_date('21-05-22','RR-MM-DD'), 'Matin', 'Le spaghetti de Ricardo', 3, 14);
insert into TP2_JOUR_RECETTE(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, TITRE_RECETTE, PORTION_JOUR_REC, NB_POINTS_JOUR_REC)
values (2, to_date('21-06-02','RR-MM-DD'), 'Soir', 'Les oeufs d''Évelyne', 1, 12);
insert into TP2_JOUR_RECETTE(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, TITRE_RECETTE, PORTION_JOUR_REC, NB_POINTS_JOUR_REC)
values (3, to_date('21-07-02','RR-MM-DD'), 'Soir', 'Les oeufs d''Évelyne', 1, 12);
insert into TP2_JOUR_RECETTE(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, TITRE_RECETTE, PORTION_JOUR_REC, NB_POINTS_JOUR_REC)
values (4, to_date('21-06-18','RR-MM-DD'), 'Soir', 'Les oeufs d''Évelyne', 1, 12);
insert into TP2_JOUR_RECETTE(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, TITRE_RECETTE, PORTION_JOUR_REC, NB_POINTS_JOUR_REC)
values (5, to_date('21-06-11','RR-MM-DD'), 'Soir', 'Les oeufs d''Évelyne', 1, 12);
insert into TP2_JOUR_RECETTE(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, TITRE_RECETTE, PORTION_JOUR_REC, NB_POINTS_JOUR_REC)
values (6, to_date('21-06-12','RR-MM-DD'), 'Soir', 'Les oeufs d''Évelyne', 1, 12);
insert into TP2_JOUR_RECETTE(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, TITRE_RECETTE, PORTION_JOUR_REC, NB_POINTS_JOUR_REC)
values (7, to_date('21-06-13','RR-MM-DD'), 'Soir', 'Les oeufs d''Évelyne', 1, 12);
insert into TP2_JOUR_RECETTE(NO_SEMAINE, DATE_JOUR, PHASE_JOUR, TITRE_RECETTE, PORTION_JOUR_REC, NB_POINTS_JOUR_REC)
values (8, to_date('21-06-14','RR-MM-DD'), 'Soir', 'Les oeufs d''Évelyne', 1, 12);


insert into TP2_ALIMENT(NOM_ALI, PORTION_ALI, UNITE_ALI, NB_LIPIDE_ALI,  
            NB_GLUCIDE_ALI, NB_FIBRE_ALI, NB_PROTEINE_ALI, NUMERO_CODE_BARRE_ALI, NB_POINTS_ALI) 
            values ('eht', 2, 'g', 4, 5, 6, 7, 
            '543tftg', 4);

select NOM_ALI from TP2_ALIMENT where NO_ALIMENT = 3;


                    
update TP2_ALIMENT 
                    
                    set PORTION_ALI = 999999,
                    UNITE_ALI = 'ml'
                    
                       
                    where NO_ALIMENT = 3;
                    
update TP2_ALIMENT 
                    set NOM_ALI = 'BINGO',
                    PORTION_ALI = 22,
                     UNITE_ALI = 'ml',
                     NB_LIPIDE_ALI = 3,
                     NB_GLUCIDE_ALI = 4,
                     NB_FIBRE_ALI = 5,
                     NB_PROTEINE_ALI = 6,
                    NUMERO_CODE_BARRE_ALI = '56hg43',
                     NB_POINTS_ALI = 22
                       
                    where NO_ALIMENT = 3;