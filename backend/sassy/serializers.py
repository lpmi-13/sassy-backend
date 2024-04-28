from django.contrib.auth.models import User
from rest_framework import serializers

from backend.sassy.models import SassInfo


class UserSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = User
        fields = ["url", "username", "email", "groups"]


class SaasSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = SassInfo
        fields = [
            "id",
            "name",
            "employee_number",
            "founder",
            "funding",
            "mau",
            "type",
            "revenue",
        ]
