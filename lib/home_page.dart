import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app_with_api/model/team.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final List<Team> teams = [];
  Future<void> getTeams() async {
    var response =
        await http.get(Uri.parse("https://www.balldontlie.io/api/v1/teams"));
    print(response.body);
    var jsonData = jsonDecode(response.body);

    for (var eachTeam in jsonData["data"]) {
      final team =
          Team(abbreviation: eachTeam['abbreviation'], city: eachTeam["city"]);
      teams.add(team);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
          future: getTeams(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(
                          teams[index].abbreviation,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(teams[index].city),
                      ),
                    ),
                  );
                },
              );
            } else {
              // Return a loading indicator or any other widget while waiting for data
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
