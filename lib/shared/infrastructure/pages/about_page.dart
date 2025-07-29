import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sigapp/core/infrastructure/ui/links.dart';
import 'package:sigapp/core/infrastructure/ui/utils/mail_utils.dart';
import 'package:sigapp/core/infrastructure/ui/widgets/brand_text.dart';
import 'package:sigapp/core/injection/get_it.dart';
import 'package:sigapp/shared/infrastructure/pages/easter_egg_page.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPageWidget extends StatelessWidget {
  const AboutPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: Stack(
        children: [
          Positioned(
            top: -size.height * 0.0,
            // left: -size.height * 0.75,
            child: Opacity(
              opacity: 0.06,
              child: SvgPicture.asset(
                'assets/svg/unp_logo_dark.svg',
                height: size.height * 1,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary,
                  BlendMode.srcOut,
                ),
              ),
            ),
          ),
          ListView(
            children: [
              ListTile(
                title: GestureDetector(
                  onLongPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EasterEggPageWidget(),
                      ),
                    );
                  },
                  child: BrandTextWidget(
                    fontSize:
                        Theme.of(context).textTheme.headlineLarge?.fontSize,
                  ),
                ),
              ),
              const ListTile(
                subtitle: Text(
                  'Cliente móvil del Sistema Integrado de Gestión Académica de la Universidad Nacional de Piura',
                ),
              ),

              ListTile(
                leading: Icon(MdiIcons.github),
                title: const Text('GitHub del proyecto'),
                onTap: () => _launchUrl(context, Links.projectUrl),
              ),
              ListTile(
                leading: Icon(MdiIcons.handshake),
                title: const Text('¿Eres desarrollador?'),
                subtitle: const Text('Apoyar al proyecto'),
                onTap: () {
                  getIt<MailUtils>().launchEmail(
                    context,
                    email: Links.contactEmail,
                    subject: 'Hola! Quiero contribuir al proyecto',
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: Text(
                  'Enlaces útiles',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              _buildLinkListTile(
                context,
                title: 'SIGA',
                // url: 'https://academico.unp.edu.pe/',
                url: Links.sigaWebAppUrl,
              ),
              _buildLinkListTile(
                context,
                title: 'Reporte pagos',
                // url: 'https://pagos.unp.edu.pe/',
                url: Links.paymentsWebAppUrl,
              ),
              _buildLinkListTile(
                context,
                title: 'Recuperar contraseña',
                // url: 'https://academico.unp.edu.pe/Cuenta/ResetPassword',
                url: Links.resetPasswordUrl,
              ),
              const Divider(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinkListTile(
    BuildContext context, {
    required String title,
    required String url,
  }) {
    return ListTile(
      leading: Icon(MdiIcons.web),
      title: Text(title),
      onTap: () => _launchUrl(context, url),
    );
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace')),
      );
    }
  }
}
