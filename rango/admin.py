from django.contrib import admin
from rango.models import UserProfile, Category, Page
from django.contrib.sessions.models import Session 

class PageAdmin(admin.ModelAdmin):
    list_display = ('title','category','url', 'views')
    fields = ['title','category','url']

class SessionAdmin(admin.ModelAdmin):
	list_display = ('session_key', 'expire_date')
	fields = ('session_key', 'expire_date')

admin.site.register(UserProfile)
admin.site.register(Category)
admin.site.register(Page,PageAdmin)
admin.site.register(Session, SessionAdmin)
