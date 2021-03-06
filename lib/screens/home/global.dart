import 'package:flutter/material.dart';
import 'package:smart_vaxx_card_client/models/global_summary.dart';
import 'package:smart_vaxx_card_client/services/covid_service.dart';

import 'global_loading.dart';
import 'global_statistics.dart';

CovidService covidService = CovidService();

class Global extends StatefulWidget {
  @override
  _GlobalState createState() => _GlobalState();
}

class _GlobalState extends State<Global> {
  late Future<GlobalSummaryModel> summary;

  @override
  void initState() {
    super.initState();
    summary = covidService.getGlobalSummary();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Global Corona Virus Cases',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      radius: 20.0,
                      onTap: () {
                        setState(() {
                          summary = covidService.getGlobalSummary();
                        });
                      },
                      child: Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: summary,
            builder: (context, AsyncSnapshot<GlobalSummaryModel> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: const Text('Error'),
                );
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return GlobalLoading();
                default:
                  return !snapshot.hasData
                      ? Center(
                          child: const Text('Empty'),
                        )
                      : GlobalStatistics(
                          summary: snapshot.data!,
                        );
              }
            },
          ),
        ],
      ),
    ]);
  }
}
