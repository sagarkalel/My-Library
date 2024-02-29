import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_library/shimmer_loadings/shimmer.dart';
import 'package:my_library/styles/components.dart';

class ViewBooksShimmer extends StatelessWidget {
  const ViewBooksShimmer({
    super.key,
    required this.itemCount,
    this.isScroll = false,
  });
  final int itemCount;
  final bool isScroll;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: itemCount,
        physics: isScroll
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return tile(context);
        });
  }

  Widget tile(context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, bottom: 10.h, right: 15.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 201, 224, 253),
          border: Border.all(
            color: Colors.black12,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x33000000),
              offset: Offset(4, 4),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerWidget.rectangular(
              height: 120,
              width: 90,
              baseColor: const Color.fromARGB(255, 203, 249, 181),
              highlightColor: Colors.grey.shade100,
            ),
            horGap(),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget.rectangular(
                  height: 15,
                  width: MediaQuery.of(context).size.width - 200.w,
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                ),
                SizedBox(
                  height: 10.h,
                ),
                ShimmerWidget.rectangular(
                  height: 15,
                  width: MediaQuery.of(context).size.width - 240.w,
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                ),
                SizedBox(
                  height: 10.h,
                ),
                ShimmerWidget.rectangular(
                  height: 15,
                  width: MediaQuery.of(context).size.width - 220.w,
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                ),
                SizedBox(
                  height: 10.h,
                ),
                ShimmerWidget.rectangular(
                  height: 15,
                  width: MediaQuery.of(context).size.width - 260.w,
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                ),
                SizedBox(
                  height: 10.h,
                ),
                ShimmerWidget.rectangular(
                  height: 15,
                  width: MediaQuery.of(context).size.width - 260.w,
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
