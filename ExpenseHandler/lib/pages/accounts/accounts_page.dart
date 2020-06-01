import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ExpenseHandler/database/db_provider.dart';
import 'package:ExpenseHandler/models/account.dart';
import 'package:ExpenseHandler/pages/accounts/account_page.dart';

class AccountsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var dbProvider = Provider.of<DbProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Account>>(
        future: dbProvider.getAllAccounts(),
        builder: (_, AsyncSnapshot<List<Account>> snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text(snapshot.error.toString()),
            );

          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

          var accounts = snapshot.data;

          if (accounts.length == 0)
            return Center(
              child: const Text('No Records'),
            );
          var formatter = NumberFormat("#,##0.00", "en_US");
          return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (_, int index) {
              var account = accounts[index];
              return ListTile(
                leading: Icon(account.iconData),
                title: Text(account.name),
                trailing: Text('\$${formatter.format(account.balance)}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AccountPage(
                              account: account,
                            )),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
