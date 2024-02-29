import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/styles/styles.dart';

import '../styles/components.dart';

class PhoneInputContainer extends StatefulWidget {
  const PhoneInputContainer(
      {super.key,
      required this.onChanged,
      required this.onSend,
      required this.firstSend,
      required this.start,
      required this.lengthOfNum,
      required this.controller});
  final Function(String) onChanged;
  final void Function()? onSend;
  final bool firstSend;
  final int start;
  final int lengthOfNum;
  final TextEditingController controller;

  @override
  State<PhoneInputContainer> createState() => _PhoneInputContainerState();
}

class _PhoneInputContainerState extends State<PhoneInputContainer> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 50.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.grey,
          width: 1.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                showCountryPicker(
                    context: context,
                    countryListTheme:
                        CountryListThemeData(bottomSheetHeight: 510.h),
                    onSelect: (value) {
                      setState(() {
                        selectedCountryCode = value;
                      });
                    });
              },
              child: Text(
                "${selectedCountryCode.flagEmoji} + ${selectedCountryCode.phoneCode}",
                style: Styles.textfild,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: TextField(
                onEditingComplete: () async {
                  _focusNode.unfocus();
                },
                autofocus: !widget.firstSend,
                controller: widget.controller,
                onChanged: widget.onChanged,
                readOnly: widget.firstSend,
                cursorColor: Colors.orange,
                style: Styles.textfild,
                decoration: InputDecoration(
                  filled: true,
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                  // contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  hintText: '1234567890',
                  hintStyle: Styles.textfildHint,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10)
                ],
                keyboardType: TextInputType.phone,
              ),
            ),
            InkWell(
              onTap: widget.onSend,
              child: Text(
                widget.firstSend == false ? '' : 'Resend',
                style: GoogleFonts.lora(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: (widget.start == 59 || widget.start == 0) &&
                            widget.lengthOfNum == 10
                        ? const Color.fromARGB(255, 244, 137, 30)
                        : Colors.grey.shade400),
              ),
            )
          ],
        ),
      ),
    );
  }

  final List<Country> supportedCountries = [
    Country(
        phoneCode: "91",
        countryCode: "IN",
        e164Sc: 0,
        geographic: true,
        level: 1,
        name: "India",
        example: "India",
        displayName: "India",
        displayNameNoCountryCode: "IN",
        e164Key: ""),
    Country(
        phoneCode: "44",
        countryCode: "UK",
        e164Sc: 44,
        geographic: true,
        level: 1,
        name: "UK",
        example: "UK",
        displayName: "UK",
        displayNameNoCountryCode: "UK",
        e164Key: "91"),
  ];
  final Country _selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");

  Widget selectCountryDropDown() {
    return DropdownButton<Country>(
      onChanged: (country) {},
      value: _selectedCountry,
      items: supportedCountries.map<DropdownMenuItem<Country>>((Country e) {
        return DropdownMenuItem<Country>(
            child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${e.flagEmoji} ${e.name}"),
          ],
        ));
      }).toList(),
    );
  }
}
