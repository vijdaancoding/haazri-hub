from django.urls import path
from .views import ObjectDetectionView, UploadImage

urlpatterns = [
    path('detect-objects/', ObjectDetectionView.as_view(), name='detect-objects'),
    path('upload-image/', UploadImage, name='upload_image'),
]
