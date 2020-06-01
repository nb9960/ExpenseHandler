import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ExpenseHandler/database/db_provider.dart';
import 'package:ExpenseHandler/models/Item_type.dart';
import 'package:ExpenseHandler/models/account.dart';
import 'package:ExpenseHandler/models/item.dart';

class ItemPage extends StatefulWidget {
  ItemPage({
    @required this.isDeposit,
  });
  final bool isDeposit;
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  Map<String, dynamic> _formData = Map<String, dynamic>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _dateTime = DateTime.now();
  List<Account> _accounts = [];
  List<ItemType> _types = [];

  @override
  void initState() {
    super.initState();
    _formData['isDeposit'] = widget.isDeposit;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadDropdownData();
  }

  void _loadDropdownData() async {
    var dbProvider = Provider.of<DbProvider>(context);
    var accounts = await dbProvider.getAllAccounts();
    var types = await dbProvider.getAllTypes();

    if (!mounted) return;

    setState(() {
      _accounts = accounts;
      _types = types;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                if (!_formKey.currentState.validate()) return;
                _formKey.currentState.save();
                var dbProvider = Provider.of<DbProvider>(context);
                _formData['date'] = DateFormat('MM/dd/yyyy').format(_dateTime);
                var item = Item.fromMap(_formData);
                dbProvider.createItem(item);
                Navigator.of(context).pop();
              }),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (String value) => value.isEmpty ? 'Required' : null,
                onSaved: (String value) => _formData['description'] = value,
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (String value) {
                  if (value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid number';
                },
                onSaved: (String value) =>
                    _formData['amount'] = double.parse(value),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _formData['isDeposit'],
                    onChanged: (bool value) {
                      setState(() {
                        _formData['isDeposit'] = value;
                      });
                    },
                  ),
                  const Text('Is Deposit'),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () async {
                      var date = await showDatePicker(
                        context: context,
                        initialDate: _dateTime,
                        firstDate: DateTime.now().add(Duration(days: -365)),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (date == null) return;

                      setState(() {
                        _dateTime = date;
                      });
                    },
                  ),
                  Text(DateFormat('MM/dd/yyyy').format(_dateTime)),
                ],
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Account'),
                value: _formData['accountId'],
                onChanged: (int value) {
                  setState(() {
                    _formData['accountId'] = value;
                  });
                },
                validator: (int value) => value == null ? 'Required' : null,
                items: _accounts
                    .map((a) => DropdownMenuItem<int>(
                          value: a.id,
                          child: Text(a.name),
                        ))
                    .toList(),
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Type'),
                value: _formData['typeId'],
                onChanged: (int value) {
                  setState(() {
                    _formData['typeId'] = value;
                  });
                },
                validator: (int value) => value == null ? 'Required' : null,
                items: _types
                    .map((t) =>
                        DropdownMenuItem<int>(value: t.id, child: Text(t.name)))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
