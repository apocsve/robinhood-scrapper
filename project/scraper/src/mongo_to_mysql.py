import pymysql
from os import environ, path, makedirs
from db import get_db
from sql import create_database_sql, create_table_sql, insert_one_sql, use_database, select_one_sql, show_databases, show_tables


class Export:
    mongo_collection: object
    collection_name: str
    create_table_sql: object
    mysql_database: str
    database_created: bool
    table_created: bool

    def __init__(self):

        ssl_info = {
            'ca': environ.get("MYSQL_SSL_CA"),
            'key': environ.get("MYSQL_SSL_KEY"),
            'cert': environ.get("MYSQL_SSL_CERT")
        }

        self.mysql_client = pymysql.connect(
            host=environ.get("MYSQL_HOST"),
            user=environ.get("MYSQL_USER"),
            password=environ.get("MYSQL_PASSWORD"), 
            charset='utf8',
            ssl=ssl_info

        )
        self.mysql_database = environ.get("MYSQL_NAME")
        self.mysql_cursor = self.mysql_client.cursor()
        self.db = get_db()
        self.collist = self.db.list_collection_names()
        self.database_created = False

    def check_database_created(self):
        try:
            self.mysql_cursor.execute(show_databases)
            databases = self.mysql_cursor.fetchall()
            for database in databases:
                current_database = database[0]
                if self.mysql_database == current_database:
                    self.database_created = True
                    print('--------------------------------------------------------')
                    print('database exists: ' + self.mysql_database)
                    print('--------------------------------------------------------')
                else:
                    continue

        except Exception as ex:
            print("error at check_database_created")
            print(str(ex))

    def check_table_exists(self):
        try:
            self.mysql_cursor.execute(use_database % self.mysql_database)
            self.mysql_cursor.execute(show_tables)
            tables = self.mysql_cursor.fetchall()
            for table in tables:
                current_table = table[0]
                if self.collection_name == current_table:
                    self.table_created = True
                    print('--------------------------------------------------------')
                    print('table exists: ' + self.collection_name)
                    print('--------------------------------------------------------')
                else:
                    continue

        except Exception as ex:
            print("error at check_table_exists")
            print(str(ex))

    def create_database(self):
        try:
            if self.database_created is False:
                self.mysql_cursor.execute(create_database_sql % self.mysql_database)
                self.mysql_cursor.execute(show_databases)
                databases = self.mysql_cursor.fetchall()

                for database in databases:
                    if database == self.mysql_database:
                        self.database_created = True
                        print('--------------------------------------------------------')
                        print('database created: ' + self.mysql_database)
                        print('--------------------------------------------------------')
                    else:
                        continue

        except Exception as ex:
            print("error at create_database")
            print(str(ex))

    def get_table_structure(self):

        collections = self.mongo_collection.find_one()
        if collections:
            field_list = list(self.mongo_collection.find_one().keys())
            field_list.remove('_id')
            field_sql = ''
            for i in field_list:
                if i == 'float':
                    i = 'float_value'

                if i == 'description':
                    field_sql = field_sql + "%s LONGTEXT," % i
                else:
                    field_sql = field_sql + "%s VARCHAR(255)," % i
            field_sql = field_sql.strip(',')
            self.create_table_sql = create_table_sql % (self.collection_name,
                                                        "external_id VARCHAR(255)," + field_sql)

    def create_table(self):
        try:
            if self.table_created is False:
                self.mysql_cursor.execute(use_database % self.mysql_database)
                self.mysql_cursor.execute(self.create_table_sql)
                self.table_created = True
                print('--------------------------------------------------------')
                print('table created: ' + self.collection_name)
                print('--------------------------------------------------------')

        except Exception as ex:
            print("error at create_table:" + self.collection_name)
            print(str(ex))

    def export_data(self):

        data = self.mongo_collection.find()

        success_count = 0

        errors_count = 0
        for item in data:
            field = ''
            value = ''
            object_id = ''
            for k, v in item.items():
                if k == '_id':
                    field = field + 'external_id' + ','
                    object_id = str(v)
                else:
                    if k == 'float':
                        k = 'float_value'

                    field = field + str(k) + ','
                if type(v) == list:

                    if v:
                        if isinstance(v, list):
                            value = value + '"' + ','.join('0') + '"' + ','
                        else:
                            value = value + '"' + ','.join(v) + '"' + ','
                    else:
                        value = value + '"' + ' ' + '"' + ','
                else:
                    value = value + '"' + (str(v).replace('"', '')) + '"' + ','
            field = field.rstrip(',')
            value = value.rstrip(',')
            try:
                query_sql = 'select * from ' + self.collection_name + ' where external_id = %s'
                self.mysql_cursor.execute(use_database % self.mysql_database)
                self.mysql_cursor.execute(query_sql, object_id)
                result = self.mysql_cursor.fetchall()
                if not result:
                    self.mysql_cursor.execute(use_database % self.mysql_database)
                    self.mysql_cursor.execute(insert_one_sql % (self.collection_name, field, value))
            except Exception as ex:
                errors_count = errors_count + 1
                print("error at inserting: " + self.collection_name)
                print(str(ex))
            else:
                self.mysql_client.commit()
                success_count = success_count + 1

        print('--------------------------------------------------------')
        print('success_count: ' + str(success_count))
        print('errors_count: ' + str(errors_count))
        print('--------------------------------------------------------')

    def close(self):
        self.mysql_cursor.close()
        self.mysql_client.close()

    def main(self):

        self.check_database_created()

        self.create_database()

        if self.database_created:
            for collection_name in self.collist:

                self.table_created = False

                print('--------------------------------------------------------')
                print('executing collection: ' + collection_name)
                print('--------------------------------------------------------')

                if collection_name == 'system.profile':
                    continue

                self.collection_name = collection_name
                self.mongo_collection = self.db[self.collection_name]

                if collection_name == 'index':
                    self.collection_name = 'companies_index'

                self.get_table_structure()
                self.check_table_exists()
                self.create_table()

                if self.table_created:
                    self.export_data()

        self.close()
        print('--------------------------------------------------------')
        print('import finished!')
        print('--------------------------------------------------------')


if __name__ == "__main__":
    e = Export()
    e.main()
