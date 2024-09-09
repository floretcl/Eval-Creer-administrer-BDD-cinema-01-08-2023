CREATE DATABASE eval_cinema;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE user_group (
  group_id SERIAL PRIMARY KEY,
  group_name VARCHAR(20) NOT NULL
);

CREATE TABLE account (
  account_id UUID DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
  lastname VARCHAR(30) NOT NULL,
  firstname VARCHAR(30) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password TEXT NOT NULL,
  group_id SERIAL,
  FOREIGN KEY (group_id) REFERENCES user_group (group_id)
);

CREATE TYPE GENRE AS ENUM (
  'action',
  'aventure',
  'comédie',
  'comédie-romantique',
  'drame',
  'famille',
  'fantastique',
  'historique',
  'horreur',
  'policier',
  'science-fiction',
  'suspense',
  'western'
);

CREATE TABLE complex (
  complex_id UUID DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
  complex_name VARCHAR(50) NOT NULL,
  adress VARCHAR(150) NOT NULL,
  postal_code INTEGER NOT NULL,
  city VARCHAR(80) NOT NULL
  CONSTRAINT valid_postal_code CHECK (postal_code <= 99999)
);

CREATE TABLE movie (
  movie_id UUID DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY, 
  title VARCHAR(100) NOT NULL,
  release_date TIMESTAMP WITH TIME ZONE NOT NULL,
  director VARCHAR(50) NOT NULL,
  genre GENRE,
  duration SMALLINT NOT NULL,
  synopsis TEXT NOT NULL
);

CREATE TABLE movie_theater (
  movie_theater_id UUID DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
  movie_theater_name VARCHAR(20) NOT NULL,
  complex_id UUID NOT NULL, 
  seating_capacity SMALLINT NOT NULL,
  FOREIGN KEY (complex_id) REFERENCES complex (complex_id) ON DELETE CASCADE
);

CREATE TABLE movie_show (
  date_show TIMESTAMP WITH TIME ZONE NOT NULL,
  version_show VARCHAR(30) NOT NULL,
  movie_id UUID NOT NULL,
  movie_theater_id UUID NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES movie (movie_id),
  FOREIGN KEY (movie_theater_id) REFERENCES movie_theater (movie_theater_id),
  PRIMARY KEY (movie_theater_id, date_show)
);

CREATE TABLE price (
  price_name VARCHAR(20) NOT NULL PRIMARY KEY,
  price_amount NUMERIC(6,2) NOT NULL
);

CREATE TABLE booking (
  booking_nb UUID DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
  customer_id UUID NOT NULL,
  price_name VARCHAR(20) NOT NULL,
  movie_theater_id UUID NOT NULL,
  date_show TIMESTAMP WITH TIME ZONE NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES account (account_id),
  FOREIGN KEY (price_name) REFERENCES price (price_name),
  FOREIGN KEY (movie_theater_id, date_show) REFERENCES movie_show (movie_theater_id, date_show)
);



-- INSERTIONS ---------
-----------------------

-- GROUP INSERTIONS

INSERT INTO user_group
  (group_name)
VALUES
  ('Admin'),
  ('Employé'),
  ('Client');

-- USERS INSERTIONS

INSERT INTO account
  (lastname, firstname, email, password, group_id)
VALUES
  ('Pacino', 'Al', 'alpacino@email.com', crypt('password', gen_salt('bf')), (SELECT group_id FROM user_group WHERE group_name = 'Admin')),
  ('De niro', 'Robert', 'deniro@email.com', crypt('password', gen_salt('bf')), (SELECT group_id FROM user_group WHERE group_name = 'Admin')),
  ('Foster', 'Jodie', 'j.foster@email.com', crypt('password', gen_salt('bf')), (SELECT group_id FROM user_group WHERE group_name = 'Employé')),
  ('Streep', 'Meryl', 'merylstreep@email.com', crypt('password', gen_salt('bf')), (SELECT group_id FROM user_group WHERE group_name = 'Employé')),
  ('Thurman', 'Uma', 'thurman.uma@email.com', crypt('password', gen_salt('bf')), (SELECT group_id FROM user_group WHERE group_name = 'Employé')),
  ('DiCaprio', 'Leonardo', 'dicaprio@email.com', crypt('password', gen_salt('bf')), (SELECT group_id FROM user_group WHERE group_name = 'Client')),
  ('Eastwood', 'Clint', 'clint.eastwood@email.com', crypt('password', gen_salt('bf')), (SELECT group_id FROM user_group WHERE group_name = 'Client')),
  ('Spacey', 'Kevin', 'kevin-spacey@email.com', crypt('password', gen_salt('bf')), (SELECT group_id FROM user_group WHERE group_name = 'Client')),
  ('Freeman', 'Morgan', 'morgan.f@email.com', crypt('password', gen_salt('bf')), (SELECT group_id FROM user_group WHERE group_name = 'Client')),
  ('Portman', 'Nathalie', 'nathalie.p@email.com', crypt('password', gen_salt('bf')), (SELECT group_id FROM user_group WHERE group_name = 'Client')),
  ('Watts', 'Naomi', 'naomi.watts@email.com', crypt('password', gen_salt('bf')), (SELECT group_id FROM user_group WHERE group_name = 'Client')),
  ('Bonham Carter', 'Helena', 'helena-bc@email.com', crypt('password', gen_salt('bf')), (SELECT group_id FROM user_group WHERE group_name = 'Client')),
  ('Knightley', 'Keira', 'keira.k@email.com', crypt('password', gen_salt('bf')), (SELECT group_id FROM user_group WHERE group_name = 'Client'));
