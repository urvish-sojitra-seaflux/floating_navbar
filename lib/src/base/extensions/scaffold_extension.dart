import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/base/utils/constants/color_constant.dart';

extension ScaffoldExtension on Widget {
  Scaffold authContainerScaffold({required BuildContext context}) {
    return Scaffold(
      body: SafeArea(
        child: this,
      ),
    );
  }

  Scaffold homeScreenScaffold({required BuildContext context}) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarbackgroundColor,
        iconTheme: const IconThemeData(color: appBarIconColor, size: 30),
        title: IconButton(
          icon: const Icon(
            Icons.account_circle_rounded,
          ),
          onPressed: () {
            // Handle Account button press
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
            ),
            onPressed: () {
              // Handle search button press
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.filter_alt_rounded,
            ),
            onPressed: () {
              // Handle Filter button press
            },
          ),
        ],
      ),
      body: SafeArea(
        child: this,
      ),
    );
  }

  Dialog dialogContainer({double height = 350}) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 20.0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        height: height,
        padding: const EdgeInsets.all(20.0),
        child: this,
      ),
    );
  }
}
