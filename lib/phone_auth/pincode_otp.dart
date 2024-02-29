import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/styles/components.dart';
import 'package:my_library/styles/styles.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpPincode extends StatefulWidget {
  const OtpPincode({
    super.key,
    required this.onChange,
    required this.pinCodeController,
  });
  final Function(String) onChange;
  final TextEditingController pinCodeController;

  @override
  State<OtpPincode> createState() => _OtpPincodeState();
}

class _OtpPincodeState extends State<OtpPincode> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 50.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          verGap(),
          PinCodeTextField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            appContext: context,
            length: 6,
            keyboardType: TextInputType.number,
            autoFocus: true,
            textStyle: GoogleFonts.poppins(
              color: const Color(0xFF303B4F),
              fontSize: 28,
              fontWeight: FontWeight.w400,
            ),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            enableActiveFill: true,
            showCursor: true,
            cursorColor: Colors.blueGrey,
            obscureText: false,
            focusNode: _focusNode,
            hintCharacter: '﹡',
            hintStyle: Styles.textfildHint,
            pinTheme: PinTheme(
              fieldHeight: 56.r,
              fieldWidth: 56.r,
              borderWidth: 2.w,
              borderRadius: BorderRadius.circular(15.r),
              shape: PinCodeFieldShape.box,
              // errorBorderColor: Colors.redAccent,
              activeColor: Colors.orange.shade100,
              activeFillColor: Colors.orange.shade50,
              inactiveFillColor: Colors.orange.shade50,
              selectedFillColor: Colors.orange.shade100,
              inactiveColor: Colors.orange.shade100,
              selectedColor: Colors.orange.shade200,
            ),
            onChanged: widget.onChange,
            controller: widget.pinCodeController,
            onCompleted: (value) async {
              _focusNode.unfocus();
            },
          ),
          verGap(),
        ],
      ),
    );
  }
}
