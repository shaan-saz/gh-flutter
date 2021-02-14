/*
 * Copyright (c) 2020 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

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
