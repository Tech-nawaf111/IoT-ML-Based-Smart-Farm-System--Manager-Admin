
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel{

  ExpenseModel(this.type,this.Amount, this.Name, this.Category,
      this.Date,);
String? type;
  String? Amount;
  String? Name;
  String? Category;
 Timestamp? Date;
}