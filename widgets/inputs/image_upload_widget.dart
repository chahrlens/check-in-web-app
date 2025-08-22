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
  return LogoUploadWidget(
      uploadImageController: imageController,
      text: placeholder,
      icon: icon,
      validator: validator);
}

class LogoUploadWidget extends StatefulWidget {
  final ImageToUpload uploadImageController;
  final String text;
  final FormFieldValidator<Object>? validator;
  final bool enabled;
  final Icon icon;
  final double height;

  const LogoUploadWidget(
      {super.key,
      required this.uploadImageController,
      required this.text,
      required this.validator,
      this.enabled = true,
      this.height = 50.0,
      this.icon = const Icon(
        Icons.upload,
        color: Colors.white,
      )});

  @override
  State<LogoUploadWidget> createState() => _LogoUploadWidgetState();
}

class _LogoUploadWidgetState extends State<LogoUploadWidget> {
  final RxString controllerImage = "".obs;

  @override
  Widget build(BuildContext context) {
    final String? linkImage = widget.uploadImageController.link;
    final colorscheme = Theme.of(context).colorScheme;

    final showImageButton = (widget.uploadImageController.needUpdate == false &&
            linkImage != null) ||
        controllerImage.value.isNotEmpty;

    return FormField(
      validator: (value) => widget.validator!(
          controllerImage.value.isEmpty ? null : controllerImage.value.isEmpty),
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: widget.height,
              decoration: BoxDecoration(
                border: Border.all(color: colorscheme.primary),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Botón 70%
                  Expanded(
                    flex: 7,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async {
                          if (!widget.enabled) return;

                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);

                          if (pickedFile != null) {
                            String fileExtension =
                                path.extension(pickedFile.path);
                            controllerImage.value = pickedFile.path;
                            final imageBytes = await pickedFile.readAsBytes();

                            List<int> compressedBytes =
                                await FlutterImageCompress.compressWithList(
                              imageBytes,
                              minHeight: 400,
                              minWidth: 600,
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
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorscheme.primary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                widget.icon,
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    widget.text,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Icono modal 30%
                  Expanded(
                      flex: 3,
                      child: IconButton(
                        icon: Icon(Icons.image,
                            color: !showImageButton
                                ? colorscheme.onSurfaceVariant
                                : colorscheme.onPrimary),
                        onPressed: !showImageButton
                            ? null
                            : () {
                                showImageWidget(
                                    context,
                                    widget.uploadImageController,
                                    controllerImage,
                                    linkImage);
                              },
                      )),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                state.errorText ?? "",
                style: TextStyle(color: colorscheme.error, fontSize: 10),
              ),
            ),
          ],
        );
      },
    );
  }

  void showImageWidget(BuildContext context, ImageToUpload imageController,
      RxString imageBase64, String? linkImage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              imageController.needUpdate == false && linkImage != null
                  ? Image.network(linkImage)
                  : Obx(
                      () => Center(
                          child: imageBase64.value.isNotEmpty
                              ? Image.memory(
                                  base64Decode(imageController.base64!),
                                  fit: BoxFit.cover,
                                  height: 600,
                                  width: 600,
                                )
                              : null),
                    )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }
}
