import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/entity/RegularInvestment.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MoneyPage extends StatefulWidget {
  MoneyPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<MoneyPage> {

  bool _hasLoadData = false;
  List<RegularInvestment> _dataList = [];
  ProgressDialog _dialog;

  @override
  void initState() {
    super.initState();
    _dialog = ProgressDialog(context);
    _dialog.style(message: "请等待...");
    loadData();
  }

  void loadData() {
    DataHelper.loadData(DataHelper.COLLECTION_INVESTMENT).then((value) {
      if (!this.mounted) return;
      if (value.code != null) {
        loadDataError(value.message);
        return;
      }

      setState(() {
        _hasLoadData = true;
        _dataList = (value.data as List)
            .map((e) =>
                RegularInvestment.fromJson(new Map<String, dynamic>.from(e)))
            .toList();
      });
    }).catchError(loadDataError);
  }

  loadDataError(error) {
    Fluttertoast.showToast(msg: "加载失败 " + error.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("理财"),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showEditDialog();
        },
      ),
    );
  }

  _buildBody() {
    if (_hasLoadData) {
      return getListView();
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  getListView() {
    return ListView.separated(
        itemBuilder: (context, index) => getRow(index),
        separatorBuilder: (context, _) => SizedBox(height: 8),
        itemCount: _dataList.length);
  }

  getRow(int index) {
    RegularInvestment data = _dataList[index];
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("[${data.rate}%] ${data.name}"),
          Text("80/月"), // FIXME calculate
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${data.startDate} 至 ${data.endDate}"),
          Text("180天"),
        ],
      ),
      onTap: () {
        showEditDialog(invest: data);
      },
    );
  }

  void showEditDialog({RegularInvestment invest}) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditDialog(),
          settings: RouteSettings(
            arguments: invest,
          ),
        ));
  }

// deleteTheDay() {
//   DialogUtils.showDeleteConfirmDialog(context, () {
//     _dialog.show();
//     DataHelper.deleteData(DataHelper.COLLECTION_THE_DAY, _theDay.id)
//         .then((value) => requestSuccess("删除"))
//         .catchError((error) => requestError(error));
//   });
// }
}

class EditDialog extends StatefulWidget {
  @override
  _DialogState createState() => _DialogState();
}

class _DialogState extends State<EditDialog> {

  static const DATE_TYPE_START = 1;
  static const DATE_TYPE_END = 2;

  RegularInvestment invest;
  bool _isUpdate = false;
  TextEditingController _nameController;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    if (invest == null) {
      invest = ModalRoute.of(context).settings.arguments;
      if (invest == null) {
        // 新增
        invest = RegularInvestment();
      } else {
        // 修改
        _isUpdate = true;
        _nameController.text = invest.name;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildFormFields()),
    );
  }

  // void showEditDialog({RegularInvestment invest}) {
  //   showDialog<bool>(
  //     context: context,
  //     builder: (context) {
  //       bool isUpdate = true;
  //       if (invest == null) {
  //         invest = RegularInvestment();
  //         isUpdate = false;
  //       }
  //       return StatefulBuilder(builder: (context, dialogSetStatue) {
  //         return AlertDialog(
  //           content: Form(
  //             key: _formKey,
  //             child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: _buildFormFields(invest, dialogSetStatue)),
  //           ),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text("取消"),
  //               onPressed: () => Navigator.pop(context), // 关闭对话框
  //             ),
  //             FlatButton(
  //               child: Text(invest != null ? "修改" : "新增"),
  //               onPressed: () {
  //                 Navigator.pop(context, true);
  //                 updateTodo(invest, isUpdate);
  //               },
  //             ),
  //           ],
  //         );
  //       });
  //     },
  //   );
  // }

  List<Widget> _buildFormFields() {
    return [
      TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: "名称",
        ),
        validator: (value) {
          return value.trim().length > 0 ? null : "名称不能为空";
        },
        onSaved: (newValue) {
          invest.name = newValue;
        },
      ),
      SizedBox(
        height: 8,
      ),
      GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "开始日期：",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              invest.startDate ?? "未填写",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        onTap: () {
          pickDate(invest, DATE_TYPE_START);
        },
      ),
    ];
  }

  pickDate(RegularInvestment invest, int dateType) async {
    var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if(date == null) return;
    var format = DateFormat("yyyy-MM-dd").format(date);
    setState(() {
      if (dateType == DATE_TYPE_START) {
        invest.startDate = format;
      } else if (dateType == DATE_TYPE_END) {
        invest.endDate = format;
      }
    });
  }

  // updateTodo(RegularInvestment invest, bool isUpdate) async {
  //   if (_formKey.currentState.validate()) {
  //     // 验证通过提交数据
  //     _formKey.currentState.save();
  //
  //     _dialog.show();
  //
  //     if (isUpdate) {
  //       DataHelper.setData(DataHelper.COLLECTION_LIST, invest.id, invest)
  //           .then((value) => requestSuccess("修改"))
  //           .catchError((error) => requestError(error));
  //     } else {
  //       DataHelper.saveData(DataHelper.COLLECTION_INVESTMENT, invest)
  //           .then((value) => requestSuccess("新增"))
  //           .catchError((error) => requestError(error));
  //     }
  //   }
  // }
  //
  // requestSuccess(String operation) {
  //   _dialog.hide();
  //   var msg = operation + "成功";
  //   Fluttertoast.showToast(msg: msg);
  //   Navigator.pop(context, true);
  // }
  //
  // requestError(error) {
  //   _dialog.hide();
  //   var msg = "操作失败 " + error.toString();
  //   Fluttertoast.showToast(msg: msg);
  // }
}