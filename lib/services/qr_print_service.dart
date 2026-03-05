import 'dart:convert';
import 'dart:html' as html;
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/models/guest_model.dart';

class QRPrintService {
  static String _escapeHtml(String text) {
    final htmlEscape = HtmlEscape();
    return htmlEscape.convert(text);
  }

  static String _formatEventDate(EventModel event) {
    // Formato personalizado para la fecha del evento
    final months = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    final days = ['domingo', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado'];

    final date = event.eventDate;
    final dayName = days[date.weekday % 7];
    final day = date.day;
    final monthName = months[date.month - 1];
    final year = date.year;

    return '$dayName $day de $monthName de $year';
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
            <div class="card-border">
              <div class="corner-ornament top-left"></div>
              <div class="corner-ornament top-right"></div>
              <div class="corner-ornament bottom-left"></div>
              <div class="corner-ornament bottom-right"></div>

              <div class="card-header">${_escapeHtml(event.name)}</div>

              <div class="event-details">
                <div class="event-location">${_escapeHtml(event.description)}</div>
                <div class="event-date">${_formatEventDate(event)}</div>
              </div>

              <img class="qr-code" src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${Uri.encodeComponent(member1.uuidCode)}"/>

              <div class="guest-name">${_escapeHtml(member1.member.fullName)}</div>
              <div class="table-number">Mesa número: #${tableNumber1 ?? '--'}</div>

              <div class="footer-text">VESTIMENTA DE GALA</div>
            </div>
          </div>
        ''');

        // Segunda tarjeta (si existe)
        if (i + 1 < members.length) {
          final member2 = members.elementAt(i + 1);
          final int? tableNumber2 = findTableNumber(member2.uuidCode);
          buffer.write('''
            <div class="qr-card">
              <div class="card-border">
                <div class="corner-ornament top-left"></div>
                <div class="corner-ornament top-right"></div>
                <div class="corner-ornament bottom-left"></div>
                <div class="corner-ornament bottom-right"></div>

                <div class="card-header">${_escapeHtml(event.name)}</div>

                <div class="event-details">
                  <div class="event-location">${_escapeHtml(event.description)}</div>
                  <div class="event-date">${_formatEventDate(event)}</div>
                </div>

                <img class="qr-code" src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${Uri.encodeComponent(member2.uuidCode)}"/>

                <div class="guest-name">${_escapeHtml(member2.member.fullName)}</div>
                <div class="table-number">Mesa número: #${tableNumber2 ?? '--'}</div>

                <div class="footer-text">VESTIMENTA DE GALA</div>
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
          <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Cinzel:wght@400;600;700&family=Cormorant:wght@400;600;700&display=swap" rel="stylesheet">
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
              background: #f5f5f5;
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
              background: linear-gradient(135deg, #1a1a1a 0%, #000000 100%);
              box-sizing: border-box;
              overflow: hidden;
            }
            .card-border {
              position: absolute;
              top: 15px;
              left: 15px;
              right: 15px;
              bottom: 15px;
              border: 3px solid #d4af37;
              box-shadow: inset 0 0 20px rgba(212, 175, 55, 0.3);
            }
            .corner-ornament {
              position: absolute;
              width: 40px;
              height: 40px;
              border-color: #e5bf49;
            }
            .corner-ornament.top-left {
              top: -2px;
              left: -2px;
              border-top: 4px solid #e5bf49;
              border-left: 4px solid #e5bf49;
            }
            .corner-ornament.top-right {
              top: -2px;
              right: -2px;
              border-top: 4px solid #e5bf49;
              border-right: 4px solid #e5bf49;
            }
            .corner-ornament.bottom-left {
              bottom: -2px;
              left: -2px;
              border-bottom: 4px solid #e5bf49;
              border-left: 4px solid #e5bf49;
            }
            .corner-ornament.bottom-right {
              bottom: -2px;
              right: -2px;
              border-bottom: 4px solid #e5bf49;
              border-right: 4px solid #e5bf49;
            }
            .card-header {
              position: absolute;
              top: 30px;
              left: 0;
              right: 0;
              text-align: center;
              font-size: 18px;
              font-weight: 700;
              color: #e5bf49;
              letter-spacing: 3px;
              text-transform: uppercase;
              font-family: 'Cinzel', 'Playfair Display', serif;
              padding: 0 20px;
            }
            .event-details {
              position: absolute;
              top: 120px;
              left: 0;
              right: 0;
              text-align: center;
              color: #e5bf49;
              font-family: 'Playfair Display', 'Cormorant', serif;
              padding: 0 30px;
            }
            .event-location {
              font-size: 14px;
              font-weight: 500;
              margin-bottom: 15px;
              line-height: 1.4;
            }
            .event-date {
              font-size: 16px;
              font-weight: 600;
              margin-top: 10px;
            }
            .qr-code {
              position: absolute;
              top: 340px;
              left: 50%;
              transform: translateX(-50%);
              width: 190px;
              height: 190px;
              background: white;
              padding: 8px;
              border-radius: 8px;
              box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            }
            .guest-name {
              position: absolute;
              top: 560px;
              left: 0;
              right: 0;
              text-align: center;
              font-size: 22px;
              font-weight: 700;
              color: #e5bf49;
              letter-spacing: 1px;
              font-family: 'Playfair Display', 'Cormorant', serif;
              padding: 0 20px;
            }
            .table-number {
              position: absolute;
              top: 600px;
              left: 0;
              right: 0;
              text-align: center;
              font-size: 16px;
              font-weight: 500;
              color: #d4af37;
              font-family: 'Playfair Display', 'Cormorant', serif;
            }
            .footer-text {
              position: absolute;
              bottom: 40px;
              left: 0;
              right: 0;
              text-align: center;
              font-size: 14px;
              font-weight: 600;
              color: #e5bf49;
              letter-spacing: 2px;
              font-family: 'Cinzel', 'Playfair Display', serif;
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
            <div class="card-border">
              <div class="corner-ornament top-left"></div>
              <div class="corner-ornament top-right"></div>
              <div class="corner-ornament bottom-left"></div>
              <div class="corner-ornament bottom-right"></div>

              <div class="card-header">${_escapeHtml(event.name)}</div>

              <div class="event-details">
                <div class="event-location">${_escapeHtml(event.description)}</div>
                <div class="event-date">${_formatEventDate(event)}</div>
              </div>

              <img class="qr-code" src="https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=${Uri.encodeComponent(member.uuidCode)}"/>

              <div class="guest-name">${_escapeHtml(member.member.fullName)}</div>
              <div class="table-number">Mesa número: #${tableNumber ?? '--'}</div>

              <div class="footer-text">VESTIMENTA DE GALA</div>
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
          <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Cinzel:wght@400;600;700&family=Cormorant:wght@400;600;700&display=swap" rel="stylesheet">
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
              background: linear-gradient(135deg, #1a1a1a 0%, #000000 100%);
              box-sizing: border-box;
              overflow: hidden;
            }
            .card-border {
              position: absolute;
              top: 15px;
              left: 15px;
              right: 15px;
              bottom: 15px;
              border: 3px solid #d4af37;
              box-shadow: inset 0 0 20px rgba(212, 175, 55, 0.3);
            }
            .corner-ornament {
              position: absolute;
              width: 40px;
              height: 40px;
              border-color: #e5bf49;
            }
            .corner-ornament.top-left {
              top: -2px;
              left: -2px;
              border-top: 4px solid #e5bf49;
              border-left: 4px solid #e5bf49;
            }
            .corner-ornament.top-right {
              top: -2px;
              right: -2px;
              border-top: 4px solid #e5bf49;
              border-right: 4px solid #e5bf49;
            }
            .corner-ornament.bottom-left {
              bottom: -2px;
              left: -2px;
              border-bottom: 4px solid #e5bf49;
              border-left: 4px solid #e5bf49;
            }
            .corner-ornament.bottom-right {
              bottom: -2px;
              right: -2px;
              border-bottom: 4px solid #e5bf49;
              border-right: 4px solid #e5bf49;
            }
            .card-header {
              position: absolute;
              top: 30px;
              left: 0;
              right: 0;
              text-align: center;
              font-size: 18px;
              font-weight: 700;
              color: #e5bf49;
              letter-spacing: 3px;
              text-transform: uppercase;
              font-family: 'Cinzel', 'Playfair Display', serif;
              padding: 0 20px;
            }
            .event-details {
              position: absolute;
              top: 120px;
              left: 0;
              right: 0;
              text-align: center;
              color: #e5bf49;
              font-family: 'Playfair Display', 'Cormorant', serif;
              padding: 0 30px;
            }
            .event-location {
              font-size: 14px;
              font-weight: 500;
              margin-bottom: 15px;
              line-height: 1.4;
            }
            .event-date {
              font-size: 16px;
              font-weight: 600;
              margin-top: 10px;
            }
            .qr-code {
              position: absolute;
              top: 340px;
              left: 50%;
              transform: translateX(-50%);
              width: 230px;
              height: 230px;
              background: white;
              padding: 10px;
              border-radius: 8px;
              box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            }
            .guest-name {
              position: absolute;
              top: 600px;
              left: 0;
              right: 0;
              text-align: center;
              font-size: 22px;
              font-weight: 700;
              color: #e5bf49;
              letter-spacing: 1px;
              font-family: 'Playfair Display', 'Cormorant', serif;
              padding: 0 20px;
            }
            .table-number {
              position: absolute;
              top: 640px;
              left: 0;
              right: 0;
              text-align: center;
              font-size: 16px;
              font-weight: 500;
              color: #d4af37;
              font-family: 'Playfair Display', 'Cormorant', serif;
            }
            .footer-text {
              position: absolute;
              bottom: 40px;
              left: 0;
              right: 0;
              text-align: center;
              font-size: 14px;
              font-weight: 600;
              color: #e5bf49;
              letter-spacing: 2px;
              font-family: 'Cinzel', 'Playfair Display', serif;
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
