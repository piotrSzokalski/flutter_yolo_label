import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class GlobalState {
  static final List<String> _classNames = [];

  static final List<String> _records = [];

  static int _recordsIndex = 0;

  static List<Offset> _lastPoints = [];

  static List<String> getClassNames() => List.unmodifiable(_classNames);

  static void addClassName(String name) => _classNames.add(name);

  static List<String> getRecords() => List.unmodifiable(_records);

  static void addRecord(int category) => _records.add(
      '$category ${_lastPoints[0].dx} ${_lastPoints[0].dy} ${_lastPoints[1].dx - _lastPoints[0].dx}  ${_lastPoints[1].dy - _lastPoints[0].dy}\n');

  static void addRecordBoundaries(Offset p1, Offset p2) =>
      _lastPoints = [p1, p2];

  static Uint8List generateBoundingBoxesFile() {
    return Uint8List.fromList(utf8.encode(_records
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(', ', '')));
  }

  static Uint8List generateClassNamesFile() {
    var content = GlobalState.getClassNames()
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(',', '')
        .replaceAll(' ', '\n');
    return Uint8List.fromList(utf8.encode(content));
  }

  static void clearRecords() {
    _records.clear();
    _recordsIndex = 0;
    _lastPoints.clear();
  }
}
