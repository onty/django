from django.contrib import admin
from rango.models import Category, Page

class PageAdmin(Page):
    list_display = ('title','category','url')
    fields = ['title','category','url']
    readonly_fields = ['title']

admin.site.register(Category)
admin.site.register(Page,PageAdmin)
