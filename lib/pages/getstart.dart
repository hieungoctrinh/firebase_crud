import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter/pages/home.dart';
import 'package:firebase_flutter/services/database.dart';
import 'package:flutter/material.dart';

class Getstart extends StatefulWidget {
  const Getstart({super.key});

  @override
  State<Getstart> createState() => _GetstartState();
}

class _GetstartState extends State<Getstart> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  // ignore: non_constant_identifier_names
  Stream? EmployeeStream;

  getontheload() async {
    EmployeeStream = await DatabaseMethods().getEmployeeDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allEmployeeDetails() {
    return StreamBuilder(
        stream: EmployeeStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Name: ' + ds['Name'],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue),
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                        onTap: () {
                                          _nameController.text = ds["Name"];
                                          _ageController.text = ds["Age"];
                                          _locationController.text =
                                              ds["Location"];
                                          EditEmployeeDetails(ds["Id"]);
                                        },
                                        child: Icon(Icons.edit,
                                            color: Colors.green)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                        onTap: () async {
                                          await DatabaseMethods()
                                              .removeEmployeeDetails(ds["Id"]);
                                        },
                                        child: Icon(
                                          Icons.delete,
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Age: ' + ds['Age'],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.orange),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Location: ' + ds['Location'],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Started"),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: [
            Expanded(child: allEmployeeDetails()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future EditEmployeeDetails(String id) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Edit Employee"),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Giới hạn chiều cao
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Name',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Age',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Location',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> updateInfo = {
                          "Name": _nameController.text,
                          "Age": _ageController.text,
                          "Id": id,
                          "Location": _locationController.text,
                        };
                        await DatabaseMethods()
                            .updateEmployeeDetails(updateInfo, id)
                            .then((value) => Navigator.pop(context));
                      },
                      child: const Icon(Icons.update)),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            // TextButton(
            //   onPressed: () async {
            //     // Xử lý cập nhật dữ liệu tại đây
            //     await DatabaseMethods().updateEmployeeDetails(
            //       id: id,
            //       name: _nameController.text,
            //       age: _ageController.text,
            //       location: _locationController.text,
            //     );
            //     Navigator.pop(context); // Đóng hộp thoại sau khi cập nhật
            //     getontheload(); // Tải lại danh sách
            //   },
            //   child: const Text("Save"),
            // ),
          ],
        ),
      );
}
