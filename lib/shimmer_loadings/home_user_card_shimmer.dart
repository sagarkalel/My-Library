import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_library/shimmer_loadings/shimmer.dart';
import 'package:shimmer/shimmer.dart';

class HomeUserCardShimmer extends StatelessWidget {
  const HomeUserCardShimmer({
    super.key,
    required this.itemCount,
  });
  final int itemCount;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: 10.0.h, right: index == itemCount - 1 ? 0 : 10.w),
            child: tile(context),
          );
        });
  }

  Widget tile(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 5.w),
          decoration: BoxDecoration(
              // color: const Color.fromARGB(255, 244, 252, 255),
              color: Colors.blue.shade100,
              // color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(6, 6),
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6)
              ]),
          child: Column(
            children: [
              SizedBox(
                height: 8.h,
              ),
              Shimmer.fromColors(
                baseColor: Colors.orange.shade100,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 110.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShimmerWidget.rectangular(
                    height: 20,
                    width: 150.w,
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  ShimmerWidget.rectangular(
                    height: 15,
                    width: 70.w,
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              ShimmerWidget.rectangular(
                height: 10,
                width: 150.w,
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade100,
              ),
              SizedBox(
                height: 8.h,
              ),
              ShimmerWidget.rectangular(
                height: 10,
                width: 150.w,
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade100,
              ),
              SizedBox(
                height: 21.h,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
