import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sigapp/auth/domain/services/toast_service.dart';
import 'package:sigapp/auth/infrastructure/pages/welcome_page.dart';
import 'package:sigapp/core/infrastructure/ui/links.dart';
import 'package:sigapp/core/infrastructure/ui/utils/mail_utils.dart';
import 'package:sigapp/core/injection/get_it.dart';
import 'package:sigapp/core/infrastructure/ui/widgets/brand_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  String? _usernameErrorText;
  bool _obscurePassword = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginCubit>().setup();
      // showDearStudentDialog(context);
      // push WelcomePage
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const WelcomePage()));
    });
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _validateUsername(String value) {
    setState(() {
      if (value.isEmpty) {
        _usernameErrorText = 'El código es requerido';
      } else if (value.length != 10) {
        _usernameErrorText = 'El código debe tener exactamente 10 dígitos';
      } else {
        _usernameErrorText = null;
      }
    });
  }

  void _login() {
    if (_usernameController.text.length != 10) {
      setState(() {
        _usernameErrorText = 'El código debe tener exactamente 10 dígitos';
      });
      return;
    }

    context.read<LoginCubit>().login(
      _usernameController.text,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        builder: (context, state) {
          final status = state.status;
          final size = MediaQuery.of(context).size;
          return Stack(
            children: [
              Positioned(
                top: -size.height * (0.0),
                left: -size.height * (0.75),
                child: Opacity(
                  opacity: 0.06,
                  child: SvgPicture.asset(
                    'assets/svg/unp_logo_dark.svg',
                    height: size.height * 1.25,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary,
                      BlendMode.srcOut,
                    ),
                  ),
                ),
              ),
              // Contenido principal
              Column(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const BrandTextWidget(fontSize: 40),
                                  // Text(
                                  //   'Beta',
                                  //   style:
                                  //       Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  //             color: Colors.red,
                                  //           ),
                                  // )
                                ],
                              ),
                              const SizedBox(height: 40),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: _usernameController,
                                      focusNode: _usernameFocusNode,
                                      decoration: InputDecoration(
                                        labelText: 'Código universitario',
                                        hintText:
                                            'Ingrese su código (10 dígitos)',
                                        prefixIcon: const Icon(Icons.person),
                                        border: const OutlineInputBorder(),
                                        // counterText: '10 dígitos',
                                        errorText: _usernameErrorText,
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        // LengthLimitingTextInputFormatter(10),
                                      ],
                                      // maxLength: 10,
                                      textInputAction: TextInputAction.next,
                                      onChanged: _validateUsername,
                                      onSubmitted: (_) {
                                        FocusScope.of(
                                          context,
                                        ).requestFocus(_passwordFocusNode);
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: _passwordController,
                                      focusNode: _passwordFocusNode,
                                      decoration: InputDecoration(
                                        labelText: 'Contraseña',
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                      obscureText: _obscurePassword,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (_) {
                                        if (status is! LoginLoading) {
                                          _login();
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: FilledButton(
                                        // style: FilledButton.styleFrom(
                                        //   shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.circular(
                                        //       8,
                                        //     ),
                                        //   ),
                                        // ),
                                        onPressed:
                                            status is LoginLoading
                                                ? null
                                                : _login,
                                        child:
                                            status is LoginLoading
                                                ? const SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                                : const Text('Ingresar'),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextButton.icon(
                                        onPressed: () {
                                          _showTroubleshootDialog(context);
                                        },
                                        label: const Text(
                                          'Tengo problemas para ingresar',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (status is LoginError)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    status.messageLevel1,
                                    style: const TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildFooter(context),
                  SizedBox(height: 10),
                ],
              ),
            ],
          );
        },
        listener: (context, state) {
          if (state.username.isNotEmpty &&
              _usernameController.text != state.username) {
            _usernameController.text = state.username;
          }
          if (state.password.isNotEmpty &&
              _passwordController.text != state.password) {
            _passwordController.text = state.password;
          }

          final status = state.status;

          switch (status) {
            // case LoginInitial:
            //   break;
            // case LoginLoading:
            //   break;
            case LoginSuccess():
              getIt<GoRouter>().pushReplacement('/');
              break;
            case LoginError():
              final LoginError(:messageLevel2, :messageLevel3) = status;
              final toastService = getIt<ToastService>();
              if (messageLevel3 != null) {
                toastService.show(messageLevel3);
              }
              if (messageLevel2 != null) {
                toastService.show(messageLevel2, isError: true);
              }
              break;
            default:
              break;
          }
        },
      ),
    );
  }

  Future<dynamic> _showTroubleshootDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dificultades para ingresar'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('1. Verifica que tu contraseña es correcta:'),
                const SizedBox(height: 4),
                FilledButton.icon(
                  onPressed: () {
                    launchUrl(
                      Uri.parse(Links.sigaWebAppUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Verificar en SIGA Web'),
                ),
                const SizedBox(height: 8),

                const Text('2. Si lo deseas, puedes cambiar tu contraseña:'),
                const SizedBox(height: 4),
                FilledButton.icon(
                  onPressed: () {
                    launchUrl(
                      Uri.parse(Links.resetPasswordUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Cambiar contraseña'),
                ),
                const SizedBox(height: 8),

                const Text(
                  '3. Si continúas con problemas, contacta al Centro de Informática y Telecomunicaciones (CIT):',
                ),
                const SizedBox(height: 4),
                FilledButton.icon(
                  onPressed: () {
                    launchUrl(
                      Uri.parse(Links.citGoogleMapsUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  icon: const Icon(Icons.location_on),
                  label: const Text('Ubicación del CIT'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
    final color = style.color?.withValues(alpha: 0.7);
    return DefaultTextStyle(
      style: style.copyWith(color: color),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12, // x
        runSpacing: 4, // y
        children: [
          GestureDetector(
            onTap: () {
              launchUrl(
                Uri.parse(Links.privacyPolicyUrl),
                mode: LaunchMode.externalApplication,
              );
            },
            child: Text('Política de privacidad'),
          ),
          GestureDetector(
            onTap: () {
              launchUrl(
                Uri.parse(Links.projectUrl),
                mode: LaunchMode.externalApplication,
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(MdiIcons.github, size: 16, color: color),
                const SizedBox(width: 4),
                const Text('Proyecto'),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              getIt<MailUtils>().launchEmail(
                context,
                email: Links.contactEmail,
                subject: 'Hola! [asunto]',
                body: 'Me comunico porque [agrega capturas de pantalla]',
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.email, size: 16, color: color),
                const SizedBox(width: 4),
                const Text('Contacto'),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              launchUrl(
                Uri.parse(Links.unpPeruGovernmentUrl),
                mode: LaunchMode.externalApplication,
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(MdiIcons.web, size: 16, color: color),
                const SizedBox(width: 4),
                const Text('gob.pe'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
