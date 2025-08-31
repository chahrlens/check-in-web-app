import 'package:get/get.dart';
import 'navigation_sidebar.dart';
import 'package:flutter/material.dart';
import '../commons/global_loader_widget.dart';
import 'package:qr_check_in/controllers/globals.dart';
import 'package:qr_check_in/shared/resources/custom_style.dart';
import 'package:qr_check_in/shared/resources/get_routes/routes.dart';

class ResponsiveSidebarLayout extends StatelessWidget {
  final Widget content;
  final String title;
  final String currentRoute;
  final String userRole;
  final String description;
  final bool showBackButton;

  const ResponsiveSidebarLayout({
    super.key,
    required this.content,
    required this.title,
    required this.currentRoute,
    required this.userRole,
    this.description = "",
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sessionController = Get.find<SessionController>();
    return Obx(() {
      if (sessionController.isLoading.value) {
        return const GlobalLoader();
      } else if (sessionController.getToken.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed(RouteConstants.login);
        });
        return const SizedBox.shrink(); // Return an empty widget while redirecting
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final appBar = AppBar(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (constraints.maxWidth <= 600)
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          Scaffold.of(
                            context,
                          ).openDrawer(); // Abre el menú lateral
                        },
                      );
                    },
                  ),
                if (showBackButton && constraints.maxWidth > 600)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop(); // Navega hacia atrás
                    },
                  ),
              ],
            ),
            actions: [
              if (constraints.maxWidth <= 600 && showBackButton)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop(); // Navega hacia atrás
                  },
                ),
            ],
            backgroundColor: colorScheme.primary,
            elevation: 0.5,
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(color: colorScheme.surface),
          );

          Widget backgroundWave = SizedBox(
            height: constraints.maxHeight * 0.4,
            width: double.infinity,
            child: CustomPaint(
              painter: WavePainter(color: colorScheme.primary),
            ),
          );

          Widget stackedContent = Stack(
            children: [
              // Fondo con la ola
              Positioned.fill(
                child: Column(
                  children: [
                    backgroundWave,
                    Expanded(child: Container()), // para completar el alto
                  ],
                ),
              ),
              // Título y descripción encima de la ola
              Positioned(
                top: -10,
                left: 58,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: CustomStyle.layoutTitleText(context)),
                    const SizedBox(height: 4),
                    if (description.isNotEmpty)
                      Text(
                        description,
                        style: CustomStyle.layoutDescriptionText(context),
                      ),
                  ],
                ),
              ),
              // Contenido general debajo del header
              Padding(
                padding: EdgeInsets.only(top: constraints.maxHeight * 0.09),
                child: SizedBox(width: double.infinity, child: content),
              ),
            ],
          );

          if (constraints.maxWidth > 600) {
            return Stack(
              children: [
                Scaffold(
                  // Tu scaffold original
                  body: Row(
                    children: [
                      NavigationSidebar(
                        userRole: userRole,
                        currentRoute: currentRoute,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            appBar,
                            Expanded(child: stackedContent),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const GlobalLoader(), // Loader encima de todo
              ],
            );
          } else {
            return Stack(
              children: [
                Scaffold(
                  appBar: appBar,
                  drawer: Drawer(
                    child: NavigationSidebar(
                      userRole: userRole,
                      currentRoute: currentRoute,
                    ),
                  ),
                  body: stackedContent,
                ),
                const GlobalLoader(),
              ],
            );
          }
        },
      );
    });
  }
}

class WavePainter extends CustomPainter {
  final Color color;

  WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height * 0.8,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ResponsiveSimpleLayout extends StatelessWidget {
  final Widget content;
  final String title;
  final String description;
  final bool showBackButton;

  const ResponsiveSimpleLayout({
    super.key,
    required this.content,
    required this.title,
    this.description = "",
    this.showBackButton = false,
  });

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Está seguro que desea cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _handleLogout();
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogout() async {
    try {
      final sessionController = Get.find<SessionController>();
      await sessionController.logOut();
      Get.offAllNamed(RouteConstants.login);
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo cerrar la sesión: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final appBar = AppBar(
          leading: showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (!Navigator.of(context).canPop() || ModalRoute.of(context)?.isFirst == true) {
                      Get.offAllNamed(RouteConstants.dashboard);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                )
              : null,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => _showLogoutDialog(context),
              tooltip: 'Cerrar sesión',
            ),
          ],
          backgroundColor: colorScheme.primary,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: colorScheme.surface),
        );

        Widget backgroundWave = SizedBox(
          height: constraints.maxHeight * 0.4,
          width: double.infinity,
          child: CustomPaint(painter: WavePainter(color: colorScheme.primary)),
        );

        Widget stackedContent = Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  backgroundWave,
                  Expanded(child: Container()),
                ],
              ),
            ),
            Positioned(
              top: -10,
              left: 58,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: CustomStyle.layoutTitleText(context)),
                  const SizedBox(height: 4),
                  if (description.isNotEmpty)
                    Text(
                      description,
                      style: CustomStyle.layoutDescriptionText(context),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: constraints.maxHeight * 0.09),
              child: SizedBox(width: double.infinity, child: content),
            ),
          ],
        );

        return Scaffold(appBar: appBar, body: stackedContent);
      },
    );
  }
}
