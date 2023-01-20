import 'package:admin_app/Expenses_Income/Expenses/model/Expense_Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseRepository {
  ExpenseRepository();


  DocumentReference documentReference =
  FirebaseFirestore.instance.collection('ExpensesFinal').doc();
  DocumentReference documentReferencemain =
  FirebaseFirestore.instance.collection('IncomeExpense').doc();

  Future<void> AddExpense(ExpenseModel expenseModel) async {
    Map<String, dynamic> data = <String, dynamic>{
      "type": expenseModel.type,
      "Amount": expenseModel.Amount,
      "Name": expenseModel.Name,
      "Category": expenseModel.Category,
      "Date": expenseModel.Date,
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