import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/constants/fonts.dart';
import 'package:flutter_app/extentions/extentions.dart';
import 'package:flutter_app/models/jobs.dart';
import 'package:flutter_app/utils/PrefrenceUtil.dart';
import 'package:flutter_app/views/common/rounded_image.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';

class PostedJobs extends StatefulWidget {
  PostedJobs({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  String title;

  @override
  _PostedJobsState createState() => _PostedJobsState();
}

class _PostedJobsState extends State<PostedJobs> {
  List<Job> jobs;
  String lang;
  @override
  void initState() {
    super.initState();
    getPostedJobs();
  }

  @override
  Widget build(BuildContext context) {
    lang = context.locale.languageCode;

    return jobs == null ? showLoader() : showList();
  }

  getPostedJobs() async {
    var user = await PrefrenceUtil.getUser();
    final response = await http.get(Uri.https(BASE_URL, POSTED_JOBS),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": user.token
        });

    if (response.statusCode == 200) {
      var jobs = Jobs.fromJson(jsonDecode(response.body));
      if (mounted) {
        setState(() {
          this.jobs = jobs.data;
        });
      }
    }
  }

  showList() {
    var headerText = TextStyle(fontFamily: KOFI_BOLD, fontSize: 13);
    var contentStyle = TextStyle(fontFamily: KOFI_REGULAR, fontSize: 13);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.builder(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            var job = jobs[index];
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                            imageUrl:
                                "https://cdn-a.william-reed.com/var/wrbm_gb_food_pharma/storage/images/publications/cosmetics/cosmeticsdesign-asia.com/article/2019/10/10/why-iso-standards-are-crucial-for-organic-and-natural-transparency-ctfas-president/10238025-1-eng-GB/Why-ISO-standards-are-crucial-for-organic-and-natural-transparency-CTFAS-president_wrbm_large.jpg"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(job.owner.fullName),
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
                              TableCellVerticalAlignment.middle,
                          children: <TableRow>[
                            TableRow(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    child: Text(
                                      "desc".tr(),
                                      style: headerText,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    job.description,
                                    softWrap: false,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                                      "location".tr(),
                                      style: headerText,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    job.city,
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
                                    job.field.getSpecial(lang),
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
                                    job.createdAt,
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
                  ],
                ),
              )),
            );
          }),
    );
  }

  showLoader() {
    return CircularProgressIndicator();
  }
}
