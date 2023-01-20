import 'package:admin_app/Expenses_Income/Expenses/model/Expense_Model.dart';
import 'package:admin_app/Expenses_Income/Expenses/repository/Expense_Repository.dart';
import 'package:admin_app/Expenses_Income/Income/model/Income_Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../screens/loadingDailog/loading_dailog.dart';
import '../Income/repository/Income_Repository.dart';

class SummaryPage extends StatefulWidget {
  SummaryPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _amountController = new TextEditingController();
  final TextEditingController _dateValue = TextEditingController();
  double incometosend = 0;
  double expensetosend = 0;
  double totaltosend = 0;
  DateTime selectedDate = DateTime.now();
  DateFormat displayDateFormat = DateFormat('yyyy-MM-dd');
  String expensecategory = "Medicine";
  String incomecategory = "Milk";

  List dropdownItemListofIncomeCatagory = [];
  List dropdownItemListofExpenseCategory = [];
  List<String> expense = [
    'Medicine',
    'Feed',
    'Pays ',
    'Others',
  ];

  List<String> income = [
    'Cows',
    'Milk',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        _dateValue.text = "${displayDateFormat.format(picked)}";
      });
    }
  }

  @override
  void initState() {
    for (var i = 0; i < expense.length; i++) {
      dropdownItemListofExpenseCategory.add(
        {
          'label': expense[i],
        },
      );
    }
    for (var i = 0; i < income.length; i++) {
      dropdownItemListofIncomeCatagory.add(
        {
          'label': income[i],
        },
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Expenses & Incomes"),
            backgroundColor: Color(0xFF212332)),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('IncomeExpense')
                .snapshots(),
            builder: (context, snapshot) {
              if (kDebugMode) {
                print(snapshot.data);
              }
              print(snapshot.connectionState);
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                //    return Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('No data found');
                  }
                  if (snapshot.data == null) {
                    return Text('No data found');
                  }

                  double expenseforuse = 0;
                  double incomeforuse = 0;
                  final data = snapshot.data!.docs;
                  for (int i = 0; i < data.length; i++) {
                    final row = data[i].data() as Map<String, dynamic>;
                    if (row["type"] == "Income") {
                      incomeforuse += double.parse(row["Amount"]);
                    } else {
                      expenseforuse += double.parse(row["Amount"]);
                    }
                  }

                  return ListView(
                      padding: const EdgeInsets.only(bottom: 124),
                      children: [
                        const WelcomeNameWidget(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: PaisaCard(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(22.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TotalBalanceWidget(
                                    title: "Total Balance",
                                    amount: (incomeforuse - expenseforuse),
                                  ),
                                  const SizedBox(height: 24),
                                  ExpenseTotalForMonthWidget(
                                    outcome: expenseforuse,
                                    income: incomeforuse,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(height: 20),
                        Row(children: [
                          SizedBox(width: 45),
                          ElevatedButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.5,
                                vertical: defaultPadding /
                                    (Responsive.isMobile(context) ? 2 : 1),
                              ),
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.75,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25.0),
                                      topRight: Radius.circular(25.0),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            25, 0, 20, 0),
                                        child: Column(children: [
                                          const Text(
                                            'Add An Income',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          CoolDropdown(
                                            defaultValue:
                                                dropdownItemListofIncomeCatagory[
                                                    0],
                                            dropdownList:
                                                dropdownItemListofIncomeCatagory,
                                            resultHeight: 74,
                                            resultWidth: 380,
                                            dropdownWidth: 380,
                                            dropdownHeight: 200,
                                            resultBD: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xFF292723),
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            onChange: (value) {
                                              setState(() {
                                                incomecategory = value['label'];
                                              });
                                              print(incomecategory);
                                            },
                                          ),

                                          //
                                        ]),
                                      ),
                                      Container(
                                        width: 420,
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  22, 20, 20, 0),
                                          child: TextFormField(
                                            obscureText: false,
                                            style: TextStyle(
                                                color: Color(0xFF292723)),
                                            controller: _nameController,
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                  Icons
                                                      .drive_file_rename_outline,
                                                  color: Color(0xFF292723)),
                                              labelText: 'Income Name',
                                              hintText: 'Enter Income Name',
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF292723),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              labelStyle: const TextStyle(
                                                color: Color(0xFF292723),
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFF292723),
                                                  width: 1,
                                                ),
                                              ),
                                              filled: true,
                                              contentPadding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(20, 24, 20, 24),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Container(
                                        width: 420,
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  22, 20, 20, 0),
                                          child: TextFormField(
                                            obscureText: false,
                                            style: TextStyle(
                                                color: Color(0xFF292723)),
                                            controller: _amountController,
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                  Icons
                                                      .drive_file_rename_outline,
                                                  color: Color(0xFF292723)),
                                              labelText: 'Income Amount',
                                              hintText: 'Enter Income Amount',
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF292723),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              labelStyle: const TextStyle(
                                                color: Color(0xFF292723),
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFF292723),
                                                  width: 1,
                                                ),
                                              ),
                                              filled: true,
                                              contentPadding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(20, 24, 20, 24),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 420,
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20, 20, 20, 0),
                                          child: TextFormField(
                                            controller: _dateValue,
                                            onTap: () {
                                              _selectDate(context);
                                            },
                                            style:
                                                TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                              // border: InputBorder.none,
                                              hintText: 'Date',
                                              labelText: 'Date',
                                              prefixIcon: Icon(
                                                  Icons.calendar_today,
                                                  color: Color(0xFF292723)),

                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFF292723),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              labelStyle: TextStyle(
                                                color: Color(0xFF292723),
                                              ),

                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFF292723),
                                                  width: 1,
                                                ),
                                              ),
                                              filled: true,
                                            ),
                                            // The validator receives the text that the user has entered.
                                            validator: (value) {
                                              if (value != null) {
                                                return 'Please select dates';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        ),
                                        child: const Text(
                                          'Add Income',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () async {
                                          DateTime currentPhoneDate =
                                              DateTime.parse(
                                                  _dateValue.text); //DateTime
                                          Timestamp myTimeStamp =
                                              Timestamp.fromDate(
                                                  currentPhoneDate); //To TimeStamp
                                          print(incomecategory);
                                          IncomeModel incomeModel = IncomeModel(
                                            "Income",
                                            _amountController.text,
                                            _nameController.text,
                                            incomecategory,
                                            myTimeStamp,
                                          );
                                          IncomeRepository incomeRepository =
                                              IncomeRepository();

                                          incomeRepository.AddIncome(
                                              incomeModel);
                                          openLoadingDialog(
                                              context,
                                              'Successfully Income Added',
                                              true);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.add),
                            label: Text("Income"),
                          ),
                          SizedBox(width: 60),
                          ElevatedButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.5,
                                vertical: defaultPadding /
                                    (Responsive.isMobile(context) ? 2 : 1),
                              ),
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.75,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25.0),
                                      topRight: Radius.circular(25.0),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            25, 0, 20, 0),
                                        child: Column(children: [
                                          const Text(
                                            'Add An Expense',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          CoolDropdown(
                                            defaultValue:
                                                dropdownItemListofExpenseCategory[
                                                    0],
                                            dropdownList:
                                                dropdownItemListofExpenseCategory,
                                            resultHeight: 74,
                                            resultWidth: 380,
                                            dropdownWidth: 380,
                                            dropdownHeight: 200,
                                            resultBD: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xFF292723),
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            onChange: (value) {
                                              setState(() {
                                                expensecategory =
                                                    value['label'];
                                              });
                                              print(expensecategory);
                                            },
                                          ),

                                          //
                                        ]),
                                      ),
                                      Container(
                                        width: 420,
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  22, 20, 20, 0),
                                          child: TextFormField(
                                            obscureText: false,
                                            style: TextStyle(
                                                color: Color(0xFF292723)),
                                            controller: _nameController,
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                  Icons
                                                      .drive_file_rename_outline,
                                                  color: Color(0xFF292723)),
                                              labelText: 'Expense Name',
                                              hintText: 'Enter Expense Name',
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF292723),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              labelStyle: const TextStyle(
                                                color: Color(0xFF292723),
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFF292723),
                                                  width: 1,
                                                ),
                                              ),
                                              filled: true,
                                              contentPadding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(20, 24, 20, 24),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Container(
                                        width: 420,
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  22, 20, 20, 0),
                                          child: TextFormField(
                                            obscureText: false,
                                            style: TextStyle(
                                                color: Color(0xFF292723)),
                                            controller: _amountController,
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                  Icons
                                                      .drive_file_rename_outline,
                                                  color: Color(0xFF292723)),
                                              labelText: 'Expense Amount',
                                              hintText: 'Enter Expense Amount',
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF292723),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              labelStyle: const TextStyle(
                                                color: Color(0xFF292723),
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFF292723),
                                                  width: 1,
                                                ),
                                              ),
                                              filled: true,
                                              contentPadding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(20, 24, 20, 24),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 420,
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20, 20, 20, 0),
                                          child: TextFormField(
                                            controller: _dateValue,
                                            onTap: () {
                                              _selectDate(context);
                                            },
                                            style:
                                                TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                              // border: InputBorder.none,
                                              hintText: 'Date',
                                              labelText: 'Date',
                                              prefixIcon: Icon(
                                                  Icons.calendar_today,
                                                  color: Color(0xFF292723)),

                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFF292723),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              labelStyle: TextStyle(
                                                color: Color(0xFF292723),
                                              ),

                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFF292723),
                                                  width: 1,
                                                ),
                                              ),
                                              filled: true,
                                            ),
                                            // The validator receives the text that the user has entered.
                                            validator: (value) {
                                              if (value != null) {
                                                return 'Please select dates';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      ElevatedButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        ),
                                        child: const Text(
                                          'Add Expense',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () async {
                                          DateTime currentPhoneDate =
                                              DateTime.parse(_dateValue.text);
                                          Timestamp myTimeStamp =
                                              Timestamp.fromDate(
                                                  currentPhoneDate);
                                          print(expensecategory);
                                          ExpenseModel expenseModel =
                                              ExpenseModel(
                                            "Expense",
                                            _amountController.text,
                                            _nameController.text,
                                            expensecategory,
                                            myTimeStamp,
                                          );
                                          ExpenseRepository expenseRepository =
                                              new ExpenseRepository();
                                          expenseRepository.AddExpense(
                                              expenseModel);
                                          openLoadingDialog(
                                              context,
                                              'Successfully Expense Added',
                                              true);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.indeterminate_check_box_outlined),
                            label: Text("Expenses"),
                          ),
                        ]),
                        Center(
                            child: Text("All Expenses & Incomes",
                                style: GoogleFonts.poppins(fontSize: 18))),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final row =
                                data[index].data() as Map<String, dynamic>;
                            return Card(
                              elevation: 8.0,
                              color: Colors.white70,
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.blue,
                                ),
                                borderRadius:
                                    BorderRadius.circular(20.0), //<-- SEE HERE
                              ),
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  leading: row["type"] == "Income"
                                      ? RichText(
                                          text: TextSpan(
                                            text: '▼',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.copyWith(
                                                  color: Colors.green,
                                                ),
                                            children: const [
                                              TextSpan(
                                                text: 'Income',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : RichText(
                                          text: TextSpan(
                                            text: '▲',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.copyWith(
                                                  color: Colors.red,
                                                ),
                                            children: [
                                              TextSpan(
                                                text: 'Expense',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                  title: Text(
                                    row["Name"],
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                                  subtitle: Column(children: [
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(row["Category"],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ))
                                      ],
                                    ),
                                  ]),

                                  // https://console.firebase.google.com/u/2/project/fyp-nawaf-mujeeb/database/fyp-nawaf-mujeeb-default-rtdb/data/~2F

                                  trailing: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: row["type"] == "Income"
                                        ? Text("+" + row["Amount"],
                                            style: GoogleFonts.poppins(
                                                fontSize: 18))
                                        : Text("-" + row["Amount"],
                                            style: GoogleFonts.poppins(
                                                fontSize: 18)),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ]);
              }
            }));
  }
}

