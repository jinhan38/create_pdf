import 'package:create_pdf/util/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfPage extends StatefulWidget {
  const PdfPage({Key? key}) : super(key: key);

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  PrintingInfo? printingInfo;

  @override
  void initState()  {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final info = await Printing.info();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        printingInfo = info;
      });
    });
  }

  bool showPdf = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    final actions = <PdfPreviewAction>[
      if (!kIsWeb) ...[
        const PdfPreviewAction(icon: Icon(Icons.save), onPressed: saveAsFile)
      ],
    ];

  return  Scaffold(
      appBar: AppBar(title: const Text("Flutter PDF")),
      body: PdfPreview(
          maxPageWidth: 700,
          actions: actions,
          onPrinted: showPrintedToast,
          onShared: showSharedToast,
          build: generatePdf),
    );
  }

}
