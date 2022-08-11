
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engez/data/provider/departments_controller.dart';
import 'package:engez/data/provider/products_controller.dart';
import 'package:engez/peresentation/screens/products.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletons/skeletons.dart';

import '../../constant.dart';

class DepartmentsScreen extends ConsumerWidget {
  String ? name;
  int? categoryID;
  DepartmentsScreen({this.name,this.categoryID});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departmentController = ref.watch(departmentsFuture);
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark ,
        title: Text(
          "الاقسام",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: Skeleton(
        isLoading: departmentController.loading,
        skeleton: GridView.builder(
          itemCount:5,
          // shrinkWrap: true,
          //   physics: NeverScrollableScrollPhysics(),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.77),
          itemBuilder: (context, i) {
          return SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: we /2,
              height: he * .16,
              //height: he * .16,
              padding:  const EdgeInsets.symmetric(
                  vertical: 5.0, horizontal: 5),
            ),

          );
        },),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            header: WaterDropHeader(),
            controller: departmentController.refreshController,
            onLoading: departmentController.onLoading,
            child:   Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GridView.builder(
                itemCount:departmentController.subcategories.length,
               // shrinkWrap: true,
           //   physics: NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.77),
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {
                      // DepartmentsController.categoryID =  homeController.home
                      //     .department![index]
                      //     .id;

                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(
                      //     builder: (context) {
                      //       return Products(company: 1,subCategory: "مكياج");}));

                      ProductsController.subCategoryID =  departmentController.subcategories[i]
                          .id;
                      if(ProductsController.subCategoryID != null)
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return Products(subCategory:departmentController.subcategories[i]
                              .title??'');
                        }));

                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(
                      //     builder: (context) {
                      //       return DepartmentsScreen(
                      //         name: homeController.home
                      //             .department![index]
                      //             .name??'',
                      //         categoryID:  homeController.home
                      //             .department![index]
                      //             .id,);
                      //     })).then((value) => homeController. refresh());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: he * .17,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: we * .38,
                                  height: he * .38,
                                  decoration: BoxDecoration(
                                    // image: DecorationImage(
                                    //   image: AssetImage(
                                    //       "assets/images/pngwing.com.png"),
                                    //   fit: BoxFit.fill,
                                    //
                                    // ),

                                      shape: BoxShape.circle,
                                      color:dark.withOpacity(.1)),
                                ),
                                CachedNetworkImage(
                                  imageUrl: departmentController.subcategories[i].image!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => SkeletonAvatar(
                                    style:  SkeletonAvatarStyle(
                                      //    width: we - 20,
                                      height: he * .09,
                                      // padding:  const EdgeInsets.symmetric(
                                      //     vertical: 5.0, horizontal: 5),
                                    ),
                                  ),
                                ),
                                // Image.asset(
                                //   slider[index]["image"].toString(),
                                //   height: he * .09,
                                //   fit: BoxFit.cover,
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(height: he * .02,),
                          Text(
                            departmentController.subcategories[i].title! ,
                            style: TextStyle(
                              fontSize: we * .045,

                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
