class ImageToUpload {
  String? base64;
  bool needUpdate;
  String? link;
  String? extension;
  String? originalName;

  ImageToUpload({
    this.base64,
    this.needUpdate = false,
    this.link,
    this.extension,
    this.originalName
  });

  void updateBase64String(String newBase64String) {
    base64 = newBase64String;
    needUpdate = true;
  }

  void updateLink(String newLink) {
    link = newLink;
    needUpdate = false;
    getOriginalNameFile();
  }

  void markUpdateComplete() {
    needUpdate = false;
  }

  void updateExtensionFile(String extensionFile){
    extension = extensionFile;
    print(extensionFile);
    print(extension);
  }

  void reset() {
    base64 = null;
    needUpdate = false;
    link = null;
    extension = null;
  }

  void getOriginalNameFile() {
    print('image_model 44  ${link}');
    originalName = link!.replaceAll("from", "replace");
  }

  factory ImageToUpload.fromJson(Map<String, dynamic> json) {
    return ImageToUpload(link: json['s3Response'].toString(), needUpdate: false, base64: "");
  }
}

class UploadImage {
  dynamic file;
  String fileName;
  String transactionType;

  UploadImage(
      {required this.file,
      required this.fileName,
      required this.transactionType});

   Map<String, dynamic> toJson() {
    return {
      "file": "$file",
      "fileName": fileName,
      "transactionType": transactionType,
    };
  }

  factory UploadImage.fromJson(Map<String, dynamic> json) {
    return UploadImage(
        file: json["file"],
        fileName: json["fileName"],
        transactionType: json["transactionType"]);
  }
}
