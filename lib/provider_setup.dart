import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/services/home/home_service.dart';
import 'core/services/map/map_service.dart';
import 'core/services/user/user_service.dart';
import 'core/view_model/auth/auth_view_model.dart';
import 'core/view_model/home/home_view_modal.dart';
import 'core/view_model/user/user_view_model.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableServices
];

List<SingleChildWidget> independentServices = [
  Provider(create: (_) => HomeService()),
  Provider(create: (_) => UserService()),
  Provider(create: (_) => MapService()),
];
List<SingleChildWidget> dependentServices = [
  ChangeNotifierProxyProvider<UserService, AuthViewModel>(
    create: (_) => AuthViewModel(),
    update: (context, UserService userService, AuthViewModel? authModal) =>
        authModal!..userService = userService,
  ),
  ChangeNotifierProxyProvider<UserService, UserViewModel>(
    create: (_) => UserViewModel(),
    update: (context, UserService userService, UserViewModel? userModel) =>
        userModel!..userService = userService,
  ),
  ChangeNotifierProxyProvider2<HomeService, MapService, HomeViewModal>(
    create: (_) => HomeViewModal(),
    update: (context, HomeService homeService, MapService mapService, HomeViewModal? homeModal) =>
        homeModal!
          ..homeService = homeService
          ..mapService = mapService,
  ),
];
List<SingleChildWidget> uiConsumableServices = [];
