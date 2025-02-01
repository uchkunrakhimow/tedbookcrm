import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_page_route.dart';

extension NavigatorExtension on State {
  Future<dynamic> push(Widget page) {
    if (page is StatefulWidget || page is StatelessWidget) {
      return Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (c) => page,
          settings: RouteSettings(
            name: "${page.runtimeType}",
          ),
        ),
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  void pushIfPageNotExist(Widget page) {
    if (page is StatefulWidget || page is StatelessWidget) {
      // ModalRoute.of(context).settings.name
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (c) => page,
          settings: RouteSettings(
            name: "${page.runtimeType}",
          ),
        ),
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  Future pushReplace(Widget page) async {
    if (page is StatefulWidget || page is StatelessWidget) {
      Navigator.pop(context);
      return Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (c) => page,
          settings: RouteSettings(
            name: "${page.runtimeType}",
          ),
        ),
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  Future pushAndRemoveAll(Widget page, {animate = true}) {
    if (page is StatefulWidget || page is StatelessWidget) {
      return Navigator.pushAndRemoveUntil(
        context,
        _wrapAnimationRoute(page, animate),
        (route) => false,
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  Future pushAndRemoveAllWithBloc<T extends Bloc>(Widget page, T bloc,
      {animate = true}) {
    if (page is StatefulWidget || page is StatelessWidget) {
      return Navigator.pushAndRemoveUntil(
        context,
        _wrapAnimationBuilder(
          (c) => BlocProvider<T>(
            create: (context) => bloc,
            child: page,
          ),
          page,
          animate,
        ),
        (route) => false,
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  void popUntilWithName(Widget page) {
    if (page is StatefulWidget || page is StatelessWidget) {
      Navigator.popUntil(context, ModalRoute.withName("${page.runtimeType}"));
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  void pop({dynamic result}) => Navigator.pop(context, result);

  pushWithBloc<T extends Bloc>(Widget page, T bloc) {
    if (page is StatefulWidget || page is StatelessWidget) {
      return Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (c) => BlocProvider<T>(
            create: (context) => bloc,
            child: page,
          ),
          settings: RouteSettings(
            name: "${page.runtimeType}",
          ),
        ),
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  Future<T?> showBottomSheetWithBloc<T extends Bloc>(Widget page, T bloc) {
    if (page is StatefulWidget || page is StatelessWidget) {
      FocusScope.of(context).requestFocus(FocusNode());
      return showModalBottomSheet<T>(
        context: context,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        builder: (BuildContext context) {
          return BlocProvider<T>(
            create: (context) => bloc,
            child: page,
          );
        },
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }
}

extension ContextExtension on BuildContext {
  Future push(Widget page) {
    if (page is StatefulWidget || page is StatelessWidget) {
      return Navigator.push(
        this,
        CupertinoPageRoute(
          builder: (c) => page,
          settings: RouteSettings(
            name: "${page.runtimeType}",
          ),
        ),
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  Future pushReplace(Widget page) {
    if (page is StatefulWidget || page is StatelessWidget) {
      Navigator.pop(this);
      return Navigator.push(
        this,
        CupertinoPageRoute(
          builder: (c) => page,
          settings: RouteSettings(
            name: "$page",
          ),
        ),
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  Future pushAndRemoveAll(Widget page, {doAnimate = true}) {
    if (page is StatefulWidget || page is StatelessWidget) {
      return Navigator.pushAndRemoveUntil(
        this,
        _wrapAnimationRoute(page, doAnimate),
        (route) => false,
      );
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  void popUntilWithName(Widget page) {
    if (page is StatefulWidget || page is StatelessWidget) {
      Navigator.popUntil(this, ModalRoute.withName("${page.runtimeType}"));
    } else {
      throw Exception(["Widget is not stfull or stless"]);
    }
  }

  void pop({dynamic result}) => Navigator.pop(this, result);
}

_wrapAnimationRoute(Widget page, bool animate) {
  if (animate) {
    return CupertinoPageRoute(
        builder: (c) => page,
        settings: RouteSettings(name: "${page.runtimeType}"));
  } else {
    return CustomPageRoute(
        builder: (c) => page,
        settings: RouteSettings(name: "${page.runtimeType}"));
  }
}

_wrapAnimationBuilder(WidgetBuilder builder, Widget page, bool animate) {
  if (animate) {
    return CupertinoPageRoute(
        builder: builder, settings: RouteSettings(name: "${page.runtimeType}"));
  } else {
    return CustomPageRoute(
        builder: builder, settings: RouteSettings(name: "${page.runtimeType}"));
  }
}
