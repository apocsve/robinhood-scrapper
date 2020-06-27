from os import environ, path, makedirs
from db import get_db


class Clear:
    mongo_collection: object
    collection_name: str

    def __init__(self):

        self.db = get_db()
        self.collist = self.db.list_collection_names()

    def main(self):

        for collection_name in self.collist:

            if collection_name == 'system.profile':
                continue

            self.collection_name = collection_name
            self.mongo_collection = self.db[self.collection_name]

            self.mongo_collection.drop()

            print('--------------------------------------------------------')
            print('table: ' + collection_name + ' trucated.')
            print('--------------------------------------------------------')

        print('--------------------------------------------------------')
        print('mongo db cleared!')
        print('--------------------------------------------------------')


if __name__ == "__main__":
    c = Clear()
    c.main()
