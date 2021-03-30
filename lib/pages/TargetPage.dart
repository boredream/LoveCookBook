import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/entity/Target.dart';
import 'package:flutter_todo/entity/TargetItem.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/main.dart';
import 'package:flutter_todo/utils/DialogUtils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class TargetPage extends StatefulWidget {
  TargetPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TargetPage> {
  Target _data;
  bool _isUpdate = false;
  TextEditingController _titleController;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ProgressDialog _dialog;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _dialog = DialogUtils.getProgressDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_data == null) {
      Map args = ModalRoute.of(context).settings.arguments as Map;
      if (args != null) {
        _data = args["data"];
      }
      if (_data == null) {
        // 新增
        _data = Target();
        _data.totalProgress = 0;
        _data.items = [];
      } else {
        // 修改
        _isUpdate = true;
      }

      _titleController.text = _data.name;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("目标详情"),
        actions: [
          Center(child: _buildCommitBtn()),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => toEditPage(null),
      ),
    );
  }

  _buildCommitBtn() {
    return TextButton(
      child:
          Text(_isUpdate ? "修改" : "新增", style: TextStyle(color: Colors.white)),
      onPressed: () => updateData(),
    );
  }

  _buildBody() {
    return Column(
      children: [
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "目标名称",
                  ),
                  validator: (value) {
                    return value.trim().length > 0 ? null : "不能为空";
                  },
                  onSaved: (newValue) {
                    setState(() {
                      _data.name = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        // Expanded(child: getListView()),
      ],
    );
  }

//   getListView() {
//     return ListView.separated(
//         itemBuilder: (context, index) => getRow(index),
//         separatorBuilder: (context, _) => SizedBox(height: 8),
//         itemCount: _dataList.length);
//   }
//
//   getRow(int index) {
//     Target data = _dataList[index];
//     int curIncome = data.curMoney - data.oriMoney;
//     double curIncomeRate = 100 * curIncome / data.oriMoney;
//     Color curInComeColor;
//     String curIncomeRateStr = NumberFormat("0.00").format(curIncomeRate);
//     if (curIncomeRate >= 0) {
//       curInComeColor = Colors.red;
//       curIncomeRateStr = "+$curIncomeRateStr";
//     } else {
//       curInComeColor = Colors.green;
//       curIncomeRateStr = "-$curIncomeRateStr";
//     }
//
//     int totalIncome = data.existIncome + curIncome;
//     return ListTile(
//       title: Text(data.name),
//       subtitle: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(child: Text("成本：${data.oriMoney}")),
//               Expanded(child: Text("持有：${data.curMoney}")),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(
//                   child: RichText(
//                 text: TextSpan(children: [
//                   TextSpan(
//                       text: "收益：$curIncome",
//                       style: TextStyle(color: Colors.grey[600], fontSize: 15)),
//                   TextSpan(
//                       text: " $curIncomeRateStr%",
//                       style: TextStyle(color: curInComeColor)),
//                 ]),
//               )),
//               // Expanded(child: Text("当前收益：$curIncome  +35%")),
//               Expanded(child: Text("累收：$totalIncome")),
//             ],
//           )
//         ],
//       ),
//       onTap: () {
//         showEditDialog(data: data);
//       },
//     );
//   }
//
//   void showEditDialog({Target data}) {
//     showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return EditDialog(
//             dialog: _dialog,
//             data: data ?? Target(),
//             updateSuccess: () {
//               setState(() {
//                 _hasLoadData = false;
//               });
//               loadData();
//             });
//       },
//     );
//   }
// }
//
// class EditDialog extends StatefulWidget {
//   final ProgressDialog dialog;
//   final Target data;
//   final Function updateSuccess;
//
//   EditDialog({Key key, this.dialog, this.data, this.updateSuccess})
//       : super(key: key);
//
//   @override
//   _DialogState createState() => _DialogState();
// }
//
// class _DialogState extends State<EditDialog> {
//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _oriMoneyController = TextEditingController();
//   TextEditingController _curMoneyController = TextEditingController();
//   TextEditingController _existIncomeController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController.text = widget.data.name;
//     _oriMoneyController.text = widget.data.oriMoney?.toString();
//     _curMoneyController.text = widget.data.curMoney?.toString();
//     _existIncomeController.text = widget.data.existIncome?.toString();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       content: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     labelText: "名称",
//                   ),
//                   validator: (value) {
//                     return value.trim().length > 0 ? null : "不能为空";
//                   },
//                   onSaved: (newValue) {
//                     setState(() {
//                       widget.data.name = newValue;
//                     });
//                   },
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 TextFormField(
//                   controller: _oriMoneyController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: "投入金额",
//                   ),
//                   validator: (value) {
//                     return value.trim().length > 0 ? null : "不能为空";
//                   },
//                   onSaved: (newValue) {
//                     setState(() {
//                       widget.data.oriMoney = int.parse(newValue);
//                     });
//                   },
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 TextFormField(
//                   controller: _curMoneyController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: "当前金额",
//                   ),
//                   validator: (value) {
//                     return value.trim().length > 0 ? null : "不能为空";
//                   },
//                   onSaved: (newValue) {
//                     setState(() {
//                       widget.data.curMoney = int.parse(newValue);
//                     });
//                   },
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 TextFormField(
//                   controller: _existIncomeController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: "已提取收益",
//                   ),
//                   validator: (value) {
//                     return value.trim().length > 0 ? null : "不能为空";
//                   },
//                   onSaved: (newValue) {
//                     setState(() {
//                       widget.data.existIncome = int.parse(newValue);
//                     });
//                   },
//                 ),
//               ]),
//         ),
//       ),
//       actions: <Widget>[
//         FlatButton(
//           child: Text("取消"),
//           onPressed: () => Navigator.pop(context), // 关闭对话框
//         ),
//         FlatButton(
//           child: Text(widget.data != null ? "修改" : "新增"),
//           onPressed: () {
//             updateData();
//           },
//         ),
//       ],
//     );
//   }
//
  updateData() async {
    if (_formKey.currentState.validate()) {
      // 验证通过提交数据
      _formKey.currentState.save();

      _dialog.show();
      if (_isUpdate) {
        DataHelper.setData(DataHelper.COLLECTION_TARGET, _data.id, _data)
            .then((value) => requestSuccess("修改"))
            .catchError((error) => requestError(error));
      } else {
        DataHelper.saveData(DataHelper.COLLECTION_TARGET, _data)
            .then((value) => requestSuccess("新增"))
            .catchError((error) => requestError(error));
      }
    }
  }

  requestSuccess(String operation) {
    _dialog.hide();
    var msg = operation + "成功";
    Fluttertoast.showToast(msg: msg);
    Navigator.pop(context, true);
  }

  requestError(error) {
    _dialog.hide();
    var msg = "操作失败 " + error.toString();
    Fluttertoast.showToast(msg: msg);
  }

  void toEditPage(TargetItem data) {
    MyRouteDelegate.of(context).push("targetItem",
        arguments: {"target": _data, "data": data});
    // .then((value) {
      // if (value) refresh();
    // });
  }
}
