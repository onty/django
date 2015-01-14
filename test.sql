PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE "auth_permission" (
    "id" integer NOT NULL PRIMARY KEY,
    "name" varchar(50) NOT NULL,
    "content_type_id" integer NOT NULL,
    "codename" varchar(100) NOT NULL,
    UNIQUE ("content_type_id", "codename")
);
INSERT INTO "auth_permission" VALUES(1,'Can add permission',1,'add_permission');
INSERT INTO "auth_permission" VALUES(2,'Can change permission',1,'change_permission');
INSERT INTO "auth_permission" VALUES(3,'Can delete permission',1,'delete_permission');
INSERT INTO "auth_permission" VALUES(4,'Can add group',2,'add_group');
INSERT INTO "auth_permission" VALUES(5,'Can change group',2,'change_group');
INSERT INTO "auth_permission" VALUES(6,'Can delete group',2,'delete_group');
INSERT INTO "auth_permission" VALUES(7,'Can add user',3,'add_user');
INSERT INTO "auth_permission" VALUES(8,'Can change user',3,'change_user');
INSERT INTO "auth_permission" VALUES(9,'Can delete user',3,'delete_user');
INSERT INTO "auth_permission" VALUES(10,'Can add content type',4,'add_contenttype');
INSERT INTO "auth_permission" VALUES(11,'Can change content type',4,'change_contenttype');
INSERT INTO "auth_permission" VALUES(12,'Can delete content type',4,'delete_contenttype');
INSERT INTO "auth_permission" VALUES(13,'Can add session',5,'add_session');
INSERT INTO "auth_permission" VALUES(14,'Can change session',5,'change_session');
INSERT INTO "auth_permission" VALUES(15,'Can delete session',5,'delete_session');
INSERT INTO "auth_permission" VALUES(16,'Can add site',6,'add_site');
INSERT INTO "auth_permission" VALUES(17,'Can change site',6,'change_site');
INSERT INTO "auth_permission" VALUES(18,'Can delete site',6,'delete_site');
INSERT INTO "auth_permission" VALUES(19,'Can add category',7,'add_category');
INSERT INTO "auth_permission" VALUES(20,'Can change category',7,'change_category');
INSERT INTO "auth_permission" VALUES(21,'Can delete category',7,'delete_category');
INSERT INTO "auth_permission" VALUES(22,'Can add page',8,'add_page');
INSERT INTO "auth_permission" VALUES(23,'Can change page',8,'change_page');
INSERT INTO "auth_permission" VALUES(24,'Can delete page',8,'delete_page');
INSERT INTO "auth_permission" VALUES(25,'Can add user profile',9,'add_userprofile');
INSERT INTO "auth_permission" VALUES(26,'Can change user profile',9,'change_userprofile');
INSERT INTO "auth_permission" VALUES(27,'Can delete user profile',9,'delete_userprofile');
INSERT INTO "auth_permission" VALUES(28,'Can add log entry',10,'add_logentry');
INSERT INTO "auth_permission" VALUES(29,'Can change log entry',10,'change_logentry');
INSERT INTO "auth_permission" VALUES(30,'Can delete log entry',10,'delete_logentry');
CREATE TABLE "auth_group_permissions" (
    "id" integer NOT NULL PRIMARY KEY,
    "group_id" integer NOT NULL,
    "permission_id" integer NOT NULL REFERENCES "auth_permission" ("id"),
    UNIQUE ("group_id", "permission_id")
);
CREATE TABLE "auth_group" (
    "id" integer NOT NULL PRIMARY KEY,
    "name" varchar(80) NOT NULL UNIQUE
);
CREATE TABLE "auth_user_groups" (
    "id" integer NOT NULL PRIMARY KEY,
    "user_id" integer NOT NULL,
    "group_id" integer NOT NULL REFERENCES "auth_group" ("id"),
    UNIQUE ("user_id", "group_id")
);
CREATE TABLE "auth_user_user_permissions" (
    "id" integer NOT NULL PRIMARY KEY,
    "user_id" integer NOT NULL,
    "permission_id" integer NOT NULL REFERENCES "auth_permission" ("id"),
    UNIQUE ("user_id", "permission_id")
);
CREATE TABLE "auth_user" (
    "id" integer NOT NULL PRIMARY KEY,
    "password" varchar(128) NOT NULL,
    "last_login" timestamp with time zone NOT NULL,
    "is_superuser" boolean NOT NULL,
    "username" varchar(30) NOT NULL UNIQUE,
    "first_name" varchar(30) NOT NULL,
    "last_name" varchar(30) NOT NULL,
    "email" varchar(75) NOT NULL,
    "is_staff" boolean NOT NULL,
    "is_active" boolean NOT NULL,
    "date_joined" timestamp with time zone NOT NULL
);
INSERT INTO "auth_user" VALUES(1,'pbkdf2_sha256$10000$nOFJMlQiPzA0$uiXT2Sx+RxhC9D2xOee/M0ZbWeaRpX1isFeGJQ5vJEw=','2014-12-30 08:11:20.346307',TRUE,'lintang','','','lintang.prasojo@gmail.com',TRUE,TRUE,'2014-12-22 14:01:15.034642');
INSERT INTO "auth_user" VALUES(4,'pbkdf2_sha256$10000$XxkTO6daYPud$JQlYVfC1IAVIsN73ad90fvpGHpUCW+a3Fj+UhMlPrKQ=','2014-12-30 11:50:40.592889',TRUE,'test','','','test@gmail.com',FALSE,TRUE,'2014-12-29 22:06:22.473583');
CREATE TABLE "django_content_type" (
    "id" integer NOT NULL PRIMARY KEY,
    "name" varchar(100) NOT NULL,
    "app_label" varchar(100) NOT NULL,
    "model" varchar(100) NOT NULL,
    UNIQUE ("app_label", "model")
);
INSERT INTO "django_content_type" VALUES(1,'permission','auth','permission');
INSERT INTO "django_content_type" VALUES(2,'group','auth','group');
INSERT INTO "django_content_type" VALUES(3,'user','auth','user');
INSERT INTO "django_content_type" VALUES(4,'content type','contenttypes','contenttype');
INSERT INTO "django_content_type" VALUES(5,'session','sessions','session');
INSERT INTO "django_content_type" VALUES(6,'site','sites','site');
INSERT INTO "django_content_type" VALUES(7,'category','rango','category');
INSERT INTO "django_content_type" VALUES(8,'page','rango','page');
INSERT INTO "django_content_type" VALUES(9,'user profile','rango','userprofile');
INSERT INTO "django_content_type" VALUES(10,'log entry','admin','logentry');
CREATE TABLE "django_session" (
    "session_key" varchar(40) NOT NULL PRIMARY KEY,
    "session_data" text NOT NULL,
    "expire_date" timestamp with time zone NOT NULL
);
INSERT INTO "django_session" VALUES('jlm69egd3s2gzsr6uzr3f0o857casplc','ZTY3OTg1MTZmZTA0ZWQyZjM2ZjNkNDRhMGY2MWE5YjEwMWFkOGI1ZDp7fQ==','2015-01-05 14:49:51.906838');
INSERT INTO "django_session" VALUES('iw4svzx9c0l7ak0drlq7nlhkoalgsmyc','ZTY3OTg1MTZmZTA0ZWQyZjM2ZjNkNDRhMGY2MWE5YjEwMWFkOGI1ZDp7fQ==','2015-01-05 15:35:53.536721');
INSERT INTO "django_session" VALUES('j14x8q9z7t54q3cgocalt6k3gx7dxla7','MjkzMDZiMWE4NmRkYTdlOGJjNzBkYjMyZGZmMjNlMjQzYjM5NzNjYzp7InZpc2l0cyI6MiwibGFzdF92aXNpdCI6IjIwMTQtMTItMjkgMDU6MzQ6MjkuMjg2NDY5IiwiX2F1dGhfdXNlcl9pZCI6MSwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQifQ==','2015-01-12 11:34:29.289149');
INSERT INTO "django_session" VALUES('5g6rh92vmhf7knzk129qon1921yrgo9r','MDZmYzJjNWU2ODFlOWY3NjU0NTNlMjRkMDRjZmZjOWVmNDdmMjY5MTp7InZpc2l0cyI6MSwibGFzdF92aXNpdCI6IjIwMTQtMTItMjkgMTY6NDM6MTAuNjI3MjM1IiwiX2F1dGhfdXNlcl9pZCI6MSwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQifQ==','2015-01-12 22:43:10.631420');
INSERT INTO "django_session" VALUES('n86dcyzgv72saxqo0ntryfm3hiuz38le','MWFlMjkzODhhMmJjN2NlNWFjNTkzMTEwN2EwYTFhNjY2ODc1YWY0Mjp7InZpc2l0cyI6MSwibGFzdF92aXNpdCI6IjIwMTQtMTItMzAgMDU6NTA6NTAuNzU0MTUxIn0=','2015-01-13 11:50:50.758087');
CREATE TABLE "django_site" (
    "id" integer NOT NULL PRIMARY KEY,
    "domain" varchar(100) NOT NULL,
    "name" varchar(50) NOT NULL
);
INSERT INTO "django_site" VALUES(1,'example.com','example.com');
CREATE TABLE "rango_category" (
    "id" integer NOT NULL PRIMARY KEY,
    "name" varchar(128) NOT NULL UNIQUE,
    "views" integer NOT NULL,
    "likes" integer NOT NULL
);
INSERT INTO "rango_category" VALUES(1,'HAHAHA',25,8);
INSERT INTO "rango_category" VALUES(2,'Django',0,4);
INSERT INTO "rango_category" VALUES(3,'Other Frameworks',58,4);
INSERT INTO "rango_category" VALUES(4,'PHP',0,7);
INSERT INTO "rango_category" VALUES(5,'Rails',0,0);
CREATE TABLE "rango_page" (
    "id" integer NOT NULL PRIMARY KEY,
    "category_id" integer NOT NULL REFERENCES "rango_category" ("id"),
    "title" varchar(128) NOT NULL,
    "url" varchar(200) NOT NULL,
    "views" integer NOT NULL
);
INSERT INTO "rango_page" VALUES(1,1,'Official Python Tutorial','http://docs.python.org/2/tutorial/',7);
INSERT INTO "rango_page" VALUES(2,1,'How to think like Computer Scientist','http://greenteapress.com/thinkpython/',7);
INSERT INTO "rango_page" VALUES(3,2,'Official Django Tutorial','https://docs.djangoproject.com/en/1.5/intro/tutorial01/',1);
INSERT INTO "rango_page" VALUES(4,2,'Django Rocks','http://www.djangorocks.com/',1);
INSERT INTO "rango_page" VALUES(5,2,'How to Tango with Django','http://www.tangowithdjango.com/',0);
INSERT INTO "rango_page" VALUES(6,3,'Bottle','http://bottlepy.org/docs/dev/',0);
INSERT INTO "rango_page" VALUES(7,3,'Flask','http://flask.pocoo.org',0);
INSERT INTO "rango_page" VALUES(8,1,'testing doang','http://testing.com/',1);
INSERT INTO "rango_page" VALUES(9,4,'PHP: Hypertext Preprocessor','http://php.net/',1);
INSERT INTO "rango_page" VALUES(10,1,'Pythagorean theorem - Wikipedia, the free encyclopedia','http://en.wikipedia.org/wiki/Pyth._theorem',0);
INSERT INTO "rango_page" VALUES(11,1,'Welcome to Python.org','https://www.python.org/',0);
INSERT INTO "rango_page" VALUES(12,2,'Django Unchained (2012) - IMDb','http://www.imdb.com/title/tt1853728/',0);
INSERT INTO "rango_page" VALUES(13,2,'Bug #1437: DJango crash after reboot - FreeNAS - Bug ...','https://bugs.freenas.org/issues/1437',0);
INSERT INTO "rango_page" VALUES(14,4,'Leading PHP applications & PHP development tools from Zend ...','http://www.zend.com/',0);
INSERT INTO "rango_page" VALUES(15,4,'lintang-jati.blogspot.com','http://lintang-jati.blogspot.com/',1);
INSERT INTO "rango_page" VALUES(16,4,'Java Struts from a PHP Perspective [Web Application ...','http://www.phpwact.org/java/struts',0);
INSERT INTO "rango_page" VALUES(17,4,'Struts 2 and PHP Integeration (Struts forum at JavaRanch)','http://www.coderanch.com/t/492995/Struts/Struts-PHP-Integeration',0);
INSERT INTO "rango_page" VALUES(18,4,'Car Bonnet, Boot and Tailgate Gas Struts, Car Gas Struts','http://www.strutsdirect.co.uk/car-gas-struts.php',0);
INSERT INTO "rango_page" VALUES(19,4,'PHPDeveloper.org: Web Builder Zone: Struts vs. Zend Framework','http://www.phpdeveloper.org/news/16121',0);
INSERT INTO "rango_page" VALUES(20,3,'Kivy: Cross-platform Python Framework for NUI Development','http://kivy.org/',1);
INSERT INTO "rango_page" VALUES(21,3,'Simple python mvc framework - Stack Overflow','http://stackoverflow.com/questions/2852056/simple-python-mvc-framework',0);
INSERT INTO "rango_page" VALUES(22,3,'Pylons Project : Home','http://www.pylonsproject.org/',2);
INSERT INTO "rango_page" VALUES(23,5,'Ruby on Rails is a Web framework','http://www.comentum.com/ruby-on-rails-vs-php-comparison.html',0);
INSERT INTO "rango_page" VALUES(24,5,'rails/rails · GitHub - GitHub · Build software better ...','https://github.com/rails/rails',0);
CREATE TABLE "rango_userprofile" (
    "id" integer NOT NULL PRIMARY KEY,
    "user_id" integer NOT NULL UNIQUE REFERENCES "auth_user" ("id"),
    "website" varchar(200) NOT NULL,
    "picture" varchar(100) NOT NULL
);
INSERT INTO "rango_userprofile" VALUES(3,4,'http://test.com/','profile_images/ayah-leap.jpg');
CREATE TABLE "django_admin_log" (
    "id" integer NOT NULL PRIMARY KEY,
    "action_time" timestamp with time zone NOT NULL,
    "user_id" integer NOT NULL REFERENCES "auth_user" ("id"),
    "content_type_id" integer REFERENCES "django_content_type" ("id"),
    "object_id" text,
    "object_repr" varchar(200) NOT NULL,
    "action_flag" smallint NOT NULL,
    "change_message" text NOT NULL
);
INSERT INTO "django_admin_log" VALUES(1,'2014-12-25 15:57:48.605942',1,5,'rybc9fj83wfkzslp7fx36t455b0z2w5q','Session object',3,'');
INSERT INTO "django_admin_log" VALUES(2,'2014-12-29 21:52:46.324616',1,9,'3','test',2,'Changed picture.');
INSERT INTO "django_admin_log" VALUES(3,'2014-12-29 21:53:09.233935',1,9,'3','test',2,'Changed picture.');
INSERT INTO "django_admin_log" VALUES(4,'2014-12-29 21:54:57.326881',1,9,'3','test',3,'');
INSERT INTO "django_admin_log" VALUES(5,'2014-12-29 21:59:18.359854',1,3,'4','test',3,'');
INSERT INTO "django_admin_log" VALUES(6,'2014-12-29 21:59:18.368853',1,3,'5','test1',3,'');
INSERT INTO "django_admin_log" VALUES(7,'2014-12-29 22:05:35.586001',1,3,'4','test',3,'');
INSERT INTO "django_admin_log" VALUES(8,'2014-12-29 22:14:37.737099',1,3,'2','onty',3,'');
INSERT INTO "django_admin_log" VALUES(9,'2014-12-29 22:14:37.747519',1,3,'3','onty123',3,'');
CREATE INDEX "auth_permission_37ef4eb4" ON "auth_permission" ("content_type_id");
CREATE INDEX "auth_group_permissions_5f412f9a" ON "auth_group_permissions" ("group_id");
CREATE INDEX "auth_group_permissions_83d7f98b" ON "auth_group_permissions" ("permission_id");
CREATE INDEX "auth_user_groups_6340c63c" ON "auth_user_groups" ("user_id");
CREATE INDEX "auth_user_groups_5f412f9a" ON "auth_user_groups" ("group_id");
CREATE INDEX "auth_user_user_permissions_6340c63c" ON "auth_user_user_permissions" ("user_id");
CREATE INDEX "auth_user_user_permissions_83d7f98b" ON "auth_user_user_permissions" ("permission_id");
CREATE INDEX "django_session_b7b81f0c" ON "django_session" ("expire_date");
CREATE INDEX "rango_page_6f33f001" ON "rango_page" ("category_id");
CREATE INDEX "django_admin_log_6340c63c" ON "django_admin_log" ("user_id");
CREATE INDEX "django_admin_log_37ef4eb4" ON "django_admin_log" ("content_type_id");
COMMIT;
