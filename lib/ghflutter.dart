import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants/strings.dart';
import 'models/member.dart';

class GHFlutter extends StatefulWidget {
  @override
  _GHFlutterState createState() => _GHFlutterState();
}

class _GHFlutterState extends State<GHFlutter> {
  final _members = <Member>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appTitle),
      ),
      body: ListView.separated(
        itemCount: _members.length,
        itemBuilder: (context, position) {
          return _buildRow(position);
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }

  Widget _buildRow(int i) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        title: Text(
          '${_members[i].login}',
          style: _biggerFont,
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          backgroundImage: NetworkImage(
            _members[i].avatarUrl,
          ),
        ),
      ),
    );
  }

  void _loadData() async {
    const dataURL = 'https://api.github.com/orgs/raywenderlich/members';
    final response = await http.get(dataURL);
    final membersJSON = json.decode(response.body);
    for (final memberJSON in membersJSON) {
      final member = Member(
        login: memberJSON['login'],
        avatarUrl: memberJSON['avatar_url'],
      );
      setState(
        () {
          _members.add(member);
        },
      );
    }
  }
}
