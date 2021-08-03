import 'package:flutter/material.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/constants/fonts.dart';
import 'package:flutter_app/extentions/extentions.dart';
import 'package:flutter_app/models/jobs.dart';
import 'package:flutter_app/network/network_client.dart';
import 'package:flutter_app/utils/tool_bar_helper.dart';
import 'package:flutter_app/views/common/loading_dialog.dart';
import 'package:flutter_app/views/common/rounded_image.dart';
import 'package:easy_localization/easy_localization.dart';

class JobDetailsPage extends StatefulWidget {
  JobDetailsPage({Key key, @required this.job, this.isOpenFromEmployer = false})
      : super(key: key);
  Job job;
  bool isOpenFromEmployer = false;
  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  var headerText = TextStyle(fontFamily: KOFI_BOLD, fontSize: 13);
  var contentStyle = TextStyle(fontFamily: KOFI_REGULAR, fontSize: 13);
  bool isApplied;
  bool isAppliedStatusLoaded = false;

  @override
  void initState() {
    super.initState();
    checkIfApplied();
  }

  @override
  Widget build(BuildContext context) {
    var jobDetail = widget.job;
    return Scaffold(
      appBar: AppBar(
        title: ToolBarHelper.setToolbarTitle("job_details".tr()),
        actions: widget.isOpenFromEmployer
            ? [
                PopupMenuButton<String>(
                    onSelected: (String result) {
                      if (result == "2") {
                        deleteJob(jobDetail.sId);
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: "2",
                            child: Text(
                              'delete'.tr(),
                              style: TextStyle(fontFamily: KOFI_REGULAR),
                            ),
                          ),
                        ]),
              ]
            : [],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CustomNetworkImage(
                          width: 50,
                          hieght: 50,
                          isCircular: true,
                          imageUrl:
                              "https://cdn-a.william-reed.com/var/wrbm_gb_food_pharma/storage/images/publications/cosmetics/cosmeticsdesign-asia.com/article/2019/10/10/why-iso-standards-are-crucial-for-organic-and-natural-transparency-ctfas-president/10238025-1-eng-GB/Why-ISO-standards-are-crucial-for-organic-and-natural-transparency-CTFAS-president_wrbm_large.jpg"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(jobDetail.owner.fullName),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    height: 1,
                    decoration:
                        BoxDecoration(color: HexColor.fromHex("#cccccc")),
                  ),
                  Container(
                    child: Table(
                        columnWidths: <int, TableColumnWidth>{
                          0: IntrinsicColumnWidth(),
                          1: FlexColumnWidth(),
                          2: FixedColumnWidth(64),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.top,
                        children: <TableRow>[
                          TableRow(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  child: Text(
                                    "location".tr(),
                                    style: headerText,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  jobDetail.city,
                                  style: contentStyle,
                                ),
                              ),
                            ],
                          ),

                          TableRow(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  child: Text(
                                    "specialization".tr(),
                                    style: headerText,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  jobDetail.field
                                      .getSpecial(context.locale.languageCode),
                                  style: contentStyle,
                                ),
                              ),
                            ],
                          ),

                          TableRow(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  child: Text(
                                    "date".tr(),
                                    style: headerText,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  jobDetail.createdAt,
                                  style: contentStyle,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "desc".tr(),
                                    style: headerText,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  jobDetail.description,
                                  style: contentStyle,
                                ),
                              ),
                            ],
                          ),

                          // children: [
                        ]
                        //   // Text(""+job.description),
                        //   // Text(job.city),
                        //   // Text(job.field),
                        //   // Text(job.createdAt),
                        // ],
                        ),
                  ),
                  if (isAppliedStatusLoaded && !widget.isOpenFromEmployer)
                    Container(
                        margin: EdgeInsets.only(top: 14),
                        width: double.infinity,
                        child: Center(child: showApplyControls(jobDetail))),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }

  checkIfApplied() async {
    var response = await NetworkClient.getInstance().request(
        requestType: RequestType.GET, path: CHECK_IF_APPLIED + widget.job.sId);
    if (response.statusCode == 200) {
      setState(() {
        isApplied = response.body.parseBool();
        isAppliedStatusLoaded = true;
      });
    }
  }

  void applyForJob(String sId) async {
    DialogUtil.showLoadingDialog(context);
    var response = await NetworkClient.getInstance()
        .request(requestType: RequestType.POST, path: APPLY_FOR_JOB + sId);
    Navigator.pop(context);
    if (response.statusCode == 200) {
      setState(() {
        isApplied = true;
      });
    }
  }

  showApplyControls(Job jobDetail) {
    var textStyle = TextStyle(
        fontFamily: KOFI_REGULAR, fontSize: 12, color: Colors.green[600]);
    var applyTextStyle =
        TextStyle(fontFamily: KOFI_REGULAR, color: Colors.white);
    if (isApplied) {
      return Text("already_applied".tr(), style: textStyle);
    } else
      return MaterialButton(
        color: Theme.of(context).primaryColor,
        onPressed: () {
          applyForJob(jobDetail.sId);
        },
        child: Text("apply_for_job".tr(), style: applyTextStyle),
      );
  }

  deleteJob(String id) async {
    DialogUtil.showLoadingDialog(context);
    var response = await NetworkClient.getInstance().request(
        requestType: RequestType.DELETE, path: DELETE_POSTED_JOBS + id);

    Navigator.pop(context);
    if (response.statusCode == 200) {
      Navigator.pop(context, "reload");
    }
  }
}
