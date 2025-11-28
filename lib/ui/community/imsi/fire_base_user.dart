import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teeklit/login/signup_info.dart';

Future<SignupInfo> getUser() async{
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  
  final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUserUid).get();

  return (SignupInfo.fromJson(userDoc));
}