import 'package:intl/intl.dart';
import 'package:personal_space/model/remote_file_model.dart';

class SearchService {
  static bool _extensionMatch(RemoteFileModel model, String keyword) {
    String extension = model.fileExtension;

    if ('text'.contains(keyword)) return extension == 'txt';

    /* match for documents */
    if ('documents'.contains(keyword))
      return extension == 'pdf' ||
          extension == 'txt' ||
          extension == 'doc' ||
          extension == 'docx' ||
          extension == 'ppt' ||
          extension == 'csv' ||
          extension == 'xls';

    /* match for images */
    if ('image'.contains(keyword) || 'picture'.contains(keyword))
      return extension == 'jpg' ||
          extension == 'jpeg' ||
          extension == 'svg' ||
          extension == 'png';

    /* match for audios */
    if ('music'.contains(keyword) ||
        'song'.contains(keyword) ||
        'audio'.contains(keyword))
      return extension == 'mp3' || extension == 'wav' || extension == 'ogg';

    /* match for videos */
    if ('video'.contains(keyword) || 'film'.contains(keyword))
      return extension == 'mp4' || extension == 'mov';

    /* match for compressed files */
    if ('compressed'.contains(keyword) || 'archived'.contains(keyword))
      return extension == 'zip' || extension == 'rar';

    if ('unknown'.contains(keyword)) return extension == 'file';

    /* direct match */
    if (extension.contains(keyword)) return true;

    /* nothing matched */
    return false;
  }

  /* TODO: DO THIS LATER */
  /* file match by name only works, if the file names are set to auto decrypt in Settings */
  static bool _filenameMatch(RemoteFileModel model, String keyword) {
    return false;
  }

  static bool _dateMatch(RemoteFileModel model, String keyword) =>
      DateFormat('E MMMM')
          .format(model.uploadedOn)
          .toLowerCase()
          .contains(keyword.toLowerCase());

  static List<RemoteFileModel> searchFor(
    String keyword,
    List<RemoteFileModel> files,
  ) {
    if (keyword == null || keyword.isEmpty) return files;

    List<RemoteFileModel> filteredFiles = [];

    /* match
    1. extension (file type)
    2. filename (only if decrypted)
    3. month OR day wise
    */

    for (RemoteFileModel model in files)
      if (_extensionMatch(model, keyword) ||
          _filenameMatch(model, keyword) ||
          _dateMatch(model, keyword)) filteredFiles.add(model);

    return filteredFiles;
  }
}
