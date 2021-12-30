const userMigration = {
  "className": "user",
  "id": {
    "type": "String",
    "required": false,
    "primaryKey": true,
    "nullable": true,
    "protocol": "uuid-v4",
  },
  "name": {
    "type": "String",
    "required": true,
    "nullable": false,
    "maxLength": 200
  },
  "age": {
    "type": "int",
    "required": true,
    "nullable": false,
    "isNegative": false,
  },
  "company": {
    "type": "list",
    "class": "company",
    "required": true,
    "nullable": false
  },
};
