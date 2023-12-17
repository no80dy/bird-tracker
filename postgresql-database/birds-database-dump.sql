--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

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
-- Name: content; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA content;


ALTER SCHEMA content OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bird_families; Type: TABLE; Schema: content; Owner: postgres
--

CREATE TABLE content.bird_families (
    id uuid NOT NULL,
    family_name character varying(30) NOT NULL,
    description text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE content.bird_families OWNER TO postgres;

--
-- Name: bird_images; Type: TABLE; Schema: content; Owner: postgres
--

CREATE TABLE content.bird_images (
    id uuid NOT NULL,
    observation_id uuid NOT NULL,
    image text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE content.bird_images OWNER TO postgres;

--
-- Name: bird_locations; Type: TABLE; Schema: content; Owner: postgres
--

CREATE TABLE content.bird_locations (
    id uuid NOT NULL,
    location_name character varying(50) NOT NULL,
    longitude double precision,
    latitude double precision,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE content.bird_locations OWNER TO postgres;

--
-- Name: bird_observations; Type: TABLE; Schema: content; Owner: postgres
--

CREATE TABLE content.bird_observations (
    id uuid NOT NULL,
    observation_name character varying(30) NOT NULL,
    location_id uuid NOT NULL,
    bird_id uuid NOT NULL,
    user_id uuid,
    gender text NOT NULL,
    description text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE content.bird_observations OWNER TO postgres;

--
-- Name: bird_statuses; Type: TABLE; Schema: content; Owner: postgres
--

CREATE TABLE content.bird_statuses (
    id uuid NOT NULL,
    status_name character varying(30) NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE content.bird_statuses OWNER TO postgres;

--
-- Name: birds; Type: TABLE; Schema: content; Owner: postgres
--

CREATE TABLE content.birds (
    id uuid NOT NULL,
    bird_name character varying(30) NOT NULL,
    scientific_name character varying(30),
    description text,
    status_id uuid NOT NULL,
    family_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE content.birds OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: content; Owner: postgres
--

CREATE TABLE content.users (
    id uuid NOT NULL,
    username character varying(30) NOT NULL,
    email character varying(30) NOT NULL,
    password_hash character varying(255) NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE content.users OWNER TO postgres;

--
-- Data for Name: bird_families; Type: TABLE DATA; Schema: content; Owner: postgres
--

COPY content.bird_families (id, family_name, description, created_at, updated_at) FROM stdin;
706efeb3-234f-49c8-b02f-3edebaa169f2	Совиные	\N	2023-12-17 15:10:32.334605+00	2023-12-17 15:10:32.33461+00
6de52f2e-7928-4fa5-abfc-23674c9c854e	Цаплевые	\N	2023-12-17 15:36:40.076141+00	2023-12-17 15:36:40.076144+00
58b5a410-854a-4b65-85df-ae46b9484e74	Соколиные	\N	2023-12-17 15:38:21.962506+00	2023-12-17 15:38:21.962509+00
4595ba9f-a00d-446a-99b6-23a78bc1ddaf	Врановые	\N	2023-12-17 15:38:27.319664+00	2023-12-17 15:38:27.319666+00
32cdb50a-1dbc-41f9-a135-a7cd6e460ab6	Дроздовые	\N	2023-12-17 15:38:33.70775+00	2023-12-17 15:38:33.707754+00
48fd4615-a872-4495-93ce-b1a212bb3adb	Дятловые	\N	2023-12-17 15:38:39.362381+00	2023-12-17 15:38:39.362384+00
73450ecc-ee9d-4140-b30f-0f5cb69e1e9f	Синицевые	\N	2023-12-17 15:38:46.396389+00	2023-12-17 15:38:46.396394+00
d1b7adfd-7283-4a4f-9930-02efc91cc376	Утиные	\N	2023-12-17 15:38:52.154177+00	2023-12-17 15:38:52.154179+00
d4a26f6c-482a-4ccd-9a94-77c39c7e5860	Королевские	\N	2023-12-17 15:39:06.430158+00	2023-12-17 15:39:06.430161+00
2128ee9f-d9e7-4cab-a7ea-96889aa0740e	Ястребиные	\N	2023-12-17 15:39:19.199349+00	2023-12-17 15:39:19.199353+00
\.


--
-- Data for Name: bird_images; Type: TABLE DATA; Schema: content; Owner: postgres
--

COPY content.bird_images (id, observation_id, image, created_at, updated_at) FROM stdin;
70106017-7cd5-43d3-92d8-3482f1e24533	a4a265c0-8a9f-4959-ac7c-6e15af58aa8b	Untitled.jpeg	2023-12-17 15:16:39.711302+00	2023-12-17 15:16:39.711311+00
1112490c-a4c6-4ee4-92d3-4cb55031a028	a4a265c0-8a9f-4959-ac7c-6e15af58aa8b	sova_1.jpeg	2023-12-17 15:23:07.412005+00	2023-12-17 15:23:07.412009+00
2c39426e-3e8b-4848-8e07-f77e46f528a7	1b94f017-59a3-4833-a202-dcc85d5911cb	chernish.jpeg	2023-12-17 16:12:33.834424+00	2023-12-17 16:12:33.834426+00
1bb91c1f-26c1-4ead-934d-1b828421bdb7	67ffe1a3-5faf-4cc9-a750-8acb2dae1dfe	chirok.jpeg	2023-12-17 16:12:41.77154+00	2023-12-17 16:12:41.771544+00
d2e4f65e-eeee-473f-9f11-aedc00c487e3	e1e206df-1a15-4322-939d-cf793018d93b	zeleniy_dyatel.jpg	2023-12-17 16:12:48.444178+00	2023-12-17 16:12:48.444182+00
6dfbb267-61db-4cad-ab4a-8658323d836c	58aac26b-348c-47bb-bf61-fa4abdb71ac3	krasnaya_ytka.jpeg	2023-12-17 16:13:39.354178+00	2023-12-17 16:13:39.35418+00
5e997118-fdc8-4a80-a8bc-055c96352de4	cca5942c-fc25-4612-a43a-f9f94b64266a	yastreb_stervyatnik.jpeg	2023-12-17 16:13:52.80296+00	2023-12-17 16:13:52.802965+00
78ee18e6-4b9f-4d47-a2b3-b8e6e64b3c36	719ab8d9-0357-444c-8987-fb1d5ff5e67c	serie_neyasiti.jpg	2023-12-17 16:14:10.165406+00	2023-12-17 16:14:10.165409+00
238b5e36-26d3-425a-be36-b5fac0f915b7	0437a8eb-231e-4b90-baf4-ebe23817f427	perevozchik.jpg	2023-12-17 16:14:22.30724+00	2023-12-17 16:14:22.307243+00
47f04c6f-0beb-4dd0-bf34-6e04629bc84d	3d8735a7-d0b2-4fe4-b90a-11924a184b0e	hohlataya_sinica.jpg	2023-12-17 16:14:56.926826+00	2023-12-17 16:14:56.92683+00
\.


--
-- Data for Name: bird_locations; Type: TABLE DATA; Schema: content; Owner: postgres
--

COPY content.bird_locations (id, location_name, longitude, latitude, created_at, updated_at) FROM stdin;
59eca990-6bb3-45c2-80c3-910b028ff36c	Река Сходня	37.199242	55.988833	2023-12-17 17:43:23.81005+00	2023-12-17 17:43:23.810051+00
978a4d9a-62cd-41f6-9f60-5d5899009370	Голеневский ручей	37.197345	55.986626	2023-12-17 17:43:45.753349+00	2023-12-17 17:43:45.753352+00
be1abef1-b605-40ce-b93a-c10b2aa3c022	Озеро Школьное	37.176362	55.989507	2023-12-17 17:44:02.711318+00	2023-12-17 17:44:02.711321+00
4f090f39-1718-4c05-beb3-a848f73209e3	Дунькин пруд	37.195001	55.996298	2023-12-17 17:44:34.653739+00	2023-12-17 17:44:34.653743+00
a81655c3-94ef-4647-a6d1-6f84a426c359	Болдов ручей	37.1858	56.000205	2023-12-17 17:44:52.149567+00	2023-12-17 17:44:52.149571+00
bc358f0e-d2f3-4b29-97ee-ce63320323ec	Малый Городской пруд	37.209845	55.987742	2023-12-17 17:45:19.086126+00	2023-12-17 17:45:19.086128+00
0014b86e-cb6e-4dcd-9f56-d77f7519639d	Озеро Чёрное	37.236693	55.992319	2023-12-17 17:45:49.61839+00	2023-12-17 17:45:49.618394+00
7c863c85-7ed6-4f04-ba64-8d691bd749fb	Никольский пруд 55.995451, 37.246584	37.246584	55.995451	2023-12-17 17:46:10.130312+00	2023-12-17 17:46:10.130315+00
78699e58-a7ec-4680-9bbf-c7e55ada3aed	Река Ржавка	37.244053	55.997069	2023-12-17 17:46:27.6346+00	2023-12-17 17:46:27.634604+00
7af63d10-0ff1-4cd4-81a4-3c572b4c894a	Михайловский пруд	37.152145	55.978707	2023-12-17 17:46:43.792288+00	2023-12-17 17:46:43.792291+00
\.


--
-- Data for Name: bird_observations; Type: TABLE DATA; Schema: content; Owner: postgres
--

COPY content.bird_observations (id, observation_name, location_id, bird_id, user_id, gender, description, created_at, updated_at) FROM stdin;
a4a265c0-8a9f-4959-ac7c-6e15af58aa8b	А я думала это сова	59eca990-6bb3-45c2-80c3-910b028ff36c	982a56df-d7e2-49b2-b020-b3d8afbbc5df	d5e4a493-422c-4d30-b1c6-af4db2637e54	Male	А я думала это сова	2023-12-17 15:14:51.144211+00	2023-12-17 15:14:51.144216+00
58aac26b-348c-47bb-bf61-fa4abdb71ac3	Красная уточка	be1abef1-b605-40ce-b93a-c10b2aa3c022	a7edc2ba-bbef-40a7-8fdc-dc9787d0fc55	d5e4a493-422c-4d30-b1c6-af4db2637e54	Male	Вау, Красная уточка	2023-12-17 15:53:03.221873+00	2023-12-17 15:53:03.221881+00
1d10de71-dd38-418b-bb82-8f062ab664d8	Цапли на Школьном озере	be1abef1-b605-40ce-b93a-c10b2aa3c022	e0536863-b2db-4cec-ae8b-3612af105bee	d5e4a493-422c-4d30-b1c6-af4db2637e54	Male	О, Цапли на Школьном озере	2023-12-17 15:53:54.771029+00	2023-12-17 15:53:54.771033+00
e1e206df-1a15-4322-939d-cf793018d93b	Зеленый дятел около р. Сходни	59eca990-6bb3-45c2-80c3-910b028ff36c	32246ce4-0020-445a-a906-3c62ee01ac23	d5e4a493-422c-4d30-b1c6-af4db2637e54	Female	Дятел с зеленой окраской	2023-12-17 15:54:37.396205+00	2023-12-17 15:54:37.396208+00
67ffe1a3-5faf-4cc9-a750-8acb2dae1dfe	Чирок на Дунькином пруду	4f090f39-1718-4c05-beb3-a848f73209e3	af29b63b-844a-4868-9e84-4a78232309f3	d5e4a493-422c-4d30-b1c6-af4db2637e54	Male	Чирок на Дунькином пруду	2023-12-17 16:01:49.73718+00	2023-12-17 16:01:49.737182+00
1b94f017-59a3-4833-a202-dcc85d5911cb	Черныш на Никольском пруду	7c863c85-7ed6-4f04-ba64-8d691bd749fb	109731b6-4a08-4e17-9b81-aeae20556085	d5e4a493-422c-4d30-b1c6-af4db2637e54	Female	Черныш на Никольском пруду	2023-12-17 16:02:25.584316+00	2023-12-17 16:02:25.584319+00
719ab8d9-0357-444c-8987-fb1d5ff5e67c	Стая сервых неясытей	7af63d10-0ff1-4cd4-81a4-3c572b4c894a	09cae6a0-17e3-472c-af33-1aa35a715e28	d5e4a493-422c-4d30-b1c6-af4db2637e54	Male, Female	Большая стая сервых неясытей	2023-12-17 16:03:18.193746+00	2023-12-17 16:03:18.193749+00
3d8735a7-d0b2-4fe4-b90a-11924a184b0e	Необычная синица	59eca990-6bb3-45c2-80c3-910b028ff36c	e6710c9d-6879-47ee-9811-852e27c47004	d5e4a493-422c-4d30-b1c6-af4db2637e54	Male	Необычная синица около Голеневского ручья	2023-12-17 16:03:57.509788+00	2023-12-17 16:03:57.509792+00
0437a8eb-231e-4b90-baf4-ebe23817f427	Перевозчик в Зеленограде	bc358f0e-d2f3-4b29-97ee-ce63320323ec	585476c6-49aa-4c41-8559-d5df25bf1a3f	d5e4a493-422c-4d30-b1c6-af4db2637e54	Female	Перевозчик рядом с малым Городским прудом	2023-12-17 16:04:49.453473+00	2023-12-17 16:04:49.453476+00
cca5942c-fc25-4612-a43a-f9f94b64266a	Ястреб в Зеленограде	be1abef1-b605-40ce-b93a-c10b2aa3c022	4c0c1ffa-6ac5-4cb5-91bd-ca58c9b3457b	d5e4a493-422c-4d30-b1c6-af4db2637e54	Male	Ястреб-тервятник пролетал над Школьным озером	2023-12-17 16:05:51.989805+00	2023-12-17 16:05:51.989809+00
\.


--
-- Data for Name: bird_statuses; Type: TABLE DATA; Schema: content; Owner: postgres
--

COPY content.bird_statuses (id, status_name, created_at, updated_at) FROM stdin;
74320ec5-4e18-4fee-94e0-555446f5e3fa	Вызывает наименьшие опасения	2023-12-17 15:13:38.227365+00	2023-12-17 15:13:38.227372+00
52b7c002-0e19-4dc2-82ae-1c57cf0ae6b7	Близки к уязвимому пположению	2023-12-17 15:45:08.97978+00	2023-12-17 15:45:08.979783+00
83d7ea76-1a79-48dc-bae3-936f1c0bf0c5	В уязвимом положении	2023-12-17 15:45:21.248725+00	2023-12-17 15:45:21.248728+00
3c3b49e5-ef6d-43d2-9b7c-52ebfeeafeb9	В опасности	2023-12-17 15:45:35.155513+00	2023-12-17 15:45:35.155517+00
8bdf522d-22ed-45b8-aca4-07ef19fe0561	В критической опасности	2023-12-17 15:45:44.099906+00	2023-12-17 15:45:44.099908+00
678d1903-71a4-4f3c-91e0-5aed1be497a5	Исчезнувшие	2023-12-17 15:45:55.302344+00	2023-12-17 15:45:55.30235+00
de67056f-6c70-4aed-bd22-ad7676c441a6	Нет оценки	2023-12-17 15:46:14.220877+00	2023-12-17 15:46:14.220881+00
e239b966-7ecb-4950-8dd1-5b7bcea1f133	Данных недостаточно	2023-12-17 15:46:21.092789+00	2023-12-17 15:46:21.092791+00
\.


--
-- Data for Name: birds; Type: TABLE DATA; Schema: content; Owner: postgres
--

COPY content.birds (id, bird_name, scientific_name, description, status_id, family_id, created_at, updated_at) FROM stdin;
982a56df-d7e2-49b2-b020-b3d8afbbc5df	Воробьиный сыч	Anas crecca	Воробьиный сыч	74320ec5-4e18-4fee-94e0-555446f5e3fa	706efeb3-234f-49c8-b02f-3edebaa169f2	2023-12-17 15:14:13.130502+00	2023-12-17 15:14:13.130505+00
e0536863-b2db-4cec-ae8b-3612af105bee	Серая цапля	Ardea cinerea	Серая цапля – довольно крупная птица, ее вес составляет в среднем 1,5 кг (может быть до 2 кг), длина тела около 1 м или чуть больше, размах крыльев варьирует от 1,5 до 1,75 м. Клюв очень острый и довольно длинный – 10-13 см, желтовато-бурый. Ноги оливково-бурые, длинные. Радужина глаз желтая, с чуть зеленоватым оттенком. Неоперенные кольца вокруг глаз зеленоватые.	74320ec5-4e18-4fee-94e0-555446f5e3fa	6de52f2e-7928-4fa5-abfc-23674c9c854e	2023-12-17 15:47:37.006848+00	2023-12-17 15:47:37.006851+00
09cae6a0-17e3-472c-af33-1aa35a715e28	Серые неясыти	Falco columbarius	 Серые неясыти – маленькие птицы, их длина составляет около 30 см, вес – около 200 грамм. Оперение серое на спине и боках, белое на груди и животе. Клюв короткий и крючковатый, черный. Ноги короткие, желтые. У самца есть черный усик.	74320ec5-4e18-4fee-94e0-555446f5e3fa	58b5a410-854a-4b65-85df-ae46b9484e74	2023-12-17 15:48:17.567947+00	2023-12-17 15:48:17.56795+00
109731b6-4a08-4e17-9b81-aeae20556085	Черныш	Turdus merula	Черныш – среднего размера птица, ее длина составляет около 25 см, вес – около 100 грамм. Оперение черное на спине и боках, желтое на краях крыльев и хвоста. Клюв длинный и прямой, желтый с черным кончиком. Ноги короткие, серые.	74320ec5-4e18-4fee-94e0-555446f5e3fa	32cdb50a-1dbc-41f9-a135-a7cd6e460ab6	2023-12-17 15:48:53.563638+00	2023-12-17 15:48:53.563642+00
32246ce4-0020-445a-a906-3c62ee01ac23	Зелёный дятел	Picus viridis	Зеленый дятел – среднего размера птица, ее длина составляет около 30 см, вес – около 150 грамм. Оперение зеленовато-желтое на спине, желтое на груди и животе. На голове красная крона и черный усик. Клюв длинный и прямой, черный. Ноги короткие, серые.	74320ec5-4e18-4fee-94e0-555446f5e3fa	48fd4615-a872-4495-93ce-b1a212bb3adb	2023-12-17 15:49:07.708212+00	2023-12-17 15:49:07.70822+00
4c0c1ffa-6ac5-4cb5-91bd-ca58c9b3457b	Ястреб-тетеревятник	Accipiter gentilis	Ястреб-тетеревятник – среднего размера птица, ее длина составляет около 60 см, вес – около 1 кг. Оперение серое на спине и боках, белое на груди и животе. Клюв короткий и крючковатый, желтый. Ноги короткие, желтые.	74320ec5-4e18-4fee-94e0-555446f5e3fa	2128ee9f-d9e7-4cab-a7ea-96889aa0740e	2023-12-17 15:50:25.034636+00	2023-12-17 15:50:25.034641+00
585476c6-49aa-4c41-8559-d5df25bf1a3f	Перевозчик	Pica pica	Перевозчик – среднего размера птица, ее длина составляет около 50 см, вес – около 500 грамм. Оперение черное на спине и боках, белое на груди и животе. На голове есть хохолок из черного пера. Клюв длинный и прямой, черный. Ноги короткие, серые.	74320ec5-4e18-4fee-94e0-555446f5e3fa	4595ba9f-a00d-446a-99b6-23a78bc1ddaf	2023-12-17 15:48:34.598272+00	2023-12-17 15:48:34.598275+00
a7edc2ba-bbef-40a7-8fdc-dc9787d0fc55	Красная утка	Aythya nyroca	"Красная утка – среднего размера птица, ее вес составляет в среднем 800 грамм, длина тела около 45 см. Клюв короткий и широкий, черный. Ноги короткие, серые. Оперение у самца и самки отличается: у самца голова и шея темно-коричневые, грудь и бока красновато-коричневые, спина черная, хвост серый; у самки оперение коричневое с белым пятном на груди.\r\n"	74320ec5-4e18-4fee-94e0-555446f5e3fa	d1b7adfd-7283-4a4f-9930-02efc91cc376	2023-12-17 15:49:49.872673+00	2023-12-17 15:49:49.872675+00
af29b63b-844a-4868-9e84-4a78232309f3	Чирок-свистунок	Regulus regulus	Чирок-свистунок – маленькая птица, ее длина составляет около 10 см, вес – около 5 грамм. Оперение зеленовато-серое на спине, белое на груди и животе. На голове есть яркая оранжевая полоса и черный усик. Клюв короткий и тонкий, черный. Ноги короткие, серые.\r\n	74320ec5-4e18-4fee-94e0-555446f5e3fa	d4a26f6c-482a-4ccd-9a94-77c39c7e5860	2023-12-17 15:50:07.561655+00	2023-12-17 15:50:07.561659+00
e6710c9d-6879-47ee-9811-852e27c47004	Хохлатая синица	Lophophanes cristatus	Хохлатая синица – маленькая птица, ее длина составляет около 11 см, вес – около 10 грамм. Оперение серое на спине и боках, белое на груди и животе. На голове хохолок из черного пера, который может быть поднят или опущен. Клюв короткий и тонкий, черный. Ноги короткие, серые.	74320ec5-4e18-4fee-94e0-555446f5e3fa	73450ecc-ee9d-4140-b30f-0f5cb69e1e9f	2023-12-17 15:49:32.798471+00	2023-12-17 15:49:32.798474+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: content; Owner: postgres
--

COPY content.users (id, username, email, password_hash, created_at, updated_at) FROM stdin;
d5e4a493-422c-4d30-b1c6-af4db2637e54	Administrator	dndjfndf	$pbkdf2-sha512$25000$GMMYA6DUurcWwpiTcu49hw$PrZTyMxnOGYTboxnM4vESUXVWHfD.3scX.cnvoqe1kUBdMjJn7qF3d.D.CQAY6Lnse/uPg/s/EyyvH0TEzbzEA	2023-12-17 17:18:53.630194+00	2023-12-17 17:18:53.630195+00
\.


--
-- Name: bird_families bird_families_pkey; Type: CONSTRAINT; Schema: content; Owner: postgres
--

ALTER TABLE ONLY content.bird_families
    ADD CONSTRAINT bird_families_pkey PRIMARY KEY (id);


--
-- Name: bird_images bird_images_pkey; Type: CONSTRAINT; Schema: content; Owner: postgres
--

ALTER TABLE ONLY content.bird_images
    ADD CONSTRAINT bird_images_pkey PRIMARY KEY (id);


--
-- Name: bird_locations bird_locations_pkey; Type: CONSTRAINT; Schema: content; Owner: postgres
--

ALTER TABLE ONLY content.bird_locations
    ADD CONSTRAINT bird_locations_pkey PRIMARY KEY (id);


--
-- Name: bird_observations bird_observations_pkey; Type: CONSTRAINT; Schema: content; Owner: postgres
--

ALTER TABLE ONLY content.bird_observations
    ADD CONSTRAINT bird_observations_pkey PRIMARY KEY (id);


--
-- Name: bird_statuses bird_statuses_pkey; Type: CONSTRAINT; Schema: content; Owner: postgres
--

ALTER TABLE ONLY content.bird_statuses
    ADD CONSTRAINT bird_statuses_pkey PRIMARY KEY (id);


--
-- Name: birds birds_pkey; Type: CONSTRAINT; Schema: content; Owner: postgres
--

ALTER TABLE ONLY content.birds
    ADD CONSTRAINT birds_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: content; Owner: postgres
--

ALTER TABLE ONLY content.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: bird_images bird_images_observation_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: postgres
--

ALTER TABLE ONLY content.bird_images
    ADD CONSTRAINT bird_images_observation_id_fkey FOREIGN KEY (observation_id) REFERENCES content.bird_observations(id) ON DELETE CASCADE;


--
-- Name: bird_observations bird_observations_bird_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: postgres
--

ALTER TABLE ONLY content.bird_observations
    ADD CONSTRAINT bird_observations_bird_id_fkey FOREIGN KEY (bird_id) REFERENCES content.birds(id) ON DELETE CASCADE;


--
-- Name: bird_observations bird_observations_location_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: postgres
--

ALTER TABLE ONLY content.bird_observations
    ADD CONSTRAINT bird_observations_location_id_fkey FOREIGN KEY (location_id) REFERENCES content.bird_locations(id) ON DELETE CASCADE;


--
-- Name: bird_observations bird_observations_user_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: postgres
--

ALTER TABLE ONLY content.bird_observations
    ADD CONSTRAINT bird_observations_user_id_fkey FOREIGN KEY (user_id) REFERENCES content.users(id) ON DELETE CASCADE;


--
-- Name: birds birds_family_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: postgres
--

ALTER TABLE ONLY content.birds
    ADD CONSTRAINT birds_family_id_fkey FOREIGN KEY (family_id) REFERENCES content.bird_families(id) ON DELETE CASCADE;


--
-- Name: birds birds_status_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: postgres
--

ALTER TABLE ONLY content.birds
    ADD CONSTRAINT birds_status_id_fkey FOREIGN KEY (status_id) REFERENCES content.bird_statuses(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

