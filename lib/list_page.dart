import 'package:get/get.dart'
    show Get, GetNavigation, GetxController, Inst, Obx, RxInt;
import 'package:flutter/material.dart'
    show
        AlertDialog,
        AppBar,
        BuildContext,
        Center,
        ElevatedButton,
        FloatingActionButton,
        Icon,
        Icons,
        Scaffold,
        StatelessWidget,
        Text,
        ThemeMode,
        Widget,
        showDialog;
import 'package:notifier/main.dart';

class Controller extends GetxController {
  var count = RxInt(0);
  increment() => count++;
}

class ListPage extends StatelessWidget {
  @override
  Widget build(context) {
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final Controller c = Get.put(Controller());

    return Scaffold(
        // Use Obx(()=> to update Text() whenever count is changed.
        appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

        // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
        body: Center(
            child: ElevatedButton(
                child: const Text("Go to Other"),
                onPressed: () => Get.to(() => Other()))),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              toggleDarkMode();
            }));
  }
}

class Other extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  final Controller c = Get.find();

  @override
  Widget build(context) {
    // Access the updated count variable
    return Scaffold(body: Center(child: Text("${c.count}")));
  }
}
