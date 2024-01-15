import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/auth_screens/welcome.dart';
import 'package:todoapp/components/components.dart';
import 'package:todoapp/global/variables.dart';
import 'package:todoapp/helper/firestore_helper.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_animations.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_button_tabbar.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_model.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_theme.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_util.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_widgets.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/event_log.dart';
import 'package:todoapp/models/patient.dart';
import 'package:todoapp/screens/home_page.dart';
import 'package:todoapp/screens/tasks_and_logs/event_log_screen.dart';

import 'new_login_model.dart';
export 'new_login_model.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);
  static String id = 'auth_widget';

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> with TickerProviderStateMixin {
  late AuthModel _model;
  bool loading = true;
  bool _saving = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 1.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 400.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 400.ms,
          begin: const Offset(0, 80),
          end: const Offset(0, 0),
        ),
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 150.ms,
          duration: 400.ms,
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
        ),
      ],
    ),
    'columnOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 300.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: const Offset(0, 20),
          end: const Offset(0, 0),
        ),
      ],
    ),
    'columnOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 300.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: const Offset(0, 20),
          end: const Offset(0, 0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    if (!firstLogin) {
      Future.microtask(() {
        checkUserType(context);
      });
    }

    super.initState();
    _model = createModel(context, () => AuthModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
    _model.emailAddressController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    _model.userNameController ??= TextEditingController();
    _model.userNameFocusNode ??= FocusNode();

    _model.emailAddressCreateController ??= TextEditingController();
    _model.emailAddressCreateFocusNode ??= FocusNode();

    _model.passwordCreateController ??= TextEditingController();
    _model.passwordCreateFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading && !firstLogin) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(32),
                child: Container(
                  width: double.infinity,
                  height: 230,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 72),
                    child: Text(
                      'CuramusApp',
                      style: FlutterFlowTheme.of(context).displaySmall,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, -1),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 170, 0, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.sizeOf(context).width >= 768.0
                                ? 530.0
                                : 630.0,
                            constraints: const BoxConstraints(
                              maxWidth: 570,
                            ),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x33000000),
                                  offset: Offset(0, 2),
                                )
                              ],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 24, 0, 0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: const Alignment(0, 0),
                                    child: FlutterFlowButtonTabBar(
                                      useToggleButtonStyle: true,
                                      isScrollable: true,
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .titleMedium,
                                      unselectedLabelStyle: const TextStyle(),
                                      labelColor: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      unselectedLabelColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryText,
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      unselectedBackgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .alternate,
                                      borderColor: FlutterFlowTheme.of(context)
                                          .alternate,
                                      borderWidth: 2,
                                      borderRadius: 12,
                                      elevation: 0,
                                      labelPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              32, 0, 32, 0),
                                      tabs: const [
                                        Tab(
                                          text: 'Sign In',
                                        ),
                                        Tab(
                                          text: 'Sign Up As Patient',
                                        ),
                                      ],
                                      controller: _model.tabBarController,
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      controller: _model.tabBarController,
                                      children: [
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, -1),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(24, 16, 24, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (responsiveVisibility(
                                                  context: context,
                                                  phone: false,
                                                  tablet: false,
                                                ))
                                                  Container(
                                                    width: 230,
                                                    height: 16,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                  ),
                                                Text(
                                                  'Welcome Back',
                                                  textAlign: TextAlign.start,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .headlineMedium,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          0, 4, 0, 24),
                                                  child: Text(
                                                    'Enter your details below.',
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          8, 0, 8, 16),
                                                  child: TextFormField(
                                                    controller: _model
                                                        .emailAddressController,
                                                    focusNode: _model
                                                        .emailAddressFocusNode,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .sentences,
                                                    obscureText: false,
                                                    onChanged: (value) {
                                                      if (value.isNotEmpty &&
                                                          value.contains('@') &&
                                                          value.contains('.') &&
                                                          value !=
                                                              _model
                                                                  .emailAddressController
                                                                  .text) {
                                                        _model
                                                            .emailAddressController
                                                            .text = value;
                                                      }
                                                    },
                                                    onFieldSubmitted:
                                                        (value) async {
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                      setState(() {
                                                        _saving = true;
                                                      });
                                                      try {
                                                        await auth.signInWithEmailAndPassword(
                                                            email: _model
                                                                .emailAddressController
                                                                .text,
                                                            password: _model
                                                                .passwordController
                                                                .text);

                                                        if (context.mounted) {
                                                          setState(() {
                                                            _saving = false;
                                                            Navigator
                                                                .popAndPushNamed(
                                                                    context,
                                                                    AuthWidget
                                                                        .id);
                                                          });
                                                          Navigator.pushNamed(
                                                              context,
                                                              WelcomeScreen.id);
                                                        }
                                                      } catch (e) {
                                                        // ignore: use_build_context_synchronously
                                                        signUpAlert(
                                                          context: context,
                                                          onPressed: () {
                                                            setState(() {
                                                              _saving = false;
                                                            });
                                                            Navigator
                                                                .popAndPushNamed(
                                                                    context,
                                                                    AuthWidget
                                                                        .id);
                                                          },
                                                          title:
                                                              'WRONG PASSWORD OR EMAIL',
                                                          desc:
                                                              'Confirm your email and password and try again',
                                                          btnText: 'Try Now',
                                                        ).show();
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Email',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium,
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent4,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium,
                                                    validator: _model
                                                        .emailAddressControllerValidator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          8, 0, 8, 16),
                                                  child: TextFormField(
                                                    onChanged: (value) {
                                                      if (value.isNotEmpty &&
                                                          value !=
                                                              _model
                                                                  .passwordController
                                                                  .text) {
                                                        _model
                                                            .passwordController
                                                            .text = value;
                                                      }
                                                    },
                                                    onFieldSubmitted:
                                                        (value) async {
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                      setState(() {
                                                        _saving = true;
                                                      });
                                                      try {
                                                        await auth.signInWithEmailAndPassword(
                                                            email: _model
                                                                .emailAddressController
                                                                .text,
                                                            password: _model
                                                                .passwordController
                                                                .text);

                                                        if (context.mounted) {
                                                          setState(() {
                                                            _saving = false;
                                                            Navigator
                                                                .popAndPushNamed(
                                                                    context,
                                                                    AuthWidget
                                                                        .id);
                                                          });
                                                          Navigator.pushNamed(
                                                              context,
                                                              WelcomeScreen.id);
                                                        }
                                                      } catch (e) {
                                                        // ignore: use_build_context_synchronously
                                                        signUpAlert(
                                                          context: context,
                                                          onPressed: () {
                                                            setState(() {
                                                              _saving = false;
                                                            });
                                                            Navigator
                                                                .popAndPushNamed(
                                                                    context,
                                                                    AuthWidget
                                                                        .id);
                                                          },
                                                          title:
                                                              'WRONG PASSWORD OR EMAIL',
                                                          desc:
                                                              'Confirm your email and password and try again',
                                                          btnText: 'Try Now',
                                                        ).show();
                                                      }
                                                    },
                                                    controller: _model
                                                        .passwordController,
                                                    focusNode: _model
                                                        .passwordFocusNode,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .sentences,
                                                    obscureText: !_model
                                                        .passwordVisibility,
                                                    decoration: InputDecoration(
                                                      labelText: 'Password',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium,
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent4,
                                                      suffixIcon: InkWell(
                                                        onTap: () => setState(
                                                          () => _model
                                                                  .passwordVisibility =
                                                              !_model
                                                                  .passwordVisibility,
                                                        ),
                                                        focusNode: FocusNode(
                                                            skipTraversal:
                                                                true),
                                                        child: Icon(
                                                          _model.passwordVisibility
                                                              ? Icons
                                                                  .visibility_outlined
                                                              : Icons
                                                                  .visibility_off_outlined,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium,
                                                    validator: _model
                                                        .passwordControllerValidator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0, 0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            0, 0, 0, 16),
                                                    child: FFButtonWidget(
                                                      onPressed: () async {
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                        setState(() {
                                                          _saving = true;
                                                        });
                                                        try {
                                                          await auth.signInWithEmailAndPassword(
                                                              email: _model
                                                                  .emailAddressController
                                                                  .text,
                                                              password: _model
                                                                  .passwordController
                                                                  .text);

                                                          if (context.mounted) {
                                                            setState(() {
                                                              _saving = false;
                                                              Navigator
                                                                  .popAndPushNamed(
                                                                      context,
                                                                      AuthWidget
                                                                          .id);
                                                            });
                                                            Navigator.pushNamed(
                                                                context,
                                                                WelcomeScreen
                                                                    .id);
                                                          }
                                                        } catch (e) {
                                                          // ignore: use_build_context_synchronously
                                                          signUpAlert(
                                                            context: context,
                                                            onPressed: () {
                                                              setState(() {
                                                                _saving = false;
                                                              });
                                                              Navigator
                                                                  .popAndPushNamed(
                                                                      context,
                                                                      AuthWidget
                                                                          .id);
                                                            },
                                                            title:
                                                                'WRONG PASSWORD OR EMAIL',
                                                            desc:
                                                                'Confirm your email and password and try again',
                                                            btnText: 'Try Now',
                                                          ).show();
                                                        }
                                                      },
                                                      text: 'Sign In',
                                                      options: FFButtonOptions(
                                                        width: 230,
                                                        height: 52,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                0, 0, 0, 0),
                                                        iconPadding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                0, 0, 0, 0),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                        elevation: 3,
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ).animateOnPageLoad(animationsMap[
                                                'columnOnPageLoadAnimation1']!),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, -1),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(24, 16, 24, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (responsiveVisibility(
                                                  context: context,
                                                  phone: false,
                                                  tablet: false,
                                                ))
                                                  Container(
                                                    width: 230,
                                                    height: 16,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                  ),
                                                Text(
                                                  'Welcome Back',
                                                  textAlign: TextAlign.start,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .headlineMedium,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          0, 4, 0, 24),
                                                  child: Text(
                                                    'Let\'s get started by filling out the form below.',
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          8, 0, 8, 16),
                                                  child: TextFormField(
                                                    controller: _model
                                                        .userNameController,
                                                    focusNode: _model
                                                        .userNameFocusNode,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .sentences,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelText: 'Username',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium,
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent4,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium,
                                                    validator: _model
                                                        .userNameControllerValidator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          8, 0, 8, 16),
                                                  child: TextFormField(
                                                    controller: _model
                                                        .emailAddressCreateController,
                                                    focusNode: _model
                                                        .emailAddressCreateFocusNode,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .sentences,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelText: 'Email',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium,
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent4,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium,
                                                    validator: _model
                                                        .emailAddressCreateControllerValidator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          8, 0, 8, 16),
                                                  child: TextFormField(
                                                    controller: _model
                                                        .passwordCreateController,
                                                    focusNode: _model
                                                        .passwordCreateFocusNode,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .sentences,
                                                    obscureText: !_model
                                                        .passwordCreateVisibility,
                                                    decoration: InputDecoration(
                                                      labelText: 'Password',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium,
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent4,
                                                      suffixIcon: InkWell(
                                                        onTap: () => setState(
                                                          () => _model
                                                                  .passwordCreateVisibility =
                                                              !_model
                                                                  .passwordCreateVisibility,
                                                        ),
                                                        focusNode: FocusNode(
                                                            skipTraversal:
                                                                true),
                                                        child: Icon(
                                                          _model.passwordCreateVisibility
                                                              ? Icons
                                                                  .visibility_outlined
                                                              : Icons
                                                                  .visibility_off_outlined,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          size: 24,
                                                        ),
                                                      ),
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium,
                                                    validator: _model
                                                        .passwordCreateControllerValidator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0, 0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            0, 0, 0, 16),
                                                    child: FFButtonWidget(
                                                      onPressed: () async {
                                                        //todo
                                                      },
                                                      text: 'Sign Up',
                                                      options: FFButtonOptions(
                                                        width: 230,
                                                        height: 52,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                0, 0, 0, 0),
                                                        iconPadding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                0, 0, 0, 0),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                        elevation: 3,
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ).animateOnPageLoad(animationsMap[
                                                'columnOnPageLoadAnimation2']!),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation']!),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkUserType(BuildContext context) async {
    relative = null;
    bool isBackOffice = false;
    bool isPatient = false;
    bool isRelative = false;
    final user = auth.currentUser;
    DocumentSnapshot<Map<String, dynamic>>? userData;
    Map<String, dynamic>? data;
    if (user != null) {
      userData = await db.collection('users').doc(user.uid).get();

      if (userData.exists) {
        data = userData.data() as Map<String, dynamic>;
        if (data['approved'] == true) {
          switch (data['role']) {
            case 'back-office':
              {
                isBackOffice = true;
                break;
              }
            case 'patient':
              {
                isPatient = true;
              }
            case 'relative':
              {
                isRelative = true;
              }
          }
        }
      } else {
        Navigator.pushNamed(context, AuthWidget.id);
      }
      if (isBackOffice) {
        back_office = true;
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
      if (isRelative) {
        relative = await getRelativeFromDb(data!['roleId'].toString());
        List<Patient> patients = [];
        _loadPatientData().then((value) {
          if (mounted) {
            setState(() {
              patients = value;
            });
          }
        });
        Patient patient =
            patients.where((i) => i.relatives.contains(relative)).first;
        List<EventLog> eventLogs =
            await loadEventLogsFromFirestore(patient.id, Caller.patient);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => EventLogScreen(
                    eventLogs: eventLogs,
                    patient: patient,
                    eventLogName: "${patient.name} Patient's Log ",
                    caller: Caller.patient,
                    isRelative: isRelative,
                  )),
        );
      }
      if (isPatient) {
        Patient patient = await getPatientFromDb(data!['roleId'].toString());
        List<EventLog> eventLogs =
            await loadEventLogsFromFirestore(patient.id, Caller.patient);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => EventLogScreen(
                    eventLogs: eventLogs,
                    patient: patient,
                    eventLogName: "${patient.name} Patient's Log ",
                    caller: Caller.patient,
                    isRelative: isRelative,
                  )),
        );
      }
      setState(() {
        loading = false;
      });
    }
  }

  Future<List<Patient>> _loadPatientData() async {
    // Load the data asynchronously
    final data = await loadPatientsFromFirestore();

    // Return the loaded data
    return data;
  }
}
