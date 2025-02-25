import 'package:flutter/material.dart';
import 'package:trakref_app/main.dart';
import 'package:trakref_app/models/workorder.dart';

enum HomeCellType {
  StickerTODO,
  StickerCOMPLETE,
  StickerCLOSED,
  StickerCYLINDER,
  Normal
}

class ServiceEventCellWidget extends StatelessWidget {
  WorkOrder order;
  ServiceEventCellWidget({this.order});

  @override
  Widget build(BuildContext context) {
    if (order.workOrderStatusID == 1) {
      return HomeCellWidget(
          line1: '${order.workOrderNumber} (${order.workItemCount})',
          line2: '${order.location}',
          line3: '${order.instance}',
          line4: 'TO DO',
          cellType: HomeCellType.StickerTODO);
    } else if (order.workOrderStatusID == 2) {
      return HomeCellWidget(
          line1: '${order.workOrderNumber} (${order.workItemCount})',
          line2: '${order.location}',
          line3: '${order.instance}',
          line4: 'COMPLETE',
          cellType: HomeCellType.StickerCOMPLETE);
    } else if (order.workOrderStatusID == 3) {
      return HomeCellWidget(
          line1: '${order.workOrderNumber} (${order.workItemCount})',
          line2: '${order.location}',
          line3: '${order.instance}',
          line4: 'CLOSED',
          cellType: HomeCellType.StickerCLOSED);
    }
    return Container();
  }
}

class HomeCellWidget extends ListTile {
  final String line1;
  final String line2;
  final String line3;
  final String line4;

  final HomeCellType cellType;

  HomeCellWidget(
      {this.line1, this.line2, this.line3, this.line4, this.cellType});

  Color getBadgeColor(HomeCellType type) {
    switch (type) {
      case HomeCellType.Normal:
        return null;
      case HomeCellType.StickerCOMPLETE:
        return Colors.orange;
      case HomeCellType.StickerTODO:
        return AppColors.lightGreen;
      case HomeCellType.StickerCYLINDER:
        return AppColors.blueTurquoise;
      case HomeCellType.StickerCLOSED:
        return Colors.redAccent;
        break;
    }
  }

  String getBadgeText(HomeCellType type) {
    switch (type) {
      case HomeCellType.Normal:
        return "";
      case HomeCellType.StickerCOMPLETE:
        return "COMPLETED";
      case HomeCellType.StickerTODO:
        return "TO DO";
      case HomeCellType.StickerCYLINDER:
        return "CYLINDER";
      case HomeCellType.StickerCLOSED:
        return "CLOSED";
        break;
    }
  }

  Widget buildLine(String text, TextStyle style) {
    TextStyle styleIfClosed = (this.cellType == HomeCellType.StickerCLOSED)
                      ? style.copyWith(color: Colors.blueGrey) : style;

    return Row(children: <Widget>[
      new Text(
        text ?? "",
        style: styleIfClosed,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // Create the badge if it's necessary
    Widget badgeWidget = Visibility(
        visible: (this.cellType == HomeCellType.StickerTODO ||
            this.cellType == HomeCellType.StickerCYLINDER ||
            this.cellType == HomeCellType.StickerCOMPLETE ||
            this.cellType == HomeCellType.StickerCLOSED),
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: getBadgeColor(cellType)
              // UIColor(red:0.55, green:0.86, blue:0.33, alpha:1)
              ),
          child: Center(
            child: Text(
              getBadgeText(cellType),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontFamily: "SF Pro Text Regular"),
            ),
          ),
        ));

    return Container(
      width: 150.0,
      padding: new EdgeInsets.fromLTRB(20, 10, 20, 10),
//      decoration: BoxDecoration(
//          border: new Border(
//              bottom: new BorderSide(
//                  color: AppColors.lightGray,
//                  width: 0.3
//              )
//          )
//      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: new EdgeInsets.only(
            top: 6,
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(line1,
                  style: (this.cellType == HomeCellType.StickerCLOSED)
                      ? Theme.of(context)
                          .textTheme
                          .display1
                          .copyWith(color: Colors.blueGrey)
                      : Theme.of(context).textTheme.display1),
              Spacer(),
              badgeWidget,
            ],
          ),
          buildLine(line2, Theme.of(context).textTheme.display2),
          SizedBox(height: 6),
          buildLine(line3, Theme.of(context).textTheme.display3),
          SizedBox(height: 6),
          buildLine(line4, Theme.of(context).textTheme.display4),
          Divider()
        ],
      ),
    );
  }
}
