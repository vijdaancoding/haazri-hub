import firebase_admin
from firebase_admin import credentials, firestore, storage
import os 

FIREBASE_CREDENTIAL_PATH = 'api/serviceAccountKey.json'

cred = credentials.Certificate(FIREBASE_CREDENTIAL_PATH)
firebase_admin.initialize_app(cred, {
    'storageBucket' : 'sehat_gang_bucket'
})

firestore_client = firestore.client()

bucket = storage.bucket()