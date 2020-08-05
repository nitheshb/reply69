import 'package:algolia/algolia.dart';

class AlgoliaApplication{
  static final Algolia algolia = Algolia.init(
    applicationId: '0T5L58WOGK', //ApplicationID
    apiKey: '3626856d16f692ea361f18409d7a064a', //search-only api key in flutter code
  );
}