import 'dart:convert';
import 'dart:html' as html;
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/models/guest_model.dart';
import 'package:qr_check_in/shared/constants/image_constants.dart';

class QRPrintService {
  static String _escapeHtml(String text) {
    final htmlEscape = HtmlEscape();
    return htmlEscape.convert(text);
  }

  // Método para imprimir en formato horizontal (2 tarjetas por página)
  static void openPrintWindow(EventModel event, {bool verticalFormat = false}) {
    if (verticalFormat) {
      openVerticalPrintWindow(event);
      return;
    }
    // Función auxiliar para encontrar el número de mesa de un invitado
    int? findTableNumber(String uuid) {
      for (var reservation in event.reservations) {
        final member = reservation.reservationMembers.firstWhere(
          (m) => m.uuidCode == uuid,
          orElse: () => ReservationMember(
            id: 0,
            reservationId: 0,
            tableId: 0,
            personId: 0,
            uuidCode: '',
            status: 0,
            createdAt: DateTime.now(),
            member: Guest.instance(),
          ),
        );

        if (member.uuidCode == uuid && member.tableId > 0) {
          // Usar directamente el tableId del miembro de reservación
          final table = event.eventTables.firstWhere(
            (t) => t.id == member.tableId,
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

    // Función para generar las páginas de QR con 2 tarjetas por página
    String generateQrPages(List<ReservationMember> members, Function findTableNumber) {
      final buffer = StringBuffer();

      for (var i = 0; i < members.length; i += 2) {
        buffer.write('<div class="page-container">');

        // Primera tarjeta
        final ReservationMember member1 = members.elementAt(i);
        final int? tableNumber1 = findTableNumber(member1.uuidCode);
        buffer.write('''
          <div class="qr-card">
            <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${Uri.encodeComponent(member1.uuidCode)}"/>
            <div class="guest-name">${_escapeHtml(member1.member.fullName)}</div>
            <div class="spaces">Mesa número: #${tableNumber1 ?? '--'}</div>
          </div>
        ''');

        // Segunda tarjeta (si existe)
        if (i + 1 < members.length) {
          final member2 = members.elementAt(i + 1);
          final int? tableNumber2 = findTableNumber(member2.uuidCode);
          buffer.write('''
            <div class="qr-card">
              <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${Uri.encodeComponent(member2.uuidCode)}"/>
              <div class="guest-name">${_escapeHtml(member2.member.fullName)}<br/>
              Mesa número: #${tableNumber2 ?? '--'}
              </div>
            </div>
          ''');
        }

        buffer.write('</div>');
      }

      return buffer.toString();
    }

    final htmlContent =
        '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="UTF-8">
          <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&display=swap" rel="stylesheet">
          <title>QR Codes - ${_escapeHtml(event.name)}</title>
          <style>
            @page {
              size: letter landscape; /* Formato horizontal */
              margin: 0.5in;
            }
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 10px;
            }
            .container {
              display: flex;
              flex-wrap: wrap;
              justify-content: center;
              max-width: 10in; /* US Letter landscape width - margins */
              margin: 0 auto;
            }
            .page-container {
              display: flex;
              justify-content: space-around;
              width: 100%;
              page-break-after: always;
              page-break-inside: avoid;
              margin-bottom: 20px;
            }
            .qr-card {
              position: relative;
              width: 348px;
              height: 768px;
              margin: 0 auto;
              overflow: hidden;
              background-image: url('$QR_EVENT_ART);
              background-size: 100% 100%;
              background-repeat: no-repeat;
              background-position: center;
              box-sizing: border-box;
              overflow: hidden;
            }
            .qr-card img {
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
              font-family: 'Montserrat', sans-serif;
            }
            .spaces {
              position: absolute;
              top: 690px;
              left: 50%;
              transform: translateX(-50%);
              display: block;
              text-align: center;
              font-size: 16px;
              width: 100%;
            }
            @media print {
              .no-print {
                display: none;
              }
              body {
                padding: 0;
              }
              .container {
                margin: 0;
                padding: 0;
              }
              .page-container {
                margin: 0;
                padding: 0;
              }
              .qr-card {
                page-break-inside: avoid;
                margin: 0 auto;
                padding: 0;
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
            ${generateQrPages(event.reservations.expand((re) => re.reservationMembers).toList(), findTableNumber)}
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

  // Método para imprimir en formato vertical (1 tarjeta por página)
  static void openVerticalPrintWindow(EventModel event) {
    // Función auxiliar para encontrar el número de mesa de un invitado
    int? findTableNumber(String uuid) {
      for (var reservation in event.reservations) {
        final member = reservation.reservationMembers.firstWhere(
          (m) => m.uuidCode == uuid,
          orElse: () => ReservationMember(
            id: 0,
            reservationId: 0,
            tableId: 0,
            personId: 0,
            uuidCode: '',
            status: 0,
            createdAt: DateTime.now(),
            member: Guest.instance(),
          ),
        );

        if (member.uuidCode == uuid && member.tableId > 0) {
          final table = event.eventTables.firstWhere(
            (t) => t.id == member.tableId,
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

    // Función para generar las páginas de QR con 1 tarjeta por página
    String generateVerticalQrPages(List<ReservationMember> members, Function findTableNumber) {
      final buffer = StringBuffer();

      for (var member in members) {
        final int? tableNumber = findTableNumber(member.uuidCode);
        buffer.write('<div class="vertical-page">');
        buffer.write('''
          <div class="vertical-qr-card">
            <img src="https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=${Uri.encodeComponent(member.uuidCode)}"/>
            <div class="vertical-guest-name">${_escapeHtml(member.member.fullName)}<br/>
              Mesa número: #${tableNumber ?? '--'}
             </div>
          </div>
        ''');
        buffer.write('</div>');
      }

      return buffer.toString();
    }

    final htmlContent = '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="UTF-8">
          <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&display=swap" rel="stylesheet">
          <title>QR Codes - ${_escapeHtml(event.name)}</title>
          <style>
            @page {
              size: letter portrait; /* Formato vertical */
              margin: 0in;
            }
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 10px;
            }
            .container {
              display: flex;
              flex-direction: column;
              align-items: center;
              max-width: 8.5in; /* US Letter width - margins */
              margin: 0 auto;
            }
            .vertical-page {
              width: 100%;
              height: 10.5in;
              page-break-after: always;
              page-break-inside: avoid;
              margin-bottom: 20px;
              display: flex;
              justify-content: center;
              align-items: center;
            }
            .vertical-qr-card {
              position: relative;
              width: 348px;
              height: 768px;
              padding: 20px;
              border-radius: 10px;
              box-shadow: 0 4px 8px rgba(0,0,0,0.1);
              text-align: center;
              background-image: url('$QR_EVENT_ART');
              background-size: 100% 100%;
              background-repeat: no-repeat;
              background-position: center;
              display: flex;
              flex-direction: column;
              justify-content: space-between;
            }
            .vertical-qr-card img {
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
            .vertical-guest-name {
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
              font-family: 'Montserrat', sans-serif;
            }
            .vertical-table {
              font-size: 18px;
              margin: 10px 0;
              color: #000;
              background: rgba(255, 255, 255, 0.8);
              padding: 8px;
              border-radius: 5px;
              display: inline-block;
            }
            .vertical-event-name {
              font-size: 16px;
              font-weight: bold;
              color: #000;
              margin-top: 15px;
              background: rgba(255, 255, 255, 0.8);
              padding: 8px;
              border-radius: 5px;
              display: inline-block;
            }
            .no-print {
              display: block;
            }
            @media print {
              .no-print {
                display: none;
              }
              body {
                margin: 0;
                padding: 0;
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
            ${generateVerticalQrPages(event.reservations.expand((re) => re.reservationMembers).toList(), findTableNumber)}
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
      'QR Codes Vertical - ${event.name}',
      'width=800,height=600,toolbar=no,location=no,status=no,menubar=no',
    );

    // Liberar el URL del objeto después de un momento
    Future.delayed(const Duration(seconds: 1), () {
      html.Url.revokeObjectUrl(url);
    });
  }
}
