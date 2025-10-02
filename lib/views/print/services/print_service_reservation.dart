import 'dart:convert';
import 'dart:html' as html;
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/shared/constants/image_constants.dart';

class QRPrintServiceReservation {
  static String _escapeHtml(String text) {
    final htmlEscape = HtmlEscape();
    return htmlEscape.convert(text);
  }

  static void openPrintWindowForTable(
    EventTable table,
    List<ReservationMember> reservations,
  ) {
    // Filtrar solo los miembros de reserva que tienen el tableId correcto
    final filteredReservations = reservations.where((member) => member.tableId == table.id).toList();

    final htmlContent =
        '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="UTF-8">
          <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&display=swap" rel="stylesheet">
          <title>QR Codes - Mesa ${_escapeHtml(table.name)}</title>
          <style>
            @page {
              size: letter portrait;
              margin: 0.5in;
            }
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 10px;
              height: 100vh;
              display: flex;
              flex-direction: column;
              align-items: center;
            }
            .container {
              display: flex;
              flex-direction: column;
              align-items: center;
              width: 100%;
            }
            .qr-card {
              position: relative;
              width: 348px;
              height: 768px;
              background-image: url('$QR_EVENT_ART');
              background-size: 100% 100%;
              background-repeat: no-repeat;
              background-position: center;
              box-sizing: border-box;
              overflow: hidden;
              margin: 0 auto;
            }
            .card-container {
              width: 100%;
              height: 100vh;
              display: flex;
              justify-content: center;
              align-items: center;
              page-break-after: always;
            }
            .qr-card img.qr {
              position: absolute;
              top: 440px;
              left: 50%;
              transform: translateX(-50%);
              width: 190px;
              height: 190px;
              background: white;
              padding: 8px;
              border-radius: 8px;
            }
            .guest-name {
              position: absolute;
              top: 650px;
              left: 50%;
              transform: translateX(-50%);
              width: 100%;
              font-size: 22px;
              font-weight: 700;
              color: #e5bf49;
              text-align: center;
              letter-spacing: 1px;
              font-family: 'Monserrat', sans-serif;
            }
            .spaces {
              display: none; /* Si no lo necesitas */
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
            ${filteredReservations.map((reservation) => '''
              <div class="card-container">
                <div class="qr-card">
                  <img
                    class="qr"
                    src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${Uri.encodeComponent(reservation.uuidCode)}"
                  />
                  <div class="guest-name">${_escapeHtml(reservation.member.fullName)}<br/>
                      Mesa número: #${_escapeHtml(table.tableNumber.toString())}
                  </div>
                </div>
              </div>
            ''').join('')}
          </div>
        </body>
      </html>
    ''';

    final blob = html.Blob([htmlContent], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.window.open(
      url,
      'QR Codes - Mesa ${table.name}',
      'width=800,height=1200,toolbar=no,location=no,status=no,menubar=no',
    );

    Future.delayed(const Duration(seconds: 1), () {
      html.Url.revokeObjectUrl(url);
    });
  }
}
