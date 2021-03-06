ALTER TABLE IDN_SAML2_ASSERTION_STORE ADD COLUMN ASSERTION BYTEA;

CREATE TABLE IF NOT EXISTS IDN_AUTH_USER (
	USER_ID VARCHAR(255) NOT NULL,
	USER_NAME VARCHAR(255) NOT NULL,
	TENANT_ID INTEGER NOT NULL,
	DOMAIN_NAME VARCHAR(255) NOT NULL,
	IDP_ID INTEGER NOT NULL,
	PRIMARY KEY (USER_ID),
	CONSTRAINT USER_STORE_CONSTRAINT UNIQUE (USER_NAME, TENANT_ID, DOMAIN_NAME, IDP_ID));

CREATE OR REPLACE FUNCTION skip_index_if_exists(indexName varchar(64),tableName varchar(64), tableColumns varchar(64))
  RETURNS void AS $$
  declare s varchar(1000);
  begin
	  if to_regclass(indexName) IS NULL  then
	    s :=  CONCAT('CREATE INDEX ' , indexName , ' ON ' , tableName, tableColumns);
	    execute s;
	  end if;
  END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS IDN_AUTH_USER_SESSION_MAPPING (
	USER_ID VARCHAR(255) NOT NULL,
	SESSION_ID VARCHAR(255) NOT NULL,
	CONSTRAINT USER_SESSION_STORE_CONSTRAINT UNIQUE (USER_ID, SESSION_ID));

CREATE INDEX IF NOT EXISTS IDX_USER_ID ON IDN_AUTH_USER_SESSION_MAPPING (USER_ID);

CREATE INDEX IF NOT EXISTS IDX_SESSION_ID ON IDN_AUTH_USER_SESSION_MAPPING (SESSION_ID);

SELECT skip_index_if_exists('IDX_OCA_UM_TID_UD_APN','IDN_OAUTH_CONSUMER_APPS','(USERNAME,TENANT_ID,USER_DOMAIN, APP_NAME)');

SELECT skip_index_if_exists('IDX_SPI_APP','SP_INBOUND_AUTH','(APP_ID)');

SELECT skip_index_if_exists('IDX_IOP_TID_CK','IDN_OIDC_PROPERTY','(TENANT_ID,CONSUMER_KEY)');


