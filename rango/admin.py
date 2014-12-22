from django.contrib import admin
from rango.models import UserProfile, Category, Page

class PageAdmin(admin.ModelAdmin):
    list_display = ('title','category','url', 'views')
    fields = ['title','category','url']

admin.site.register(UserProfile)
admin.site.register(Category)
admin.site.register(Page,PageAdmin)
