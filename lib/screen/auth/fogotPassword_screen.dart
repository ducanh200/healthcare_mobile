import 'package:flutter/material.dart';

class FogotPasswordScreeen extends StatelessWidget{
  const FogotPasswordScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar:
      AppBar(
        elevation:0,
        centerTitle:false,
        automaticallyImplyLeading: false,
        backgroundColor:Color(0x00ffffff),
        shape:RoundedRectangleBorder(
          borderRadius:BorderRadius.zero,
        ),
        title:Text(
          "Change Password",
          style:TextStyle(
            fontWeight:FontWeight.w700,
            fontStyle:FontStyle.normal,
            fontSize:20,
            color:Color(0xff000000),
          ),
        ),
        leading: Icon(
          Icons.arrow_back_ios,
          color:Color(0xff212435),
          size:24,
        ),
      ),
      body:Padding(
        padding:EdgeInsets.symmetric(vertical: 0,horizontal:16),
        child:SingleChildScrollView(
          child:
          Column(
            mainAxisAlignment:MainAxisAlignment.start,
            crossAxisAlignment:CrossAxisAlignment.center,
            mainAxisSize:MainAxisSize.max,
            children: [
              ///***If you have exported images you must have to copy those images in assets/images directory.
              Image.network(
                "https://doccure.dreamstechnologies.com/mobile/framework7/template-rtl/assets/img/register-top-img.png",
                height:200,
                width:200,
                fit:BoxFit.cover,
              ),
              ///***If you have exported images you must have to copy those images in assets/images directory.
              Image.network(
                "https://doccure.dreamstechnologies.com/html/template/assets/img/logo.png",
                width:150,
                fit:BoxFit.contain,
              ),

              Text(
                "Enter your email address you registered with and will we send you a unique  verification code",
                textAlign: TextAlign.center,
                overflow:TextOverflow.clip,
                style:TextStyle(
                  fontWeight:FontWeight.w400,
                  fontStyle:FontStyle.normal,
                  fontSize:14,
                  color:Color(0xff696767),
                ),
              ),
              Padding(
                padding:EdgeInsets.symmetric(vertical: 30,horizontal:0),
                child:TextField(
                  controller:TextEditingController(),
                  obscureText:false,
                  textAlign:TextAlign.start,
                  maxLines:1,
                  style:TextStyle(
                    fontWeight:FontWeight.w400,
                    fontStyle:FontStyle.normal,
                    fontSize:14,
                    color:Color(0xff000000),
                  ),
                  decoration:InputDecoration(
                    disabledBorder:OutlineInputBorder(
                      borderRadius:BorderRadius.circular(30.0),
                      borderSide:BorderSide(
                          color:Color(0xff696767),
                          width:1.5
                      ),
                    ),
                    focusedBorder:OutlineInputBorder(
                      borderRadius:BorderRadius.circular(30.0),
                      borderSide:BorderSide(
                          color:Color(0xff696767),
                          width:1.5
                      ),
                    ),
                    enabledBorder:OutlineInputBorder(
                      borderRadius:BorderRadius.circular(30.0),
                      borderSide:BorderSide(
                          color:Color(0xff696767),
                          width:1.5
                      ),
                    ),
                    hintText:"Your Email ",
                    hintStyle:TextStyle(
                      fontWeight:FontWeight.w400,
                      fontStyle:FontStyle.normal,
                      fontSize:14,
                      color:Color(0xff696767),
                    ),
                    filled:true,
                    fillColor:Color(0x00ffffff),
                    isDense:false,
                    contentPadding:EdgeInsets.symmetric(vertical: 8,horizontal:12),
                    suffixIcon:Icon(Icons.mail,color:Color(0xff212435),size:24),
                  ),
                ),
              ),
              MaterialButton(
                onPressed:(){},
                color:Color(0xff3a57e8),
                elevation:0,
                shape:RoundedRectangleBorder(
                  borderRadius:BorderRadius.circular(30.0),
                ),
                padding:EdgeInsets.all(16),
                child:Text("Send Email", style: TextStyle( fontSize:16,
                  fontWeight:FontWeight.w700,
                  fontStyle:FontStyle.normal,
                ),),
                textColor:Color(0xffffffff),
                height:50,
                minWidth:MediaQuery.of(context).size.width,
              ),
            ],),),),
    )
    ;
  }

}