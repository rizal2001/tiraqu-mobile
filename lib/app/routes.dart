import 'package:flutter/material.dart';
import '../pages/home/home_pages.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomePages(),
};
