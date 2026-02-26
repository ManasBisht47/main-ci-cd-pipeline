

provider "snowflake" {
  account_name=var.sf_account

  organization_name=var.sf_org_name

  user=var.sf_username

  password=var.sf_password
  
  role="ACCOUNTADMIN"   
   preview_features_enabled = [
    "snowflake_table_resource"
  ]
 
  
}



resource "snowflake_warehouse" "wh" {
  name           = "MANAS_${upper(var.environment)}_WH"
  warehouse_size = "XSMALL"
  auto_suspend   = 60
  auto_resume    = true
}

resource "snowflake_database" "db" {
  name = "MANAS_${upper(var.environment)}_DB"
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


resource "snowflake_account_role" "lambda_role" {
  name = "LAMBDA_${upper(var.environment)}_ROLE"
}

resource "snowflake_grant_privileges_to_account_role" "db_usage" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.lambda_role.name

  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.db.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "schema_usage" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.lambda_role.name

  on_schema {
    schema_name = "${snowflake_database.db.name}.${snowflake_schema.schema.name}"
  }
}

resource "snowflake_grant_privileges_to_account_role" "table_insert" {
  privileges        = ["INSERT"]
  account_role_name = snowflake_account_role.lambda_role.name

  on_schema_object {
    object_type = "TABLE"
    object_name = "${snowflake_database.db.name}.${snowflake_schema.schema.name}.${snowflake_table.clean_users.name}"
  }
}

resource "snowflake_grant_privileges_to_account_role" "warehouse_usage" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.lambda_role.name

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.wh.name
  }
}

resource "snowflake_grant_account_role" "grant_role_to_user" {
  role_name = snowflake_account_role.lambda_role.name
  user_name = var.sf_username
}