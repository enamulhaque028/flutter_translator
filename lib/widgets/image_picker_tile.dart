import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:translator_app/config/route.dart';
import 'package:translator_app/widgets/custom_icon_button.dart';

import '../config/presentation/app_color.dart';

class PickImages extends StatefulWidget {
  final Function(String?) onSelectImage;

  const PickImages({super.key, required this.onSelectImage});

  @override
  State<StatefulWidget> createState() {
    return PickImagesState();
  }
}

class PickImagesState extends State<PickImages> {
  XFile? imageFile;

  ///open image from camera or gallery
  void _openImagePicker({
    required BuildContext context,
    required ImageSource source,
  }) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
    );
    setState(() {
      imageFile = pickedFile!;
      String imagePath = pickedFile.path;
      widget.onSelectImage(imagePath);
    });
    RouteController.instance.pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Choose option",
            style: TextStyle(color: AppColor.primaryColor),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Divider(
                  height: 1,
                  color: AppColor.primaryColor,
                ),
                ListTile(
                  onTap: () {
                    _openImagePicker(
                      context: context,
                      source: ImageSource.gallery,
                    );
                  },
                  title: const Text("Gallery"),
                  leading: const Icon(
                    Icons.image,
                    color: AppColor.primaryColor,
                  ),
                ),
                const Divider(
                  height: 1,
                  color: AppColor.primaryColor,
                ),
                ListTile(
                  onTap: () {
                    _openImagePicker(
                      context: context,
                      source: ImageSource.camera,
                    );
                  },
                  title: const Text("Camera"),
                  leading: const Icon(
                    Icons.camera_alt,
                    color: AppColor.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      iconData: Icons.camera_alt_rounded,
      onTap: () {
        _showChoiceDialog(context);
      },
    );
  }
}
