import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:qr_check_in/models/image_model.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Widget buildImageWidget(String id, ImageToUpload imageController, Icon icon,
    String placeholder, String? initUrl, String? Function(Object?)? validator) {
  // ImageToUpload imageController = ImageToUpload(
  //   base64: null,
  //   needUpdate: true,
  //   link: "",
  // );

  if (initUrl != null && initUrl.isNotEmpty) {
    imageController.updateLink(initUrl);
  }

  // imageControllers[id] = imageController;
  return ImagePickerButton(
      uploadImageController: imageController,
      text: placeholder,
      icon: icon,
      validator: validator);
}

class ImagePickerButton extends StatefulWidget {
  final ImageToUpload uploadImageController;
  final String text;
  final FormFieldValidator<Object>? validator;
  final bool enabled;
  final Icon icon;

  const ImagePickerButton(
      {super.key,
      required this.uploadImageController,
      required this.text,
      required this.validator,
      this.enabled = true,
      this.icon = const Icon(
        Icons.upload,
        color: Colors.white,
      )});

  @override
  State<ImagePickerButton> createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  final RxString controllerImage = "".obs;

  @override
  @override
  Widget build(BuildContext context) {
    final String? linkImage = widget.uploadImageController.link;
    // final colorscheme = Theme.of(context).colorScheme;

    // final showImageButton = (widget.uploadImageController.needUpdate == false &&
    //         linkImage != null) ||
    //     controllerImage.value.isNotEmpty;

    return FormField(
        validator: (value) => widget.validator!(controllerImage.value.isEmpty
            ? null
            : controllerImage.value.isEmpty),
        builder: (state) {
          return Column(
            children: [
              GestureDetector(
                child: Container(
                  height: 30.0,
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30))),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        widget.icon,
                      ],
                    ),
                  ),
                ),
                onTap: () async {
                  if (!widget.enabled) return;

                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);

                  if (pickedFile != null) {
                    String fileExtension = path.extension(pickedFile.path);
                    controllerImage.value = pickedFile.path;
                    final imageBytes = await pickedFile.readAsBytes();

                    List<int> compressedBytes =
                        await FlutterImageCompress.compressWithList(
                      imageBytes,
                      minHeight: 300,
                      minWidth: 400,
                      quality: 50,
                    );

                    String base64Image = base64Encode(compressedBytes);
                    setState(() {
                      widget.uploadImageController
                          .updateExtensionFile(fileExtension);
                      widget.uploadImageController
                          .updateBase64String(base64Image);
                    });
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    state.errorText ?? "",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 11),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              widget.uploadImageController.needUpdate == false &&
                      linkImage != null
                  ? Image.network(linkImage)
                  : Center(
                          child: widget.uploadImageController.base64 != null
                              ? Image.memory(
                                  base64Decode(widget.uploadImageController.base64!),
                                  fit: BoxFit.cover,
                                  height: 600,
                                  width: 600,
                                )
                              : null),
            ],
          );
        });
  }
}
