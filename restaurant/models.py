from django.db import models
from django.utils import timezone

class Restaurant(models.Model):
    name = models.CharField(max_length=50)
    location = models.CharField(max_length=200)
    image = models.CharField(max_length = 200)
    context = models.TextField()
    naver_link = models.URLField(blank=True, null=True, max_length=500)
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return self.name