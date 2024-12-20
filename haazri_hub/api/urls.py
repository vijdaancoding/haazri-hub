from django.urls import path
from .views import ObjectDetectionView, upload_image

urlpatterns = [
    path('detect-objects/', ObjectDetectionView.as_view(), name='detect-objects'),
    path('upload-image/', upload_image, name='upload_image'),
]
