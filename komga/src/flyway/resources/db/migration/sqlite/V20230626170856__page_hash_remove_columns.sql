ALTER TABLE PAGE_HASH
    RENAME TO _PAGE_HASH_OLD;

CREATE TABLE PAGE_HASH
(
    HASH               varchar  NOT NULL PRIMARY KEY,
    SIZE               int8     NULL,
    ACTION             varchar  NOT NULL,
    DELETE_COUNT       int      NOT NULL default 0,
    CREATED_DATE       datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    LAST_MODIFIED_DATE datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO PAGE_HASH(HASH, ACTION, SIZE, DELETE_COUNT, CREATED_DATE, LAST_MODIFIED_DATE)
SELECT HASH, ACTION, SIZE, DELETE_COUNT, CREATED_DATE, LAST_MODIFIED_DATE
FROM _PAGE_HASH_OLD;

DROP TABLE _PAGE_HASH_OLD;

ALTER TABLE PAGE_HASH_THUMBNAIL
    RENAME TO _PAGE_HASH_THUMBNAIL_OLD;

CREATE TABLE PAGE_HASH_THUMBNAIL
(
    HASH      varchar NOT NULL PRIMARY KEY,
    THUMBNAIL blob    NOT NULL
);

INSERT INTO PAGE_HASH_THUMBNAIL(HASH, THUMBNAIL)
SELECT HASH, THUMBNAIL
FROM _PAGE_HASH_THUMBNAIL_OLD;

DROP TABLE _PAGE_HASH_THUMBNAIL_OLD;
