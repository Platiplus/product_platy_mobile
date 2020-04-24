// FLUTTER DEPENDENCIES
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:platy/core/error/Failures.dart';
import 'package:platy/features/manage_transactions/presentation/widgets/Widgets.dart';
import 'package:platy/features/manage_transactions/data/models/TransactionModel.dart';
import 'package:platy/injection_container.dart';
import 'package:platy/features/manage_transactions/domain/usecases/GetTransactions.dart';

// EXTERNAL DEPENDENCIES
import 'package:platy/core/helpers/constants/style_constants.dart' as Theme;
import 'package:platy/core/helpers/utils/TabIndicationPainter.dart';
import 'package:platy/core/widgets/CustomIcons.dart';
import 'package:platy/features/manage_transactions/presentation/widgets/TransactionItem.dart';

class Control extends StatefulWidget {
  Control({Key key}) : super(key: key);

  @override
  ControlState createState() => new ControlState();
}

class ControlState extends State<Control> {
  GetAllTransactions getAllTransactions;
  PageController _pageController;
  Color leftMenuTextColor = Theme.controlMenuSelectedBarItemTextColor;
  Color centerMenuTextColor = Theme.controlMenuDeselectedBarItemTextColor;
  Color rightMenuTextColor = Theme.controlMenuDeselectedBarItemTextColor;

  List<TransactionModel> variableOutcomeTransactions = [];
  List<TransactionModel> fixedOutcomeTransactions = [];
  List<TransactionModel> incomeTransactions = [];
  bool _loading = true;

