import 'dart:convert';
import 'dart:html' as html;
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/models/guest_model.dart';

class QRPrintService {
  static String _escapeHtml(String text) {
    final htmlEscape = HtmlEscape();
    return htmlEscape.convert(text);
  }
  static void openPrintWindow(EventModel event) {
    // Función auxiliar para encontrar el número de mesa de un invitado
    int? findTableNumber(String uuid) {
      for (var reservation in event.reservations) {
        final member = reservation.reservationMembers
            .firstWhere((m) => m.uuidCode == uuid, orElse: () => ReservationMember(
                  id: 0,
                  reservationId: 0,
                  personId: 0,
                  uuidCode: '',
                  status: 0,
                  createdAt: DateTime.now(),
                  member: Guest.instance(),
                ));
        if (member.uuidCode == uuid) {
          // Encontrar la mesa asociada a la familia
          final tableId = reservation.family.familyTables.first.tableId;
          final table = event.eventTables.firstWhere(
            (t) => t.id == tableId,
            orElse: () => EventTable(
              id: 0,
              eventId: 0,
              name: '',
              description: '',
              tableNumber: 0,
              capacity: 0,
              availableCapacity: 0,
              reservedCount: 0,
              status: 0,
              createdAt: DateTime.now(),
              updatedAt: null,
            ),
          );
          return table.tableNumber;
        }
      }
      return null;
    }

    // Creamos el contenido HTML para la página de impresión
    final htmlContent = '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="UTF-8">
          <title>QR Codes - ${_escapeHtml(event.name)}</title>
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
              max-width: 7.5in; /* US Letter width - margins */
              margin: 0 auto;
            }
            .qr-card {
              border: 1px solid #ddd;
              padding: 10px;
              text-align: center;
              break-inside: avoid;
              width: 3.5in; /* (8.5in - 1in margins - 0.5in gap) / 2 */
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
            ${event.reservations.expand((re) => re.reservationMembers).map((reservation) {
              final tableNumber = findTableNumber(reservation.uuidCode);
              return '''
              <div class="qr-card">
                <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${Uri.encodeComponent(reservation.uuidCode)}"/>
                <div class="guest-name">${_escapeHtml(reservation.member.fullName)}</div>
                <div class="spaces">Mesa número: #${tableNumber ?? '--'}</div>
              </div>
              ''';
            }).join('')}
          </div>
        </body>
      </html>
    ''';

    // Crear un Blob con el contenido HTML
    final blob = html.Blob([htmlContent], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Abrir nueva ventana con el contenido
    html.window.open(
      url,
      'QR Codes - ${event.name}',
      'width=800,height=600,toolbar=no,location=no,status=no,menubar=no',
    );

    // Liberar el URL del objeto después de un momento
    Future.delayed(const Duration(seconds: 1), () {
      html.Url.revokeObjectUrl(url);
    });
  }
}
