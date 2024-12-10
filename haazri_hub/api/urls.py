from django.urls import path
from .views import ObjectDetectionView

urlpatterns = [
    path('detect-objects/', ObjectDetectionView.as_view(), name='detect-objects'),
]
