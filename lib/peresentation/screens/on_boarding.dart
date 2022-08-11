
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engez/constant.dart';
import 'package:engez/data/models/intro.dart';
import 'package:engez/data/provider/intro.dart';
import 'package:engez/peresentation/widgets/nav_bar.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletons/skeletons.dart';
import 'login.dart';

class OnBoardingPage extends ConsumerWidget {



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    final introController = ref.watch(splashFuture);
    const pageDecoration = PageDecoration(
      pageColor: Colors.white,
      fullScreen: true,
    );

    return Scaffold(
        body:
        // ChangeNotifierProvider<IntroProvider>(
        //     create: (_) => IntroProvider(),
        //     child: Consumer<IntroProvider>(
        //         builder: (buildContext, introProvider, _) {

      introController.slider.data!.length != 0
                 ?
      IntroductionScreen(
                      key: introController.introKey,
                      globalBackgroundColor: Colors.white,
                      pages: [
                        for (int i = 0;
                            i < introController.slider.data!.length;
                            i++)
                          PageViewModel(
                            title: '',
                            body: '',
                            image: _buildNetworkImage(
                                introController.slider.data![i].photo.toString(),context),
                            decoration: pageDecoration,
                          ),
                      ],
                      onDone: () => _onIntroEnd(context),
                      onSkip: () =>Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => BottomNavBar ()),
                      ) , // You can override onSkip callback
                      showSkipButton: true,
                     // skipFlex: 0,
                      nextFlex: 0,
                      //rtl: true, // Display as right-to-left
                      skip: Text('تخطي',
                          style: TextStyle(fontWeight: FontWeight.bold,color: dark)),
                      next: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: dark,
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                      done: Text('تم',
                          style: TextStyle(fontWeight: FontWeight.bold,color: dark)),

                      curve: Curves.fastLinearToSlowEaseIn,
                      controlsMargin: const EdgeInsets.all(16),
                      controlsPadding: kIsWeb
                          ? const EdgeInsets.all(12.0)
                          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                      dotsDecorator: const DotsDecorator(
                        size: Size(10.0, 10.0),
                        color: Color(0xFFBDBDBD),
                        activeColor: dark,
                        activeSize: Size(22.0, 10.0),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                      ),
                      dotsContainerDecorator: ShapeDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                    )
                  : Center(
                      child: Lottie.asset('assets/images/lf20_t7d0gynr.json',
                          height: 120, width: 120),
                    )
            );
  }
  void _onIntroEnd(context) {
    // LocalStorage.saveData(key: 'new_user', value: false);
    // LocalStorage.saveData(key: 'type', value: 0);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  Widget _buildNetworkImage(String assetName,context) {
   // return
    //   CachedNetworkImage(
    //   imageUrl: assetName,
    //   fit: BoxFit.fill,
    //   placeholder: (context, url) => SkeletonAvatar(
    //     style:  SkeletonAvatarStyle(
    //       width: MediaQuery.of(context).size.width,
    //       height: MediaQuery.of(context).size.height,
    //
    //     ),
    //   ),
    // );
    return Image.network(
      assetName,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.fill,
    );
  }
}
