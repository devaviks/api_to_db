import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../providers/db_provider.dart';
import '../providers/product_api_provider.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api to sqlite'),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.settings_input_antenna),
              onPressed: () async {
                await _loadFromApi();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await _deleteData();
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _buildEmployeeListView(),
    );
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = ProductApiProvider();
    await apiProvider.getAllProducts();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllProducts();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    print('All products deleted');
  }

  _buildEmployeeListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllProducts(),
      builder: (context, data) {
        if (data.hasError) {
          return Center(child: Text("${data.error}"));
        } else if (data.hasData) {
          var items = data.data as List<Products>;
          return ListView.builder(
              itemCount: items == null ? 0 : items.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Image(
                                image: NetworkImage(
                                    items[index].thumbnail!),
                                fit: BoxFit.fill,
                              ),
                            ),
                            Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: Text(
                                          items[index].title.toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: Text(items[index]
                                            .description
                                            .toString()),
                                      )
                                    ],
                                  ),
                                )),
                          ],
                        ),

                      ],
                    ),
                  ),
                );
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
