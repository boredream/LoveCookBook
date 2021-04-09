import 'package:flutter_todo/entity/BaseCloudBean.dart';

abstract class BaseItemBean<T> extends BaseCloudBean {

  List<T> getItems();

}
