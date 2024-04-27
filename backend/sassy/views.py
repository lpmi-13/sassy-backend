from django.contrib.auth.models import Group, User
from backend.sassy.models import SassInfo
from rest_framework import permissions, viewsets

from backend.sassy.serializers import GroupSerializer, UserSerializer
from backend.sassy.serializers import SaasSerializer


class UserViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows users to be viewed or edited.
    """

    queryset = User.objects.all().order_by("-date_joined")
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]


class GroupViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows groups to be viewed or edited.
    """

    queryset = Group.objects.all().order_by("name")
    serializer_class = GroupSerializer
    permission_classes = [permissions.IsAuthenticated]


class SaasViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows groups to be viewed or edited.
    """

    queryset = SassInfo.objects.all().order_by("id")
    serializer_class = SaasSerializer
    permission_classes = [permissions.IsAuthenticated]
