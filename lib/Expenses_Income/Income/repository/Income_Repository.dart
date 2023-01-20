import 'package:admin_app/Expenses_Income/Expenses/model/Expense_Model.dart';
import 'package:admin_app/Expenses_Income/Income/model/Income_Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IncomeRepository {
  IncomeRepository();


  DocumentReference documentReference =
  FirebaseFirestore.instance.collection('IncomeFinal').doc();

  DocumentReference documentReferencemain =
  FirebaseFirestore.instance.collection('IncomeExpense').doc();

  Future<void> AddIncome(IncomeModel incomeModel) async {
    Map<String, dynamic> data = <String, dynamic>{
      "type": incomeModel.type,
      "Amount": incomeModel.Amount,
      "Name": incomeModel.Name,
      "Category": incomeModel.Category,
      "Date": incomeModel.Date,
    };
    await documentReference
        ?.set(data)
        .whenComplete(() =>
        print("Notes item added to the database"))
        .catchError((e) => print(e));

    await documentReferencemain
        ?.set(data)
        .whenComplete(() =>
        print("Notes item added to the database"))
        .catchError((e) => print(e));
  }
}