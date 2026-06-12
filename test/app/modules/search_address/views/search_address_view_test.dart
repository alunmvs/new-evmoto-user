import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/search_address/controllers/search_address_controller.dart';
import 'package:new_evmoto_user/app/modules/search_address/views/search_address_view.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../helpers/test_dependencies.dart';

class MockGeocodingRepository extends Mock implements GeocodingRepository {}

class TestSearchAddressController extends SearchAddressController {
  TestSearchAddressController({required super.geocodingRepository});

  @override
  Future<void> onInit() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  group('SearchAddressView', () {
    late TestSearchAddressController controller;
    late MockGeocodingRepository geocodingRepository;
    const tag = 'search-address-test';

    setUp(() {
      registerCoreTestServices(
        language: Language(
          addLocationHome: 'Add Home Location',
          enterHomeAddress: 'Enter home address',
          enterLocationHomeAddress: 'Search home address',
        ),
      );
      registerFakeLocationServices();
      geocodingRepository = MockGeocodingRepository();
      controller = TestSearchAddressController(
        geocodingRepository: geocodingRepository,
      );
      controller.addressType.value = 1;
      controller.isFetch.value = false;
      controller.textEditingController = TextEditingController();
      Get.put<SearchAddressController>(controller, tag: tag);
    });

    tearDown(() {
      controller.textEditingController.dispose();
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders search address screen for home location', (
      WidgetTester tester,
    ) async {
      Get.routing.args = {'address_type': 1, 'tag': tag};

      await tester.pumpWidget(
        GetMaterialApp(home: SearchAddressView()),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Add Home Location'), findsOneWidget);
      expect(find.text('Enter home address'), findsOneWidget);
      expect(find.text('Search home address'), findsWidgets);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
