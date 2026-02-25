

provider "snowflake" {
  account_name=var.sf_account
  username=var.sf_username
  password=var.sf_password
  role="ACCOUNTADMIN"
}


resource "snowflake_warehouse" "wh" {
  name           = "MANAS_WH"
  warehouse_size = "XSMALL"
  auto_suspend   = 60
  auto_resume    = true
}

resource "snowflake_database" "db" {
  name = "MANAS_DB"
}

resource "snowflake_schema" "schema" {
  database = snowflake_database.db.name
  name     = "RAW"

}
resource "snowflake_table" "clean_users" {
  database = snowflake_database.db.name
  schema   = snowflake_schema.schema.name
  name     = "CLEAN_USERS"

  column {
    name = "ID"
    type = "INTEGER"
  }

  column {
    name = "NAME"
    type = "STRING"
  }

   column {
    name = "COMPANY"
    type = "STRING"
  }

   column {
    name = "USERNAME"
    type = "STRING"
  }

 column {
    name = "EMAIL"
    type = "STRING"
  }
 column {

    name = "ADDRESS"
    type = "STRING"
  }

   column {
    name = "ZIP"
    type = "STRING"
  }

 column {
    name = "STATE"
    type = "STRING"
  }
 column {
    name = "COUNTRY"
    type = "STRING"
  }

   column {
    name = "PHONE"
    type = "STRING"
  }

   column {
    name = "STATE_AND_COUNTRY"
    type = "STRING"
  }




  column {
    name = "PHOTO"
    type = "STRING"
  }

  column {
    name = "FIRST_NAME"
    type = "VARCHAR"
  }

  column {
    name = "LAST_NAME"
    type = "VARCHAR"
  }

  column {
    name = "FULL_ADDRESS"
    type = "STRING"
  }

  column {
    name = "COUNTRY_IS_USA"
    type = "BOOLEAN"
  }
}


resource "snowflake_role" "lambda_role" {
  name = "LAMBDA_ROLE"
}

resource "snowflake_database_grant" "db_usage" {
  database_name = snowflake_database.db.name
  privilege     = "USAGE"
  roles         = [snowflake_role.lambda_role.name]
}
resource "snowflake_schema_grant" "schema_usage" {
  database_name = snowflake_database.db.name
  schema_name   = snowflake_schema.schema.name
  privilege     = "USAGE"
  roles         = [snowflake_role.lambda_role.name]
}
resource "snowflake_table_grant" "table_insert" {
  database_name = snowflake_database.db.name
  schema_name   = snowflake_schema.schema.name
  table_name    = snowflake_table.clean_users.name
  privilege     = "INSERT"
  roles         = [snowflake_role.lambda_role.name]
}
resource "snowflake_warehouse_grant" "warehouse_usage" {
  warehouse_name = snowflake_warehouse.wh.name
  privilege      = "USAGE"
  roles          = [snowflake_role.lambda_role.name]
}