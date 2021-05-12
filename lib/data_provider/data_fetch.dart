import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_ex/models/datas_.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final dataProvider = StreamProvider.autoDispose<List<Data>>((ref) => Database().videos);
class Database{
  List<Data> _getFroSnap(QuerySnapshot snapshot){
    return snapshot.docs.map((e) => Data.fromJson(e.data())).toList();
  }
  
  Stream<List<Data>> get videos{
    CollectionReference _db = FirebaseFirestore.instance.collection('datas');
return   _db.snapshots().map(_getFroSnap);
  }


}