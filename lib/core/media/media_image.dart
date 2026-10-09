import 'dart:io';

import 'package:flutter/widgets.dart';

/// Ảnh từ URL mạng hoặc file đã tải offline (`file://…`).
ImageProvider mediaImage(String url) =>
    url.startsWith('file://') ? FileImage(File(Uri.parse(url).toFilePath())) : NetworkImage(url);
