import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guarappwebfriday/functions/encode_data.dart';
import 'package:guarappwebfriday/screens/redirect_screen.dart';
import 'package:guarappwebfriday/widgets/app_bar.dart';
import 'package:guarappwebfriday/widgets/background_widget.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductScreen extends StatefulWidget
{
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
{
  ValueNotifier<int> disp = ValueNotifier<int>(0);
  ValueNotifier<int> amount = ValueNotifier<int>(0);

  ScrollController scrollcontroller = ScrollController();

  String milisec, checkoutID;
  bool isWeekend;

  Map<String, dynamic> checkoutMap;

  int sDay = 13, sMonth = 8, sYear = 2020;

  @override
  void initState()
  {
    milisec = DateTime.now().millisecondsSinceEpoch.toRadixString(32);

    super.initState();
  }

  Future<int> getLimit() async
  {
    DocumentSnapshot snap =  await Firestore.instance
        .collection("limits").document("years").collection(sYear.toString())
        .document("months").collection(sMonth < 10 ? '0${sMonth.toString()}'
        : sMonth.toString()).document(sDay < 10 ? '0${sDay.toString()}'
        : sDay.toString()).get();

    try
    {
      if(snap.exists)
      {
        int total = snap.data['limit'];
        int expected = snap.data['expected'];
        disp.value = total - expected;
        return disp.value >= 0 ? disp.value : 0;
      }
      else {disp.value = 600; return 600;}
    }
    catch(e){print(e);}
  }

  void openPaymentScreen(checkoutMap)
  {
    String day = EncodeData.ConvertDay(sDay);
    String month = EncodeData.ConvertMonth(sMonth);
    String year = EncodeData.ConvertYear(sYear);

    checkoutID = '$year$month${day}z${amount.value.toRadixString(16)}0g$milisec';
    print(checkoutID);
    checkoutMap = {
      "OrderNumber": checkoutID,
      "SoftDescriptor": "",
      "Cart":{
        "Discount":{
          "Type":"Percent",
          "Value":00
        },
        "Items":
        [
          {
            "Name": 'Ingresso Quinta Louca',
            "Description": 'Bilhete de Ingresso',
            "UnitPrice": 1500,
            "Quantity": amount.value,
            "Type":"Asset",
            "Sku":"",
            "Weight":0
          },
        ]
      },
      "Shipping":{
        "SourceZipCode":"",
        "TargetZipCode":"",
        "Type":"WithoutShippingPickUp",
        "Services":[],
        "Address":{
          "Street":"",
          "Number":"",
          "Complement":"",
          "District":"",
          "City":"",
          "State":""
        }
      },
      "Payment":{
        "BoletoDiscount":0,
        "DebitDiscount":0,
        "Installments":null,
        "MaxNumberOfInstallments": null
      },
      "Customer":{
        "Identity":"",
        "FullName":"",
        "Email":"",
        "Phone":""
      },
      "Options":{
        "AntifraudEnabled":true,
        "ReturnUrl": ""
      },
      "Settings":null
    };

    Navigator.of(context).push(MaterialPageRoute
      (builder: (context) => RedirectScreen(checkoutMap)));
  }

  Widget _buildAmountPicker(int limit)
  {
    return Container
      (
      decoration: BoxDecoration
        (
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white
      ),
      child: Row
        (
        children: <Widget>
        [
          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('Quantidade', style: TextStyle(fontSize: 16))),
          Expanded(child: Container()),
          Row
            (
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>
            [
              IconButton
                (
                padding: EdgeInsets.symmetric(horizontal: 5),
                iconSize: 40,
                icon: Icon(Icons.arrow_left, color: Colors.blue,),
                onPressed: ()
                {
                  if(amount.value > 0) amount.value--;
                },
              ),

              Container
                (
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: ValueListenableBuilder
                  (
                  valueListenable: amount,
                  builder: (context, value, child)
                  {
                    return Text(value.toString(), style: TextStyle(fontSize: 18));
                  },
                ),
              ),

              IconButton
                (
                padding: EdgeInsets.symmetric(horizontal: 5),
                iconSize: 40,
                icon: Icon(Icons.arrow_right, color: Colors.blue,),
                onPressed: ()
                {
                  if(amount.value < 15 && amount.value < limit)
                    amount.value++;
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLimit(String limit)
  {
    return Container
    (
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration
      (
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue, width: 2),
        color: Colors.white
      ),
      child: Row
        (
        children:
        [
          Text("Ingressos disponíveis:"),
          Expanded(child: Container()),
          Text(limit)
        ],
      ),
    );
  }

  Widget buildPortrait(double height, double width, int limit)
  {
    return Container
      (
      height: height,
      child: SingleChildScrollView
        (
        physics: BouncingScrollPhysics(),
        child: Column
          (
          children:
          [
            Container
              (
                padding: EdgeInsets.only(left: 75, top: 25, right: 75),
                alignment: Alignment.center,
                child: Container
                  (
                  decoration: new BoxDecoration
                    (
                    boxShadow:
                    [
                      new BoxShadow
                        (
                        color: Colors.black38,
                        offset: Offset(-10, 10),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Stack
                    (
                    alignment: Alignment.center,
                    children:
                    [
                      Center(child: CircularProgressIndicator()),
                      AspectRatio
                        (
                        aspectRatio: 1,
                        child: ClipRRect
                          (
                          borderRadius: BorderRadius.circular(4),
                          child: FadeInImage.memoryNetwork
                            (
                            placeholder: kTransparentImage,
                            image: 'https://firebasestorage.googleapis.com/v0/b/guarapp-91591.appspot.com/o/Product%20Images%2FWhatsApp%20Image%202020-08-01%20at%2011.15.10.jpeg?alt=media&token=ddd8e6a5-e84d-4fe2-9031-befec79384ab',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ),
            Padding
              (
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Text('Ingresso Quinta Louca', style: TextStyle(fontSize: 35, fontFamily:
                'Fredoka', color: Colors.grey[600]), textAlign: TextAlign.center)
            ),
            Text('Bilhetes de Ingresso da Quinta Louca', style: TextStyle(fontSize: 25, fontFamily:
            'Fredoka', color: Colors.blueGrey[300]), textAlign: TextAlign.center),
            Padding
              (
              padding: EdgeInsets.symmetric(vertical: 100),
              child: Text('Dia escolhido: ${sDay < 10 ? '0${sDay.toString()}'
                  : sDay.toString()}/${sMonth < 10 ? '0${sMonth.toString()}'
                  : sMonth.toString()}/2020', style: TextStyle(fontSize: 25, fontFamily:
              'Fredoka', color: Colors.amber[600]), textAlign: TextAlign.center),
            ),
            Padding
              (
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: _buildLimit(limit.toString())
            ),
            Padding
            (
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
              child: _buildAmountPicker(limit)
            ),
            SizedBox(height: 10),
            ValueListenableBuilder
            (
              valueListenable: amount,
              builder: (context, value, child)
              {
                return FlatButton
                  (
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  disabledColor: Colors.blueGrey[100],
                  color: Colors.blue,
                  onPressed: value <= 0 ? null : () => openPaymentScreen(checkoutMap),
                  child: Container
                    (
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    height: 45,
                    width: width - 150,
                    child: Row
                      (
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:
                      [
                        Container(child: Text('Confirmar  ', style: TextStyle
                          (fontSize: 20, fontFamily: 'Fredoka', color: Colors.white))),
                        Container(child: Icon(Icons.check, size: 30, color: Colors.white))
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 75)
          ],
        ),
      ),
    );
  }

  Widget buildLandscape(width, limit)
  {
    double sized = 30;
    double height = MediaQuery.of(context).size.height - 90;
    double padding = 10;
    return Scrollbar
    (
      controller: scrollcontroller,
      isAlwaysShown: true,
      child: Padding
        (
        padding: EdgeInsets.fromLTRB(250, 25, padding, 25),
        child: SingleChildScrollView
          (
          physics: BouncingScrollPhysics(),
          child: Row
            (
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            [
              Container
                (
                alignment: Alignment.centerRight,
                width: width/2 - 200 - sized,
                child: Container
                  (
                    alignment: Alignment.center,
                    child: Container
                      (
                      decoration: new BoxDecoration
                        (
                        boxShadow:
                        [
                          new BoxShadow
                            (
                            color: Colors.black38,
                            offset: Offset(-10, 10),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Stack
                        (
                        alignment: Alignment.center,
                        children:
                        [
                          Center(child: CircularProgressIndicator()),
                          AspectRatio
                            (
                            aspectRatio: 1,
                            child: ClipRRect
                              (
                              borderRadius: BorderRadius.circular(4),
                              child: FadeInImage.memoryNetwork
                                (
                                placeholder: kTransparentImage,
                                image: 'https://firebasestorage.googleapis.com/v0/b/guarapp-91591.appspot.com/o/Product%20Images%2FWhatsApp%20Image%202020-08-01%20at%2011.15.10.jpeg?alt=media&token=ddd8e6a5-e84d-4fe2-9031-befec79384ab',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ),
              SizedBox(width: 60),
              Container
                (
                  alignment: Alignment.centerRight,
                  width: width/3 - padding - sized,
                  height: height,
                  child: SingleChildScrollView
                    (
                    controller: scrollcontroller,
                    child: Column
                      (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:
                        [
                          Padding
                            (
                              padding: EdgeInsets.symmetric(vertical: 25),
                              child: Text('Ingresso Quinta Louca', style: TextStyle(fontSize: 40, fontFamily:
                              'Fredoka', color: Colors.grey[600]), textAlign: TextAlign.center)
                          ),
                          Text('Bilhete de Ingresso para a Quinta Louca', style: TextStyle(fontSize: 25, fontFamily:
                          'Fredoka', color: Colors.blueGrey[300]), textAlign: TextAlign.center),
                          Padding
                            (
                            padding: EdgeInsets.symmetric(vertical: 100),
                            child: Text('Dia escolhido: ${sDay < 10 ? '0${sDay.toString()}'
                                : sDay.toString()}/${sMonth < 10 ? '0${sMonth.toString()}'
                                : sMonth.toString()}/2020', style: TextStyle(fontSize: 25, fontFamily:
                            'Fredoka', color: Colors.amber[600]), textAlign: TextAlign.center)                          ),
                          _buildLimit(limit.toString()),
                          _buildAmountPicker(limit),
                          SizedBox(height: 10),
                          ValueListenableBuilder
                            (
                            valueListenable: amount,
                            builder: (context, value, child)
                            {
                              return FlatButton
                                (
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                disabledColor: Colors.blueGrey[100],
                                color: Colors.blue,
                                onPressed: value <= 0 ? null : () => openPaymentScreen(checkoutMap),
                                child: Container
                                  (
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(5),
                                  height: 45,
                                  width: width - 150,
                                  child: Row
                                    (
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:
                                    [
                                      Container(child: Text('Confirmar  ', style: TextStyle
                                        (fontSize: 20, fontFamily: 'Fredoka', color: Colors.white))),
                                      Container(child: Icon(Icons.check, size: 30, color: Colors.white))
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        ]
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold
      (
        appBar: appBar(width, context),
        body: FutureBuilder
        (
          future: getLimit(),
          builder: (context, snapshot)
          {
            if(snapshot.connectionState != ConnectionState.done)
              return Center(child: CircularProgressIndicator());
            else
            {
              int limit = snapshot.data;
              return OrientationBuilder
                (
                builder: (context, orientation)
                {
                  bool isPortrait = (orientation == Orientation.portrait);
                  return Stack
                    (
                    children:
                    [
                      backgroundWidget(height, isPortrait),
                      isPortrait ? buildPortrait(height, width, limit) : buildLandscape(width, limit)
                    ],
                  );
                },
              );
            }
          },
        )
    );
  }
}
