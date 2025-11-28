import 'dart:io';

class ModifyImage {
  final String? url;
  final File? file;

  ModifyImage.fromUrl(this.url) : file = null;
  ModifyImage.fromFile(this.file) : url = null;
}