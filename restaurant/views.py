from django.shortcuts import render
from .models import Restaurant

# Create your views here.
def main_page(request):
    restaurants = Restaurant.objects.all()
    context = {
        'restaurants' : restaurants
    }
    return render(request, 'main.html', context=context)