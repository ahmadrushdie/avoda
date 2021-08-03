import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/constants/fonts.dart';
import 'package:flutter_app/extentions/extentions.dart';
import 'package:flutter_app/models/job_applicants.dart';
import 'package:flutter_app/models/jobs.dart';
import 'package:flutter_app/network/network_client.dart';
import 'package:flutter_app/views/common/job_details_view.dart';
import 'package:flutter_app/views/common/no_records_view.dart';
import 'package:flutter_app/views/common/rounded_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/views/employer/add_job_view.dart';

import 'job_applicatns_view.dart';

class EmployerJobsPage extends StatefulWidget {
  EmployerJobsPage({Key key}) : super(key: key);

  @override
  _EmployerJobsPageState createState() => _EmployerJobsPageState();
}

class _EmployerJobsPageState extends State<EmployerJobsPage> {
  List<Job> jobs;
  var headerText = TextStyle(fontFamily: KOFI_BOLD, fontSize: 13);
  var contentStyle = TextStyle(fontFamily: KOFI_REGULAR, fontSize: 13);

  @override
  void initState() {
    getMyJobs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: renderUI(),
      floatingActionButton: Container(
        margin: EdgeInsets.only(right: 30),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
              onPressed: () {
                openAddNewJob();
              },
              child: const Icon(Icons.add),
              backgroundColor: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  renderButtons(Job item) {
    const buttonTextStyle =
        TextStyle(color: Colors.white, fontFamily: KOFI_REGULAR);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: MaterialButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                openApplicats(item);
              },
              child: Text("applicatnts".tr(), style: buttonTextStyle),
            ),
          ),
          Container(
            width: 10,
          ),
          Expanded(
            child: MaterialButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                openDetailsScreen(item);
              },
              child: Text(
                "view_add".tr(),
                style: buttonTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }

  renderUI() {
    return jobs != null
        ? jobs.length == 0
            ? NoDataView(text: "no_record_found".tr())
            : RefreshIndicator(
                onRefresh: () {
                  return getMyJobs();
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: jobs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = jobs[index];
                    return Container(
                      child: GestureDetector(
                        onTap: () {
                          openDetailsScreen(item);
                        },
                        child: Card(
                            margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CustomNetworkImage(
                                          width: 50,
                                          hieght: 50,
                                          isCircular: true,
                                          imageUrl: item.owner.userPic),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(item.owner.fullName),
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    height: 1,
                                    decoration: BoxDecoration(
                                        color: HexColor.fromHex("#cccccc")),
                                  ),
                                  Container(
                                    child: Table(
                                        columnWidths: <int, TableColumnWidth>{
                                          0: IntrinsicColumnWidth(),
                                          1: FlexColumnWidth(),
                                          2: FixedColumnWidth(64),
                                        },
                                        defaultVerticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        children: <TableRow>[
                                          TableRow(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Container(
                                                  child: Text(
                                                    "location".tr(),
                                                    style: headerText,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  item.city,
                                                  style: contentStyle,
                                                ),
                                              ),
                                            ],
                                          ),

                                          TableRow(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Container(
                                                  child: Text(
                                                    "specialization".tr(),
                                                    style: headerText,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  item.field.getSpecial(context
                                                      .locale.languageCode),
                                                  style: contentStyle,
                                                ),
                                              ),
                                            ],
                                          ),

                                          TableRow(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Container(
                                                  child: Text(
                                                    "date".tr(),
                                                    style: headerText,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  item.createdAt,
                                                  style: contentStyle,
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Container(
                                                  child: Text(
                                                    "desc".tr(),
                                                    style: headerText,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  item.description,
                                                  softWrap: false,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                  renderButtons(item)
                                ],
                              ),
                            )),
                      ),
                    );
                  },
                ),
              )
        : Center(child: CircularProgressIndicator());
  }

  Future<String> getMyJobs() async {
    var response = await NetworkClient.getInstance()
        .request(requestType: RequestType.GET, path: GET_MY_POSTED_JOBS);

    if (response.statusCode == 200) {
      var list = Jobs.fromJson(jsonDecode(response.body));
      setState(() {
        jobs = list.data;
      });
    }
    return "test";
  }

  openDetailsScreen(Job item) async {
    var response = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => JobDetailsPage(
                job: item,
                isOpenFromEmployer: true,
              )),
    );

    if (response == "reload") {
      getMyJobs();
    }
  }

  openApplicats(Job item) async {
    var response = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => JobApplicantsPage(jobId: item.sId)),
    );

    if (response == "reload") {
      getMyJobs();
    }
  }

  openAddNewJob() async {
    var response = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddJobPage()),
    );

    if (response == "reload") {
      getMyJobs();
    }
  }
}
