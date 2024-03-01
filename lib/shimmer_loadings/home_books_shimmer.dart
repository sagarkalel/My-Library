import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_library/shimmer_loadings/shimmer.dart';
import 'package:my_library/widgets/components.dart';

class HomeBooksShimmer extends StatelessWidget {
  const HomeBooksShimmer({
    super.key,
    required this.color,
    required this.itemCount,
  });
  final Color color;
  final int itemCount;
  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: [
    //     tile(
    //       context,
    //       color,
    //     ),
    //     verGap(),
    //     tile(
    //       context,
    //       color,
    //     ),
    //     verGap(),
    //     tile(
    //       context,
    //       color,
    //     ),
    //   ],
    // );

    return ListView.builder(
        shrinkWrap: true,
        itemCount: itemCount,
        padding: EdgeInsets.only(bottom: 10.h),
        itemBuilder: (_, index) {
          return tile(context, color);
        });
  }

  Widget tile(context, color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5),
      child: Container(
        padding:
            EdgeInsets.only(bottom: 6.h, left: 15.w, right: 15.w, top: 6.h),
        decoration: BoxDecoration(
            color: color,
            // color:Colors.amber.shade200,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(4, 4),
                  color: Colors.black.withOpacity(0.13),
                  blurRadius: 8)
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0.r),
              child: ShimmerWidget.rectangular(
                height: 80,
                width: 80,
                color: Colors.red.shade100,
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
              ),
            ),
            horGap(),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                ShimmerWidget.rectangular(
                  height: 10,
                  width: 150.w,
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                ),
                SizedBox(
                  height: 10.h,
                ),
                ShimmerWidget.rectangular(
                  height: 10,
                  width: 170.w,
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                ),
                SizedBox(
                  height: 10.h,
                ),
                ShimmerWidget.rectangular(
                  height: 10,
                  width: 100.w,
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                ),
                SizedBox(
                  height: 10.h,
                ),
                ShimmerWidget.rectangular(
                  height: 10,
                  width: 140.w,
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
