import os
import csv

PROJECT_NAME="tango_with_django_project"
APP_NAME="rango"

os.environ.setdefault("DJANGO_SETTINGS_MODULE",PROJECT_NAME+".settings")
from django.db.models.loading import get_model

def db_access(f):
		for row in f:
			o = get_model(app_label=APP_NAME, model_name=row[1]).objects.get(id=row[0])
			print o.views , o.name
			setattr(o,row[2],row[3])
			o.save()
			print o.views, o.name

if __name__ == "__main__":	
	with open("test.csv","rb") as csvfile:
		baca = csv.reader(csvfile, delimiter=',',quotechar='"')
		db_access(baca)
