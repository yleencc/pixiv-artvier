import 'package:flutter/widgets.dart';

typedef IconButtonModelBuilder = IconButtonModel Function(BuildContext context);
typedef PerferenceBottomSheetBuilder = PerferenceBottomSheetModel Function(BuildContext context);

class IconButtonModel {
  String text;
  Widget icon;

  /// 将要跳转路由的名字
  String routeName;

  /// 跳转路由携带的参数
  Object? argument;

  IconButtonModel(this.text, this.icon, this.routeName, this.argument);
}

class PerferenceBottomSheetModel {
  String text;
  Widget icon;
  Widget? widget;
  Object? argument;

  PerferenceBottomSheetModel(this.text, this.icon, this.widget, this.argument);
}
