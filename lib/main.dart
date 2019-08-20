import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        canvasColor: Colors.white,
      ),
      home: MyHomePage(title: 'Lets Get This Bread'),
    );
  }
}

class TimePassedWidget {

  String timePassed = '0s';
  Stopwatch myStopwatch = new Stopwatch();

  Stopwatch getMyStopwatch(){
    return myStopwatch;
  }

  String getTimePassed(){
    timePassed = '';

    if(myStopwatch.elapsed.inHours >= 1){
      timePassed += myStopwatch.elapsed.inHours.toString()+'hr ';
      timePassed += (myStopwatch.elapsed.inMinutes%60).toString()+'m ';
      return timePassed;
    }

    if(myStopwatch.elapsed.inMinutes >= 1){
      timePassed += (myStopwatch.elapsed.inMinutes%60).toString()+'m ';
      timePassed += (myStopwatch.elapsed.inSeconds%60).toString()+'s';
      return timePassed;
    }

    timePassed += (myStopwatch.elapsed.inSeconds%60).toString()+'s';

    return timePassed;
  }

  Widget buildTimePassed(){
    return Container(
        padding: EdgeInsets.only(top: 25.0),
        child: Text(
          'Time worked: '+getTimePassed(),
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.orange,
          ),
        )
    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  TimePassedWidget timePassedWidget = new TimePassedWidget();
  Timer timer;
  double payRate = 9.6;
  String myPayRate;
  final payRateController = TextEditingController();
  String buttonText = 'Start';
  String currency = '€';


  void callback(Timer timer){
    setState(() {

    });
  }

  void updatePayRate(String newPayRate){
    payRate = double.parse(newPayRate);
    print(double.parse(newPayRate));
  }

  void startStop(){
    if(!timePassedWidget.myStopwatch.isRunning){
      timePassedWidget.myStopwatch.start();
      timer = Timer.periodic(Duration(seconds: 1), callback);
      timePassedWidget.timePassed = '';
      buttonText = 'Stop';
    }
    else{
      timePassedWidget.myStopwatch.stop();
      buttonText = 'Start';
      timer.cancel();
      setState(() {

      });
    }
  }

  Widget buildMoneyEarned(){
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Text(
          currency+((timePassedWidget.myStopwatch.elapsed.inSeconds) * (payRate/60/60)).toStringAsFixed(2),
          style: TextStyle(
            fontSize: 48.0,
            color: Colors.orange,
          ),
        )
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            //buildTimePassed(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 25.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Pay Rate: ',//+currency+' ',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.orange,
                    ),
                  ),
                  DropdownButton<String>(
                    value: currency,
                    iconEnabledColor: Colors.orange,
                    onChanged: (String newCurrency){
                      setState(() {
                        currency = newCurrency;
                      });
                    },
                    items: <String>['€', '\$'].map<DropdownMenuItem<String>>((String value){
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.orange,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Expanded(
                    child: Center(
                      child: TextField(
                        controller: payRateController,
                        onSubmitted: (newPayRate){
                          updatePayRate(newPayRate);
                        },
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '9.60',
                          hintStyle: TextStyle(
                            color: Colors.orange[400],
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 22.0,
                        ),
                        keyboardType: TextInputType.numberWithOptions(signed: false),
                      ),
                    ),
                  ),
                  Text(
                    ' /hr',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.orange,
                    ),
                  )
                ],
              )
            ),
            timePassedWidget.buildTimePassed(),
            buildMoneyEarned(),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 50.0),
              child: MaterialButton(
                color: Colors.orange,
                padding: EdgeInsets.all(20.0),
                onPressed: () => {
                  startStop()
                },
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                ),
              )
            )
          ],
        ),
      )
    );
  }
}