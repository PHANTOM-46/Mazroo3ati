import 'package:flutter/material.dart';
import 'package:mazroo3atkom/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Add_Plant extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddPlantState();
}

class _AddPlantState extends State<Add_Plant> {
  final TextEditingController _textController = TextEditingController();
  final List<int> list_items = [1, 2, 3, 4, 5, 6, 7];
  int? _value;
  int? _selectedImageIndex;
  String? iconPath;

  final List<String> _imagePaths = [
    'assets/icons/daisy-flower.png',
    'assets/icons/cactus.png',
    'assets/icons/plant.png',
    'assets/icons/tree.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
        ),
        title: Text(
          'نباتي',
          style: TextStyle(
              fontFamily: 'PlaypenSansArabic',
              fontWeight: FontWeight.w500,
              fontSize: 30,
              color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '1- ما نوع النبتة؟',
                  style: TextStyle(
                      fontFamily: 'PlaypenSansArabic',
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _textController,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xC2E5E5E5),
                  hintText: 'مثال: زهرة الياسمين',
                  hintStyle: TextStyle(color: Color(0xFF727070)),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '2- حاجتها للسقاية في الأسبوع؟',
                  style: TextStyle(
                      fontFamily: 'PlaypenSansArabic',
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 10),
              DropdownButton<int>(
                isExpanded: true,
                hint: Text('عدد المرات'),
                value: _value,
                items: list_items.map((int item) {
                  return DropdownMenuItem<int>(
                    child: Text('$item'),
                    value: item,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
              SizedBox(height: 25),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '3- اختر رمزًا للنبتة',
                  style: TextStyle(
                      fontFamily: 'PlaypenSansArabic',
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(_imagePaths.length, (index) {
                  final isSelected = _selectedImageIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImageIndex =
                        (_selectedImageIndex == index) ? null : index;
                        iconPath = _imagePaths[index];
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                        isSelected ? Colors.green[100] : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        _imagePaths[index],
                        width: 40,
                        height: 40,
                      ),
                    ),
                  );
                }),
              ),
             SizedBox(height: 230,),
              ElevatedButton(
                onPressed: () async {
                  String userInput = _textController.text.trim();

                  if (userInput.isNotEmpty &&
                      iconPath != null &&
                      _value != null) {
                    try {
                      await FirebaseFirestore.instance
                          .collection('plants')
                          .add({
                        'label': userInput,
                        'iconPath': iconPath,
                        'wateringFrequency': _value, //  أهم سطر
                        'timestamp': FieldValue.serverTimestamp(),
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تمت إضافة النبتة بنجاح!')),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    } catch (e) {
                      print('Error saving: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('فشل في حفظ البيانات')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'يرجى إدخال الاسم، عدد مرات السقاية، واختيار الرمز')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment.center,
                  child: Text(
                    'إضافة',
                    style: TextStyle(
                        fontFamily: 'PlaypenSansArabic',
                        fontWeight: FontWeight.w200,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
