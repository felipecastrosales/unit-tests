import 'package:flutter/material.dart';

import 'package:extended_masked_text/extended_masked_text.dart';

import 'package:tests_in_flutter/error/failure.dart';
import 'package:tests_in_flutter/models/operation.dart';
import 'package:tests_in_flutter/models/user.dart';

class OperationPage extends StatefulWidget {
  const OperationPage({
    Key? key,
    required this.user,
    required this.operationType,
    required this.onError,
    required this.onSuccess,
  }) : super(key: key);

  final User user;
  final OperationType operationType;
  final Function(Failure) onError;
  final Function(String) onSuccess;

  @override
  _OperationPageState createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> {
  final controller =
      MoneyMaskedTextController(leftSymbol: 'R\$ ', initialValue: 0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        key: const Key('OperationContinue'),
        disabledElevation: 0,
        child: const Icon(Icons.chevron_right),
        onPressed: () {
          try {
            // Create the operation object
            final Operation operation = Operation(
                balance: widget.user.balance,
                value: controller.numberValue,
                type: widget.operationType);
            // Do the operation
            final response = operation.doOperation();
            widget.onSuccess(response.message);
            // Closes the modal returning the user with their new data
            Navigator.pop(
              context,
              widget.user.update(
                balance: response.result,
                history: response.history,
              ),
            );
          } on Failure catch (e) {
            // Error handling if validation fails
            widget.onError(e);
          }
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SizedBox(
              height: 54,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.close,
                    key: const Key('CloseOperation'),
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  'Qual o valor do ${widget.operationType == OperationType.deposit ? 'depósito' : 'saque'}?',
                  style: Theme.of(context).textTheme.headline6,
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  key: const Key('OperationValueKey'),
                  autofocus: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'R\$ 0,00',
                    hintStyle: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 32,
                        ),
                  ),
                  keyboardType: TextInputType.number,
                  controller: controller,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 32,
                      ),
                ),
                Text(
                  'Digite um valor maior que R\$ 0,01',
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
