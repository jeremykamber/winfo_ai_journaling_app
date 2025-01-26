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
      backgroundColor: const Color(0xFFF5F4E8),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E2D5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Widgets Here',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFFFFFFF),
                    hintText: 'Start your journal here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                child: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFF958E8E),
                    hintText: 'Ask me anything!',
                    hintStyle: const TextStyle(color: Color(0xFF958E8E)),
                    labelText: 'Have a question?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
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
