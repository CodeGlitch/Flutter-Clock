// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double timeFontSize = MediaQuery.of(context).size.width / 4;
    final double textFontSize = timeFontSize / 6;
    return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Time(
                fontSize: timeFontSize,
                time: _dateTime,
              ),
              Date(
                fontSize: textFontSize,
                time: _dateTime,
              ),
            ],
          ),
        ));
  }
}

class Time extends StatelessWidget {
  final double fontSize;
  final DateTime time;
  Time({Key key, @required this.fontSize, @required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat('HH:mm').format(time),
      style: TextStyle(
        color: Colors.blueAccent,
        fontSize: fontSize,
        fontWeight: FontWeight.w300,
        decoration: TextDecoration.none,
        shadows: [
          Shadow(offset: Offset(-2, -2), color: Colors.grey[50]),
          Shadow(offset: Offset(2, -2), color: Colors.grey[50]),
          Shadow(offset: Offset(2, 2), color: Colors.grey[50]),
          Shadow(offset: Offset(-2, 2), color: Colors.grey[50]),
        ],
      ),
    );
  }
}

class Date extends StatelessWidget {
  final double fontSize;
  final DateTime time;
  Date({Key key, @required this.fontSize, @required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat('E, d LLL y').format(time),
      style: TextStyle(
        color: Colors.blueAccent,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        decoration: TextDecoration.none,
      ),
    );
  }
}
