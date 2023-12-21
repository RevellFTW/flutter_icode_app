import '../helper/flutter_flow/flutter_flow_util.dart';
import '../helper/flutter_flow/form_field_controller.dart';
import '../screens/forms/patient_form_screen.dart' show PatientFormScreen;
import 'package:flutter/material.dart';

class PatientFormModel extends FlutterFlowModel<PatientFormScreen> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textFieldController1;
  String? Function(BuildContext, String?)? textFieldController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textFieldController2;
  String? Function(BuildContext, String?)? textFieldController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textFieldController3;
  String? Function(BuildContext, String?)? textFieldController3Validator;
  // State field(s) for CountController widget.
  int? countControllerValue;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textFieldController4;
  String? Function(BuildContext, String?)? textFieldController4Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode5;
  TextEditingController? textFieldController5;
  String? Function(BuildContext, String?)? textFieldController5Validator;
  // State field(s) for DropDown widget.
  List<dynamic>? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode1?.dispose();
    textFieldController1?.dispose();

    textFieldFocusNode2?.dispose();
    textFieldController2?.dispose();

    textFieldFocusNode3?.dispose();
    textFieldController3?.dispose();

    textFieldFocusNode4?.dispose();
    textFieldController4?.dispose();

    textFieldFocusNode5?.dispose();
    textFieldController5?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
