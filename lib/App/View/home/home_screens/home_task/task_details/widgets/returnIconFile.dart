import '../../../../../../Util/Const/constants.dart';

String returnIconFile(String path) {
  if (imgFileTypes.any((type) => path.toString().contains(type))) {
    return "assets/icons/photo.png";
  }
  if (pdfFileTypes.any((type) => path.toString().contains(type))) {
    return "assets/icons/pdf.png";
  }
  if (excelFileTypes.any((type) => path.toString().contains(type))) {
    return "assets/icons/excel.png";
  }

  return "assets/icons/photo.png";
}
