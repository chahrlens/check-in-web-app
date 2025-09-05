import 'dart:convert';
import 'dart:html' as html;
import 'package:qr_check_in/models/event_model.dart';

class QRPrintServiceReservation {
  static String _escapeHtml(String text) {
    final htmlEscape = HtmlEscape();
    return htmlEscape.convert(text);
  }

  static void openPrintWindowForTable(EventTable table, List<ReservationMember> reservations) {
    final htmlContent = '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="UTF-8">
          <title>QR Codes - Mesa ${_escapeHtml(table.name)}</title>
          <style>
            @page {
              size: letter;
              margin: 0.5in;
            }
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 10px;
            }
            .container {
              display: grid;
              grid-template-columns: repeat(2, 1fr);
              gap: 10px;
              max-width: 7.5in;
              margin: 0 auto;
            }
            .qr-card {
              border: 1px solid #ddd;
              padding: 10px;
              text-align: center;
              break-inside: avoid;
              width: 3.5in;
              box-sizing: border-box;
            }
            .guest-name {
              font-size: 14px;
              font-weight: bold;
              margin: 8px 0;
              overflow: hidden;
              text-overflow: ellipsis;
              white-space: nowrap;
            }
            .spaces {
              font-size: 12px;
              color: #666;
            }
            @media print {
              .no-print {
                display: none;
              }
              body {
                padding: 0;
              }
              .container {
                gap: 0;
              }
              .qr-card {
                page-break-inside: avoid;
                margin-bottom: 0.25in;
                border: none;
                border-bottom: 1px dashed #ccc;
              }
            }
          </style>
        </head>
        <body>
          <div class="no-print" style="margin-bottom: 20px; text-align: center;">
            <button onclick="window.print()">Imprimir QRs</button>
            <button onclick="window.close()">Cerrar</button>
          </div>
          <div class="container">
            ${reservations.map((reservation) => '''
              <div class="qr-card">
                <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${Uri.encodeComponent(reservation.uuidCode)}"/>
                <div class="guest-name">${_escapeHtml(reservation.member.fullName)}</div>
                <div class="spaces">Mesa número: #${_escapeHtml(table.tableNumber.toString())}</div>
              </div>
            ''').join('')}
          </div>
        </body>
      </html>
    ''';


    //TODO add table number line 84
    final blob = html.Blob([htmlContent], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.window.open(
      url,
      'QR Codes - Mesa ${table.name}',
      'width=800,height=600,toolbar=no,location=no,status=no,menubar=no',
    );

    Future.delayed(const Duration(seconds: 1), () {
      html.Url.revokeObjectUrl(url);
    });
  }
}
