import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/constants/fonts.dart';
import 'package:flutter_app/extentions/extentions.dart';
import 'package:flutter_app/models/jobs.dart';
import 'package:flutter_app/models/profile.dart';
import 'package:flutter_app/models/work_fields.dart';
import 'package:flutter_app/models/workers.dart';
import 'package:flutter_app/network/network_client.dart';
import 'package:flutter_app/views/common/job_details_view.dart';
import 'package:flutter_app/views/common/no_records_view.dart';
import 'package:flutter_app/views/common/rounded_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/views/worker/user_profile.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchWorkers extends StatefulWidget {
  SearchWorkers({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  String title;

  @override
  _SearchWorkersState createState() => _SearchWorkersState();
}

class _SearchWorkersState extends State<SearchWorkers> {
  List<Worker> workers;
  List<WorkField> workFields;
  String lang;
  String sortBy;
  static const _pageSize = 10;
  String workFieldId;
  String workFieldName;

  final _pagingController = PagingController<int, Worker>(
    // 2
    firstPageKey: 1,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      getWorkers(pageKey);
    });
    getWorkers(1);
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
    return workers == null
        ? showLoader()
        : Container(
            child: Column(children: [
              Row(
                children: [
                  Row(
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
                  ),
                ],
              ),
              Expanded(child: showList())
            ]),
          );
  }

  getWorkers(int pageNumber) async {
    var queryParameters = {
      'page': '$pageNumber',
    };

    if (workFieldId != null) {
      queryParameters["workFields"] = workFieldId;
    }

    var response = await NetworkClient.getInstance().request(
        requestType: RequestType.GET,
        path: SEARCH_WORKER,
        parameter: queryParameters);

    if (response.statusCode == 200) {
      var workers = Workers.fromJson(jsonDecode(response.body));
      final isLastPage = workers.data.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(workers.data);
      } else {
        final nextPageKey = pageNumber + 1;
        _pagingController.appendPage(workers.data, nextPageKey);
      }

      if (mounted) {
        setState(() {
          this.workers = workers.data;
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
                      Container(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("cancel".tr()),
                        ),
                      ),
                    ],
                  ),
                );
              }));
        });
  }

  showList() {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView<int, Worker>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Worker>(
              itemBuilder: (context, item, index) => Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: GestureDetector(
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
                  )),
              noItemsFoundIndicatorBuilder: (BuildContext context) {
                return NoDataView(text: "no_record_found".tr());
              })),
    );
  }

  showLoader() {
    return Center(child: CircularProgressIndicator());
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
