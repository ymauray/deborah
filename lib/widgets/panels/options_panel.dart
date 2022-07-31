import 'package:deborah/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class OptionsPanel extends StatefulWidget {
  const OptionsPanel({Key? key}) : super(key: key);

  @override
  State<OptionsPanel> createState() => _OptionsPanelState();
}

class _OptionsPanelState extends State<OptionsPanel> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = LocalStorage.get(LocalStorage.debgetpathKey, '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0).copyWith(left: 0.0, top: 16.0),
          child: Text(
            "Options",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              children: [
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        autovalidateMode: AutovalidateMode.always,
                        name: 'debgetpath',
                        controller: _controller,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'deb-get path '
                              '(including executable name, '
                              'leave empty for default)',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _controller.clear();
                            },
                          ),
                        ),
                        onChanged: (value) {
                          debugPrint(value);
                          LocalStorage.set(
                            LocalStorage.debgetpathKey,
                            (value ?? ''),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                //const SizedBox(height: 16.0),
                //Row(
                //  mainAxisAlignment: MainAxisAlignment.end,
                //  children: <Widget>[
                //    ElevatedButton(
                //      onPressed: () {
                //        if (_formKey.currentState?.saveAndValidate() ?? false) {
                //          LocalStorage.set(
                //            LocalStorage.debgetpathKey,
                //            (_formKey.currentState?.value['debgetpath'] ?? '')
                //                as String,
                //          );
                //        } else {
                //          debugPrint(_formKey.currentState?.value.toString());
                //          debugPrint('validation failed');
                //        }
                //      },
                //      child: const Padding(
                //        padding: EdgeInsets.all(14.0),
                //        child: Text(
                //          'Submit',
                //          style: TextStyle(color: Colors.white),
                //        ),
                //      ),
                //    ),
                //    const SizedBox(width: 20),
                //    OutlinedButton(
                //      onPressed: () {
                //        _formKey.currentState?.reset();
                //      },
                //      // color: Theme.of(context).colorScheme.secondary,
                //      child: Padding(
                //        padding: const EdgeInsets.all(14.0),
                //        child: Text(
                //          'Reset',
                //          style: TextStyle(
                //            color: Theme.of(context).colorScheme.secondary,
                //          ),
                //        ),
                //      ),
                //    ),
                //  ],
                //),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
