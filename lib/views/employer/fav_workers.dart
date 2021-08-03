import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/eventbus/reload_fav_event.dart';
import 'package:flutter_app/models/favorite_list.dart';
import 'package:flutter_app/network/network_client.dart';
import 'package:flutter_app/views/common/loading_dialog.dart';
import 'package:flutter_app/views/common/no_records_view.dart';
import 'package:flutter_app/views/common/rounded_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class FavWorkersPage extends StatefulWidget {
  FavWorkersPage({Key key}) : super(key: key);

  @override
  _FavWorkersPageState createState() => _FavWorkersPageState();
}

class _FavWorkersPageState extends State<FavWorkersPage> {
  List<Favorite> favList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavWorkers();

    eventBus.on<ReloadFavEvent>().listen((ReloadFavEvent event) {
      getFavWorkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: favList == null
            ? Center(child: CircularProgressIndicator())
            : renderFavUsers());
  }

  renderFavUsers() {
    return favList.length > 0
        ? ListView.builder(
            itemCount: favList.length,
            itemBuilder: (BuildContext context, int index) {
              var item = favList[index];
              return Card(
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item.fullName),
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            onPressed: () {
                              unFavWorker(item.sId);
                            })
                      ],
                    ),
                  ],
                ),
              ));
            })
        : Center(child: NoDataView(text: "no_record_found".tr()));
  }

  getFavWorkers() async {
    var response = await NetworkClient.getInstance()
        .request(requestType: RequestType.GET, path: GET_FAVORITES);
    if (response.statusCode == 200) {
      var result = FavoriteList.fromJson(jsonDecode(response.body));
      setState(() {
        favList = result.favorites;
      });
    }
  }

  unFavWorker(String workerId) async {
    DialogUtil.showLoadingDialog(context);
    var response = await NetworkClient.getInstance().request(
        requestType: RequestType.DELETE, path: UNFAVORITE_USER + workerId);
    Navigator.pop(context);
    if (response.statusCode == 200) {
      getFavWorkers();
    }
  }
}
