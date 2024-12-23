from django.urls import path
from .views import ObjectDetectionView,get_attendance_by_date

urlpatterns = [
    path('detect-objects/', ObjectDetectionView.as_view(), name='detect-objects'),
    path('get-attendance/', get_attendance_by_date, name='get-attendance'),
]
