# craftops

Run this to create session table in admin schema of DB:

-- Table: admin.session

-- DROP TABLE admin.session;

CREATE TABLE admin.session
(
  sid character varying NOT NULL,
  sess json NOT NULL,
  expire timestamp(6) without time zone NOT NULL,
  CONSTRAINT session_pkey PRIMARY KEY (sid)
)
WITH (
  OIDS=FALSE
);

-- Table: admin.users

-- DROP TABLE admin.users;

CREATE TABLE admin.users
(
  id serial NOT NULL,
  email character varying(256),
  password character varying(64),
  salt character varying(64),
  "createdAt" date,
  "updatedAt" date,
  CONSTRAINT "PKey" PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
