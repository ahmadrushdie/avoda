import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FavouriteJobs extends StatefulWidget {
  FavouriteJobs() : super();

  @override
  FavouriteJobsState createState() => FavouriteJobsState();
}

class FavouriteJobsState extends State<FavouriteJobs> {
  List<String> names = [
    "Ahmad Nasser",
    "Qusi Tamer",
    "Rami Jamal",
    "Test Name",
    "Ahmad Nasser",
    "Qusi Tamer",
    "Rami Jamal",
    "Test Name",
    "Ahmad Nasser",
    "Qusi Tamer",
    "Rami Jamal",
    "Test Name",
    "Ahmad Nasser",
    "Qusi Tamer",
    "Rami Jamal",
    "Test Name"
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return Card(
              child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(
                      left: 10.0, right: 20.0, top: 10, bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100 / 2),
                    child: FadeInImage(
                      width: 80,
                      height: 80,
                      placeholder: AssetImage('assets/images/place-holder.png'),
                      image: NetworkImage(
                          "https://cdn.shopify.com/s/files/1/1788/4235/files/PPF-BlogUpdate-Thumbs_0041_42_Cat-Stages.jpg"),
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          names[index],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )),
                    Text("Builder", style: TextStyle(fontSize: 12)),
                    Text("Nablus, Palestine", style: TextStyle(fontSize: 12)),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          Icons.thumb_up_outlined,
                          size: 15,
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text('(10)',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(Icons.delete_outline),
                  color: Colors.black26,
                  tooltip: 'Delete Item',
                  onPressed: () {
                    setState(() {});
                  },
                ),
              )
            ],
          ));
        });
  }
}
