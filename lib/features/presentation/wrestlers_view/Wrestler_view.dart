import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/core/widgets/custom_app_bar.dart';

import 'package:project/features/presentation/wrestlers_view/widgets/Wrestler_view_body.dart';
import 'package:project/features/presentation/wrestlers_view/widgets/custom_expandable_fab.dart';
import 'package:project/features/presentation/wrestlers_view/widgets/custom_note_floating_button.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class WrestlerView extends StatelessWidget {
  const WrestlerView({super.key});

  static String id = 'note';

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as List;
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: CustomExpandableFab(arguments: arguments),
      appBar: customAppBar(
        title: arguments[0]['name'],
        context: context,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: WrestlerViewBody(
        catId: arguments[0].id,
      ),
    );
  }
}
