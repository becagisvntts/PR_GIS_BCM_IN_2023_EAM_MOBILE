import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/middlewares/class_middleware.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/middlewares/menu_middleware.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/app_state.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> eamMiddlewares() {
  return [ClassesMiddleware(), MenuMiddleware()];
}
