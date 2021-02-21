import 'package:flutter/material.dart';

const kSettings = 'Settings';
const kBin = 'Bin';
const kLogout = 'Logout';

const kMainScreenMenuItemChoices = <String>[
  kSettings,
  kBin,
  kLogout,
];

const kMenuPopupOffset = const Offset(10.0, 65.0);

const _kIconBase = 'assets/file_type_icons';
const kIconFile = '$_kIconBase/file.png';
const kIconPdf = '$_kIconBase/pdf.png';
const kIconMp3 = '$_kIconBase/mp3.png';
const kIconMp4 = '$_kIconBase/mp4.png';
const kIconPng = '$_kIconBase/png.png';
const kIconJpg = '$_kIconBase/jpg.png';
const kIconSvg = '$_kIconBase/svg.png';
const kIconZip = '$_kIconBase/zip.png';
const kIconCompressed = '$_kIconBase/zip-1.png';
const kIconTxt = '$_kIconBase/txt.png';
const kIconCsv = '$_kIconBase/csv.png';
const kIconDoc = '$_kIconBase/doc.png';
const kIconPpt = '$_kIconBase/ppt.png';
const kIconXls = '$_kIconBase/xls.png';

const FILE = 'file';
const PDF = 'pdf';
const MP3 = 'mp3';
const OGG = 'ogg';
const MP4 = 'mp4';
const PNG = 'png';
const JPG = 'jpg';
const SVG = 'svg';
const ZIP = 'zip';
const RAR = 'rar';
const TXT = 'txt';
const CSV = 'csv';
const DOC = 'doc';
const DOCX = 'docx';
const PPT = 'ppt';
const XLS = 'xls';

const kUsersCollection = 'users';
const kFilesCollection = 'files';
const kTotalBytesUsage = 'totalBytesUsage';
const kFirestoreRef = 'firestoreRef';

const kAnimationDuration = const Duration(milliseconds: 700);
const kFastAnimationDuration = const Duration(milliseconds: 300);

const kWaitDuration = const Duration(milliseconds: 2100);
const kFastWaitDuration = const Duration(milliseconds: 900);

const kLightGray = const Color(0xfff0f0f0);
const kGray = const Color(0xffa0a0a0);
const kDarkGray = const Color(0xff707070);
const kDarkestGray = const Color(0xff303030);

const kDividerVert20 = SizedBox(height: 20);
const kDividerHor20 = SizedBox(width: 20);

const kEmptyWidget = SizedBox.shrink();

const kTextStyle30 = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w800,
  fontSize: 30.0,
);

const kTextStyle25 = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w800,
  fontSize: 25.0,
);

const kGroupByTextStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w800,
  fontSize: 16.0,
);

const kErrorTextStyle = TextStyle(
  color: Colors.red,
  fontSize: 20.0,
);

const kSuccessTextStyle = TextStyle(
  color: Colors.green,
  fontSize: 20.0,
);

const kUploadingWidgetFileNameTextStyle = TextStyle(
  color: Colors.deepPurple,
  fontSize: 16.0,
);

const kUploadingWidgetTitleTextTextStyle = TextStyle(
  color: Colors.deepPurple,
  fontWeight: FontWeight.w800,
  fontSize: 25.0,
);

const kUploadingWidgetPercentageDoneTextStyle = TextStyle(
  color: Colors.deepPurpleAccent,
  fontSize: 18.0,
);

const kRemoteFileItemWidgetFileNameTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 15.0,
);

const ERROR = 'ERROR';
const SUCCESS = 'SUCCESS';

const kContentPaddingVertical20 = const EdgeInsets.symmetric(
  vertical: 20.0,
);

/* max download size is 100 MiB */
const int kFirebaseDownloadMaxSize = 104857600;
