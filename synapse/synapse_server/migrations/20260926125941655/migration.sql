BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "orchestration_tasks" (
    "id" bigserial PRIMARY KEY,
    "prompt" text NOT NULL,
    "codeContext" text,
    "geminiResponse" text,
    "status" text NOT NULL,
    "skillName" text,
    "skillInput" text,
    "skillOutput" text,
    "errorMessage" text,
    "createdAt" timestamp without time zone NOT NULL,
    "completedAt" timestamp without time zone
);


--
-- MIGRATION VERSION FOR synapse
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('synapse', '20260926125941655', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260926125941655', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
