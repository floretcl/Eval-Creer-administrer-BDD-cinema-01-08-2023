--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3 (Ubuntu 15.3-0ubuntu0.23.04.1)
-- Dumped by pg_dump version 15.3 (Ubuntu 15.3-0ubuntu0.23.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: genre; Type: TYPE; Schema: public; Owner: clementfloret
--

CREATE TYPE public.genre AS ENUM (
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


ALTER TYPE public.genre OWNER TO clementfloret;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account; Type: TABLE; Schema: public; Owner: clementfloret
--

CREATE TABLE public.account (
    account_id uuid DEFAULT gen_random_uuid() NOT NULL,
    lastname character varying(30) NOT NULL,
    firstname character varying(30) NOT NULL,
    email character varying(255) NOT NULL,
    password text NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.account OWNER TO clementfloret;

--
-- Name: account_group_id_seq; Type: SEQUENCE; Schema: public; Owner: clementfloret
--

CREATE SEQUENCE public.account_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_group_id_seq OWNER TO clementfloret;

--
-- Name: account_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clementfloret
--

ALTER SEQUENCE public.account_group_id_seq OWNED BY public.account.group_id;


--
-- Name: booking; Type: TABLE; Schema: public; Owner: clementfloret
--

CREATE TABLE public.booking (
    booking_nb uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_id uuid NOT NULL,
    price_name character varying(20) NOT NULL,
    movie_theater_id uuid NOT NULL,
    date_show timestamp with time zone NOT NULL
);


ALTER TABLE public.booking OWNER TO clementfloret;

--
-- Name: complex; Type: TABLE; Schema: public; Owner: clementfloret
--

CREATE TABLE public.complex (
    complex_id uuid DEFAULT gen_random_uuid() NOT NULL,
    complex_name character varying(50) NOT NULL,
    adress character varying(150) NOT NULL,
    postal_code integer NOT NULL,
    city character varying(80) NOT NULL,
    CONSTRAINT valid_postal_code CHECK ((postal_code <= 99999))
);


ALTER TABLE public.complex OWNER TO clementfloret;

--
-- Name: movie; Type: TABLE; Schema: public; Owner: clementfloret
--

CREATE TABLE public.movie (
    movie_id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(100) NOT NULL,
    release_date timestamp with time zone NOT NULL,
    director character varying(50) NOT NULL,
    genre public.genre,
    duration smallint NOT NULL,
    synopsis text NOT NULL
);


ALTER TABLE public.movie OWNER TO clementfloret;

--
-- Name: movie_show; Type: TABLE; Schema: public; Owner: clementfloret
--

CREATE TABLE public.movie_show (
    date_show timestamp with time zone NOT NULL,
    version_show character varying(30) NOT NULL,
    movie_id uuid NOT NULL,
    movie_theater_id uuid NOT NULL
);


ALTER TABLE public.movie_show OWNER TO clementfloret;

--
-- Name: movie_theater; Type: TABLE; Schema: public; Owner: clementfloret
--

CREATE TABLE public.movie_theater (
    movie_theater_id uuid DEFAULT gen_random_uuid() NOT NULL,
    movie_theater_name character varying(20) NOT NULL,
    complex_id uuid NOT NULL,
    seating_capacity smallint NOT NULL
);


ALTER TABLE public.movie_theater OWNER TO clementfloret;

--
-- Name: price; Type: TABLE; Schema: public; Owner: clementfloret
--

CREATE TABLE public.price (
    price_name character varying(20) NOT NULL,
    price_amount numeric(6,2) NOT NULL
);


ALTER TABLE public.price OWNER TO clementfloret;

--
-- Name: user_group; Type: TABLE; Schema: public; Owner: clementfloret
--

CREATE TABLE public.user_group (
    group_id integer NOT NULL,
    group_name character varying(20) NOT NULL
);


ALTER TABLE public.user_group OWNER TO clementfloret;

--
-- Name: user_group_group_id_seq; Type: SEQUENCE; Schema: public; Owner: clementfloret
--

CREATE SEQUENCE public.user_group_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_group_group_id_seq OWNER TO clementfloret;

--
-- Name: user_group_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clementfloret
--

ALTER SEQUENCE public.user_group_group_id_seq OWNED BY public.user_group.group_id;


--
-- Name: account group_id; Type: DEFAULT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.account ALTER COLUMN group_id SET DEFAULT nextval('public.account_group_id_seq'::regclass);


--
-- Name: user_group group_id; Type: DEFAULT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.user_group ALTER COLUMN group_id SET DEFAULT nextval('public.user_group_group_id_seq'::regclass);


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: clementfloret
--

COPY public.account (account_id, lastname, firstname, email, password, group_id) FROM stdin;
cc591ff9-5240-4170-90c0-4d78724ac31a	Pacino	Al	alpacino@email.com	$2a$06$gngn4F0DdVF7AwFW9yeXFO2qVqGQfWqCMq7C/ZnTfKqTZVYGzaVvq	1
3c896266-43c0-4ca1-b5d1-2162709d7912	De niro	Robert	deniro@email.com	$2a$06$TA1i5yiNoESjmrWODtZoCu7EaPXVp9E0UpMOHGPhogyaS3qJHI5Ca	1
18280547-9de8-4627-8c41-97be8bd48f38	Foster	Jodie	j.foster@email.com	$2a$06$/9UaRFWa88H8BS8SWwZ7SOYfQBHrwN6NshWUOAtivjeWnCuFVLbUq	2
3e97af4c-7693-490a-8012-913f5f8293a2	Streep	Meryl	merylstreep@email.com	$2a$06$.YQt2c5NmuaunHXtBmRDb.v3Vs/2CPrUSGWepgbY3wkDha7mA.QoS	2
3706629b-6c82-4a4b-a17f-f9086fa9e8e8	Thurman	Uma	thurman.uma@email.com	$2a$06$/SWrWHpybx6Yu7UZjqEzn.6iFLoswVk5Iqu66VYYjxUpwibLr6hti	2
f5f4f2c5-e5e3-498b-a0fc-d83efab85bef	DiCaprio	Leonardo	dicaprio@email.com	$2a$06$CqMU8wnAi1rUxdpfXFltd.8bPekzLw.hdkTTWYQLlYOx9/Yz8mTVS	3
db80efc1-599e-4301-8e86-cbe9c267d447	Eastwood	Clint	clint.eastwood@email.com	$2a$06$NbvgtZElfdQjqAUAZrGEw.YR8nv9d9F4aI8D8/.Gk8unDfcjOyiGq	3
7d8a3f9d-9c89-4800-a02a-1a11ab671b8a	Spacey	Kevin	kevin-spacey@email.com	$2a$06$r2biNG3..fPgokOyiLowE.8NrJ4MUAQx4G5t6IzBo4nQebvapkyvC	3
b4ac3f0d-c27d-467a-a644-c50dcfe65509	Freeman	Morgan	morgan.f@email.com	$2a$06$LGx2apfVvvQpcYFr70eQCOVT1Ns69RzE5lPDreqnB4hEWG2whT3ka	3
aef1b805-ee7a-4448-982c-2199427a12f5	Portman	Nathalie	nathalie.p@email.com	$2a$06$JzA5xbiWDF6YoHtDH.jDAeG.wbQ9eOFKVya2DadJeTRZb4T7hdUjK	3
5f19c3c3-a462-4c56-ba0f-62bcd25484a5	Watts	Naomi	naomi.watts@email.com	$2a$06$8tpf5DC.00wxt5wOEXMSd.vb.MrmMSfCS6xq5A.c0fd.q59PfbNt.	3
f9b488a6-2590-4e1c-bf14-a1d9bbed9c04	Bonham Carter	Helena	helena-bc@email.com	$2a$06$lop8Qbnrex1gZ5w0uoJNluveawFOt4kB0Sv1gbNLeyih.IKYDOv5O	3
d42efde3-9031-424f-9e57-e6eccfe2f966	Knightley	Keira	keira.k@email.com	$2a$06$GbEfJjuRsVIqZprCRhl6nedyKLiSpAstWNMqxfOB9kLorP1yaPrQy	3
\.


--
-- Data for Name: booking; Type: TABLE DATA; Schema: public; Owner: clementfloret
--

COPY public.booking (booking_nb, customer_id, price_name, movie_theater_id, date_show) FROM stdin;
55bb8a92-ca38-44e4-88ff-60719378c521	f5f4f2c5-e5e3-498b-a0fc-d83efab85bef	Moins de 14 ans	223b38f5-1e7e-468d-9e0d-740d6545dc9c	2023-07-30 21:45:00+02
e6892088-8d7e-4501-9789-07e2294d14af	db80efc1-599e-4301-8e86-cbe9c267d447	Moins de 14 ans	c3737141-8205-42d9-b5f0-c4767f5921c7	2023-07-31 18:15:00+02
9e96101e-7762-4bc5-9299-b8eeef9bef92	db80efc1-599e-4301-8e86-cbe9c267d447	Plein price	cae3ef71-818a-41cc-9c9a-e9a554989ff0	2023-07-31 20:15:00+02
f5a2c987-518b-4113-94a6-b3d8bac28a82	f9b488a6-2590-4e1c-bf14-a1d9bbed9c04	Plein price	cae3ef71-818a-41cc-9c9a-e9a554989ff0	2023-07-31 20:15:00+02
3cb5022d-3c19-40b1-bba3-759d99a7134c	f9b488a6-2590-4e1c-bf14-a1d9bbed9c04	Plein price	cac6fcf4-44c8-4997-90af-f06ae0128097	2023-07-31 16:30:00+02
8c99b02f-f156-4347-944f-26dc34fc58a8	d42efde3-9031-424f-9e57-e6eccfe2f966	Étudiant	c3a510ad-6096-4b05-92e6-02fe8b61fac4	2023-07-30 20:30:00+02
c420c2d4-373c-4d1a-9f39-981c253c154f	7d8a3f9d-9c89-4800-a02a-1a11ab671b8a	Plein price	223b38f5-1e7e-468d-9e0d-740d6545dc9c	2023-07-30 21:45:00+02
0e31e6cd-c7f4-48c9-b2a2-b9e83f9fe587	aef1b805-ee7a-4448-982c-2199427a12f5	Étudiant	6223f9e3-47e7-4e9a-bf86-53cb560c53c1	2023-07-31 14:30:00+02
2863b2cf-d7a6-49ee-9f43-d9ecab89b27a	b4ac3f0d-c27d-467a-a644-c50dcfe65509	Plein price	9750e5ed-cbd0-4436-96ac-69a4255aecdf	2023-07-31 18:15:00+02
fb0f0ef4-eb52-4a87-8d63-12bfc5ae7495	b4ac3f0d-c27d-467a-a644-c50dcfe65509	Moins de 14 ans	89b23cd7-5d68-4cd8-a31f-bcf2bae83adf	2023-08-01 19:15:00+02
a9b76c60-99cd-4724-897e-d5538346f404	5f19c3c3-a462-4c56-ba0f-62bcd25484a5	Étudiant	5b2fb546-8817-477f-aecd-4d097ba5caea	2023-07-30 18:15:00+02
\.


--
-- Data for Name: complex; Type: TABLE DATA; Schema: public; Owner: clementfloret
--

COPY public.complex (complex_id, complex_name, adress, postal_code, city) FROM stdin;
f9e66dbf-9168-416c-9429-6b0109ffc20a	Complexe A	100 Avenue des champs élysées	75008	Paris
53a28c21-2eac-44c1-97cb-d034e7450024	Complexe B	11 Place bellecour	69002	Lyon
a3db4710-c478-45c6-9dbf-34710a7d885e	Complexe C	23 La canebière	13001	Marseille
\.


--
-- Data for Name: movie; Type: TABLE DATA; Schema: public; Owner: clementfloret
--

COPY public.movie (movie_id, title, release_date, director, genre, duration, synopsis) FROM stdin;
a29ca0b1-5e37-455c-8375-829be99168a7	Forrest Gump	1994-10-05 00:00:00+01	Robert Zemeckis	comédie	140	Quelques décennies d'histoire américaine, des années 1940 à la fin du XXème siècle, à travers le regard et l'étrange odyssée d'un homme simple et pur, Forrest Gump.
b925c654-f6c5-4b33-8998-30dddbf46a8a	La liste de schindler	1994-03-02 00:00:00+01	Steven Spielberg	historique	195	Evocation des années de guerre d'Oskar Schindler, fils d'industriel d'origine autrichienne rentré à Cracovie en 1939 avec les troupes allemandes. Il va, tout au long de la guerre, protéger des juifs en les faisant travailler dans sa fabrique et en 1944 sauver huit cents hommes et trois cents femmes du camp d'extermination de Auschwitz-Birkenau.
37fd08fa-0813-47c4-9086-dfd387c06e4b	La ligne verte	2000-03-01 00:00:00+01	Frank Darabont	drame	189	Paul Edgecomb, pensionnaire centenaire d'une maison de retraite, est hanté par ses souvenirs. Gardien-chef du pénitencier de Cold Mountain en 1935, il était chargé de veiller au bon déroulement des exécutions capitales en s’efforçant d'adoucir les derniers moments des condamnés. Parmi eux se trouvait un colosse du nom de John Coffey, accusé du viol et du meurtre de deux fillettes. Intrigué par cet homme candide et timide aux dons magiques, Edgecomb va tisser avec lui des liens très forts.
5eedb392-c3a5-4a58-a766-47b16c78d737	12 hommes en colère	1957-09-04 00:00:00+01	Sidney Lumet	drame	95	Un jeune homme d'origine modeste est accusé du meurtre de son père et risque la peine de mort. Le jury composé de douze hommes se retire pour délibérer et procède immédiatement à un vote : onze votent coupable, or la décision doit être prise à l'unanimité. Le juré qui a voté non-coupable, sommé de se justifier, explique qu'il a un doute et que la vie d'un homme mérite quelques heures de discussion. Il s'emploie alors à les convaincre un par un.
31e9891e-717f-4f50-b3d7-6cb70de64415	Le parrain	1972-10-18 00:00:00+01	Francis Ford Coppola	policier	175	En 1945, à New York, les Corleone sont une des cinq familles de la mafia. Don Vito Corleone, parrain de cette famille, marie sa fille à un bookmaker. Sollozzo, parrain de la famille Tattaglia, propose à Don Vito une association dans le trafic de drogue, mais celui-ci refuse. Sonny, un de ses fils, y est quant à lui favorable.\nAfin de traiter avec Sonny, Sollozzo tente de faire tuer Don Vito, mais celui-ci en réchappe. Michael, le frère cadet de Sonny, recherche alors les commanditaires de l'attentat et tue Sollozzo et le chef de la police, en représailles.\nMichael part alors en Sicile, où il épouse Apollonia, mais celle-ci est assassinée à sa place. De retour à New York, Michael épouse Kay Adams et se prépare à devenir le successeur de son père...
68015a1c-25be-4f70-8a07-73622c4093f2	Les évadés	1995-03-01 00:00:00+01	Frank Darabont	drame	142	Red, condamné à perpétuité, et Andy Dufresne, un gentil banquier injustement condamné pour meurtre, se lient d'une amitié inattendue qui va durer plus de vingt ans. Ensemble, ils découvrent l'espoir comme l'ultime moyen de survie. Sous des conditions terrifiantes et la menace omniprésente de la violence, les deux condamnés à perpétuité récupèrent leurs âmes et retrouvent la liberté dans leurs cœurs.
f73e8cc3-c2a0-41e0-9c9b-9262ad614a3e	Le seigneur des anneaux : le retour du roi	2003-12-17 00:00:00+01	Peter Jackson	fantastique	201	Les armées de Sauron ont attaqué Minas Tirith, la capitale de Gondor. Jamais ce royaume autrefois puissant n'a eu autant besoin de son roi. Mais Aragorn trouvera-t-il en lui la volonté d'accomplir sa destinée ?\nTandis que Gandalf s'efforce de soutenir les forces brisées de Gondor, Théoden exhorte les guerriers de Rohan à se joindre au combat. Mais malgré leur courage et leur loyauté, les forces des Hommes ne sont pas de taille à lutter contre les innombrables légions d'ennemis qui s'abattent sur le royaume...\nChaque victoire se paye d'immenses sacrifices. Malgré ses pertes, la Communauté se jette dans la bataille pour la vie, ses membres faisant tout pour détourner l'attention de Sauron afin de donner à Frodon une chance d'accomplir sa quête.\nVoyageant à travers les terres ennemies, ce dernier doit se reposer sur Sam et Gollum, tandis que l'Anneau continue de le tenter...
0ebaf313-4dbc-4003-b9d9-412f5167fb59	Le roi lion	1994-11-23 00:00:00+01	Roger Allers, Rob Minkoff	famille	89	Sur les Hautes terres d’Afrique règne un lion tout-puissant, le roi Mufasa, que tous les hôtes de la jungle respectent et admirent pour sa sagesse et sa générosité. Son jeune fils Simba sait qu’un jour il lui succédera, conformément aux lois universelles du cycle de la vie, mais il est loin de deviner les épreuves et les sacrifices que lui imposera l’exercice du pouvoir. Espiègle, naïf et turbulent, le lionceau passe le plus clair de son temps à jouer avec sa petite copine Nala et à taquiner Zazu, son digne précepteur. Son futur royaume lui apparaît en songe comme un lieu enchanté où il fera bon vivre, s’amuser et donner des ordres. Cependant, l’univers de Simba n’est pas aussi sûr qu’il le croie. Scar, le frère de Mufasa, aspire en effet depuis toujours au trône. Maladivement jaloux de son aîné, il intrigue pour l’éliminer en même temps que son successeur. Misant sur la curiosité enfantine et le tempérament aventureux de Simba, il révèle à celui-ci l’existence d’un mystérieux et dangereux cimetière d’éléphants. Simba, oubliant les avertissements répétés de son père, s’y rend aussitôt en secret avec Nala et se fait attaquer par 3 hyènes féroces. Par chance, Mufasa arrive à temps pour sauver l’imprudent lionceau et sa petite compagne. Mais Scar ne renonce pas à ses sinistres projets. Aidé des 3 hyènes, il attire Simba dans un ravin et lance à sa poursuite un troupeau de gnous. N’écoutant que son courage, Mufasa sauve à nouveau son fils et tente de se mettre à l’abri en gravissant la falaise. Repoussé par son frère félon, il périt sous les sabots des gnous affolés. Scar blâme alors l’innocent Simba pour la mort du Roi et le persuade de quitter pour toujours les Hautes terres. Simba se retrouve pour la première fois seul et démuni face à un monde hostile. C’est alors que le destin place sur sa route un curieux tandem d’amis...
94d640c6-4765-4bfc-a3d8-7c199e790848	Vol-au-dessus d'un nid de coucou	1976-03-01 00:00:00+01	Milos Forman	drame	129	Adapté du best-seller éponyme de Ken Kesey, Vol au-dessus d'un nid de coucou décrit, avec une précision quasiment documentaire, les traitements infligés aux patients dans les années 1960 : médicaments surdosés, douches glacées, électrochocs ou encore lobotomie. Mais ce pamphlet contre le fonctionnement des hôpitaux psychiatriques questionne aussi le sens de la révolte : pourquoi doit-on résister ? Jusqu'où peut-on s'opposer ? Où se situe la frontière entre l'héroïsme et la folie ? D'un côté, convaincue de faire le bien, miss Ratched applique les règles aveuglément et infantilise ses patients. De l'autre, McMurphy se bat pour leur rendre leur dignité quitte à défier les lois d'un système répressif et inhumain. Louise Fletcher et Jack Nicholson, tous deux oscarisés pour leur performance exceptionnelle, personnifient la confrontation entre l'individu et l'institution, placée au cœur d'une œuvre intense dont on ne sort pas indemne. Magistralement mis en scène par Milos Forman, un grand movie, qui a marqué toute une génération.
7507dbce-fd18-4950-a96e-660ee62d2dc6	The dark knight : le chevalier noir	2008-08-13 00:00:00+02	Christopher Nolan	action	152	Dans ce nouveau volet, Batman augmente les mises dans sa guerre contre le crime. Avec l'appui du lieutenant de police Jim Gordon et du procureur de Gotham, Harvey Dent, Batman vise à éradiquer le crime organisé qui pullule dans la ville. Leur association est très efficace mais elle sera bientôt bouleversée par le chaos déclenché par un criminel extraordinaire que les citoyens de Gotham connaissent sous le nom de Joker.
\.


--
-- Data for Name: movie_show; Type: TABLE DATA; Schema: public; Owner: clementfloret
--

COPY public.movie_show (date_show, version_show, movie_id, movie_theater_id) FROM stdin;
2023-07-30 20:30:00+02	VF	a29ca0b1-5e37-455c-8375-829be99168a7	c3a510ad-6096-4b05-92e6-02fe8b61fac4
2023-07-30 15:30:00+02	VF	a29ca0b1-5e37-455c-8375-829be99168a7	c3a510ad-6096-4b05-92e6-02fe8b61fac4
2023-08-01 18:15:00+02	VF	b925c654-f6c5-4b33-8998-30dddbf46a8a	c3737141-8205-42d9-b5f0-c4767f5921c7
2023-07-31 18:15:00+02	VF	b925c654-f6c5-4b33-8998-30dddbf46a8a	c3737141-8205-42d9-b5f0-c4767f5921c7
2023-07-31 14:30:00+02	VO	37fd08fa-0813-47c4-9086-dfd387c06e4b	6223f9e3-47e7-4e9a-bf86-53cb560c53c1
2023-07-30 18:15:00+02	VF	5eedb392-c3a5-4a58-a766-47b16c78d737	cae3ef71-818a-41cc-9c9a-e9a554989ff0
2023-07-31 20:15:00+02	VF	31e9891e-717f-4f50-b3d7-6cb70de64415	cae3ef71-818a-41cc-9c9a-e9a554989ff0
2023-07-31 14:15:00+02	VF	31e9891e-717f-4f50-b3d7-6cb70de64415	cae3ef71-818a-41cc-9c9a-e9a554989ff0
2023-08-01 09:15:00+02	VO	f73e8cc3-c2a0-41e0-9c9b-9262ad614a3e	a864e648-dfbc-4da1-b2a5-28d0fb46cabd
2023-07-30 20:30:00+02	VF	b925c654-f6c5-4b33-8998-30dddbf46a8a	9f5068e2-7e82-49bb-bea6-91ea462725b7
2023-07-30 16:00:00+02	VF	94d640c6-4765-4bfc-a3d8-7c199e790848	9f5068e2-7e82-49bb-bea6-91ea462725b7
2023-08-01 18:15:00+02	VF	94d640c6-4765-4bfc-a3d8-7c199e790848	9750e5ed-cbd0-4436-96ac-69a4255aecdf
2023-07-31 18:15:00+02	VF	b925c654-f6c5-4b33-8998-30dddbf46a8a	9750e5ed-cbd0-4436-96ac-69a4255aecdf
2023-07-31 16:30:00+02	VO	a29ca0b1-5e37-455c-8375-829be99168a7	cac6fcf4-44c8-4997-90af-f06ae0128097
2023-07-30 18:15:00+02	VF	7507dbce-fd18-4950-a96e-660ee62d2dc6	5b2fb546-8817-477f-aecd-4d097ba5caea
2023-07-31 19:15:00+02	VF	37fd08fa-0813-47c4-9086-dfd387c06e4b	5b2fb546-8817-477f-aecd-4d097ba5caea
2023-07-31 14:15:00+02	VF	f73e8cc3-c2a0-41e0-9c9b-9262ad614a3e	5b2fb546-8817-477f-aecd-4d097ba5caea
2023-08-01 10:15:00+02	VO	68015a1c-25be-4f70-8a07-73622c4093f2	5b2fb546-8817-477f-aecd-4d097ba5caea
2023-07-30 21:45:00+02	VF	a29ca0b1-5e37-455c-8375-829be99168a7	223b38f5-1e7e-468d-9e0d-740d6545dc9c
2023-08-01 16:00:00+02	VF	5eedb392-c3a5-4a58-a766-47b16c78d737	223b38f5-1e7e-468d-9e0d-740d6545dc9c
2023-07-31 18:15:00+02	VF	5eedb392-c3a5-4a58-a766-47b16c78d737	223b38f5-1e7e-468d-9e0d-740d6545dc9c
2023-08-01 18:15:00+02	VF	a29ca0b1-5e37-455c-8375-829be99168a7	ec37aad1-fad6-456d-92b7-7153bdd74369
2023-07-30 16:30:00+02	VO	94d640c6-4765-4bfc-a3d8-7c199e790848	ec37aad1-fad6-456d-92b7-7153bdd74369
2023-07-31 18:15:00+02	VF	f73e8cc3-c2a0-41e0-9c9b-9262ad614a3e	89b23cd7-5d68-4cd8-a31f-bcf2bae83adf
2023-08-01 19:15:00+02	VF	68015a1c-25be-4f70-8a07-73622c4093f2	89b23cd7-5d68-4cd8-a31f-bcf2bae83adf
2023-08-01 14:15:00+02	VF	7507dbce-fd18-4950-a96e-660ee62d2dc6	d3bbbb9d-c3ae-4f99-b920-3820b6e68caa
2023-07-30 10:15:00+02	VO	7507dbce-fd18-4950-a96e-660ee62d2dc6	d3bbbb9d-c3ae-4f99-b920-3820b6e68caa
\.


--
-- Data for Name: movie_theater; Type: TABLE DATA; Schema: public; Owner: clementfloret
--

COPY public.movie_theater (movie_theater_id, movie_theater_name, complex_id, seating_capacity) FROM stdin;
c3a510ad-6096-4b05-92e6-02fe8b61fac4	1	f9e66dbf-9168-416c-9429-6b0109ffc20a	182
c3737141-8205-42d9-b5f0-c4767f5921c7	2	f9e66dbf-9168-416c-9429-6b0109ffc20a	140
6223f9e3-47e7-4e9a-bf86-53cb560c53c1	3	f9e66dbf-9168-416c-9429-6b0109ffc20a	120
cae3ef71-818a-41cc-9c9a-e9a554989ff0	4	f9e66dbf-9168-416c-9429-6b0109ffc20a	110
a864e648-dfbc-4da1-b2a5-28d0fb46cabd	5	f9e66dbf-9168-416c-9429-6b0109ffc20a	92
9f5068e2-7e82-49bb-bea6-91ea462725b7	1	53a28c21-2eac-44c1-97cb-d034e7450024	120
9750e5ed-cbd0-4436-96ac-69a4255aecdf	2	53a28c21-2eac-44c1-97cb-d034e7450024	96
cac6fcf4-44c8-4997-90af-f06ae0128097	3	53a28c21-2eac-44c1-97cb-d034e7450024	96
5b2fb546-8817-477f-aecd-4d097ba5caea	4	53a28c21-2eac-44c1-97cb-d034e7450024	88
223b38f5-1e7e-468d-9e0d-740d6545dc9c	A	a3db4710-c478-45c6-9dbf-34710a7d885e	160
ec37aad1-fad6-456d-92b7-7153bdd74369	B	a3db4710-c478-45c6-9dbf-34710a7d885e	126
89b23cd7-5d68-4cd8-a31f-bcf2bae83adf	C	a3db4710-c478-45c6-9dbf-34710a7d885e	126
d3bbbb9d-c3ae-4f99-b920-3820b6e68caa	D	a3db4710-c478-45c6-9dbf-34710a7d885e	98
\.


--
-- Data for Name: price; Type: TABLE DATA; Schema: public; Owner: clementfloret
--

COPY public.price (price_name, price_amount) FROM stdin;
Plein price	9.20
Étudiant	7.60
Moins de 14 ans	5.90
\.


--
-- Data for Name: user_group; Type: TABLE DATA; Schema: public; Owner: clementfloret
--

COPY public.user_group (group_id, group_name) FROM stdin;
1	Admin
2	Employé
3	Client
\.


--
-- Name: account_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clementfloret
--

SELECT pg_catalog.setval('public.account_group_id_seq', 1, false);


--
-- Name: user_group_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clementfloret
--

SELECT pg_catalog.setval('public.user_group_group_id_seq', 3, true);


--
-- Name: account account_email_key; Type: CONSTRAINT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_email_key UNIQUE (email);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (account_id);


--
-- Name: booking booking_pkey; Type: CONSTRAINT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_pkey PRIMARY KEY (booking_nb);


--
-- Name: complex complex_pkey; Type: CONSTRAINT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.complex
    ADD CONSTRAINT complex_pkey PRIMARY KEY (complex_id);


--
-- Name: movie movie_pkey; Type: CONSTRAINT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.movie
    ADD CONSTRAINT movie_pkey PRIMARY KEY (movie_id);


--
-- Name: movie_show movie_show_pkey; Type: CONSTRAINT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.movie_show
    ADD CONSTRAINT movie_show_pkey PRIMARY KEY (movie_theater_id, date_show);


--
-- Name: movie_theater movie_theater_pkey; Type: CONSTRAINT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.movie_theater
    ADD CONSTRAINT movie_theater_pkey PRIMARY KEY (movie_theater_id);


--
-- Name: price price_pkey; Type: CONSTRAINT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_pkey PRIMARY KEY (price_name);


--
-- Name: user_group user_group_pkey; Type: CONSTRAINT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.user_group
    ADD CONSTRAINT user_group_pkey PRIMARY KEY (group_id);


--
-- Name: account account_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.user_group(group_id);


--
-- Name: booking booking_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.account(account_id);


--
-- Name: booking booking_movie_theater_id_date_show_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_movie_theater_id_date_show_fkey FOREIGN KEY (movie_theater_id, date_show) REFERENCES public.movie_show(movie_theater_id, date_show);


--
-- Name: booking booking_price_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_price_name_fkey FOREIGN KEY (price_name) REFERENCES public.price(price_name);


--
-- Name: movie_show movie_show_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.movie_show
    ADD CONSTRAINT movie_show_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movie(movie_id);


--
-- Name: movie_show movie_show_movie_theater_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.movie_show
    ADD CONSTRAINT movie_show_movie_theater_id_fkey FOREIGN KEY (movie_theater_id) REFERENCES public.movie_theater(movie_theater_id);


--
-- Name: movie_theater movie_theater_complex_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: clementfloret
--

ALTER TABLE ONLY public.movie_theater
    ADD CONSTRAINT movie_theater_complex_id_fkey FOREIGN KEY (complex_id) REFERENCES public.complex(complex_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

