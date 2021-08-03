import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/models/job_applicants.dart';
import 'package:flutter_app/network/network_client.dart';
import 'package:flutter_app/utils/tool_bar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/views/common/no_records_view.dart';
import 'package:flutter_app/views/common/rounded_image.dart';
import 'package:flutter_app/views/worker/user_profile.dart';

class JobApplicantsPage extends StatefulWidget {
  JobApplicantsPage({Key key, this.jobId}) : super(key: key);

  String jobId;
  @override
  _JobApplicantsPageState createState() => _JobApplicantsPageState();
}

class _JobApplicantsPageState extends State<JobApplicantsPage> {
  List<Applicant> applicants;

  @override
  void initState() {
    super.initState();

    getJobApplicants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: ToolBarHelper.setToolbarTitle("applicants".tr()),
        ),
        body: applicants == null
            ? Center(child: CircularProgressIndicator())
            : applicants.length > 0
                ? ListView.builder(
                    itemCount: applicants.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = applicants[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProfilePage(workerId: item.sId)),
                          );
                        },
                        child: Card(
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
                                      imageUrl: item.userPic),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(item.fullName),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                      );
                    })
                : Center(child: NoDataView(text: "no_record_found".tr())));
  }

  getJobApplicants() async {
    var response = await NetworkClient.getInstance().request(
        requestType: RequestType.GET, path: JOB_APPLICANTS + widget.jobId);

    if (response.statusCode == 200) {
      var list = JobApplicants.fromJson(jsonDecode(response.body));
      setState(() {
        applicants = list.data;
      });
    }
  }
}
