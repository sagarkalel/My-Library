import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:my_library/screens/home_page/home_page.dart';
import '../styles/components.dart';

class Registered extends StatefulWidget {
  const Registered({Key? key});

  @override
  State<Registered> createState() => _RegisteredState();
}

class _RegisteredState extends State<Registered>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 2200)).then(
      (value) {
        navigateScaleUntil(context, const HomePage());
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "saved_data",
      child: Scaffold(
        backgroundColor: Colors.orange.shade100,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/images/successfully_registered.json',
              ),
              verGap(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                child: FadeTransition(
                  opacity: _animation,
                  child: Text(
                    'User successfully registered',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lora(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
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
}
