from django.urls import path
from .views import ObjectDetectionView, get_attendance_by_date
from django.views.decorators.csrf import csrf_exempt

urlpatterns = [
    path('detect-objects/', csrf_exempt(ObjectDetectionView.as_view()), name='detect-objects'),
    path('get-attendance/', get_attendance_by_date, name='get-attendance'),
]