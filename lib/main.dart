import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main()
{
  runApp(FetchDataFromAPI());
}
class FetchDataFromAPI extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {return FetchingDataState();}
}

class FetchingDataState extends State<FetchDataFromAPI>
{
  List<UserDetails> users=[];
  late Future usersData;
  Future fetchData() async
  {
    final http.Response httpResponse=await http.get(Uri.parse('https://reqres.in/api/users?page=1')); // same as final Future<http.Response> httpResponse=http.get(Uri.https("reqres.in", "api/users?page=1"));
    var jsonData;
    if(httpResponse.statusCode==200)
    {
      jsonData = jsonDecode(httpResponse.body);
      print('jsonData: $jsonData');//print(jsonData.runtimeType);
      var userData=jsonData['data'];//print(userData.runtimeType);
      for(var x in userData)
      {
        UserDetails particularUser=UserDetails(x['id'],x['email'],x['first_name'],x['last_name'],x['avatar']); //print(x);
        users.add(particularUser);
      }
    }
    else
      throw Exception('Failed to load');
    return users;
  }

  @override
  void initState()
  {
    super.initState();
    users.clear();
    usersData=fetchData();
  }

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetched Data From API'),
          centerTitle: true,
        ),
        body: Center(
          child: FutureBuilder(
            future: usersData,  //avoid future fxn calling here as it leading to reduandant data.
            builder:(context, snapshot)
            {
              if(snapshot.data==null)
                return Container(child: Center(child: Text('Loading..'),),);
              else
                return ListView.builder(
                  itemCount:users.length,
                  padding: const EdgeInsets.all(5.0),
                  itemBuilder: (context, index)
                {
                  return ListTile(
                      title: Text('${users[index].emailID}'),
                    subtitle: Text('${users[index].firstName}  ${users[index].lastName}'),
                    //trailing: Text('${users[index].avatar}'),
                  );
                },);
            },
          ),
        ),
      ),
    );
  }
}

class UserDetails
{
  int? userID;
  String? emailID,firstName,lastName,avatar;
  UserDetails(int? userID, String? emailID, String? firstName, String? lastName, String? avatar)
  {
    this.userID??=userID;
    this.emailID??=emailID;
    this.firstName??=firstName;
    this.lastName??=lastName;
    this.avatar??=avatar;
  }

}