import 'dart:io';
import 'package:create_pdf/util/category.dart';
import 'package:create_pdf/util/url_text.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

Future<Uint8List> generatePdf(final PdfPageFormat format) async {
  final doc = pw.Document(title: "flutter School");
  final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/bee.png')).buffer.asUint8List());
  final footerImage = pw.MemoryImage(
      (await rootBundle.load('assets/crab.png')).buffer.asUint8List());
  final font = await rootBundle.load('fonts/korean.ttf');
  final ttf = pw.Font.ttf(font);

  final pageTheme = await _myPageTheme(format);

  doc.addPage(
    pw.MultiPage(
      pageTheme: pageTheme,
      header: (final context) {
        return pw.Image(logoImage,
            alignment: pw.Alignment.topLeft,
            fit: pw.BoxFit.contain,
            width: 100);
      },
      footer: (final context) {
        return pw.Image(footerImage,
            alignment: pw.Alignment.topLeft,
            fit: pw.BoxFit.scaleDown,
            width: 100);
      },
      build: (context) => [
        pw.Container(
          padding: const pw.EdgeInsets.only(left: 30, bottom: 20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Padding(padding: const pw.EdgeInsets.only(top: 20)),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("Phone : "),
                      pw.Text("Email : "),
                      pw.Text("Instagram : "),
                    ],
                  ),
                  pw.SizedBox(width: 70),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('010-3089-0122'),
                      UrlText("jinhan38", 'jinhan38@naver.com'),
                      UrlText("jinhan instagram", "@jinhan38"),
                    ],
                  ),
                  pw.SizedBox(width: 70),
                  pw.BarcodeWidget(
                      data: 'jinhan38',
                      width: 40,
                      height: 40,
                      barcode: pw.Barcode.qrCode(),
                      drawText: false),
                  pw.Padding(padding: pw.EdgeInsets.zero),
                ],
              ),
            ],
          ),
        ),
        pw.Center(
          child: pw.Text(
            'This is PDF File',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: ttf,
              fontSize: 30,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: SubTitle(
            'Jinhan PDF',
            ttf,
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Table(
          border: tableBorder,
          children: [
            tableRow(),
            tableRow(),
            tableRow(),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Paragraph(
          margin: const pw.EdgeInsets.only(top: 10),
          text: bodyText,
          style: pw.TextStyle(
            font: ttf,
            lineSpacing: 8,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
  return doc.save();
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  final logoImage = pw.MemoryImage(
      (await rootBundle.load("assets/butterfly.png")).buffer.asUint8List());
  return pw.PageTheme(
      margin: const pw.EdgeInsets.symmetric(
          horizontal: 1 * PdfPageFormat.cm, vertical: 0.5 * PdfPageFormat.cm),
      textDirection: pw.TextDirection.ltr,
      orientation: pw.PageOrientation.portrait,
      buildBackground: (final context) => pw.FullPage(
          ignoreMargins: true,
          child: pw.Watermark(
              angle: 20,
              child: pw.Opacity(
                  opacity: 0.5,
                  child: pw.Image(logoImage,
                      alignment: pw.Alignment.center, fit: pw.BoxFit.cover)))));
}

Future<void> saveAsFile(
  final BuildContext context,
  final LayoutCallback build,
  final PdfPageFormat pageFormat,
) async {
  final bytes = await build(pageFormat);
  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath/document.pdf');
  print('save as file : ${file.path}...');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}

void showPrintedToast(final BuildContext context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text("Success print")));
}

void showSharedToast(final BuildContext context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text("Share print")));
}

pw.TableBorder tableBorder = const pw.TableBorder(
  top: pw.BorderSide(
    color: PdfColors.black,
    width: 1.0,
  ),
  bottom: pw.BorderSide(
    color: PdfColors.black,
    width: 1.0,
  ),
  left: pw.BorderSide(
    color: PdfColors.black,
    width: 1.0,
  ),
  right: pw.BorderSide(
    color: PdfColors.black,
    width: 1.0,
  ),
);

List<String> reportedItems = [
  "표 테스트중 1",
  "표 테스트중 2",
  "표 테스트중 3",
];

pw.TableRow tableRow() {
  return pw.TableRow(children: [
    pw.Expanded(
      flex: 1,
      child: pw.Column(
        children: [
          pw.Text(
            "555555555555555555555555555",
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.Divider(thickness: 1, height: 1),
        ],
      ),
    ),
    pw.Expanded(
      flex: 1,
      child: pw.Column(
        children: [
          pw.Text(
            "555555555555555555555555555",
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.Divider(thickness: 1, height: 1),
        ],
      ),
    ),
    pw.Expanded(
      flex: 1,
      child: pw.Column(
        children: [
          pw.Text(
            "555555555555555555555555555",
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.Divider(thickness: 1, height: 1),
        ],
      ),
    ),
    pw.Expanded(
      flex: 1,
      child: pw.Column(
        children: [
          pw.Text(
            "555555555555555555555555555",
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.Divider(thickness: 1, height: 1),
        ],
      ),
    ),
    pw.Expanded(
      flex: 1,
      child: pw.Column(
        children: [
          pw.Text(
            "555555555555555555555555555",
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.Divider(thickness: 1, height: 1),
        ],
      ),
    ),
  ]);
}

const String bodyText = "2차전지의 핵심 소재인 분리막을 만드는 더블유씨피(WCP)가 공모가를 낮춰 코스닥에 상장한다. "
    "당초 계획과 달리 기존 주주들의 구주매출도 포기했다. "
    "투자자 친화적인 공모 구조로 상장을 완주하기 위해서다. "
    "\n\n"
    "16일 투자은행(IB) 업계에 따르면 WCP는 지난 14~15일 진행한 수요예측에서 100대1을 밑도는 경쟁률을 기록했다. "
    "전날 오후 5시까지 주문을 받았는데 오후 2시 기준 경쟁률이 50대1에도 못 미친 것으로 전해진다. WCP는 공모가를 희망 수준 대비 최대 36% 낮은 6만4000원으로 사실상 확정 지었다. "
    "이와 동시에 모회사와 기존 주주의 구주매출도 포기했다. 참여한 투자자들은 대부분 6만~6만5000원 사이로 가격을 써냈다. "
    "자산운용사는 수요예측에 참여하길 꺼렸지만 연기금이 6만원을 제안하며 분위기를 주도했다."
    "\n\n"
    "흥행에 실패한 배경으로는 증시 부진이 꼽힌다. "
    "최근 분리막 시장 1위 업체 SK아이이테크놀로지(SKIET)의 주가가 급락한 점이 결정적인 영향을 미쳤다. "
    "16일 종가 기준 SKIET의 시가총액은 5조4257억원으로 1년 전 대비 33% 수준에 불과하다. 이로써 WCP의 상장 직후 시총은 약 2조704억원으로 확정됐다. "
    "이는 코스닥시장에서 13~15번째에 해당하는 규모다. "
    "일각에서는 WCP의 상장 철회 가능성을 제기하지만 회사는 상장 의지를 강조하고 있다. "
    "최원근 WCP 대표는 \"시장이 녹록지 않아 희망 수준의 가격은 어려워 보인다\"고 말했다."
    "\n\n"
    "WCP는 오는 19일 증권신고서를 정정 공시하며 공모 결과를 밝힐 예정이다. "
    "일반 공모 청약은 20~21일 진행된다. "
    "청약은 KB증권과 신한금융투자, 삼성증권에서 참여할 수 있다.";
