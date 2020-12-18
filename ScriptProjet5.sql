
CREATE TABLE public.IngredientDisponible (
                reference_ingredient VARCHAR NOT NULL,
                quantite_disponible INTEGER NOT NULL,
                CONSTRAINT ingredientdisponible_pk PRIMARY KEY (reference_ingredient)
);


CREATE SEQUENCE public.produitdisponible_reference_produit_seq;

CREATE TABLE public.ProduitDisponible (
                reference_produit VARCHAR NOT NULL DEFAULT nextval('public.produitdisponible_reference_produit_seq'),
                memo_recette VARCHAR NOT NULL,
                prix_unitaire NUMERIC NOT NULL,
                CONSTRAINT produitdisponible_pk PRIMARY KEY (reference_produit)
);


ALTER SEQUENCE public.produitdisponible_reference_produit_seq OWNED BY public.ProduitDisponible.reference_produit;

CREATE TABLE public.StockDisponible (
                reference_produit VARCHAR NOT NULL,
                reference_ingredient VARCHAR NOT NULL,
                quantite_disponible INTEGER NOT NULL,
                CONSTRAINT stockdisponible_pk PRIMARY KEY (reference_produit, reference_ingredient)
);


CREATE SEQUENCE public.pizzeria_id_pizzeria_seq_1;

CREATE TABLE public.Pizzeria (
                id_pizzeria INTEGER NOT NULL DEFAULT nextval('public.pizzeria_id_pizzeria_seq_1'),
                numero_telephone INTEGER NOT NULL,
                adresse VARCHAR NOT NULL,
                horaires VARCHAR NOT NULL,
                CONSTRAINT pizzeria_pk PRIMARY KEY (id_pizzeria)
);


ALTER SEQUENCE public.pizzeria_id_pizzeria_seq_1 OWNED BY public.Pizzeria.id_pizzeria;

CREATE SEQUENCE public.employe_id_employe_seq_2;

CREATE SEQUENCE public.pizzeria_id_pizzeria_seq_2;

CREATE TABLE public.Employe (
                id_employe INTEGER NOT NULL DEFAULT nextval('public.employe_id_employe_seq_2'),
                id_pizzeria INTEGER NOT NULL DEFAULT nextval('public.pizzeria_id_pizzeria_seq_2'),
                nom VARCHAR NOT NULL,
                prenom VARCHAR NOT NULL,
                poste_occupe VARCHAR NOT NULL,
                adresse_mail VARCHAR NOT NULL,
                identifiant VARCHAR NOT NULL,
                mot_de_passe VARCHAR NOT NULL,
                CONSTRAINT employe_pk PRIMARY KEY (id_employe, id_pizzeria)
);


ALTER SEQUENCE public.employe_id_employe_seq_2 OWNED BY public.Employe.id_employe;

ALTER SEQUENCE public.pizzeria_id_pizzeria_seq_2 OWNED BY public.Employe.id_pizzeria;

CREATE SEQUENCE public.client_numero_client_seq;

CREATE TABLE public.Client (
                numero_client INTEGER NOT NULL DEFAULT nextval('public.client_numero_client_seq'),
                nom VARCHAR NOT NULL,
                prenom VARCHAR NOT NULL,
                numero_telephone VARCHAR(10) NOT NULL,
                adresse_mail VARCHAR NOT NULL,
                identifiant VARCHAR NOT NULL,
                mot_de_passe VARCHAR NOT NULL,
                CONSTRAINT client_pk PRIMARY KEY (numero_client)
);


ALTER SEQUENCE public.client_numero_client_seq OWNED BY public.Client.numero_client;

CREATE SEQUENCE public.commande_numero_commande_seq_1;

CREATE TABLE public.Commande (
                numero_commande INTEGER NOT NULL DEFAULT nextval('public.commande_numero_commande_seq_1'),
                numero_client INTEGER NOT NULL,
                id_pizzeria INTEGER NOT NULL,
                date TIMESTAMP NOT NULL,
                detail_commande VARCHAR NOT NULL,
                choix_livraison VARCHAR NOT NULL,
                etat_payement VARCHAR NOT NULL,
                type_de_payement VARCHAR NOT NULL,
                prix_commande NUMERIC NOT NULL,
                etat_commande VARCHAR NOT NULL,
                CONSTRAINT commande_pk PRIMARY KEY (numero_commande, numero_client, id_pizzeria)
);


ALTER SEQUENCE public.commande_numero_commande_seq_1 OWNED BY public.Commande.numero_commande;

CREATE TABLE public.LigneDeCommande (
                numero_commande INTEGER NOT NULL,
                numero_client INTEGER NOT NULL,
                id_pizzeria INTEGER NOT NULL,
                reference_produit VARCHAR NOT NULL,
                quantite INTEGER NOT NULL,
                prix_unitaire NUMERIC NOT NULL,
                CONSTRAINT lignedecommande_pk PRIMARY KEY (numero_commande, numero_client, id_pizzeria, reference_produit)
);


CREATE SEQUENCE public.adresse_id_adresse_seq_1_1_1;

CREATE TABLE public.Adresse (
                id_adresse INTEGER NOT NULL DEFAULT nextval('public.adresse_id_adresse_seq_1_1_1'),
                numero_client INTEGER NOT NULL,
                numero_commande INTEGER NOT NULL,
                id_pizzeria INTEGER NOT NULL,
                nom_adresse VARCHAR NOT NULL,
                rue VARCHAR NOT NULL,
                code_postal VARCHAR NOT NULL,
                ville VARCHAR NOT NULL,
                CONSTRAINT adresse_pk PRIMARY KEY (id_adresse, numero_client, numero_commande, id_pizzeria)
);


ALTER SEQUENCE public.adresse_id_adresse_seq_1_1_1 OWNED BY public.Adresse.id_adresse;

ALTER TABLE public.StockDisponible ADD CONSTRAINT ingredientproduit_stockdisponible_fk
FOREIGN KEY (reference_ingredient)
REFERENCES public.IngredientDisponible (reference_ingredient)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.LigneDeCommande ADD CONSTRAINT produitdisponible_lignedecommande_fk
FOREIGN KEY (reference_produit)
REFERENCES public.ProduitDisponible (reference_produit)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.StockDisponible ADD CONSTRAINT produitdisponible_stockdisponible_fk
FOREIGN KEY (reference_produit)
REFERENCES public.ProduitDisponible (reference_produit)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Commande ADD CONSTRAINT pizzeria_commande_fk
FOREIGN KEY (id_pizzeria)
REFERENCES public.Pizzeria (id_pizzeria)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Employe ADD CONSTRAINT pizzeria_employe_fk
FOREIGN KEY (id_pizzeria)
REFERENCES public.Pizzeria (id_pizzeria)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Adresse ADD CONSTRAINT client__adresse_fk
FOREIGN KEY (numero_client)
REFERENCES public.Client (numero_client)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Commande ADD CONSTRAINT client_commande_fk
FOREIGN KEY (numero_client)
REFERENCES public.Client (numero_client)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.LigneDeCommande ADD CONSTRAINT commande_lignedecommande_fk
FOREIGN KEY (numero_commande, numero_client, id_pizzeria)
REFERENCES public.Commande (numero_commande, numero_client, id_pizzeria)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Adresse ADD CONSTRAINT commande_adresse_fk
FOREIGN KEY (numero_client, id_pizzeria, numero_commande)
REFERENCES public.Commande (numero_client, id_pizzeria, numero_commande)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