class WelcomeNameWidget extends StatelessWidget {
  const WelcomeNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome",
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Text(
            "Manager",
          ),
        ],
      ),
    );
  }
}

class TotalBalanceWidget extends StatelessWidget {
  TotalBalanceWidget({
    Key? key,
    required this.title,
    required this.amount,
  }) : super(key: key);
  final String title;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withOpacity(0.85),
              ),
        ),
        const SizedBox(height: 8),
        Text(
          "RS" + amount!.toString(),
          style: GoogleFonts.manrope(
            textStyle: Theme.of(context).textTheme.headline4?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }
}

class ExpenseTotalForMonthWidget extends StatelessWidget {
  ExpenseTotalForMonthWidget({
    Key? key,
    this.income = 0,
    required this.outcome,
  }) : super(key: key);

  final double income;
  final double outcome;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This month',
          style: Theme.of(context).textTheme.headline6?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withOpacity(0.85),
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '▼',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Colors.green,
                          ),
                      children: [
                        TextSpan(
                          text: 'Income',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    '+RS${income}',
                    style: GoogleFonts.manrope(
                      textStyle:
                          Theme.of(context).textTheme.headline6?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '▲',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Colors.red,
                          ),
                      children: [
                        TextSpan(
                          text: 'OutCome',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    '-Rs${outcome}',
                    style: GoogleFonts.manrope(
                      textStyle:
                          Theme.of(context).textTheme.headline6?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PaisaCard extends StatelessWidget {
  const PaisaCard({
    required this.child,
    this.elevation,
    this.color,
  });

  final Widget child;
  final double? elevation;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: color ?? Theme.of(context).colorScheme.surfaceVariant,
      clipBehavior: Clip.antiAlias,
      elevation: elevation ?? 2.0,
      shadowColor: color ?? Theme.of(context).colorScheme.shadow,
      child: child,
    );
  }
}
