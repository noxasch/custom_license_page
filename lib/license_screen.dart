import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LicenseScreen extends StatefulWidget {

  @override
  _LicenseScreenState createState() => _LicenseScreenState();
}

class _LicenseScreenState extends State<LicenseScreen> {
  final List<Widget> _licenses = <Widget>[];
  final Map<String, List> _licenseContent = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _initLicenses();
  }

  Future<void> _initLicenses() async {
    // most of these part are taken from flutter showLicensePage
    await for (final LicenseEntry license in LicenseRegistry.licenses) {
      List<Widget> tempSubWidget = [];
      final List<LicenseParagraph> paragraphs =
          await SchedulerBinding.instance.scheduleTask<List<LicenseParagraph>>(
        license.paragraphs.toList,
        Priority.animation,
        debugLabel: 'License',
      );
      if (_licenseContent.containsKey(license.packages.join(', '))) {
        tempSubWidget = _licenseContent[license.packages.join(', ')];
      }
      for (LicenseParagraph paragraph in paragraphs) {
        if (paragraph.indent == LicenseParagraph.centeredIndent) {
          tempSubWidget.add(Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              paragraph.text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ));
        } else {
          tempSubWidget.add(Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              paragraph.text,
            ),
          ));
        }
      }
      tempSubWidget.add(Divider());
      _licenseContent[license.packages.join(', ')] = tempSubWidget;
    }

    _licenseContent.forEach((key, value) {
      int count = 0;
      value.forEach((element) {  
        if (element.runtimeType == Divider) count += 1; 
      });
      // Replace ExpansionTile with any widget that suits you
      _licenses.add(ExpansionTile(
        title: Text('$key', style: TextStyle(color: Colors.black)),
        subtitle: Text(
          '$count licenses',
          style: TextStyle(color: Colors.black),
        ),
        children: <Widget>[...value],
      ));
    });

    setState(() {
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // elevation: 0,
          // backgroundColor: Colors.white,
          centerTitle: true,
          title: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Text(
                'Open Source Licenses',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16
                ),
              )),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300], width: 1)),
        ),
        child: SafeArea(
          child: !_loaded
            ? Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: _licenses.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return _licenses.elementAt(index);
                },
              ),
        ),
      ),
    );
  }
}
