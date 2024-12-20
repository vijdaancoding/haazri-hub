from django import forms

class ImageUploadForm(forms.Form):
    image = forms.ImageField()
    description = forms.CharField(
        required=False, 
        widget=forms.Textarea
    )
    image_date = forms.DateTimeField()
