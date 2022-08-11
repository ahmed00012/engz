import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:engez/data/models/order.dart';

import '../../constant.dart';

class OrderDetails extends StatefulWidget {
  Details orderDetail;
   OrderDetails({Key? key,required this.orderDetail}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;

    return Scaffold(

      appBar: AppBar(
        backgroundColor: dark,
        title: const Text('تفاصيل الطلب',
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
      body: Stack(
        children: [
          Container(
            height: he,
            child: SingleChildScrollView(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                 // width: we,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                   //   SizedBox(height: 30,),
                   //    Padding(
                   //      padding: const EdgeInsets.only(top: 24.0,right: 20),
                   //      child: Text('تفاصيل الطلب', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                   //    ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 20),
                        child: Text(widget.orderDetail.createdAt.toString(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color:kColorPrimary)),
                      ),
                      ListView.builder(
                        itemCount: widget.orderDetail.cart!.cartItems?.length??0,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),

                        itemBuilder: (BuildContext context, int index) {
                          return buildCartItemList(widget.orderDetail.cart!.cartItems![index]);
                        },
                      ),
                      SizedBox(height: size.height *.27,),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Padding(
              padding:
              EdgeInsets.only(bottom: 0),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: we,
                      padding:
                      EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          color: kColorAccent,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              topLeft: Radius.circular(50)
                          )
                      ),
                      //    height: size.height *.4,
                      //  alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: size.width * .19,
                                right: size.width * .16),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                 "#"+ widget.orderDetail.uuid.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * 0.03,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  'تفاصيل الفاتورة',
                                  style: TextStyle(
                                      color: kColorPrimary,
                                      fontSize: size.height * 0.026,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),

                      SizedBox(
                        height: size.height * .02,
                      ),

                          Padding(
                            padding: EdgeInsets.only(
                                left: size.width * .08,
                                right: size.width * .1),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.orderDetail.cart!.subTotal.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  'اجمالي الطلب',
                                  style: TextStyle(
                                      color: kColorPrimary,
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * .01,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: size.width * .08,
                                right: size.width * .07),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${widget.orderDetail.cart!.tax.toString()}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.02,
                                       fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  'الضريبة',
                                  style: TextStyle(
                                      color: kColorPrimary,
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                if(widget.orderDetail.cart!.discount!= null)
                          SizedBox(
                            height: size.height * .01,
                          ),
                          if(widget.orderDetail.cart!.discount!= null)
                          Padding(
                            padding: EdgeInsets.only(
                                left: size.width * .08,
                                right: size.width * .07),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${widget.orderDetail.cart!.discount.toString()}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  'الخصم',
                                  style: TextStyle(
                                      color: kColorPrimary,
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * .01,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: size.width * .08,
                                right: size.width * .07),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${widget.orderDetail.cart!.total}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.02,
                                        fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  'اجمالي الفاتورة',
                                  style: TextStyle(
                                      color: kColorPrimary,
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * .02,
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget buildCartItemList(CartItem items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5),
      child: Container(
        height: 120,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color:
                Colors.white
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 20,),
            Flexible(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                child: Image.network(items.products!.photo.toString(),
                  fit: BoxFit.fill,
                 // width: 100,
                  height: 100,
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: items.products!.title.toString().length > 20 ?40:20,
                    child: Text(items.products!.title.toString(),
                      style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("السعر  :",
                        style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2),
                        child: Text('${items.productPrice} جنيها ', style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),

                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("الكمية  :",
                        style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2),
                        child: Text('${items.productCount}', style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),

                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
