
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/entity/RegularInvestment.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/utils/DateUtils.dart';
import 'package:flutter_todo/utils/StringUtils.dart';
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
    DataHelper.loadData(DataHelper.COLLECTION_INVESTMENT,
            orderField: "endDate", orderGrow: true)
        .then((value) {
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
      int totalMoney = 0;
      dynamic totalIncome = 0;
      for (RegularInvestment data in _dataList) {
        totalMoney += data.money;
        totalIncome += data.money * data.rate;
      }
      String totalRate = NumberFormat("0.00").format(totalIncome / totalMoney);

      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            margin: EdgeInsets.all(16),
            child: ListTile(
              title: Text("总投入：${StringUtils.formatMoney(totalMoney)} * "
                  "$totalRate% ~ "
                  "${(totalIncome ~/ 1200).toString()}/月"),
            ),
          ),
          Expanded(child: getListView()),
        ],
      );
      // return getListView();
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
          Text(data.name),
          Text("${StringUtils.formatMoney(data.money)} * "
              "${data.rate}% ~ "
              "${data.money * data.rate ~/ 1200}/月"),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${data.startDate ?? ""} 至 ${data.endDate ?? ""}"),
          Text("剩余：${DateUtils.calculateDayDiff(DateTime.now(),
              DateUtils.str2ymd(data.endDate))}天"),
        ],
      ),
      onTap: () {
        showEditDialog(invest: data);
      },
    );
  }

  void showEditDialog({RegularInvestment invest}) {
      showDialog<bool>(
        context: context,
        builder: (context) {
          return EditDialog(dialog: _dialog, invest: invest ?? RegularInvestment(),
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
  final RegularInvestment invest;
  final Function updateSuccess;
  EditDialog({Key key, this.dialog, this.invest, this.updateSuccess}) : super(key: key);

  @override
  _DialogState createState() => _DialogState();
}

class _DialogState extends State<EditDialog> {

  static const DATE_TYPE_START = 1;
  static const DATE_TYPE_END = 2;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _rateController = TextEditingController();
  TextEditingController _moneyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.invest.name;
    _rateController.text = widget.invest.rate?.toString();
    _moneyController.text = widget.invest.money?.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "理财产品名称",
                ),
                validator: (value) {
                  return value.trim().length > 0 ? null : "不能为空";
                },
                onSaved: (newValue) {
                  setState(() {
                    widget.invest.name = newValue;
                  });
                },
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _moneyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "投入金额",
                ),
                validator: (value) {
                  return value.trim().length > 0 ? null : "不能为空";
                },
                onSaved: (newValue) {
                  setState(() {
                    widget.invest.money = int.parse(newValue);
                  });
                },
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _rateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "费率 (%)",
                ),
                validator: (value) {
                  return value.trim().length > 0 ? null : "不能为空";
                },
                onSaved: (newValue) {
                  setState(() {
                    widget.invest.rate = double.parse(newValue);
                  });
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
                      widget.invest.startDate ?? "未填写",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
                onTap: () {
                  pickDate(DATE_TYPE_START);
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
                      "结束日期：",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(
                      widget.invest.endDate ?? "未填写",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
                onTap: () {
                  pickDate(DATE_TYPE_END);
                },
              ),
            ]),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("取消"),
          onPressed: () => Navigator.pop(context), // 关闭对话框
        ),
        FlatButton(
          child: Text(widget.invest != null ? "修改" : "新增"),
          onPressed: () {
            updateTodo();
          },
        ),
      ],
    );
  }

  pickDate(int dateType) async {
    var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if(date == null) return;
    var format = DateFormat("yyyy-MM-dd").format(date);
    setState(() {
      if (dateType == DATE_TYPE_START) {
        widget.invest.startDate = format;
      } else if (dateType == DATE_TYPE_END) {
        widget.invest.endDate = format;
      }
    });
  }

  updateTodo() async {
    if (_formKey.currentState.validate()) {
      // 验证通过提交数据
      _formKey.currentState.save();

      widget.dialog.show();
      if (widget.invest.id != null) {
        DataHelper.setData(DataHelper.COLLECTION_INVESTMENT, widget.invest.id, widget.invest)
            .then((value) => requestSuccess("修改"))
            .catchError((error) => requestError(error));
      } else {
        DataHelper.saveData(DataHelper.COLLECTION_INVESTMENT, widget.invest)
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
