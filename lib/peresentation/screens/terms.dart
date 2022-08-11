
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engez/constant.dart';
import 'package:engez/data/provider/terms.dart';
import 'package:skeletons/skeletons.dart';


class TermsScreen extends ConsumerWidget {
  const TermsScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final contactProvider = ref.watch(termsFuture);
    return Scaffold(
        backgroundColor: Color(0xfff4f5fb),
        appBar: AppBar(
          backgroundColor: dark,
          title: Text('الشروط والاحكام',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight .bold,
                fontSize: 20
            ),
          ),
          centerTitle: true,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
        ),
        body:
        SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                contactProvider.terms.data != null
                    ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0),
                  child: Html(data: contactProvider.terms.data),
                )
                    : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0),
                  child: SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                        lines: 18,
                        spacing: 6,
                        lineStyle: SkeletonLineStyle(
                          randomLength: true,
                          height: 10,
                          borderRadius: BorderRadius.circular(8),
                          minLength:
                          MediaQuery.of(context).size.width /
                              3,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
