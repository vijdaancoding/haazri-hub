from django.urls import path
from . import views

urlpatterns = [
    path('attendance/mark/', views.mark_attendance, name='mark_attendance'),  # Endpoint for marking attendance
    path('attendance/list/', views.list_attendance, name='list_attendance'),  # Endpoint to list all attendance records
    path('attendance/<int:id>/', views.get_attendance, name='get_attendance'),  # Get attendance by ID
]
