import 'package:camera/camera.dart';
import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
/*import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:color_find/model/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;*/
import 'package:testedb2/color_description.dart';

class Page2 extends StatefulWidget{
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  XFile? image;
  Size? size;
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  //ColorHelper helper = ColorHelper();


  @override
  void initState() {
    super.initState();
    _loadCameras();
  }
  _loadCameras() async {
    try {
      cameras = await availableCameras();
      _startCamera();
    } on CameraException catch (e) {
      debugPrint(e.description);
    }
  }

  _startCamera() {
    if (cameras.isEmpty) {
      debugPrint('Câmera não foi encontrada');
    } else {
      _previewCamera(cameras.first);
    }
  }

  _previewCamera(CameraDescription camera) async {
    final CameraController cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    controller = cameraController;

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      debugPrint(e.description);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tire a Foto da Cor desejada!'),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[900],
        child: Center(
          child: _arquivoWidget(),
        ),
      ),
      floatingActionButton: (image != null)
          ? FloatingActionButton.extended(
        onPressed: () => {
          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Page4())),
        },//uploadFile(),
        label: const Text('Finalizar'),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _arquivoWidget() {
    return SizedBox(
      width: size!.width - 50,
      height: size!.height - (size!.height / 3),
      child: image == null
          ? _cameraPreviewWidget()
          : Image.file(
        File(image!.path),
        fit: BoxFit.contain,
      ),
    );
  }
  _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text('Widget para Câmera que não está disponível');
    } else {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          CameraPreview(controller!),
          _botaoCapturaWidget(),
        ],
      );
    }
  }
  _botaoCapturaWidget() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.black.withOpacity(0.5),
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: tirarFoto,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.black.withOpacity(0.5),
                child: IconButton(
                  icon: const Icon(
                    Icons.photo_album,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: EscolheFoto,
                ),
              ),
            ),
          ],
        )
    );
  }
  tirarFoto() async {
    final CameraController? cameraController = controller;

    if (cameraController != null && cameraController.value.isInitialized) {
      try {
        XFile file = await cameraController.takePicture();
        if (mounted) setState(() => _photo = File(file.path));
      } on CameraException catch (e) {
        debugPrint(e.description);
      }
    }
  }

  EscolheFoto()  async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        //uploadFile();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Page4()));
      } else {
        print('No image selected.');
      }
    });
  }


 /* uploadFile() async {

    if (_photo == null) return;
    final fileName = basename(_photo!.path);

    try {

      final ref = firebase_storage.FirebaseStorage.instance.ref();
      final mountainRef = ref.child('file/');
      final mountainImagesRef=mountainRef.child('$fileName');
      await mountainImagesRef.putFile(_photo!);
    } catch (e) {
      print('$e');
    }
  }*/
}

