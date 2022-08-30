import 'dart:io';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:mcfitness/pages/teste/preview_page.dart';

class TesteCamera extends StatefulWidget {
  TesteCamera({Key? key}) : super(key: key);

  @override
  _TesteCameraState createState() => _TesteCameraState();
}

class _TesteCameraState extends State<TesteCamera> {
  File? arquivo;
  final picker = ImagePicker();

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    //XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    return image;
  }

  Future<UploadTask> upload(String path) async {
    File file = File(path);
    try {
      String ref = 'images/img-${DateTime.now().toString()}.jpeg';
      //String ref = 'images/img-${DateTime.now().toString()}.mp4';
      final storageRef = FirebaseStorage.instance.ref();
      return storageRef.child(ref).putFile(
            file,
            SettableMetadata(
              cacheControl: "public, max-age=300",
              contentType: "image/jpeg",
              //contentType: "video/mp4",
              customMetadata: {
                "user": "123",
              },
            ),
          );
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  pickAndUploadImage(String file) async {
    if (file != null) {
      UploadTask task = await upload(file);

      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          setState(() {

          });
        } else if (snapshot.state == TaskState.success) {
          final photoRef = snapshot.ref;

          // final newMetadata = SettableMetadata(
          //   cacheControl: "public, max-age=300",
          //   contentType: "image/jpeg",
          // );
          // await photoRef.updateMetadata(newMetadata);

          //arquivos.add(await photoRef.getDownloadURL());

          print("Url gerada = ${await photoRef.getDownloadURL()}");
          //refs.add(photoRef);
          // final SharedPreferences prefs = await _prefs;
          // prefs.setStringList('images', arquivos);

          setState((){});
        }
      });
    }
  }

  Future getFileFromGallery() async {
    PickedFile? file = await picker.getImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() => arquivo = File(file.path));
    }
  }

  showPreview(file) async {
    //File? arq = await Get.to(() => PreviewPage(file: file));

    File? arq =  await Navigator.push(
      context, MaterialPageRoute(
        builder: (context) => PreviewPage(file: file)
      )
    );

    if (arq != null) {
      setState(() => arquivo = arq);
      print("Arquivo (Path) = ${arq.path}");
      print("Arquivo = ${arq}");
      pickAndUploadImage(arq.path);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Envie seu Comprovante'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //if (arquivo != null) Anexo(arquivo: arquivo!),
                ElevatedButton.icon(
                  /*onPressed: () => Get.to(
                    () => CameraCamera(onFile: (file) => showPreview(file)),
                  ),*/
                  onPressed: (){
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => CameraCamera(
                          onFile: (file){
                            showPreview(file);
                          },
                        )
                      )
                    );
                  },
                  
                  icon: Icon(Icons.camera_alt),
                  label: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Tire uma foto'),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      textStyle: TextStyle(
                        fontSize: 18,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('ou'),
                ),
                OutlinedButton.icon(
                  icon: Icon(Icons.attach_file),
                  label: Text('Selecione um arquivo'),
                  onPressed: () => getFileFromGallery(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}