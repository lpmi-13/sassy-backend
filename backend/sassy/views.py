from django.contrib.auth.models import User
from backend.sassy.models import SassInfo
from rest_framework import permissions, viewsets
from rest_framework.response import Response

from backend.sassy.serializers import UserSerializer
from backend.sassy.serializers import SaasSerializer


class UserViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows users to be viewed or edited.
    """

    queryset = User.objects.all().order_by("-date_joined")
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAdminUser]


class SaasViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows Saas companies to be returned.
    """

    queryset = SassInfo.objects.all().order_by("id")
    serializer_class = SaasSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]


class SaasIndividualViewSet(viewsets.ModelViewSet):
    """
    API endpoint to get Saas companies by id.
    """

    queryset = SassInfo.objects.all()
    serializer_class = SaasSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

    def retrieve(self, request, pk=None):
        queryset = self.queryset.get(pk=pk)
        serializer = self.serializer_class(queryset)
        return Response(serializer.data)
