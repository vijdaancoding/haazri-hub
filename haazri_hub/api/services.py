import uuid 
from firebase_admin import firestore
from .firebase_config import bucket, firestore_client
from django.utils import timezone

def UploadImageToFirebase(image_file, description=None):
    try:
        timestamp = timezone.now().strftime('%Y%m%d_%H%M%S')
        filename = f"attendance_images/{timestamp}_{uuid.uuid4()}.jpg"

        blob = bucket.blob(filename)
        
        # If image_file is a file object (BufferedReader), read its content
        if hasattr(image_file, 'read'):
            file_content = image_file.read()
        else:
            file_content = image_file.file.read()

        blob.upload_from_string(
            file_content,
            content_type='image/jpeg'
        )

        blob.make_public()

        doc_ref = firestore_client.collection('attendance_images').document()
        doc_data = {
            'filename': filename,
            'public_url': blob.public_url,
            'description': description or '',
            'image_date': firestore.SERVER_TIMESTAMP,
            'attendance_type': 'automated_yolo',
            'upload_timestamp': timestamp,
            'status': 'success'
        }
        
        doc_ref.set(doc_data)

        return {
            'url': blob.public_url,
            'firestore_id': doc_ref.id,
            'filename': filename
        }

    except Exception as e:
        try:
            if 'blob' in locals():
                blob.delete()
        except:
            pass
        raise Exception(f"Failed to upload image: {str(e)}")