-- COMPLEXES INSERTIONS

INSERT INTO complex 
  (complex_name, adress, postal_code, city)
VALUES
  ('Complexe A', '100 Avenue des champs élysées', '75008', 'Paris'),
  ('Complexe B', '11 Place bellecour', '69002', 'Lyon'),
  ('Complexe C', '23 La canebière', '13001', 'Marseille');

  -- TARIFS INSERTIONS

INSERT INTO price 
  (price_name, price_amount)
VALUES
  ('Plein price', 9.20),
  ('Étudiant', 7.60),
  ('Moins de 14 ans', 5.90);

-- FILMS INSERTIONS

INSERT INTO movie
  (title, release_date, director, genre, duration, synopsis)
VALUES
  ('Forrest Gump', '1994-10-05 00:00:00 Europe/Paris', 'Robert Zemeckis', 'comédie', 140, 'Quelques décennies d''histoire américaine, des années 1940 à la fin du XXème siècle, à travers le regard et l''étrange odyssée d''un homme simple et pur, Forrest Gump.'),
  
  ('La liste de schindler', '1994-03-02 00:00:00 Europe/Paris', 'Steven Spielberg', 'historique', 195, 'Evocation des années de guerre d''Oskar Schindler, fils d''industriel d''origine autrichienne rentré à Cracovie en 1939 avec les troupes allemandes. Il va, tout au long de la guerre, protéger des juifs en les faisant travailler dans sa fabrique et en 1944 sauver huit cents hommes et trois cents femmes du camp d''extermination de Auschwitz-Birkenau.'),
  
  ('La ligne verte', '2000-03-01 00:00:00 Europe/Paris', 'Frank Darabont', 'drame', 189, 'Paul Edgecomb, pensionnaire centenaire d''une maison de retraite, est hanté par ses souvenirs. Gardien-chef du pénitencier de Cold Mountain en 1935, il était chargé de veiller au bon déroulement des exécutions capitales en s’efforçant d''adoucir les derniers moments des condamnés. Parmi eux se trouvait un colosse du nom de John Coffey, accusé du viol et du meurtre de deux fillettes. Intrigué par cet homme candide et timide aux dons magiques, Edgecomb va tisser avec lui des liens très forts.'),
  
  ('12 hommes en colère', '1957-09-04 00:00:00 Europe/Paris', 'Sidney Lumet', 'drame', 95, 'Un jeune homme d''origine modeste est accusé du meurtre de son père et risque la peine de mort. Le jury composé de douze hommes se retire pour délibérer et procède immédiatement à un vote : onze votent coupable, or la décision doit être prise à l''unanimité. Le juré qui a voté non-coupable, sommé de se justifier, explique qu''il a un doute et que la vie d''un homme mérite quelques heures de discussion. Il s''emploie alors à les convaincre un par un.'),
  
  ('Le parrain', '1972-10-18 00:00:00 Europe/Paris', 'Francis Ford Coppola', 'policier', 175, 'En 1945, à New York, les Corleone sont une des cinq familles de la mafia. Don Vito Corleone, parrain de cette famille, marie sa fille à un bookmaker. Sollozzo, parrain de la famille Tattaglia, propose à Don Vito une association dans le trafic de drogue, mais celui-ci refuse. Sonny, un de ses fils, y est quant à lui favorable.
Afin de traiter avec Sonny, Sollozzo tente de faire tuer Don Vito, mais celui-ci en réchappe. Michael, le frère cadet de Sonny, recherche alors les commanditaires de l''attentat et tue Sollozzo et le chef de la police, en représailles.
Michael part alors en Sicile, où il épouse Apollonia, mais celle-ci est assassinée à sa place. De retour à New York, Michael épouse Kay Adams et se prépare à devenir le successeur de son père...'),
  
  ('Les évadés', '1995-03-01 00:00:00 Europe/Paris', 'Frank Darabont', 'drame', 142, 'Red, condamné à perpétuité, et Andy Dufresne, un gentil banquier injustement condamné pour meurtre, se lient d''une amitié inattendue qui va durer plus de vingt ans. Ensemble, ils découvrent l''espoir comme l''ultime moyen de survie. Sous des conditions terrifiantes et la menace omniprésente de la violence, les deux condamnés à perpétuité récupèrent leurs âmes et retrouvent la liberté dans leurs cœurs.'),
  
  ('Le seigneur des anneaux : le retour du roi', '2003-12-17 00:00:00 Europe/Paris', 'Peter Jackson', 'fantastique', 201, 'Les armées de Sauron ont attaqué Minas Tirith, la capitale de Gondor. Jamais ce royaume autrefois puissant n''a eu autant besoin de son roi. Mais Aragorn trouvera-t-il en lui la volonté d''accomplir sa destinée ?
Tandis que Gandalf s''efforce de soutenir les forces brisées de Gondor, Théoden exhorte les guerriers de Rohan à se joindre au combat. Mais malgré leur courage et leur loyauté, les forces des Hommes ne sont pas de taille à lutter contre les innombrables légions d''ennemis qui s''abattent sur le royaume...
Chaque victoire se paye d''immenses sacrifices. Malgré ses pertes, la Communauté se jette dans la bataille pour la vie, ses membres faisant tout pour détourner l''attention de Sauron afin de donner à Frodon une chance d''accomplir sa quête.
Voyageant à travers les terres ennemies, ce dernier doit se reposer sur Sam et Gollum, tandis que l''Anneau continue de le tenter...'),
  ('Le roi lion', '23/11/1994 00:00:00 Europe/Paris', 'Roger Allers, Rob Minkoff', 'famille', 89, 'Sur les Hautes terres d’Afrique règne un lion tout-puissant, le roi Mufasa, que tous les hôtes de la jungle respectent et admirent pour sa sagesse et sa générosité. Son jeune fils Simba sait qu’un jour il lui succédera, conformément aux lois universelles du cycle de la vie, mais il est loin de deviner les épreuves et les sacrifices que lui imposera l’exercice du pouvoir. Espiègle, naïf et turbulent, le lionceau passe le plus clair de son temps à jouer avec sa petite copine Nala et à taquiner Zazu, son digne précepteur. Son futur royaume lui apparaît en songe comme un lieu enchanté où il fera bon vivre, s’amuser et donner des ordres. Cependant, l’univers de Simba n’est pas aussi sûr qu’il le croie. Scar, le frère de Mufasa, aspire en effet depuis toujours au trône. Maladivement jaloux de son aîné, il intrigue pour l’éliminer en même temps que son successeur. Misant sur la curiosité enfantine et le tempérament aventureux de Simba, il révèle à celui-ci l’existence d’un mystérieux et dangereux cimetière d’éléphants. Simba, oubliant les avertissements répétés de son père, s’y rend aussitôt en secret avec Nala et se fait attaquer par 3 hyènes féroces. Par chance, Mufasa arrive à temps pour sauver l’imprudent lionceau et sa petite compagne. Mais Scar ne renonce pas à ses sinistres projets. Aidé des 3 hyènes, il attire Simba dans un ravin et lance à sa poursuite un troupeau de gnous. N’écoutant que son courage, Mufasa sauve à nouveau son fils et tente de se mettre à l’abri en gravissant la falaise. Repoussé par son frère félon, il périt sous les sabots des gnous affolés. Scar blâme alors l’innocent Simba pour la mort du Roi et le persuade de quitter pour toujours les Hautes terres. Simba se retrouve pour la première fois seul et démuni face à un monde hostile. C’est alors que le destin place sur sa route un curieux tandem d’amis...'),
  
  ('Vol-au-dessus d''un nid de coucou', '1976-03-01 00:00:00 Europe/Paris', 'Milos Forman', 'drame', 129, 'Adapté du best-seller éponyme de Ken Kesey, Vol au-dessus d''un nid de coucou décrit, avec une précision quasiment documentaire, les traitements infligés aux patients dans les années 1960 : médicaments surdosés, douches glacées, électrochocs ou encore lobotomie. Mais ce pamphlet contre le fonctionnement des hôpitaux psychiatriques questionne aussi le sens de la révolte : pourquoi doit-on résister ? Jusqu''où peut-on s''opposer ? Où se situe la frontière entre l''héroïsme et la folie ? D''un côté, convaincue de faire le bien, miss Ratched applique les règles aveuglément et infantilise ses patients. De l''autre, McMurphy se bat pour leur rendre leur dignité quitte à défier les lois d''un système répressif et inhumain. Louise Fletcher et Jack Nicholson, tous deux oscarisés pour leur performance exceptionnelle, personnifient la confrontation entre l''individu et l''institution, placée au cœur d''une œuvre intense dont on ne sort pas indemne. Magistralement mis en scène par Milos Forman, un grand movie, qui a marqué toute une génération.'),
  
  ('The dark knight : le chevalier noir', '2008-08-13 00:00:00 Europe/Paris', 'Christopher Nolan', 'action', 152, 'Dans ce nouveau volet, Batman augmente les mises dans sa guerre contre le crime. Avec l''appui du lieutenant de police Jim Gordon et du procureur de Gotham, Harvey Dent, Batman vise à éradiquer le crime organisé qui pullule dans la ville. Leur association est très efficace mais elle sera bientôt bouleversée par le chaos déclenché par un criminel extraordinaire que les citoyens de Gotham connaissent sous le nom de Joker.');

-- SALLES INSERTIONS

INSERT INTO movie_theater 
  (movie_theater_name, complex_id, seating_capacity)
VALUES
  ('1',(SELECT complex_id FROM complex WHERE complex_name = 'Complexe A'),182),
  ('2',(SELECT complex_id FROM complex WHERE complex_name = 'Complexe A'),140),
  ('3',(SELECT complex_id FROM complex WHERE complex_name = 'Complexe A'),120),
  ('4',(SELECT complex_id FROM complex WHERE complex_name = 'Complexe A'),110),
  ('5',(SELECT complex_id FROM complex WHERE complex_name = 'Complexe A'),92),
  ('1',(SELECT complex_id FROM complex WHERE complex_name = 'Complexe B'),120),
  ('2',(SELECT complex_id FROM complex WHERE complex_name = 'Complexe B'),96),
  ('3',(SELECT complex_id FROM complex WHERE complex_name = 'Complexe B'),96),
  ('4',(SELECT complex_id FROM complex WHERE complex_name = 'Complexe B'),88),
  ('A',(SELECT complex_id FROM complex WHERE complex_name = 'Complexe C'),160),
  ('B',(SELECT complex_id FROM complex WHERE complex_name = 'Complexe C'),126),
  ('C',(SELECT complex_id FROM complex WHERE complex_name = 'Complexe C'),126),
  ('D',(SELECT complex_id FROM complex WHERE complex_name = 'Complexe C'),98);

-- SEANCES INSERTIONS

INSERT INTO movie_show
  (date_show, version_show, movie_id, movie_theater_id)
VALUES
  ('2023-07-30 20:30:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'Forrest Gump'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '1' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe A'))
  ),

  ('2023-07-30 15:30:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'Forrest Gump'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '1' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe A'))
  ),

  ('2023-08-01 18:15:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'La liste de schindler'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '2' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe A'))
  ),

  ('2023-07-31 18:15:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'La liste de schindler'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '2' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe A'))
  ),

  ('2023-07-31 14:30:00 Europe/Paris',
  'VO',
  (SELECT movie_id FROM movie WHERE title = 'La ligne verte'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '3' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe A'))
  ),

  ('2023-07-30 18:15:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = '12 hommes en colère'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '4' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe A'))
  ),

  ('2023-07-31 20:15:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'Le parrain'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '4' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe A'))
  ),

  ('2023-07-31 14:15:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'Le parrain'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '4' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe A'))
  ),

  ('2023-08-01 09:15:00 Europe/Paris',
  'VO',
  (SELECT movie_id FROM movie WHERE title = 'Le seigneur des anneaux : le retour du roi'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '5' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe A'))
  ),

  ('2023-07-30 20:30:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'La liste de schindler'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '1' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe B'))
  ),

  ('2023-07-30 16:00:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'Vol-au-dessus d''un nid de coucou'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '1' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe B'))
  ),

  ('2023-08-01 18:15:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'Vol-au-dessus d''un nid de coucou'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '2' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe B'))
  ),

  ('2023-07-31 18:15:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'La liste de schindler'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '2' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe B'))
  ),

  ('2023-07-31 16:30:00 Europe/Paris',
  'VO',
  (SELECT movie_id FROM movie WHERE title = 'Forrest Gump'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '3' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe B'))
  ),

  ('2023-07-30 18:15:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'The dark knight : le chevalier noir'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '4' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe B'))
  ),

  ('2023-07-31 19:15:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'La ligne verte'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '4' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe B'))
  ),

  ('2023-07-31 14:15:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'Le seigneur des anneaux : le retour du roi'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '4' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe B'))
  ),

  ('2023-08-01 10:15:00 Europe/Paris',
  'VO',
  (SELECT movie_id FROM movie WHERE title = 'Les évadés'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '4' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe B'))
  ),

  ('2023-07-30 21:45:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'Forrest Gump'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = 'A' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe C'))
  ),

  ('2023-08-01 16:00:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = '12 hommes en colère'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = 'A' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe C'))
  ),

  ('2023-07-31 18:15:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = '12 hommes en colère'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = 'A' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe C'))
  ),

  ('2023-08-01 18:15:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'Forrest Gump'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = 'B' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe C'))
  ),

  ('2023-07-30 16:30:00 Europe/Paris',
  'VO',
  (SELECT movie_id FROM movie WHERE title = 'Vol-au-dessus d''un nid de coucou'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = 'B' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe C'))
  ),

  ('2023-07-31 18:15:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'Le seigneur des anneaux : le retour du roi'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = 'C' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe C'))
  ),

  ('2023-08-01 19:15:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'Les évadés'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = 'C' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe C'))
  ),

  ('2023-08-01 14:15:00 Europe/Paris',
  'VF',
  (SELECT movie_id FROM movie WHERE title = 'The dark knight : le chevalier noir'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = 'D' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe C'))
  ),

  ('2023-07-30 10:15:00 Europe/Paris',
  'VO',
  (SELECT movie_id FROM movie WHERE title = 'The dark knight : le chevalier noir'),
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = 'D' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe C'))
  );

-- RESERVATIONS INSERTIONS

INSERT INTO booking
  (customer_id, price_name, movie_theater_id, date_show)
VALUES
  
  ((SELECT account_id FROM account WHERE email = 'dicaprio@email.com'),
  'Moins de 14 ans',
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = 'A' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe C')),
  '2023-07-30 21:45:00 Europe/Paris'
  ),
  ((SELECT account_id FROM account WHERE email = 'clint.eastwood@email.com'),
  'Moins de 14 ans',
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '2' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe A')),
  '2023-07-31 18:15:00 Europe/Paris'
  ),
  ((SELECT account_id FROM account WHERE email = 'clint.eastwood@email.com'),
  'Plein price',
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '4' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe A')),
  '2023-07-31 20:15:00 Europe/Paris'
  ),
  ((SELECT account_id FROM account WHERE email = 'helena-bc@email.com'),
  'Plein price',
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '4' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe A')),
  '2023-07-31 20:15:00 Europe/Paris'
  ),
  ((SELECT account_id FROM account WHERE email = 'helena-bc@email.com'),
  'Plein price',
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '3' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe B')),
  '2023-07-31 16:30:00 Europe/Paris'
  ),
  ((SELECT account_id FROM account WHERE email = 'keira.k@email.com'),
  'Étudiant',
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '1' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe A')),
  '2023-07-30 20:30:00 Europe/Paris'
  ),
  ((SELECT account_id FROM account WHERE email = 'kevin-spacey@email.com'),
  'Plein price',
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = 'A' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe C')),
  '2023-07-30 21:45:00 Europe/Paris'
  ),
  ((SELECT account_id FROM account WHERE email = 'nathalie.p@email.com'),
  'Étudiant',
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '3' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe A')),
  '2023-07-31 14:30:00 Europe/Paris'
  ),
  ((SELECT account_id FROM account WHERE email = 'morgan.f@email.com'),
  'Plein price',
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '2' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe B')),
  '2023-07-31 18:15:00 Europe/Paris'
  ),
  ((SELECT account_id FROM account WHERE email = 'morgan.f@email.com'),
  'Moins de 14 ans',
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = 'C' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe C')),
  '2023-08-01 19:15:00 Europe/Paris'
  ),
  ((SELECT account_id FROM account WHERE email = 'naomi.watts@email.com'),
  'Étudiant',
  (SELECT movie_theater_id FROM movie_theater WHERE movie_theater_name = '4' AND complex_id = (SELECT complex_id FROM complex WHERE complex_name = 'Complexe B')),
  '2023-07-30 18:15:00 Europe/Paris'
  );
  