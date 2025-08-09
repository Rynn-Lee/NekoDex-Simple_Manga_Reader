import 'package:flutter_svg/flutter_svg.dart';

const Map<String, String> mangaDexLangToCountryLowercase = {
  'en': 'us',
  'ja': 'jp',
  'zh': 'cn',
  'zh-hk': 'hk',
  'zh-cn': 'cn',
  'zh-ro': 'cn',
  'zh-tw': 'tw',
  'ko': 'kr',
  'ko-ro': 'kr',
  'es-la': 'mx',
  'pt-br': 'br',
  'uk': 'ua',
  'it': 'it',
  'ja-ro': 'jp',
  'ka': 'ge',
  'id': 'id',
  'vi': 'vn',
  'ar': 'sa',
  'kk': 'kz',
  'da': 'dk',
  'ur': 'pk',
  'hi': 'in',
  'bn': 'bd',
  'ms': 'my',
  'sv': 'se',
  'he': 'il',
  'cs': 'cz',
  'el': 'gr',
  'fa': 'ir',
  'ta': 'lk',
  'te': 'in',
  'ml': 'in',
  'sr': 'rs',
};

SvgPicture getFlag(String flag){
  final flagIcon = mangaDexLangToCountryLowercase.containsKey(flag) ? mangaDexLangToCountryLowercase[flag] : flag;
  return SvgPicture.asset('lib/assets/icons/flags/$flagIcon.svg', height: 18.0, width: 18.0);
}