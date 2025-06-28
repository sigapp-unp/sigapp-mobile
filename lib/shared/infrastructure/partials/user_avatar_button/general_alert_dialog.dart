import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sigapp/core/infrastructure/ui/links.dart';
import 'package:sigapp/core/infrastructure/ui/utils/share_utils.dart';
import 'package:sigapp/core/infrastructure/ui/widgets/avatar.dart';
import 'package:sigapp/core/infrastructure/ui/widgets/brand_text.dart';
import 'package:sigapp/core/infrastructure/ui/widgets/initials_avatar.dart';
import 'package:sigapp/shared/infrastructure/pages/report_problem_page.dart';
import 'package:url_launcher/url_launcher.dart';

class AvatarCircleWidget extends StatelessWidget {
  final String? imageFilePath;
  final String? fallbackContent;
  final Color backgroundColor;
  final void Function()? onTap;

  const AvatarCircleWidget({
    super.key,
    required this.imageFilePath,
    required this.fallbackContent,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (imageFilePath != null) {
      return AvatarWidget(
        backgroundColor: backgroundColor,
        onPressed: onTap,
        enableGradient: true,
        child: Container(
          padding: const EdgeInsets.all(16 * 0.3),
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            child: Image.asset(imageFilePath!, fit: BoxFit.cover),
          ),
        ),
      );
    }
    if (fallbackContent != null) {
      return InitialsAvatarWidget(
        backgroundColor: backgroundColor,
        content: fallbackContent!,
        enableGradient: true,
        onPressed: onTap,
      );
    }
    throw Exception(
      'No image or fallback content provided for AvatarCircleWidget',
    );
  }
}

class GeneralAvatarDialog extends StatelessWidget {
  const GeneralAvatarDialog({
    super.key,
    required this.avatar,
    // required this.userFirstNameInitials,
    required this.userFullName,
    required this.userId,
    this.errorMessage,
    required this.onSignOut,
  });

  final Widget avatar;
  // final String userFirstNameInitials;
  final String userFullName;
  final String userId;
  final String? errorMessage;
  final void Function() onSignOut;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Stack(
        children: [
          Center(
            child: BrandTextWidget(
              fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close),
            ),
          ),
        ],
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            // leading: AvatarCircleWidget(
            //   imageFilePath:
            //       null, // Replace with actual image path if available
            //   fallbackContent: userFirstNameInitials,
            //   backgroundColor: Theme.of(context).colorScheme.primary,
            //   onTap: () {},
            // ),
            leading: avatar,
            title: Text(userFullName),
            subtitle: Text(userId),
          ),
          if (errorMessage != null)
            ListTile(
              subtitle: Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ),
          Divider(),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Compartir'),
            onTap: () {
              Navigator.of(context).pop();
              ShareUtils.shareAssetsFile(
                context,
                assetPath: 'assets/share.png',
                mimeType: 'image/png',
                name: 'share.png',
                text:
                    'Unepino, descarga la app del SIGA (no oficial) desde el siguiente enlace: '
                    '${Links.playStoreUrl}\n'
                    '👌\tBon appetit',
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.bug_report),
            title: Text('Reportar un problema'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportProblemPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Acerca de'),
            onTap: () {
              Navigator.of(context).pop();
              GoRouter.of(context).push('/about');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar sesión'),
            onTap: () {
              onSignOut();
            },
          ),
          Divider(),
          _buildFooter(context),
        ],
      ),
    );
  }

  GestureDetector _buildFooter(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchUrl(context, Links.privacyPolicyUrl),
      child: Text(
        'Política de privacidad',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo abrir el enlace')));
    }
  }
}
