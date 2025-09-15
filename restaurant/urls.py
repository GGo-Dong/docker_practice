from django.contrib import admin
from django.urls import path
from .views import *

app_name = 'restaurant'

urlpatterns = [
    path('', main_page, name='main'),
]