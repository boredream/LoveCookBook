import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/entity/RegularInvest.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/utils/DateStrUtils.dart';
import 'package:flutter_todo/utils/DialogUtils.dart';
import 'package:flutter_todo/utils/StringUtils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RegularInvestPage extends StatefulWidget {
  RegularInvestPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<RegularInvestPage> {
  bool _hasLoadData = false;
  List<RegularInvest> _dataList = [];
  Map<String, int> _monthIncomeMap;
  ProgressDialog _dialog;

  @override
  void initState() {
    super.initState();
    _dialog = DialogUtils.getProgressDialog(context);
    loadData();
  }

  void loadData() {
    DataHelper.loadData(DataHelper.COLLECTION_REGULAR_INVEST,
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
            .map(
                (e) => RegularInvest.fromJson(new Map<String, dynamic>.from(e)))
            .toList();

        // 按到期时间分组
        _monthIncomeMap = Map();
        _dataList.forEach((element) {
          DateTime date = DateStrUtils.str2date(element.endDate);
          String dateStr = "${date.year}-${date.month}";
          int money = _monthIncomeMap[dateStr];
          if (money == null) {
            _monthIncomeMap[dateStr] = 0;
          }
          _monthIncomeMap[dateStr] += element.money;
        });
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
        title: Text("定期投资"),
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
      dynamic totalIncome = 0;
      for (RegularInvest data in _dataList) {
        totalOriMoney += data.money;
        double income = data.money * data.rate;
        totalIncome += income;

        int pastDays = DateStrUtils.calculateDayDiff(
            DateStrUtils.str2date(data.startDate), DateTime.now());
        int curIncome =
        pastDays <= 0 ? 0 : data.money * data.rate / 100 * pastDays ~/ 365;
        totalCurMoney += curIncome;
      }
      totalCurMoney += totalOriMoney;
      String totalRate =
      NumberFormat("0.00").format(totalIncome / totalOriMoney);

      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border:
                Border.all(color: Theme
                    .of(context)
                    .primaryColor, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(),
                Text("总投入：${StringUtils.formatMoney(totalOriMoney)} * "
                    "$totalRate% ~ "
                    "${(totalIncome ~/ 1200).toString()}/月"),
                Text("当前持有：${StringUtils.formatMoney(totalCurMoney)}"),
              ],
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

  _buildYearIncomeGrid() {
    PageController controller = PageController(
      initialPage: 0,
      keepPage: true,
    );

    // 看未来5年的现金流
    DateTime now = DateTime.now();
    List<Widget> yearGridList = [];
    for (int i = 0; i < 5; i++) {
      int year = now.year + i;
      yearGridList.add(Column(
        children: [
          Text("$year 年"),
          GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                String monthStr = (index + 1).toString();
                String date = "$year-$monthStr";
                Color color = Colors.blue[50];
                List<Widget> children = [
                  Text("$monthStr 月", style: TextStyle(fontSize: 12))
                ];
                int money = _monthIncomeMap[date];
                if (money != null) {
                  // 当月有金额，颜色也分梯度取
                  children.add(Text(StringUtils.formatMoney(money)));
                  if (money < 50000) {
                    color = Colors.blue[100];
                  } else if (money < 100000) {
                    color = Colors.blue[300];
                  } else {
                    color = Colors.blue[500];
                  }
                }

                return Container(
                  alignment: Alignment.center,
                  color: color,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
                );
              })
        ],
      ));
    }
    return SizedBox(
        height: 142,
        child: PageView(
          controller: controller,
          children: yearGridList,
        ));
  }

  getListView() {
    return ListView.separated(
        itemBuilder: (context, index) => getRow(index),
        separatorBuilder: (context, _) => Divider(height: 1),
        itemCount: _dataList.length + 1);
  }

  getRow(int index) {
    if (index == 0) {
      return _buildYearIncomeGrid();
    }

    index --;
    RegularInvest data = _dataList[index];

    int totalDays = DateStrUtils.calculateDayDiff(
        DateStrUtils.str2date(data.startDate),
        DateStrUtils.str2date(data.endDate));
    int pastDays = DateStrUtils.calculateDayDiff(
        DateStrUtils.str2date(data.startDate), DateTime.now());
    int monthIncome = data.money * data.rate ~/ 1200;
    int curIncome =
    pastDays <= 0 ? 0 : data.money * data.rate / 100 * pastDays ~/ 365;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(data.name),
          Text("${StringUtils.formatMoney(data.money)} * "
              "${data.rate}% ~ $monthIncome/月"),
        ],
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${data.startDate ?? ""} 至 ${data.endDate ?? ""}"),
              Text("剩余：${totalDays - pastDays}天"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$pastDays  /  $totalDays天"),
              Text("当前收益：$curIncome"),
            ],
          ),
        ],
      ),
      onTap: () => showEditDialog(invest: data),
      onLongPress: () => showDeleteDialog(data),
    );
  }

  void showDeleteDialog(RegularInvest invest) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text('提示'),
            content: Text('是否确认删除？'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('取消'),
              ),
              TextButton(
                onPressed: () => deleteData(invest),
                child: Text('删除'),
              ),
            ],
          ),
        );
      },
    );
  }

  deleteData(RegularInvest invest) async {
    _dialog.show();
    DataHelper.deleteData(DataHelper.COLLECTION_REGULAR_INVEST, invest.id)
        .then((value) => requestSuccess("删除"))
        .catchError((error) => requestError(error));
  }

  requestSuccess(String operation) {
    _dialog.hide();
    var msg = operation + "成功";
    Fluttertoast.showToast(msg: msg);
    Navigator.pop(context, true);

    setState(() {
      _hasLoadData = false;
    });
    loadData();
  }

  requestError(error) {
    _dialog.hide();
    var msg = "操作失败 " + error.toString();
    Fluttertoast.showToast(msg: msg);
  }

  void showEditDialog({RegularInvest invest}) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return EditDialog(
            dialog: _dialog,
            invest: invest ?? RegularInvest(),
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
  final RegularInvest invest;
  final Function updateSuccess;

  EditDialog({Key key, this.dialog, this.invest, this.updateSuccess})
      : super(key: key);

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
                    labelText: "理财产品名称",
                  ),
                  validator: (value) {
                    return value
                        .trim()
                        .length > 0 ? null : "不能为空";
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
                    return value
                        .trim()
                        .length > 0 ? null : "不能为空";
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: "费率 (%)",
                  ),
                  validator: (value) {
                    return value
                        .trim()
                        .length > 0 ? null : "不能为空";
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
                        style: Theme
                            .of(context)
                            .textTheme
                            .subtitle1,
                      ),
                      Text(
                        widget.invest.startDate ?? "未填写",
                        style: Theme
                            .of(context)
                            .textTheme
                            .subtitle1,
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
                        style: Theme
                            .of(context)
                            .textTheme
                            .subtitle1,
                      ),
                      Text(
                        widget.invest.endDate ?? "未填写",
                        style: Theme
                            .of(context)
                            .textTheme
                            .subtitle1,
                      ),
                    ],
                  ),
                  onTap: () {
                    pickDate(DATE_TYPE_END);
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
          child: Text(widget.invest != null ? "修改" : "新增"),
          onPressed: () {
            updateData();
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
    if (date == null) return;
    var format = DateFormat("yyyy-MM-dd").format(date);
    setState(() {
      if (dateType == DATE_TYPE_START) {
        widget.invest.startDate = format;
      } else if (dateType == DATE_TYPE_END) {
        widget.invest.endDate = format;
      }
    });
  }

  updateData() async {
    if (_formKey.currentState.validate()) {
      // 验证通过提交数据
      _formKey.currentState.save();

      widget.dialog.show();
      if (widget.invest.id != null) {
        DataHelper.setData(DataHelper.COLLECTION_REGULAR_INVEST,
            widget.invest.id, widget.invest)
            .then((value) => requestSuccess("修改"))
            .catchError((error) => requestError(error));
      } else {
        DataHelper.saveData(DataHelper.COLLECTION_REGULAR_INVEST, widget.invest)
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
