import uuid 
from django.core.files.storage import default_storage
from firebase_admin import firestore
from .firebase_config import bucket, firestore_client

def UploadImageToFirebase(image_file, description=None):

    filename = f"uploaded_images/{uuid.uuid4()}.jpg"

    blob = bucket.blob(filename)
    blob.upload_from_string(
        image_file.read(),
        content_type=image_file.content_type
    )

    blob.make_public()

    doc_ref = firestore_client.collection('images').document()
    doc_ref.set({
        'filename': filename,
        'public_url': blob.public_url,
        'description': description,
        'image_date': firestore.SERVER_TIMESTAMP
    })

    return{
        'url': blob.public_url,
        'firestore_id': doc_ref.id
    }


