
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/entity/Fund.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/utils/DialogUtils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class FundPage extends StatefulWidget {
  FundPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<FundPage> {
  bool _hasLoadData = false;
  List<Fund> _dataList = [];
  ProgressDialog _dialog;

  @override
  void initState() {
    super.initState();
    _dialog = DialogUtils.getProgressDialog(context);
    loadData();
  }

  void loadData() {
    DataHelper.loadData(DataHelper.COLLECTION_FUND, orderField: "curMoney")
        .then((value) {
      if (!this.mounted) return;
      if (value.code != null) {
        loadDataError(value.message);
        return;
      }

      setState(() {
        _hasLoadData = true;
        _dataList = (value.data as List)
            .map((e) => Fund.fromJson(new Map<String, dynamic>.from(e)))
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
        title: Text("净值类投资"),
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
      int totalOriMoney = 0;
      int totalCurMoney = 0;
      int totalExistIncome = 0;
      for (Fund data in _dataList) {
        totalOriMoney += data.oriMoney;
        totalCurMoney += data.curMoney;
        totalExistIncome += data.existIncome;
      }

      int curIncome = totalCurMoney - totalOriMoney;
      double curIncomeRate = 100 * curIncome / totalOriMoney;
      Color curInComeColor;
      String curIncomeRateStr = NumberFormat("0.00").format(curIncomeRate);
      if (curIncomeRate >= 0) {
        curInComeColor = Colors.red;
        curIncomeRateStr = "+$curIncomeRateStr";
      } else {
        curInComeColor = Colors.green;
        curIncomeRateStr = "-$curIncomeRateStr";
      }

      int totalIncome = totalExistIncome + curIncome;

      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text("总成本：$totalOriMoney"), flex: 5),
                    Expanded(child: Text("总持有：$totalCurMoney"), flex: 4),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "收益：$curIncome",
                                style: TextStyle(color: Colors.black87 , fontSize: 15)),
                            TextSpan(
                                text: " $curIncomeRateStr%",
                                style: TextStyle(color: curInComeColor)),
                          ]),
                        )),
                    // Expanded(child: Text("当前收益：$curIncome  +35%")),
                    Expanded(child: Text("累收：$totalIncome"), flex: 4),
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: getListView()),
        ],
      );
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
    Fund data = _dataList[index];
    int curIncome = data.curMoney - data.oriMoney;
    double curIncomeRate = 100 * curIncome / data.oriMoney;
    Color curInComeColor;
    String curIncomeRateStr = NumberFormat("0.00").format(curIncomeRate);
    if (curIncomeRate >= 0) {
      curInComeColor = Colors.red;
      curIncomeRateStr = "+$curIncomeRateStr";
    } else {
      curInComeColor = Colors.green;
      curIncomeRateStr = "-$curIncomeRateStr";
    }

    int totalIncome = data.existIncome + curIncome;
    return ListTile(
      title: Text(data.name),
      subtitle: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text("成本：${data.oriMoney}")),
              Expanded(child: Text("持有：${data.curMoney}")),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "收益：$curIncome",
                      style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                  TextSpan(
                      text: " $curIncomeRateStr%",
                      style: TextStyle(color: curInComeColor)),
                ]),
              )),
              // Expanded(child: Text("当前收益：$curIncome  +35%")),
              Expanded(child: Text("累收：$totalIncome")),
            ],
          )
        ],
      ),
      onTap: () {
        showEditDialog(data: data);
      },
    );
  }

  void showEditDialog({Fund data}) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return EditDialog(
            dialog: _dialog,
            data: data ?? Fund(),
            updateSuccess: () {
              setState(() {
                _hasLoadData = false;
              });
              loadData();
            });
      },
    );
  }
}

class EditDialog extends StatefulWidget {
  final ProgressDialog dialog;
  final Fund data;
  final Function updateSuccess;

  EditDialog({Key key, this.dialog, this.data, this.updateSuccess})
      : super(key: key);

  @override
  _DialogState createState() => _DialogState();
}

class _DialogState extends State<EditDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _oriMoneyController = TextEditingController();
  TextEditingController _curMoneyController = TextEditingController();
  TextEditingController _existIncomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.data.name;
    _oriMoneyController.text = widget.data.oriMoney?.toString();
    _curMoneyController.text = widget.data.curMoney?.toString();
    _existIncomeController.text = widget.data.existIncome?.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "名称",
                  ),
                  validator: (value) {
                    return value.trim().length > 0 ? null : "不能为空";
                  },
                  onSaved: (newValue) {
                    setState(() {
                      widget.data.name = newValue;
                    });
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _oriMoneyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "投入金额",
                  ),
                  validator: (value) {
                    return value.trim().length > 0 ? null : "不能为空";
                  },
                  onSaved: (newValue) {
                    setState(() {
                      widget.data.oriMoney = int.parse(newValue);
                    });
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _curMoneyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "当前金额",
                  ),
                  validator: (value) {
                    return value.trim().length > 0 ? null : "不能为空";
                  },
                  onSaved: (newValue) {
                    setState(() {
                      widget.data.curMoney = int.parse(newValue);
                    });
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _existIncomeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "已提取收益",
                  ),
                  validator: (value) {
                    return value.trim().length > 0 ? null : "不能为空";
                  },
                  onSaved: (newValue) {
                    setState(() {
                      widget.data.existIncome = int.parse(newValue);
                    });
                  },
                ),
              ]),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("取消"),
          onPressed: () => Navigator.pop(context), // 关闭对话框
        ),
        FlatButton(
          child: Text(widget.data != null ? "修改" : "新增"),
          onPressed: () {
            updateData();
          },
        ),
      ],
    );
  }

  updateData() async {
    if (_formKey.currentState.validate()) {
      // 验证通过提交数据
      _formKey.currentState.save();

      widget.dialog.show();
      if (widget.data.id != null) {
        DataHelper.setData(
                DataHelper.COLLECTION_FUND, widget.data.id, widget.data)
            .then((value) => requestSuccess("修改"))
            .catchError((error) => requestError(error));
      } else {
        DataHelper.saveData(DataHelper.COLLECTION_FUND, widget.data)
            .then((value) => requestSuccess("新增"))
            .catchError((error) => requestError(error));
      }
    }
  }

  requestSuccess(String operation) {
    widget.dialog.hide();
    var msg = operation + "成功";
    Fluttertoast.showToast(msg: msg);
    Navigator.pop(context, true);

    widget.updateSuccess.call();
  }

  requestError(error) {
    widget.dialog.hide();
    var msg = "操作失败 " + error.toString();
    Fluttertoast.showToast(msg: msg);
  }
}
