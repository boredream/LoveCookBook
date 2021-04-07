import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/entity/Target.dart';
import 'package:flutter_todo/entity/TargetItem.dart';
import 'package:flutter_todo/main.dart';

class TargetDetailPage extends StatefulWidget {
  TargetDetailPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TargetDetailPage> {
  Target _data;

  @override
  Widget build(BuildContext context) {
    if (_data == null) {
      Map args = ModalRoute.of(context).settings.arguments as Map;
      _data = args["data"];
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("目标详情"),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => toEditItemPage(null),
      ),
    );
  }

  _buildBody() {
    String nextReward = "无";
    int curProgress = 0;
    for(String reward in _data.rewardList ?? []) {
      String name = Target.getRewardName(reward);
      String progress = Target.getRewardProgress(reward);
      curProgress += int.parse(progress);
      if(curProgress > _data.getTotalProgress()) {
        nextReward = "[$progress%] $name";
        break;
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(),
                  Text("目标名称：${_data.name}"),
                  Text("总体进度：${_data.getTotalProgress()}%"),
                  Text("下个奖励：$nextReward"),
                ],
              )),
          onTap: () => toEditPage(),
        ),
        Expanded(child: getListView()),
      ],
    );
  }

  getListView() {
    // 计算每次进度增加时正好可新获得的奖励
    if (_data != null &&
        _data.rewardList != null &&
        _data.rewardList.length > 0 &&
        _data.items != null &&
        _data.items.length > 0) {

      // 先清空新增奖励信息
      for(TargetItem item in _data.items) {
        item.newReward = null;
      }

      int rewardIndex = 0;
      int targetItemIndex = _data.items.length - 1;
      int curTotalProgress = 0;
      for (; rewardIndex < _data.rewardList.length && targetItemIndex >= 0;) {
        // 获取奖励信息
        String reward = _data.rewardList[rewardIndex];
        String name = Target.getRewardName(reward);
        String progress = Target.getRewardProgress(reward);

        curTotalProgress += _data.items[targetItemIndex].progress;
        if (curTotalProgress > int.parse(progress)) {
          // 如果当前累计进度超过奖励所需，记录本次打卡新增奖励信息
          _data.items[targetItemIndex].newReward = name;
          // 判断下个奖励
          rewardIndex++;
        } else {
          // 当前累计进度不足
          targetItemIndex--;
        }
      }
    }
    return ListView.separated(
        itemBuilder: (context, index) => getRow(index),
        separatorBuilder: (context, _) => SizedBox(height: 8),
        itemCount: _data == null ? 0 : _data.items.length);
  }

  getRow(int index) {
    TargetItem data = _data.items[index];
    String titleInfo = "[${data.date}] ${data.title}";
    String progressInfo = "+ ${data.progress}%";
    if(data.newReward != null) {
      titleInfo += "\n奖励：${data.newReward}";
    }
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(titleInfo)),
              Text(progressInfo),
            ],
          )),
      onTap: () => toEditItemPage(data),
    );
  }

  void toEditPage() {
    MyRouteDelegate.of(context)
        .push("targetDetailEdit", arguments: {"data": _data});
  }

  void toEditItemPage(TargetItem data) {
    MyRouteDelegate.of(context)
        .push("targetItem", arguments: {"target": _data, "data": data});
  }
}
