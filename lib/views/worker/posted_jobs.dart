import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/constants/fonts.dart';
import 'package:flutter_app/extentions/extentions.dart';
import 'package:flutter_app/models/jobs.dart';
import 'package:flutter_app/models/work_fields.dart';
import 'package:flutter_app/network/network_client.dart';
import 'package:flutter_app/views/common/job_details_view.dart';
import 'package:flutter_app/views/common/no_records_view.dart';
import 'package:flutter_app/views/common/rounded_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
  List<WorkField> workFields;
  String lang;
  String sortBy;
  static const _pageSize = 10;
  String workFieldId;
  String workFieldName;

  final _pagingController = PagingController<int, Job>(
    // 2
    firstPageKey: 0,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      getPostedJobs(_pageSize, pageKey);
    });
    getPostedJobs(_pageSize, 0);
    getWorkingFields();
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lang = context.locale.languageCode;
    var filtersTextStyle =
        TextStyle(fontFamily: KOFI_BOLD, fontSize: 13, color: Colors.blue);
    return jobs == null
        ? showLoader()
        : SafeArea(
            child: Column(children: [
            Row(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    IconButton(
                        icon: Icon(
                            workFieldName != null
                                ? Icons.close
                                : Icons.filter_alt,
                            color: Colors.blue),
                        onPressed: () {
                          if (workFieldName != null) {
                            setState(() {
                              workFieldId = null;
                              workFieldName = null;
                              removeSelection(workFields);
                              _pagingController.refresh();
                            });
                          } else {
                            showWokingFieldFilter(workFields);
                          }
                        }),
                    GestureDetector(
                      onTap: () {
                        showWokingFieldFilter(workFields);
                      },
                      child: Text(
                          workFieldName != null
                              ? workFieldName
                              : "filter_by".tr(),
                          style: filtersTextStyle),
                    ),
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: PopupMenuButton<String>(
                      child: Expanded(
                          child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Icon(Icons.sort, color: Colors.blue),
                          ),
                          Text(
                              workFieldName != null
                                  ? workFieldName
                                  : "sort_by".tr(),
                              style: filtersTextStyle),
                        ],
                      )),
                      onSelected: (String result) {
                        setState(() {
                          sortBy = result;
                          _pagingController.refresh();
                        });
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: "-refeN,-lastLogin",
                              child: Text(
                                'recomendation_count'.tr(),
                                style: TextStyle(fontFamily: KOFI_REGULAR),
                              ),
                            ),
                            PopupMenuItem<String>(
                                value: "-lastLogin,-refeN",
                                child: Text(
                                  'last_appear'.tr(),
                                  style: TextStyle(fontFamily: KOFI_REGULAR),
                                ))
                          ]),
                ),
              ],
            ),
            Expanded(child: showList())
          ]));
  }

  getPostedJobs(int limit, int pageNumber) async {
    var queryParameters = {
      'limit': '$_pageSize',
      'page': '$pageNumber',
    };
    if (sortBy != null) {
      queryParameters['sort'] = sortBy;
    } else {
      queryParameters['sort'] = "-refeN,-lastLogin";
    }
    if (workFieldId != null) {
      queryParameters["filed"] = workFieldId;
    }

    var response = await NetworkClient.getInstance().request(
        requestType: RequestType.GET,
        path: POSTED_JOBS,
        parameter: queryParameters);

    if (response.statusCode == 200) {
      var jobs = Jobs.fromJson(jsonDecode(response.body));
      final isLastPage = jobs.data.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(jobs.data);
      } else {
        final nextPageKey = pageNumber + 1;
        _pagingController.appendPage(jobs.data, nextPageKey);
      }

      if (mounted) {
        setState(() {
          this.jobs = jobs.data;
        });
      }
    }
  }

  getWorkingFields() async {
    var response = await NetworkClient.getInstance()
        .request(requestType: RequestType.GET, path: GET_WORKING_FIELDS);

    if (response.statusCode == 200) {
      var workFieldsModel = WorkFields.fromJson(jsonDecode(response.body));
      if (workFieldsModel != null) {
        workFieldsModel.data.forEach((element) {
          if (element.sId == workFieldId) {
            element.isChecked = true;
          }
        });
        setState(() {
          this.workFields = workFieldsModel.data;
        });
      }
    }
  }

  showWokingFieldFilter(List<WorkField> list) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.zero,
              title: Text('specialization'.tr(),
                  style: TextStyle(fontFamily: KOFI_REGULAR)),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Container(
                  // Change as per your requirement
                  width: 300.0, // Change as per your requirement
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                right: 23.0, top: 8, bottom: 8),
                            child: Column(
                              children: [
                                Row(children: [
                                  GestureDetector(
                                    onTap: () {
                                      makeSelection(list, index);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                        list[index].getFieldName(
                                            context.locale.languageCode),
                                        style: TextStyle(
                                            fontFamily: KOFI_REGULAR,
                                            color: list[index].isChecked
                                                ? Theme.of(context).primaryColor
                                                : Colors.black,
                                            fontSize: 15)),
                                  )
                                ]),
                              ],
                            ),
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 1.5,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.grey.shade100),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("cancel".tr()),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }));
        });
  }

  showList() {
    var headerText = TextStyle(fontFamily: KOFI_BOLD, fontSize: 13);
    var contentStyle = TextStyle(fontFamily: KOFI_REGULAR, fontSize: 13);
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView<int, Job>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Job>(
              itemBuilder: (context, item, index) => Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JobDetailsPage(
                                  job: item,
                                )),
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
                                  imageUrl:
                                      "https://cdn-a.william-reed.com/var/wrbm_gb_food_pharma/storage/images/publications/cosmetics/cosmeticsdesign-asia.com/article/2019/10/10/why-iso-standards-are-crucial-for-organic-and-natural-transparency-ctfas-president/10238025-1-eng-GB/Why-ISO-standards-are-crucial-for-organic-and-natural-transparency-CTFAS-president_wrbm_large.jpg"),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(item.owner.fullName),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
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
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
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
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          child: Text(
                                            "specialization".tr(),
                                            style: headerText,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          item.field.getSpecial(lang),
                                          style: contentStyle,
                                        ),
                                      ),
                                    ],
                                  ),

                                  TableRow(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
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
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
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
                                          overflow: TextOverflow.ellipsis,
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
                  )),
              noItemsFoundIndicatorBuilder: (BuildContext context) {
                return NoDataView(text: "no_record_found".tr());
              })),
    );
  }

  showLoader() {
    return CircularProgressIndicator();
  }

  void removeSelection(List<WorkField> list) {
    var checked = list.where((element) => element.isChecked).toList();
    if (checked != null) {
      checked.forEach((element) {
        element.isChecked = false;
      });
    }
  }

  void makeSelection(List<WorkField> list, int index) {
    var checked = list.where((element) => element.isChecked).toList();
    if (checked != null) {
      checked.forEach((element) {
        element.isChecked = false;
      });
    }
    workFieldId = list[index].sId;
    setState(() {
      workFieldName = list[index].getFieldName(context.locale.languageCode);
    });
    list[index].isChecked = true;

    _pagingController.refresh();
  }
}