  ControlState(){
    getAllTransactions = Injector.resolve<GetAllTransactions>();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 60.0, left: 30.0, bottom: 20.0),
                  child: GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Text(
                          'FEVEREIRO',
                          style: TextStyle(
                            fontSize: Theme.monthButtonFontSize,
                            fontFamily: Theme.primaryFontFamily,
                            color: Theme.monthButtonTextColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Icon(CSIcons.arrow_down, color: Theme.inputSelectableIconColor, size: Theme.inputIconSize),
                        ),
                      ],
                    )
                  ),
                ),
              ],
            ),
            Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: Text(
                        "R\$ 0,00",
                        style: TextStyle(
                          color: Theme.moneyBalanceTextColor,
                          fontSize: Theme.moneyBalanceFontSize,
                          fontFamily: Theme.primaryFontFamily,
                          fontWeight: Theme.moneyBalanceFontWeight
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: GestureDetector(
                        child: Material(
                          child: Ink(
                            height: 24.0,
                            width: 24.0,
                            decoration: ShapeDecoration(
                              color: Theme.linkLightBGTextColor,
                              shape: CircleBorder(),
                            ),
                            child: Icon(
                              CSIcons.cta_add,
                              color: Colors.white,
                              size: 14.0,
                            ),
                          ),
                        ),
                        onTap: (){
                          print('ADICIONAR TRANSACAO ATIVADO');
                        },
                      )
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0, left: 30.0),
                  child: Text(
                    "Balanço do mês",
                    style: TextStyle(
                      color: Theme.supportTextColor,
                      fontSize: Theme.supportFontSize,
                      fontFamily: Theme.primaryFontFamily,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2, left: 240),
                  child: Container(
                    height: 40,
                    child: VerticalDivider(
                      color: Theme.dividerColor,
                      thickness: 1.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 270),
                  child: FlatButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed('home-details', arguments: [variableOutcomeTransactions, fixedOutcomeTransactions, incomeTransactions]);
                    },
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      "Ver detalhes",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.linkLightBGTextColor,
                        fontSize: Theme.linkFontSize,
                        fontFamily: Theme.primaryFontFamily,
                      ),
                    ),
                  )
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: Container(
                width: 348.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: Theme.controlMenuLightBGBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                child: CustomPaint(
                  painter: TabIndicationPainterThreeItems(pageController: _pageController),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: _onVariableOutcomeButtonPress,
                          child: Text(
                            "Gasto Variável",
                            style: TextStyle(
                                color: leftMenuTextColor,
                                fontSize: Theme.sliderMenuFontSize,
                                fontFamily: Theme.primaryFontFamily,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: _onFixedOutcomeButtonPress,
                          child: Text(
                            "Gasto Fixo",
                            style: TextStyle(
                                color: centerMenuTextColor,
                                fontSize: Theme.sliderMenuFontSize,
                                fontFamily: Theme.primaryFontFamily,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: _onIncomeButtonPress,
                          child: Text(
                            "Recebimento",
                            style: TextStyle(
                                color: rightMenuTextColor,
                                fontSize: Theme.sliderMenuFontSize,
                                fontFamily: Theme.primaryFontFamily,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) {
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  changeMenuTextColors(i);
                },
                children: <Widget>[
                  new ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: variableOutcomeTransactions.length == 0
                        ?
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Column(
                        children: <Widget>[
                          !_loading ? noTransactions() : Container(),
                          Visibility(
                            visible: _loading,
                            child: _loading ? CircularProgressIndicator(/*ADICIONAR COR AO PROGRESS*/) : Container(),
                          ),
                        ],
                      ),
                    )
                        :
                    ListView.builder(
                      itemBuilder: (_, index) {
                        var transaction = variableOutcomeTransactions[index];
                        TransactionListItem listItem = new TransactionListItem(
                          transaction: transaction,
                          onEdit: (){
                            setState(() {
                              transaction.value = 1235;
                              variableOutcomeTransactions[index] = transaction;
                            });
                          },
                          last: index == variableOutcomeTransactions.length - 1 ? true : false
                        );
                        return listItem;
                      },
                      itemCount: variableOutcomeTransactions.length,
                    ),
                  ),
                  new ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: fixedOutcomeTransactions.length == 0
                        ?
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Column(
                        children: <Widget>[
                          !_loading ? noTransactions() : Container(),
                          Visibility(
                            visible: _loading,
                            child: _loading ? CircularProgressIndicator() : Container(),
                          ),
                        ],
                      ),
                    )
                        :
                    ListView.builder(
                      itemBuilder: (_, index) {
                        var transaction = fixedOutcomeTransactions[index];
                        TransactionListItem listItem = new TransactionListItem(
                            transaction: transaction,
                            onEdit: (){
                              setState(() {
                                transaction.value = 1235;
                                fixedOutcomeTransactions[index] = transaction;
                              });
                            },
                            last: index == fixedOutcomeTransactions.length - 1 ? true : false
                        );
                        return listItem;
                      },
                      itemCount: fixedOutcomeTransactions.length,
                    ),
                  ),
                  new ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: incomeTransactions.length == 0
                        ?
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Column(
                        children: <Widget>[
                          !_loading ? noTransactions() : Container(),
                          Visibility(
                            visible: _loading,
                            child: _loading ? CircularProgressIndicator() : Container(),
                          ),
                        ],
                      ),
                    )
                        :
                    ListView.builder(
                      itemBuilder: (_, index) {
                        var transaction = incomeTransactions[index];
                        TransactionListItem listItem = new TransactionListItem(
                          transaction: transaction,
                          onEdit: (){
                            setState(() {
                              transaction.value = 1235;
                              incomeTransactions[index] = transaction;
                            });
                          },
                          last: index == incomeTransactions.length - 1 ? true : false
                        );
                        return listItem;
                      },
                      itemCount: incomeTransactions.length,
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

  //STATE MANAGEMENT
  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
    fillTransactionsList();
  }

  void _onVariableOutcomeButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 800), curve: Curves.decelerate);
  }

  void _onFixedOutcomeButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 800), curve: Curves.decelerate);
  }

  void _onIncomeButtonPress() {
    _pageController?.animateToPage(2,
        duration: Duration(milliseconds: 800), curve: Curves.decelerate);
  }

  void changeMenuTextColors(i){
    if (i == 0) {
      setState(() {
        rightMenuTextColor = Theme.controlMenuDeselectedBarItemTextColor;
        centerMenuTextColor = Theme.controlMenuDeselectedBarItemTextColor;
        leftMenuTextColor = Theme.controlMenuSelectedBarItemTextColor;
      });
    } else if (i == 1) {
      setState(() {
        rightMenuTextColor = Theme.controlMenuDeselectedBarItemTextColor;
        centerMenuTextColor = Theme.controlMenuSelectedBarItemTextColor;
        leftMenuTextColor = Theme.controlMenuDeselectedBarItemTextColor;
      });
    } else if (i == 2) {
      setState(() {
        rightMenuTextColor = Theme.controlMenuSelectedBarItemTextColor;
        centerMenuTextColor = Theme.controlMenuDeselectedBarItemTextColor;
        leftMenuTextColor = Theme.controlMenuDeselectedBarItemTextColor;
      });
    }
  }

  void fillTransactionsList() async {

    Map<String, List<TransactionModel>> list = {
      "variable_outcome" : [],
      "fixed_outcome": [],
      "income": []
    };

    var transactions;

    var response = await getAllTransactions();

    response.fold(
        (error) => throw ServerFailure(),
        (retrieved) => transactions = retrieved
    );

      transactions.forEach((transaction){
        switch(transaction.type){
          case 1:
            list['income'].add(transaction);
            break;
          case 2:
            list['variable_outcome'].add(transaction);
            break;
          case 3:
            list['fixed_outcome'].add(transaction);
            break;
        }
      });

    setState(() {
      variableOutcomeTransactions = list["variable_outcome"];
      fixedOutcomeTransactions = list["fixed_outcome"];
      incomeTransactions = list["income"];
      _loading = false;
    });
  }

}