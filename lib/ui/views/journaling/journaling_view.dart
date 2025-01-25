import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'journaling_viewmodel.dart';

class JournalingView extends StackedView<JournalingViewModel> {
  const JournalingView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    JournalingViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text('hello', style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                ),),
              ),
              TextField(
                obscureText: false, 
                decoration: InputDecoration(
                  hintText: 'Enter here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: 'Today\'s Note',
                  )
                ) 
            ],
          ),
            ),
          ),
    );
  }

  @override
  JournalingViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      JournalingViewModel();
}
