import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  FirebaseStorage _storage = FirebaseStorage.instance;

  startUpload(image) async {
    String filePath = 'images/${DateTime.now()}.png';

    if (image != null) {
      // Upload to Firebase
      try {
        var snapshot = await _storage.ref(filePath).putFile(image);
        return await snapshot.ref.getDownloadURL();
      } catch (e) {
        print(e);
      }
    }
  }

  //Select Image

}
