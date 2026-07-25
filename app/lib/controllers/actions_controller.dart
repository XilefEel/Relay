import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../widgets/action_button.dart';

class ActionsController extends ChangeNotifier {
  final String serverIp;

  ActionsController({required this.serverIp}) {
    fetchActions();
  }

  List<ActionButtonData> actions = [];
  String? runningActionId;

  Future<void> fetchActions() async {
    try {
      final response = await http.get(
        Uri.parse('http://$serverIp:3000/api/actions'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        actions = data.map((e) => ActionButtonData.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      // actions are non-critical; fail silently for now
    }
  }

  Future<void> runAction(String id) async {
    runningActionId = id;
    notifyListeners();
    try {
      await http.post(Uri.parse('http://$serverIp:3000/api/actions/$id'));
    } catch (e) {
      // could surface an error later
    } finally {
      runningActionId = null;
      notifyListeners();
    }
  }
}
