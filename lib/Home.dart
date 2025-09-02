import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mazroo3atkom/Plus%20Pages/Add_Plant.dart';
import 'Plus Pages/AI_Chat.dart';
import 'Plus Pages/Calendar.dart';
import 'SignIn.dart';
import 'package:get/get.dart';


class Home extends StatefulWidget{
final String? userInput;
final String? iconPath;

const Home({this.userInput, this.iconPath , Key? key, }) : super(key: key);
  @override
  State<StatefulWidget> createState() => HomeState();


}

class HomeState extends State<Home>{

  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('مزرعتي',
        style: TextStyle(
        fontFamily: 'PlaypenSansArabic',
        fontWeight: FontWeight.w500,
        fontSize: 30,
        color: Colors.white
        ),
      ),
    centerTitle: true,
    backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        leading: Icon(Icons.logout,color: Colors.grey[700],),
                        title: Text(
                          'Logout',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () async{
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context)=>SignIn())
                          );

                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: buildSpeedDial(),
      
      
      body:StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('plants')
        .orderBy('timestamp', descending: true)
        .snapshots(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
    return const Center(
    child: Text(
    'لا يوجد نباتات مضافة',
    style: TextStyle(
    fontFamily: 'PlaypenSansArabic',
    fontSize: 18,
    ),
    ),
    );
    }

    final docs = snapshot.data!.docs;

    return SingleChildScrollView(
    padding: const EdgeInsets.only(top: 16),
    child: Column(
    children: docs.map((doc) {
    final label = doc['label'] ?? '';
    final iconPath = doc['iconPath'] ?? '';

    return buildFeatureCard(
    iconPath: iconPath,
    label: label,
    docId: doc.id,

    );
    }).toList(),
    ),
    );
    },
    ),
    );

  }


  Widget buildFeatureCard({
    required String iconPath,
    required String label,
    required String docId,
  }) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 242, 238, 238),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: Directionality(
              textDirection: TextDirection.rtl, // RTL layout
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      iconPath,
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'PlaypenSansArabic',
                          fontWeight: FontWeight.w500,

                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.grey[400]),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('plants')
                            .doc(docId)
                            .delete();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget buildSpeedDial() {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 0,
      overlayColor: Colors.transparent,
      overlayOpacity: 0.0,
      childPadding: const EdgeInsets.all(8),
      closeDialOnPop: true,
      spaceBetweenChildren: 4,
      buttonSize: Size(40, 40),
      childrenButtonSize: Size(62, 62),
      dialRoot: (ctx, open, toggleChildren) => IconButton(
        onPressed: toggleChildren,
        icon: Image.asset('assets/icons/plus.png', width: 60, height: 60),
      ),
      tooltip: 'Open Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      elevation: 0,
      animationCurve: Curves.elasticInOut,
      isOpenOnStart: false,
      animationDuration: const Duration(milliseconds: 100),
      shape: const StadiumBorder(),
      direction: SpeedDialDirection.left,
      children: [


        // SpeedDialChild(
        //   child: Image.asset(
        //     'assets/icons/technical-support.png',
        //   ),
        //   foregroundColor: Colors.transparent,
        //   backgroundColor: Colors.white,
        //   onTap: () {
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(builder: (context) =>  AI_Chat()),
        //     );
        //   },
        // ),



        // SpeedDialChild(
        //   child: Image.asset(
        //     'assets/icons/garden.png',
        //   ),
        //   foregroundColor: Colors.transparent,
        //   backgroundColor: Colors.white,
        //   onTap: () {
        //
        //   },
        // ),

        SpeedDialChild(
          child: Image.asset(
            'assets/icons/natural-product.png',
          ),
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.white,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Add_Plant()),
            );
          },
        ),

        SpeedDialChild(
          child: Image.asset(
            'assets/icons/calendar.png',
          ),
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.white,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Calendar()),
            );
          },
        ),

      ],
    ).marginSymmetric(horizontal: 3.0, vertical: 30.0);
  }
}


