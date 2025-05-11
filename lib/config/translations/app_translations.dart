import 'package:get/get.dart';
import 'af_ZA.dart';
import 'am_ET.dart';
import 'ar_AR.dart';
import 'de_DE.dart';
import 'en_US.dart';
import 'es_ES.dart';
import 'fr_FR.dart';
import 'hi_IN.dart';
import 'id_ID.dart';
import 'nl_NL.dart';
import 'pt_PT.dart';
import 'tr_TR.dart';
import 'vi_VN.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'fr_FR': frFR,
    'am_ET': amET,
    'ar_AR': arAR,
    'de_DE': deDE,
    'es_ES': esES,
    'id_ID': idID,
    'nl_NL': nlNL,
    'pt_PT': ptPT,
    'tr_TR': trTR,
    'vi_VN': viVN,
    'hi_IN': hiIN,
    'af_ZA': afZA,
  };
}
