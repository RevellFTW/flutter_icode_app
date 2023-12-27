import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todoapp/global/variables.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_icon_button.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function onBackPressed;

  const CustomAppBar({
    required this.title,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: AppBar(
        backgroundColor: appBackgroundColor,
        foregroundColor: appForegroundColor,
        automaticallyImplyLeading: false,
        actions: const [],
        flexibleSpace: FlexibleSpaceBar(
          title: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 14),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: Align(
                          alignment: const AlignmentDirectional(0.00, 0.00),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 8, 0, 0),
                            child: Text(
                              'CuramusApp',
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12, 0, 0, 0),
                            child: Container(
                              width: 60, // Adjust these values as needed
                              height: 60, // Adjust these values as needed
                              child: const FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 50,
                                borderWidth: 1,
                                buttonSize: 50,
                                icon: Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            onBackPressed();
                          },
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                4, 0, 0, 0),
                            child: Text(
                              title,
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
          expandedTitleScale: 1.0,
        ),
        elevation: 2,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
