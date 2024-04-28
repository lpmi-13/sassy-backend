from django.contrib.auth.models import User
from backend.sassy.models import SassInfo
from rest_framework import permissions, viewsets

from backend.sassy.serializers import UserSerializer
from backend.sassy.serializers import SaasSerializer


class UserViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows users to be viewed or edited.
    """

    queryset = User.objects.all().order_by("-date_joined")
    serializer_class = UserSerializer
    permission_classes = [permissions.AllowAny]


class SaasViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows groups to be viewed or edited.
    """

    queryset = SassInfo.objects.all().order_by("id")
    serializer_class = SaasSerializer
    permission_classes = [permissions.AllowAny]
