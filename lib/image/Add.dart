import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImage extends StatefulWidget {
  const AddImage({Key? key}) : super(key: key);

  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  void _pickImage() {
    final imagePicker = ImagePicker();
    imagePicker.pickImage(source: ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      width: 150,
      height: 300,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
          ),
          SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.image),
            label: Text('프로필 사진 설정'),
          ),
          SizedBox(
            height: 80,
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
            label: Text('Close'),
          ),
        ],
      ),
    );
  }
}
