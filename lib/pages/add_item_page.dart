import 'dart:io';
import 'package:beadando/components/my_button.dart';
import 'package:beadando/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController personController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String imageUrl = '';
  final FirestoreService firestoreService = FirestoreService();
  bool isUploading = false;

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> uploadImage() async {
    setState(() {
      isUploading = true;
    });

    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    if (file == null) {
      setState(() {
        isUploading = false;
      });
      return;
    }

    Reference referenceImagesFolder =
        FirebaseStorage.instance.ref().child('images');
    Reference referenceImgToUpload = referenceImagesFolder.child(fileName);

    try {
      await referenceImgToUpload.putFile(File(file!.path));
      imageUrl = await referenceImgToUpload.getDownloadURL();
      setState(() {
        imageUrl = imageUrl;
        isUploading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 53, 51, 51),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 32, 32, 32),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    AppLocalizations.of(context)!.new_expense,
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                    labelText: AppLocalizations.of(context)!.choose_date,
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => selectDate(context),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: costController,
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.attach_money,
                      color: Colors.white,
                    ),
                    labelText: AppLocalizations.of(context)!.expense_cost,
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: personController,
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    labelText: AppLocalizations.of(context)!.person_spent_with,
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.location_city,
                      color: Colors.white,
                    ),
                    labelText: AppLocalizations.of(context)!.location,
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: uploadImage,
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(45.0),
                child: isUploading
                    ? const CircularProgressIndicator()
                    : MyButton(
                        text: AppLocalizations.of(context)!.add,
                        onTap: () {
                          if (imageUrl.isEmpty) imageUrl = '';

                          firestoreService.addExpense(
                            dateController.text,
                            costController.text,
                            personController.text,
                            imageUrl,
                            locationController.text,
                          );

                          dateController.clear();
                          costController.clear();
                          personController.clear();
                          locationController.clear();
                          imageUrl = '';

                          Navigator.pop(context);
                        }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
