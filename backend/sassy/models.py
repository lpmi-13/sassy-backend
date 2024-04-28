from django.db import models


class SassInfo(models.Model):
    employee_number = models.IntegerField()
    founder = models.CharField(max_length=50)
    funding = models.IntegerField()
    # monthly active users
    mau = models.IntegerField()
    name = models.CharField(max_length=100)
    type = models.CharField(max_length=50, default="AI")
    revenue = models.FloatField()
