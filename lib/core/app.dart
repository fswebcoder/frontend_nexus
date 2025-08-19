import 'package:flutter/material.dart';
import 'package:nexus/core/router/app_router.dart';
import 'package:nexus/presentation/widgets/connectivity_wrapper.dart';
import 'package:toastification/toastification.dart';

class NexusApp extends StatelessWidget {
  const NexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _MaterialWidget(key: key);
  }
}

class _MaterialWidget extends StatefulWidget {
  const _MaterialWidget({required super.key});

  @override
  __MaterialWidgetState createState() => __MaterialWidgetState();
}

class __MaterialWidgetState extends State<_MaterialWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'Nexus App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, visualDensity: VisualDensity.adaptivePlatformDensity),
        routerConfig: appRouter,
        builder: (context, child) {
          return ConnectivityWrapper(child: child ?? const SizedBox.shrink());
        },
      ),
    );
  }
}
