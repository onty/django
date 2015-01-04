import os
import csv
#import django -- if django 1.7


APP_NAME="bulk"
CSV_NAME="1.csv"
TARGET_MODEL="StorageModel"
TARGET_OBJ_ID=2
TARGET_FIELD_NAME="dump_field"

os.environ.setdefault("DJANGO_SETTINGS_MODULE","settings")
from django.db.models.loading import get_model

def load_to_mem(f):
    insert_list = []

    reader = csv.DictReader(open(f))
    for row in reader:
        title = row['title']
        desc = row['description']
        insert_list.append(''.join([title,desc]))

    o = get_model(app_label=APP_NAME, model_name=TARGET_MODEL).objects.get(id=int(TARGET_OBJ_ID))
    setattr(o,TARGET_FIELD_NAME,' '.join(insert_list))
    o.save()
    print '%d data loaded' % len(insert_list)

if __name__ == "__main__":	
#    django.setup() -- if django 1.7
    load_to_mem(CSV_NAME)
