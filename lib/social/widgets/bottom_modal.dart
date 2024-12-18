import 'package:flutter/material.dart';

class ModalBottomSheet extends StatelessWidget {
  const ModalBottomSheet(
      {super.key,
      required this.child,
      required this.title,
      this.heightFactor = 0.75});

  final Widget child;
  final String title;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return FractionallySizedBox(
      heightFactor: heightFactor,
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> showBottomDialog(
    {required BuildContext context,
    required String title,
    required Widget child,
    double heightFactor = 0.75}) {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (context) => ModalBottomSheet(
      title: title,
      heightFactor: heightFactor,
      child: child,
    ),
  );
}
