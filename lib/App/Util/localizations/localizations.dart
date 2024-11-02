import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/localizations/ar.dart';
import 'package:mformatic_crm_delegate/App/Util/localizations/en.dart';

import 'fr.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'fr': fr,
        // 'ar': ar,
      };
}
